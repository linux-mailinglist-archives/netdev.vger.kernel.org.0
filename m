Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A136731C610
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 05:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBPExj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 23:53:39 -0500
Received: from m12-12.163.com ([220.181.12.12]:55101 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhBPExg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 23:53:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Crq+/R51ZywcCE68Nd
        9EPx+wTRXjhto214xLK9drBCs=; b=m0kJlt3WOvKva9djZQJ2oP8b3GAtk9urvA
        0iIDAt5OmwQsoVNqVo3LTLEDgeLT88L9tP4aLxpK4kGDL8x8y6sjbPZN0o5DBngs
        kSgCzIRiBaqZ23T29JESy34cyn+3g4MVpdPF3A/U/pfqXiLAWyQZhvwHn6uvbV3+
        qhtjiC33s=
Received: from localhost.localdomain (unknown [125.70.193.99])
        by smtp8 (Coremail) with SMTP id DMCowACnFfVFRCtgdbFZQw--.33021S2;
        Tue, 16 Feb 2021 12:04:25 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, snelson@pensando.io, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Lin <chen.lin5@zte.com.cn>
Subject: [PATCH] ionic: Remove unused function pointer typedef ionic_reset_cb
Date:   Tue, 16 Feb 2021 12:05:30 +0800
Message-Id: <1613448330-4783-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
X-CM-TRANSID: DMCowACnFfVFRCtgdbFZQw--.33021S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKrWrAw1Duw1UZrWDKFW3Jrb_yoWfZrb_CF
        1UZF43Gr15GF1rKw1UKr43XryYvrZrWrW8Ja4aqayfKayUGa1Yy34jvF4UZrsrur4xJFs8
        GasrtFy2y34xtjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0Mlk7UUUUU==
X-Originating-IP: [125.70.193.99]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbBRxs7nlPABz-xowAAsA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Lin <chen.lin5@zte.com.cn>

Remove the 'ionic_reset_cb' typedef as it is not used.

Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 9bed427..563dba3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -249,8 +249,6 @@ static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
 	return (usecs * mult) / div;
 }
 
-typedef void (*ionic_reset_cb)(struct ionic_lif *lif, void *arg);
-
 void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep);
 void ionic_get_stats64(struct net_device *netdev,
 		       struct rtnl_link_stats64 *ns);
-- 
1.7.9.5


