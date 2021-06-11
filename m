Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A923A3ABA
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 06:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhFKEJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 00:09:52 -0400
Received: from mail-m971.mail.163.com ([123.126.97.1]:39262 "EHLO
        mail-m971.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhFKEJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 00:09:51 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jun 2021 00:09:50 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=JK59B
        nQzsQzGiQN6t1hIY6FUxl4BZr02ov496yuGuzc=; b=YZDohcZ5ZF2gbBBSpXnIN
        vzlcRodkeCEHujBKT3b6/yh5+Qx8I273a1yOdKGCVhc5Tvt8oLEdc978AjXzyv4l
        heqVeYLeLzdj3GSOi7OcTMaQiy+WdBS40sVKUqachT0GxS1J6aqHmXSsIoDPMenJ
        j0hq0827ZQ8quM/HqNgKjA=
Received: from ubuntu.localdomain (unknown [103.220.76.197])
        by smtp1 (Coremail) with SMTP id GdxpCgBH_XLp3cJgAIcVEQ--.151S2;
        Fri, 11 Jun 2021 11:52:14 +0800 (CST)
From:   13145886936@163.com
To:     robin@protonic.nl, linux@rempel-privat.de, kernel@pengutronix.de,
        socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH] can: j1939: socket: correct a grammatical error
Date:   Fri, 11 Jun 2021 11:52:02 +0800
Message-Id: <20210611035202.16833-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgBH_XLp3cJgAIcVEQ--.151S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xr4Dtr4DAF1fXw1UZFyDGFg_yoW3GFg_Zr
        n3Ar18X3yUXr1S9a15uwsrXryxt3WUWr18Zwn8tFy5K34xArW8Kwn8ua13Gry5KrWSvrya
        vwnYy3s8trWIqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8rMa5UUUUU==
X-Originating-IP: [103.220.76.197]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBRweug1PADBqMPQAAsZ
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
+	/* This function will be called by the generic networking code, when
 	 * the socket is ultimately closed (sk->sk_destruct).
 	 *
 	 * The race between
-- 
2.25.1

