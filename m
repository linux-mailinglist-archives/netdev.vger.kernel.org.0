Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C235FEDD
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfGDX6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:58:11 -0400
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:45332 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727829AbfGDX6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 19:58:02 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id D8E168368EFC;
        Thu,  4 Jul 2019 23:58:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:4321:4605:5007:6261:8603:10004:10848:11026:11657:11658:11914:12043:12296:12297:12438:12555:12895:13069:13138:13231:13311:13357:14096:14181:14384:14394:14721:21080:21627:30054,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: ring36_631e347fc9527
X-Filterd-Recvd-Size: 1477
Received: from joe-laptop.perches.com (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Thu,  4 Jul 2019 23:58:01 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 6/8] net: nixge: Fix misuse of strlcpy
Date:   Thu,  4 Jul 2019 16:57:46 -0700
Message-Id: <ab064ed18bee3e59431afb742dfe7a570d7d0b58.1562283944.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <cover.1562283944.git.joe@perches.com>
References: <cover.1562283944.git.joe@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Probable cut&paste typo - use the correct field size.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/ni/nixge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 96f7a9818294..0b384f97d2fd 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -990,7 +990,7 @@ static void nixge_ethtools_get_drvinfo(struct net_device *ndev,
 				       struct ethtool_drvinfo *ed)
 {
 	strlcpy(ed->driver, "nixge", sizeof(ed->driver));
-	strlcpy(ed->bus_info, "platform", sizeof(ed->driver));
+	strlcpy(ed->bus_info, "platform", sizeof(ed->bus_info));
 }
 
 static int nixge_ethtools_get_coalesce(struct net_device *ndev,
-- 
2.15.0

