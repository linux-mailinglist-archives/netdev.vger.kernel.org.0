Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68307AA709
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbfIEPLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:11:30 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:48982 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731401AbfIEPLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:11:30 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 470B525B753;
        Fri,  6 Sep 2019 01:11:28 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 9E883940A10; Thu,  5 Sep 2019 17:11:25 +0200 (CEST)
From:   Simon Horman <horms+renesas@verge.net.au>
To:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH net-next v2 1/4] ravb: correct typo in FBP field of SFO register
Date:   Thu,  5 Sep 2019 17:10:56 +0200
Message-Id: <20190905151059.26794-2-horms+renesas@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905151059.26794-1-horms+renesas@verge.net.au>
References: <20190905151059.26794-1-horms+renesas@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The field name is FBP rather than FPB.

This field is unused and could equally be removed from the driver entirely.
But there seems no harm in leaving as documentation of the presence of the
field.

Based on work by Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Acked-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
---
v2 - Simon Horman
* Accumulated tags
* Claimed authorship - a whole one line
* No mangled diff this time

v1 - Simon Horman
* Extracted from larger patch
* Wrote changelog
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

