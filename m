Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1052C7C0B
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 01:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgK3ALJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 19:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgK3ALI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 19:11:08 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF825C0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 16:10:27 -0800 (PST)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id CD7B7891AD;
        Mon, 30 Nov 2020 13:10:21 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1606695021;
        bh=UIqWYi9dJ/tmnYKWJprnq3EqMYZT/sDGMsS3orkktdo=;
        h=From:To:Cc:Subject:Date;
        b=BVXwGbSxxSE6NNiSC4BF9So9Y8VsGlyKL1PbiicB6DSYHHRWqUgWEPI6wpO4sOMnx
         zYZPoohLTv9sCOn5t7SJKxkdTA3nidQSu0PtYEIUfCeE+OkpHcwrpMuL2+661YoLMM
         P2K9Jd7fmDE6lkwUiJRO802vaOVXZ3MO+ZZtL+lK7YC0zCyfgsHxWIjVqPYZrf1uff
         Zk2NhVRmMHi89+Rkz97PtyBBtkcLEsb7l/g4KE39dondLRwhxVoneRtb2rO4S2scgS
         1oekPW8ZF6e1QPl6B2duOtsXeKMwYva1KsgyF9nH2jxZeubre1DGFKaC5miXlADICy
         dHLKzPcJaL1Fg==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5fc438660000>; Mon, 30 Nov 2020 13:10:19 +1300
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.20])
        by smtp (Postfix) with ESMTP id DD87913EF0D;
        Mon, 30 Nov 2020 13:10:15 +1300 (NZDT)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 966612800AA; Mon, 30 Nov 2020 13:10:16 +1300 (NZDT)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     leoyang.li@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [net-next PATCH] net: freescale: ucc_geth: remove unused SKB_ALLOC_TIMEOUT
Date:   Mon, 30 Nov 2020 13:10:10 +1300
Message-Id: <20201130001010.28998-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was added in commit ce973b141dfa ("[PATCH] Freescale QE UCC gigabit
ethernet driver") but doesn't appear to have been used. Remove it now.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 drivers/net/ethernet/freescale/ucc_geth.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethe=
rnet/freescale/ucc_geth.h
index 3fe903972195..1a9bdf66a7d8 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -882,7 +882,6 @@ struct ucc_geth_hardware_statistics {
 							   addresses */
=20
 #define TX_TIMEOUT                              (1*HZ)
-#define SKB_ALLOC_TIMEOUT                       100000
 #define PHY_INIT_TIMEOUT                        100000
 #define PHY_CHANGE_TIME                         2
=20
--=20
2.29.2

