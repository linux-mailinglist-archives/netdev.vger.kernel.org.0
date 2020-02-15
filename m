Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F80915FD4E
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 08:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgBOHRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 02:17:39 -0500
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:32945 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgBOHRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 02:17:39 -0500
Received: from localhost.localdomain ([93.22.132.135])
        by mwinf5d34 with ME
        id 2vHY2200J2vRqAd03vHZa6; Sat, 15 Feb 2020 08:17:36 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 15 Feb 2020 08:17:36 +0100
X-ME-IP: 93.22.132.135
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sameo@linux.intel.com, joe@perches.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, allison@lohutok.net,
        tglx@linutronix.de, kstewart@linuxfoundation.org,
        natechancellor@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] NFC: pn544: Fix a typo in a debug message
Date:   Sat, 15 Feb 2020 08:17:28 +0100
Message-Id: <20200215071728.302-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ending character of the string shoulb be \n, not \b.

Fixes: 17936b43f0fd ("NFC: Standardize logging style")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/nfc/pn544/pn544.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/pn544/pn544.c b/drivers/nfc/pn544/pn544.c
index 2b83156efe3f..b788870473e8 100644
--- a/drivers/nfc/pn544/pn544.c
+++ b/drivers/nfc/pn544/pn544.c
@@ -682,7 +682,7 @@ static int pn544_hci_tm_send(struct nfc_hci_dev *hdev, struct sk_buff *skb)
 static int pn544_hci_check_presence(struct nfc_hci_dev *hdev,
 				   struct nfc_target *target)
 {
-	pr_debug("supported protocol %d\b", target->supported_protocols);
+	pr_debug("supported protocol %d\n", target->supported_protocols);
 	if (target->supported_protocols & (NFC_PROTO_ISO14443_MASK |
 					NFC_PROTO_ISO14443_B_MASK)) {
 		return nfc_hci_send_cmd(hdev, target->hci_reader_gate,
-- 
2.20.1

