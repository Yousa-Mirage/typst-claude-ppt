-- Keep Markdown as Pandoc nodes so Quarto can still process citations, figures,
-- shortcodes and code. Only the component boundaries are raw Typst. Run before
-- Quarto turns callout Divs and column layouts into its own components.
if not FORMAT:match("typst") then
  return {}
end

local function raw(text)
  return pandoc.RawBlock("typst", text)
end

local callouts = {
  callout = true,
  ["callout-note"] = true,
  ["callout-tip"] = true,
  ["callout-warning"] = true,
  ["callout-important"] = true,
  ["callout-caution"] = true,
}

local function panel(div, name)
  local title
  local first = div.content[1]
  if first and first.t == "Header" then
    title = first.content
    div.content:remove(1)
  end
  if div.attributes.title ~= nil then
    -- Parse inline Markdown, preserving emphasis, links, math and escaping.
    title = pandoc.utils.blocks_to_inlines(
      pandoc.read(div.attributes.title, "markdown").blocks
    )
  end

  local blocks = pandoc.Blocks({})
  if title and #title > 0 then
    local inlines = pandoc.Inlines({ pandoc.RawInline("typst", "#claude." .. name .. "(title: [") })
    inlines:extend(title)
    inlines:insert(pandoc.RawInline("typst", "])["))
    blocks:insert(pandoc.Plain(inlines))
  else
    blocks:insert(raw("#claude." .. name .. "["))
  end
  blocks:extend(div.content)
  blocks:insert(raw("]"))
  -- Preserve the identifier without exposing component classes to Quarto.
  return pandoc.Div(blocks, pandoc.Attr(div.identifier))
end

local function columns(div)
  local cols = div.content
  assert(#cols == 2 and cols[1].t == "Div" and cols[2].t == "Div"
    and cols[1].classes:includes("column")
    and cols[2].classes:includes("column"),
    "Claude PPT: .columns requires exactly two direct .column Divs")
  local blocks = pandoc.Blocks({ raw("#claude.two-columns([") })
  for i, col in ipairs(cols) do
    local width = col.attributes.width
    assert(not width or width == "50%",
      "Claude PPT: .column width must be 50% or omitted (equal columns)")
    blocks:insert(pandoc.Div(col.content, pandoc.Attr(col.identifier)))
    blocks:insert(raw(i == 1 and "], [" or "])"))
  end
  return pandoc.Div(blocks, pandoc.Attr(div.identifier))
end

return { {
  Div = function(div)
    for _, class in ipairs(div.classes) do
      if callouts[class] then
        return panel(div, "callout")
      elseif class == "card" then
        return panel(div, "card")
      elseif class == "columns" then
        return columns(div)
      end
    end
  end,
} }
