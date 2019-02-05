local api = {}
local http = require('vendor.http')
local hash = require('vendor.sha256')
local System = luajava.bindClass('java.lang.System')
require 'vendor.helper'

local function calcHash(method, endpoint, token, time)
    return hash.sha256(string.format("fgobot%s%s%s%i_%s", method, token, endpoint, time, Config.API_KEY))
end

local function fetchAPI(method, endpoint, headers, data, isAuth)
    if (not isTable(headers) and headers ~= nil) then error('[fetchAPI] Invalid Headers') end
    if (headers == nil) then headers = {} end
    if (isAuth) then
        headers['X-FGO-TOKEN'] = getDeviceID()
    end
    local requestTime = System:currentTimeMillis()
    local fullURL = not string.find(endpoint, Config.API_URL) and Config.API_URL .. endpoint or endpoint
    headers['X-FGO-REQUEST-TIME'] = requestTime
    headers['X-FGO-HASH'] = calcHash(method, endpoint, getDeviceID(), requestTime)
    return http
        .fetch(method, fullURL, headers, data)
        :resolve(
            function (res)
                if (res.ok) then
                    return res:isJson() and res:json() or { success=false, message=res:text() }
                else
                    message = string.format('%d - Unexpected Error', res.status)
                    if (res:isJson()) then
                        result = res:json()
                        message = result.message
                    end
                    error({message=message})
                end
            end,
            function (error)
                return { success=false, message=error.message }
            end
        )
end

function api.fetchQuestInfoByOCR(fileName)
    local path = '@'..Config.runtimePath..fileName
    return fetchAPI('POST', '/quest', nil, {file=path}, false)
end

function api.fetchPlayerAPbyOCR(fileName)
    local path = '@'..Config.runtimePath..fileName
    return fetchAPI('POST', '/player/ap', nil, {file=path}, true)
end

function api.fetchNPByOCR(fileName)
    local path = '@'..Config.runtimePath..fileName
    return fetchAPI('POST', '/servant/np', nil, {file=path}, true)
end

function api.fetchServantSkillLevelByOCR(fileName)
    local path = '@'..Config.runtimePath..fileName
    return fetchAPI('POST', '/servant/skill', nil, {file=path}, true)
end

function api.postStartQuest(id)
    return fetchAPI('POST', '/quest/'..id..'/start', nil, nil, true)
end

function api.postEndQuest(id)
    return fetchAPI('POST', '/quest/'..id..'/end', nil, nil, true)
end

function api.log(message)
    return fetchAPI('POST', '/log', nil, {message=message}, false)
end

function api.debug(filename)
    local path = '@'..Config.debugPath..filename
    return fetchAPI('POST', '/data/transfer', nil, {file=path}, false)
end

return api
