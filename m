Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C1614FD83
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 15:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgBBOXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 09:23:50 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:35756 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgBBOXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 09:23:50 -0500
Received: from localhost.localdomain ([93.22.39.62])
        by mwinf5d09 with ME
        id xqPl2100G1LTYWM03qPmkl; Sun, 02 Feb 2020 15:23:47 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 02 Feb 2020 15:23:47 +0100
X-ME-IP: 93.22.39.62
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     macro@linux-mips.org, ralf@linux-mips.org, davem@davemloft.net,
        akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] defxx: Fix a sentinel at the end of a 'eisa_device_id' structure
Date:   Sun,  2 Feb 2020 15:23:41 +0100
Message-Id: <20200202142341.22124-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'struct eisa_device_id' must be ended by an empty string, not a NULL
pointer. Otherwise, a NULL pointer dereference may occur in
'eisa_bus_match()'.

Also convert some spaces to tab to please 'checkpatch.pl'.

Fixes: e89a2cfb7d7b ("[TC] defxx: TURBOchannel support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/fddi/defxx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
index 077c68498f04..7ef0c57f07c6 100644
--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -3768,11 +3768,11 @@ static void dfx_pci_unregister(struct pci_dev *pdev)
 
 #ifdef CONFIG_EISA
 static const struct eisa_device_id dfx_eisa_table[] = {
-        { "DEC3001", DEFEA_PROD_ID_1 },
-        { "DEC3002", DEFEA_PROD_ID_2 },
-        { "DEC3003", DEFEA_PROD_ID_3 },
-        { "DEC3004", DEFEA_PROD_ID_4 },
-        { }
+	{ "DEC3001", DEFEA_PROD_ID_1 },
+	{ "DEC3002", DEFEA_PROD_ID_2 },
+	{ "DEC3003", DEFEA_PROD_ID_3 },
+	{ "DEC3004", DEFEA_PROD_ID_4 },
+	{ "" }
 };
 MODULE_DEVICE_TABLE(eisa, dfx_eisa_table);
 
-- 
2.20.1

