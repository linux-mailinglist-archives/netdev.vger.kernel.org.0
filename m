Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DCF180F26
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 06:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgCKFGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 01:06:44 -0400
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:33780 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725813AbgCKFGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 01:06:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 17F48182CED2A;
        Wed, 11 Mar 2020 05:06:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:541:800:960:967:973:982:988:989:1260:1311:1314:1345:1359:1437:1515:1534:1541:1568:1711:1714:1730:1747:1777:1792:2194:2199:2393:2525:2560:2563:2682:2685:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3865:3866:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4416:4605:5007:6261:9025:10004:10848:11026:11473:11657:11658:11914:12043:12048:12294:12297:12438:12555:12679:12895:12986:13069:13255:13311:13357:13894:14096:14181:14384:14394:14721:21080:21433:21627:21811:21939:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: skate15_1d63d46acf10d
X-Filterd-Recvd-Size: 1923
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 11 Mar 2020 05:06:41 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next 002/491] MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER: Use fallthrough;
Date:   Tue, 10 Mar 2020 21:51:16 -0700
Message-Id: <a110b54f4e04b43b866c9348a280c02c566769cd.1583896347.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583896344.git.joe@perches.com>
References: <cover.1583896344.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the various uses of fallthrough comments to fallthrough;

Done via script
Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 36953d4..01a7931 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -737,7 +737,7 @@ static int rvu_nix_aq_enq_inst(struct rvu *rvu, struct nix_aq_enq_req *req,
 		else if (req->ctype == NIX_AQ_CTYPE_MCE)
 			memcpy(mask, &req->mce_mask,
 			       sizeof(struct nix_rx_mce_s));
-		/* Fall through */
+		fallthrough;
 	case NIX_AQ_INSTOP_INIT:
 		if (req->ctype == NIX_AQ_CTYPE_RQ)
 			memcpy(ctx, &req->rq, sizeof(struct nix_rq_ctx_s));
-- 
2.24.0

