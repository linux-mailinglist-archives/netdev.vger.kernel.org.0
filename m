Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBC82D76C5
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 14:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436851AbgLKNj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 08:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390015AbgLKNjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 08:39:19 -0500
Received: from andre.telenet-ops.be (andre.telenet-ops.be [IPv6:2a02:1800:120:4::f00:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1988FC061793
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 05:38:38 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by andre.telenet-ops.be with bizsmtp
        id 31ed2400R4C55Sk011edHF; Fri, 11 Dec 2020 14:38:37 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1knid3-009iI7-5t; Fri, 11 Dec 2020 14:38:37 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1knid2-00CSkB-M8; Fri, 11 Dec 2020 14:38:36 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] mwifiex: pcie: Drop bogus __refdata annotation
Date:   Fri, 11 Dec 2020 14:38:35 +0100
Message-Id: <20201211133835.2970384-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the Marvell PCIE WiFi-Ex driver does not have any code or data
located in initmem, there is no need to annotate the mwifiex_pcie
structure with __refdata.  Drop the annotation, to avoid suppressing
future section warnings.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 5f0a61b974ee521a..94228b316df1b210 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -571,7 +571,7 @@ static SIMPLE_DEV_PM_OPS(mwifiex_pcie_pm_ops, mwifiex_pcie_suspend,
 #endif
 
 /* PCI Device Driver */
-static struct pci_driver __refdata mwifiex_pcie = {
+static struct pci_driver mwifiex_pcie = {
 	.name     = "mwifiex_pcie",
 	.id_table = mwifiex_ids,
 	.probe    = mwifiex_pcie_probe,
-- 
2.25.1

