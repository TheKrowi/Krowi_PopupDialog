--[[
    Copyright (c) 2023 Krowi

    All Rights Reserved unless otherwise explicitly stated.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

---@diagnostic disable: undefined-global

local lib = LibStub:NewLibrary("Krowi_PopupDialog-1.0", 3);

if not lib then
	return;
end

-- [[ External Link Popup Dialog ]] --
local externalLink = "";
local externalLinkDialog = "KROWI_EXTERNAL_LINK";
StaticPopupDialogs[externalLinkDialog] = { -- Needs to be added to the Blizzard list
	text = "Press CTRL+X to copy the website and close this window.",
	button1 = "Close",
	hasEditBox = true,
	editBoxWidth = 500,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	OnShow = function(self)
		local editBox = self.editBox or self.EditBox;
		editBox:SetMaxLetters(0);
		editBox:SetText(externalLink);
		editBox:HighlightText();
	end,
	EditBoxOnEscapePressed = function(self)
		local button = self:GetParent().button1 or self:GetParent().ButtonContainer.Button1;
		button:Click();
	end,
	EditBoxOnTextChanged = function(self)
		local button = self:GetParent().button1 or self:GetParent().ButtonContainer.Button1;
		if self:GetText():len() < 1 then
			button:Click();
		else
			self:SetMaxLetters(0);
			self:SetText(externalLink);
			self:HighlightText();
		end
	end,
}

function lib.ShowExternalLink(link)
	externalLink = link;
	StaticPopup_Show(externalLinkDialog);
end

-- [[ Numeric Input Dialog ]] --
local numericInputCallback;
local numericInputMin, numericInputMax;
local numericInputDefault;
local numericInputDialog = "KROWI_NUMERIC_INPUT";
StaticPopupDialogs[numericInputDialog] = {
	text = "",
	button1 = "",
	button2 = "",
	hasEditBox = true,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	OnShow = function(self)
		local editBox = self.editBox or self.EditBox;
		editBox:SetNumeric(true);
		editBox:SetMaxLetters(string.len(tostring(numericInputMax)));
		editBox:SetText(tostring(numericInputDefault));
		editBox:HighlightText();
	end,
	OnAccept = function(self)
		local editBox = self.editBox or self.EditBox;
		local value = tonumber(editBox:GetText());
		if value and value >= numericInputMin and value <= numericInputMax and numericInputCallback then
			numericInputCallback(value);
		end
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent();
		local button = parent.button1 or parent.ButtonContainer and parent.ButtonContainer.Button1;
		if button then
			button:Click();
		end
	end,
	EditBoxOnEscapePressed = function(self)
		local parent = self:GetParent();
		local button = parent.button2 or parent.ButtonContainer and parent.ButtonContainer.Button2;
		if button then
			button:Click();
		end
	end,
	preferredIndex = 3,
};

function lib.ShowNumericInput(options)
	local dialog = StaticPopupDialogs[numericInputDialog];
	dialog.text = options.text or "Enter a number:";
	dialog.button1 = options.acceptText or "Accept";
	dialog.button2 = options.cancelText or "Cancel";
	numericInputMin = options.min or 1;
	numericInputMax = options.max or 999;
	numericInputDefault = options.default or numericInputMin;
	numericInputCallback = options.callback;
	StaticPopup_Show(numericInputDialog);
end