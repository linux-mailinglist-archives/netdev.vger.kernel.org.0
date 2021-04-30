Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CAD36F9D2
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 14:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhD3MMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 08:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhD3MMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 08:12:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A827CC06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 05:11:46 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lcRzk-0024G6-Su; Fri, 30 Apr 2021 14:11:45 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Chris Snook <chris.snook@gmail.com>
Subject: [PATCH] net: atheros: nic-devel@qualcomm.com is dead
Date:   Fri, 30 Apr 2021 14:11:42 +0200
Message-Id: <20210430141142.28d49433b7a0.Ibcb12b70ce4d7d1c3a7a3b69200e1eea5f59e842@changeid>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove it from the MODULE_AUTHOR statements referencing it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/ethernet/atheros/alx/main.c         | 2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9e02f8864593..b3d74332ed33 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -2016,7 +2016,7 @@ static struct pci_driver alx_driver = {
 module_pci_driver(alx_driver);
 MODULE_DEVICE_TABLE(pci, alx_pci_tbl);
 MODULE_AUTHOR("Johannes Berg <johannes@sipsolutions.net>");
-MODULE_AUTHOR("Qualcomm Corporation, <nic-devel@qualcomm.com>");
+MODULE_AUTHOR("Qualcomm Corporation");
 MODULE_DESCRIPTION(
 	"Qualcomm Atheros(R) AR816x/AR817x PCI-E Ethernet Network Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 1d17c24e6d75..c6263cf8d3c0 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -32,7 +32,7 @@ static const struct pci_device_id atl1c_pci_tbl[] = {
 MODULE_DEVICE_TABLE(pci, atl1c_pci_tbl);
 
 MODULE_AUTHOR("Jie Yang");
-MODULE_AUTHOR("Qualcomm Atheros Inc., <nic-devel@qualcomm.com>");
+MODULE_AUTHOR("Qualcomm Atheros Inc.");
 MODULE_DESCRIPTION("Qualcomm Atheros 100/1000M Ethernet Network Driver");
 MODULE_LICENSE("GPL");
 
-- 
2.30.2

