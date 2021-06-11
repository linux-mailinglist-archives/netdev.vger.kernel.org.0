Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1943A3959
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 03:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhFKBnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 21:43:25 -0400
Received: from mail-m972.mail.163.com ([123.126.97.2]:39468 "EHLO
        mail-m972.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhFKBnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 21:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=aVNNe
        SE3Rgpe8lFTKlM7vDmFANfMcnb5OouqT8Q1iLY=; b=c1HSmQokkPh2TpYz3R0AS
        pJqg2EVxzELKKiooG/K/dtpEHiYJNaV3EzFjyz79NjdY2paYNeYx+88bLyyiM4aZ
        81mc7/cA9euqlXz1hDjvo98Q/lbQoDcsHaZxffR6rncid8l9h8cHVPbCQhyRsjNx
        /To8XP6fQf32s6nfzW/cIA=
Received: from ubuntu.localdomain (unknown [103.220.76.197])
        by smtp2 (Coremail) with SMTP id GtxpCgBH7sUlv8JglMRmFA--.794S2;
        Fri, 11 Jun 2021 09:40:55 +0800 (CST)
From:   13145886936@163.com
To:     robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] can: j1939: socket: correct a grammatical error
Date:   Fri, 11 Jun 2021 09:40:51 +0800
Message-Id: <20210611014051.13081-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgBH7sUlv8JglMRmFA--.794S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xr4Dtr4DAF1fXw1UZFyDGFg_yoW3Xrb_Zr
        n3Ar18X3y8Xr1S9a15uwsrXryxt3WUWr18Zwn8tFy5K34xArW8K3Z8ua13Gry5KrWSvrya
        vwnYy3s8trWIqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8zyIUUUUUU==
X-Originating-IP: [103.220.76.197]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiXAmug1Xlz7JpGQAAsF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Correct a grammatical error.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/can/j1939/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 56aa66147d5a..31ec493a0fca 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -352,7 +352,7 @@ static void j1939_sk_sock_destruct(struct sock *sk)
 {
 	struct j1939_sock *jsk = j1939_sk(sk);
 
-	/* This function will be call by the generic networking code, when then
+	/* This function will be called by the generic networking code, when then
 	 * the socket is ultimately closed (sk->sk_destruct).
 	 *
 	 * The race between
-- 
2.25.1

