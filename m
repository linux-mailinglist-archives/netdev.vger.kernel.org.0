Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEFC39EC68
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFHC6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:58:08 -0400
Received: from m12-18.163.com ([220.181.12.18]:57394 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhFHC6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 22:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=wJavJ
        IZ3rkjBqcOadhie55VNtZw3NrGG5os88R0EbcY=; b=eG1356y3AA6j6I6a57s2s
        JtofudQq7FEfgemM4ou7lIY+ec0AmwVOJUDTGaS2qRR1o6KsUjVrW/jdTOF2/XKx
        XsfRGLWYsSx49r8EvXgZsuV8ik4Wz7lKmlZi4DgoLJA/xfjglDu0LQ7mjQT0wwYr
        CoerG0mr2w43UZbqXPVyzM=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowACnrs5F3L5gQwujoA--.55587S2;
        Tue, 08 Jun 2021 10:56:05 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH v2] net: appletalk: fix some mistakes in grammar
Date:   Mon,  7 Jun 2021 19:56:02 -0700
Message-Id: <20210608025602.8066-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowACnrs5F3L5gQwujoA--.55587S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XF1Dtw15Cw4UZFWkJFyDGFg_yoWkuwb_Ja
        yfGr9F9rWvy3Wkt3W3Gan8Wr4rCw1FvF18AF9xCrZxJrZYv3W8Cw1UWF97GF18XFWj9FZa
        93WruFsYqr13KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5b2-5UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiQgWrg1aD-La3HwAAsY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix some mistakes in grammar.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
v2: This statement "Anyone wanting to add it goes ahead." 
is changed to "Anyone wanting to add it, go ahead.".
 net/appletalk/ddp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index bc76b2fa3dfb..8ade5a4ceaf5 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -707,7 +707,7 @@ static int atif_ioctl(int cmd, void __user *arg)
 
 		/*
 		 * Phase 1 is fine on LocalTalk but we don't do
-		 * EtherTalk phase 1. Anyone wanting to add it goes ahead.
+		 * EtherTalk phase 1. Anyone wanting to add it, go ahead.
 		 */
 		if (dev->type == ARPHRD_ETHER && nr->nr_phase != 2)
 			return -EPROTONOSUPPORT;
@@ -828,7 +828,7 @@ static int atif_ioctl(int cmd, void __user *arg)
 		nr = (struct atalk_netrange *)&(atif->nets);
 		/*
 		 * Phase 1 is fine on Localtalk but we don't do
-		 * Ethertalk phase 1. Anyone wanting to add it goes ahead.
+		 * Ethertalk phase 1. Anyone wanting to add it, go ahead.
 		 */
 		if (dev->type == ARPHRD_ETHER && nr->nr_phase != 2)
 			return -EPROTONOSUPPORT;
-- 
2.25.1


