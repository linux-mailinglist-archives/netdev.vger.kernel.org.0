Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEA43A241F
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 07:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFJFxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 01:53:17 -0400
Received: from m12-18.163.com ([220.181.12.18]:39763 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJFxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 01:53:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Xjjm8
        wPDmlOQZUcNtDueNsxlGren9KtpZtjNt9Q4OEg=; b=dzIpcypzJ2DQwZYvASFNm
        DxG2iFmaPJCuOqmiiGEQDS9uK1dGq+CU8SgqkfQhdYVLJGk9+fp6aO9x/vNqFzH1
        taxolg1/pr91bJkElGtgLHQGYdXCeNu1TCyKytCMinvRliURp+FH+X4IIT9a9AHP
        esJfbuiDlh07Nq7FA83u5U=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowABHS+M9qMFg7xRcog--.32388S2;
        Thu, 10 Jun 2021 13:50:54 +0800 (CST)
From:   13145886936@163.com
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] node.c: fix the use of indefinite article
Date:   Wed,  9 Jun 2021 22:50:46 -0700
Message-Id: <20210610055046.37722-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowABHS+M9qMFg7xRcog--.32388S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZryxuw4DAF18Jry7JF1UKFg_yoW3urX_CF
        1ku3y8W3y5J3s293yDAwn5XFs7Aa15uFyI9w1xGryIq3s8AFW5ta95CryrZrWrWrW7u34D
        AF1Fy3Wftw429jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5OjjPUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiXBGtg1Xlz6fn7wABsy
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix the use of indefinite article.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/tipc/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 81af92954c6c..9947b7dfe1d2 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1214,7 +1214,7 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 		/* Peer has changed i/f address without rebooting.
 		 * If so, the link will reset soon, and the next
 		 * discovery will be accepted. So we can ignore it.
-		 * It may also be an cloned or malicious peer having
+		 * It may also be a cloned or malicious peer having
 		 * chosen the same node address and signature as an
 		 * existing one.
 		 * Ignore requests until the link goes down, if ever.
-- 
2.25.1


