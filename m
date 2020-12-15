Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C9F2DA828
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 07:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgLOGiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 01:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgLOGid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 01:38:33 -0500
From:   Jakub Kicinski <kuba@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] phy: fix kdoc warning
Date:   Mon, 14 Dec 2020 22:37:50 -0800
Message-Id: <20201215063750.3120976-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kdoc does not like it when multiline comment follows the networking
style of starting right on the first line:

include/linux/phy.h:869: warning: Function parameter or member 'config_intr' not described in 'phy_driver'

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/phy.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 381a95732b6a..9effb511acde 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -741,11 +741,12 @@ struct phy_driver {
 	int (*aneg_done)(struct phy_device *phydev);
 
 	/** @read_status: Determines the negotiated speed and duplex */
 	int (*read_status)(struct phy_device *phydev);
 
-	/** @config_intr: Enables or disables interrupts.
+	/**
+	 * @config_intr: Enables or disables interrupts.
 	 * It should also clear any pending interrupts prior to enabling the
 	 * IRQs and after disabling them.
 	 */
 	int (*config_intr)(struct phy_device *phydev);
 
-- 
2.26.2

