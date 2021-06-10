Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3923A252B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 09:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFJHTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 03:19:20 -0400
Received: from m12-12.163.com ([220.181.12.12]:54346 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhFJHTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 03:19:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=l2DzS
        Zh6xMUJTUBwiPkpftt8aGtaO4jSAl6jI3+phfw=; b=YdT0KSkgW5ZrIZcn9Tecs
        lfi3KRUFfcIDWsB6lIedl/qJPQ+qEPUE4f0toqDW/lwzt1j201F6WDKgofex+hCl
        z5nbMw3vVpYr1delI40NgMZ4zZGlbupyMjR7m1k7XvDYJq8Onk8FSjkasPLtPiOO
        zWJfWpwRVsTigfcY4K8ApE=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowABHECFoscFg9apBJA--.3570S2;
        Thu, 10 Jun 2021 14:30:01 +0800 (CST)
From:   13145886936@163.com
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] tipc:subscr.c: fix a spelling mistake
Date:   Wed,  9 Jun 2021 23:29:58 -0700
Message-Id: <20210610062958.38656-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMCowABHECFoscFg9apBJA--.3570S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtFW7WF48tr1kGry5KF13CFg_yoW3Xwc_Wa
        48tw4fu3y8Cw1xta17Aan5XrWxtay5uF4v9w13AFy8K3y0yryYka18tFn5Gry3uw10k3sr
        Zryqq34rJw4xujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU51WlPUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiQhOtg1aD-NN8+QABsB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix a spelling mistake.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/tipc/subscr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
index 8e00d739f03a..05d49ad81290 100644
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -66,7 +66,7 @@ static void tipc_sub_send_event(struct tipc_subscription *sub,
 /**
  * tipc_sub_check_overlap - test for subscription overlap with the given values
  * @subscribed: the service range subscribed for
- * @found: the service range we are checning for match
+ * @found: the service range we are checking for match
  *
  * Returns true if there is overlap, otherwise false.
  */
-- 
2.25.1


