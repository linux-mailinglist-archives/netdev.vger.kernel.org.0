Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE04300FED
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbhAVTyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 14:54:03 -0500
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:49378 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728520AbhAVSiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:38:22 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 15BA018026205;
        Fri, 22 Jan 2021 18:37:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3350:3653:3865:3867:3868:3870:3872:4250:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12297:12555:12700:12737:12760:12986:13069:13095:13221:13229:13311:13357:13439:14181:14394:14659:14721:21080:21212:21433:21627:21660:30054:30070,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:28,LUA_SUMMARY:none
X-HE-Tag: hook92_4a17fb32756e
X-Filterd-Recvd-Size: 2090
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Fri, 22 Jan 2021 18:37:35 +0000 (UTC)
Message-ID: <b9dc4a808b1518e08ab8761480d9872e5d18e7cd.camel@perches.com>
Subject: [PATCH] checkpatch: Add kmalloc_array_node to unnecessary OOM
 message check
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>, Ronak Doshi <doshir@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Vandrovec <petr@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 22 Jan 2021 10:37:33 -0800
In-Reply-To: <20210122095006.58d258aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210120021941.9655-1-doshir@vmware.com>
         <20210121170705.08ecb23d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <888F37FB-B8BD-43D8-9E75-4F1CE9D4FAC7@vmware.com>
         <20210122095006.58d258aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 5799b255c491 ("include/linux/slab.h: add kmalloc_array_node() and
kcalloc_node()") was added in 2017.  Update the unnecessary OOM message
test to include it.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
---

Maybe not worth fixing, but no real effort to fix either.

 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4f8494527139..8dbf1986a8de 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -487,7 +487,7 @@ our $logFunctions = qr{(?x:
 
 our $allocFunctions = qr{(?x:
 	(?:(?:devm_)?
-		(?:kv|k|v)[czm]alloc(?:_node|_array)? |
+		(?:kv|k|v)[czm]alloc(?:_array)?(?:_node)? |
 		kstrdup(?:_const)? |
 		kmemdup(?:_nul)?) |
 	(?:\w+)?alloc_skb(?:_ip_align)? |

