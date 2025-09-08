local M = {}

-- Icons which are used for multiple entries
local icon = {
    yes   = '✓' ,
    error = '🛇',
    warn  = '⚠' ,
    info  = '🛈',
    log   = '' , -- ✎
    circle_filled = ''
}

-- Default icons
local default_icons = {
    virtual_text = {
        prefix = icon.circle_filled
    },
    tabs = {
        close = '󰅖',
        trunc = { left = '🡄', right = '🡆' }
    },
    notifications = {
         debug = '',
         error = icon.error,
         info  = icon.info,
         trace = icon.log,
         warn  = icon.warn,
    },
    diagnostics = {
        error = icon.error,
        warn  = icon.warn,
        info  = icon.info,
        hint  = "󰌶",
    },
    git = {
        added    = "",
        modified = "",
        removed  = "",
    },
    debug = {
        breakpoint           = icon.circle_filled,
        breakpoint_condition = '',
        breakpoint_rejected  = '',
        log_point            = icon.log,
        stopped              = '',
        disconnect           = "",
        pause                = "",
        play                 = "",
        run_last             = "",
        step_back            = "",
        step_into            = "",
        step_out             = "",
        step_over            = "",
        terminate            = "󰓛"
    },
    menu = {
        collapsed = "",
        current_frame = "➜",
        expanded = ""
    },
    package = {
        installed   = icon.yes,
        pending     = '➜',
        uinstalled  = '✗',
    },
    file_format = {
        unix = '',
        dos  = '',
        mac  = '',
    },
    file_status = {
        modified = '●', -- Text to show when the file is modified.
        readonly = '󰌾', -- Text to show when the file is non-modifiable or readonly.
        unnamed  = '󱘹', -- Text to show for unnamed buffers.
        newfile  = '󱇬', -- Text to show for newly created file before first write TODO: Find icon
    },
    state = {
        loading = {
            dot_spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
        },
        done = icon.yes
    },
    separators = {
        simple = {
            default = ' '
        },
        advanced = {
            slant = {
                filled  = { left  = '🭛', right = '🭦', },
                outline = { left  = '/', right = '\\', }
            }
        }
    }
}

M.icons = default_icons

--- Setup user config
--- @param user_config      table
M.setup = function(user_config)
    if user_config then
        M.icons = vim.tbl_deep_extend("force", default_icons, user_config)
    end

    vim.diagnostic.config({
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = M.icons.diagnostics.error,
                [vim.diagnostic.severity.WARN]  = M.icons.diagnostics.warn,
                [vim.diagnostic.severity.INFO]  = M.icons.diagnostics.hint,
                [vim.diagnostic.severity.HINT]  = M.icons.diagnostics.info
            },
            linehl = {
                [vim.diagnostic.severity.ERROR] = "Error",
                [vim.diagnostic.severity.WARN] = "Warn",
                [vim.diagnostic.severity.INFO] = "Info",
                [vim.diagnostic.severity.HINT] = "Hint",
            },
        },
    })
end

--- Get value from icons table
--- @param tbl      table
local function get_value(tbl)
    tbl = tbl or {}  -- allows nil tables

     -- detect array vs map
    local is_array = #tbl > 0
    if is_array then
        return tbl  -- don't wrap arrays
    end

    return setmetatable({}, {
        __index = function(_, k)
            local v = tbl[k]
            if type(v) == "table" then
                return get_value(v) -- intermediate table → recurse
            elseif v ~= nil then
                return v            -- leaf exists → return value
            else
                vim.notify("Icon path not found: " .. k, vim.log.levels.WARN)
                return "󰹞"          -- missing key → return predefined icon (leaf exit)
            end
        end
    })
end

M.get = get_value(M.icons)

return M



