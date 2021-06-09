Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBA23A0A6D
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 05:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhFIDFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 23:05:30 -0400
Received: from m12-16.163.com ([220.181.12.16]:50675 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231438AbhFIDFa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 23:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=gZKwd
        3aNIP9rzeKxuDyxIhrIwFgUfqysdlRMC5Q9IXM=; b=TeZqfdWaRT4Eokcf2FXew
        BeGuaCNYZT2riTXgxVhCHKYep3rKexUpiUneUL5rAd+ZIwhW6pGU/kIpObyT8YTR
        7vHlBHLNIDEDGQplvTpRLFmAzmCOV2+A6OiMDCQ4221lwOpP4MAQ8mSzNXUVV35o
        OqklUC2miLaAdTP+fTGnP4=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp12 (Coremail) with SMTP id EMCowACnszR3L8Bg01hwwA--.15351S2;
        Wed, 09 Jun 2021 11:03:20 +0800 (CST)
From:   13145886936@163.com
To:     ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] net/x25: fix a mistake in grammar
Date:   Tue,  8 Jun 2021 20:03:17 -0700
Message-Id: <20210609030317.17687-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EMCowACnszR3L8Bg01hwwA--.15351S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFyDurWkXr45uw1xCF43Awb_yoW3urg_WF
        nrKF4UWrWDJr1I9ay7GF4Fqr4Sy34Uu3yfZayI9FZxJ348Zr45K3sIgw4rAF1S9r48Cr9I
        g3yFg34Fkw17CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5Ub15UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiQhWsg1aD-MOnSwABs-
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix a mistake in grammar.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/x25/af_x25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 1816899499ce..3583354a7d7f 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -366,7 +366,7 @@ static void x25_destroy_timer(struct timer_list *t)
 
 /*
  *	This is called from user mode and the timers. Thus it protects itself
- *	against interrupt users but doesn't worry about being called during
+ *	against interrupting users but doesn't worry about being called during
  *	work. Once it is removed from the queue no interrupt or bottom half
  *	will touch it and we are (fairly 8-) ) safe.
  *	Not static as it's used by the timer
-- 
2.25.1


