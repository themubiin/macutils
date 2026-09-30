// SPDX-License-Identifier: GPL-3.0-or-later
// Made with ❤️ by Muntasir Mubin

import Foundation

enum FinderRenameSupport {
    private static let editableRoles: Set<String> = [
        "AXTextField", "AXTextArea", "AXComboBox", "AXSecureTextField",
    ]

    static func acceptsFocusedRole(_ role: String?) -> Bool {
        guard let role else { return false }
        return !editableRoles.contains(role)
    }
}
