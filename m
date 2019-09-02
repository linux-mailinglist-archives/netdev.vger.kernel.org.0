Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3763AA50D9
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbfIBIGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:06:13 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60600 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730059AbfIBIGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:06:12 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id CBE4D25B7D2;
        Mon,  2 Sep 2019 18:06:07 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 492AF940173; Mon,  2 Sep 2019 10:06:05 +0200 (CEST)
From:   Simon Horman <horms+renesas@verge.net.au>
To:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [net-next 1/3] ravb: correct typo in FBP field of SFO register
Date:   Mon,  2 Sep 2019 10:06:01 +0200
Message-Id: <20190902080603.5636-2-horms+renesas@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190902080603.5636-1-horms+renesas@verge.net.au>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>

The field name is FBP rather than FPB.

This field is unused and could equally be removed from the driver entirely.
But there seems no harm in leaving as documentation of the presence of the
field.

Signed-off-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
v0 - Kazuya Mizuguchi

v1 - Simon Horman
* Extracted from larger patch
* Wrote changelog

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index ac9195add811..bdb051f04b0c 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -317,7 +312,7 @@ enum UFCD_BIT {

 /* SFO */
 enum SFO_BIT {
-	SFO_FPB		= 0x0000003F,
+	SFO_FBP		= 0x0000003F,
 };

 /* RTC */
---
 drivers/net/ethernet/renesas/ravb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index ac9195add811..2596a95a4300 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -317,7 +317,7 @@ enum UFCD_BIT {
 
 /* SFO */
 enum SFO_BIT {
-	SFO_FPB		= 0x0000003F,
+	SFO_FBP		= 0x0000003F,
 };
 
 /* RTC */
-- 
2.11.0

