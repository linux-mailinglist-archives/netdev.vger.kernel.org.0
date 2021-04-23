Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FB836932A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 15:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242876AbhDWNaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 09:30:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47469 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242762AbhDWN3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 09:29:20 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lZvrJ-00027P-37; Fri, 23 Apr 2021 13:28:37 +0000
From:   Colin King <colin.king@canonical.com>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/atm: Fix spelling mistake "requed" -> "requeued"
Date:   Fri, 23 Apr 2021 14:28:36 +0100
Message-Id: <20210423132836.338763-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a printk message. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index eef637fd90b3..933e3ff2ee8d 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -680,7 +680,7 @@ static void ia_tx_poll (IADEV *iadev) {
           skb1 = skb_dequeue(&iavcc->txing_skb);
        }                                                        
        if (!skb1) {
-          IF_EVENT(printk("IA: Vci %d - skb not found requed\n",vcc->vci);)
+          IF_EVENT(printk("IA: Vci %d - skb not found requeued\n",vcc->vci);)
           ia_enque_head_rtn_q (&iadev->tx_return_q, rtne);
           break;
        }
-- 
2.30.2

