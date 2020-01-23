Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA46514600F
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 01:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgAWAp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 19:45:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52749 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWAp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 19:45:59 -0500
Received: from [82.43.126.140] (helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iuQdA-0006Os-F3; Thu, 23 Jan 2020 00:45:56 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] caif_usb: fix spelling mistake "to" -> "too"
Date:   Thu, 23 Jan 2020 00:45:55 +0000
Message-Id: <20200123004555.2833355-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a pr_warn message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/caif/caif_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index 76bd67891fb3..a0116b9503d9 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -62,7 +62,7 @@ static int cfusbl_transmit(struct cflayer *layr, struct cfpkt *pkt)
 	hpad = (info->hdr_len + CFUSB_PAD_DESCR_SZ) & (CFUSB_ALIGNMENT - 1);
 
 	if (skb_headroom(skb) < ETH_HLEN + CFUSB_PAD_DESCR_SZ + hpad) {
-		pr_warn("Headroom to small\n");
+		pr_warn("Headroom too small\n");
 		kfree_skb(skb);
 		return -EIO;
 	}
-- 
2.24.0

