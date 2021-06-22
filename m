Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0D13AFCD8
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFVGHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:07:55 -0400
Received: from m12-18.163.com ([220.181.12.18]:57688 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhFVGHy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 02:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ilcOj
        Hf4q07TTFRR9LGXtwmnIXI9EZlayKctXMKUjH8=; b=UqCiVuCwKF8jicdDfa4wu
        6FCMVgTj3r+HaJ3ihCk5MjQANiIY0ZjS/rAR4oaZOPaSWxWoRwqNYNnnhiNNCjYQ
        gZFtcG6DFQ608/roj76DOm9MYToLQj3dreV/GH98nXphpSQKM1uTcOTHR+F0V4eF
        zhS+sIrzXVus66ueESvu8M=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowABXXOShfdFg3T6Kqw--.59927S2;
        Tue, 22 Jun 2021 14:05:22 +0800 (CST)
From:   13145886936@163.com
To:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] bridge: cfm: remove redundant return
Date:   Mon, 21 Jun 2021 23:05:19 -0700
Message-Id: <20210622060519.318930-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowABXXOShfdFg3T6Kqw--.59927S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JrWUJFyrAw17tFWrAF1rtFb_yoW3JwbEkF
        93Zas2g3y5tr92k3y5AFsFqF1xK3y8uryIk3WqqFZIy3y5Ar4a9a4kWF1fJr1Ygr48ur9r
        Gw4qkrZIkw12kjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU54T5JUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBRw+5g1PADJXlnAAAsB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Return statements are not needed in Void function.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/bridge/br_cfm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
index 001064f7583d..a3c755d0a09d 100644
--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -142,7 +142,7 @@ static void br_cfm_notify(int event, const struct net_bridge_port *port)
 {
 	u32 filter = RTEXT_FILTER_CFM_STATUS;
 
-	return br_info_notify(event, port->br, NULL, filter);
+	br_info_notify(event, port->br, NULL, filter);
 }
 
 static void cc_peer_enable(struct br_cfm_peer_mep *peer_mep)
-- 
2.25.1


