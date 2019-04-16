--[[
    少数派最新文章获取，点击后打开对应文章。
--]]

-- 请求文章数量
local article_num = "5"

-- 刷新时间（秒）
local s = 18000

local menubar = hs.menubar.new()
local title_items = {}
local articleKey = {}
local headers = {}
local articlesApi = "https://sspai.com/api/v1/articles?offset=0&limit=" .. article_num .. "&type=recommend_to_home&sort=recommend_to_home_at&include_total=false"
headers["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"

function updateMenubar()
    menubar:setMenu(title_items)
end

function openArticle(url)
    hs.urlevent.openURL(url)
end

function getArticles()
    hs.http.doAsyncRequest(
        articlesApi, 
        "GET", 
        nil, 
        headers,
        function (code, body, htable)
            if code ~= 200 then
                hs.notify.new({title="SSPAI - Error", informativeText="无法获取到最新文章！"}):send()
                return 
            end
            raw_json = hs.json.decode(body)
            -- menubar:setTitle("少数派")
            menubar:setIcon(hs.image.imageFromPath("/Users/lijianxun/.hammerspoon/sspai/icon.png"):setSize({w=16,h=16}))
            title_items = {}

            for k, v in pairs(raw_json.list) do
                _title = v.title
                _url = "https://sspai.com/post/" .. v.id
                articleKey[k] = _url
                table.insert( title_items, {title = _title, fn = function() openArticle(articleKey[k]) end})
            end
            
            updateMenubar()
        end
    )
end

getArticles()
updateMenubar()
hs.timer.doEvery(s, getArticles)