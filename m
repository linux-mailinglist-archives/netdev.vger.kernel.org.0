Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E9480283
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 00:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392325AbfHBWFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 18:05:09 -0400
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:48139 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729311AbfHBWFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 18:05:09 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 669D7100E806B;
        Fri,  2 Aug 2019 22:05:07 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1263:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4384:4605:4659:5007:7514:9025:9388:9389:10004:10049:10400:10848:10967:11232:11658:11914:12043:12296:12297:12555:12740:12760:12895:12986:13069:13095:13311:13357:13439:14096:14097:14181:14659:14721:14764:21080:21433:21451:21611:21627:21691:30009:30054:30070:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: swing93_49a7a4bebce5e
X-Filterd-Recvd-Size: 2071
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Fri,  2 Aug 2019 22:05:06 +0000 (UTC)
Message-ID: <2ecfbf8dda354fe47912446bf5c3fe30ca905aa0.camel@perches.com>
Subject: Re: [PATCH] isdn: hysdn: Fix error spaces around '*'
From:   Joe Perches <joe@perches.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jose Carlos Cazarin Filho <joseespiriki@gmail.com>
Cc:     isdn@linux-pingi.de, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 02 Aug 2019 15:05:05 -0700
In-Reply-To: <20190802145506.168b576b@hermes.lan>
References: <20190802195602.28414-1-joseespiriki@gmail.com>
         <20190802145506.168b576b@hermes.lan>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-08-02 at 14:55 -0700, Stephen Hemminger wrote:
> On Fri,  2 Aug 2019 19:56:02 +0000
> Jose Carlos Cazarin Filho <joseespiriki@gmail.com> wrote:
> 
> > Fix checkpath error:
> > CHECK: spaces preferred around that '*' (ctx:WxV)
> > +extern hysdn_card *card_root;        /* pointer to first card */
> > 
> > Signed-off-by: Jose Carlos Cazarin Filho <joseespiriki@gmail.com>
> 
> Read the TODO, these drivers are scheduled for removal, so changes
> are not helpful at this time.

Maybe better to mark the MAINTAINERS entry obsolete so
checkpatch bleats a message about unnecessary changes.
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 30bf852e6d6b..b5df91032574 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8628,7 +8628,7 @@ M:	Karsten Keil <isdn@linux-pingi.de>
 L:	isdn4linux@listserv.isdn4linux.de (subscribers-only)
 L:	netdev@vger.kernel.org
 W:	http://www.isdn4linux.de
-S:	Odd Fixes
+S:	Obsolete
 F:	Documentation/isdn/
 F:	drivers/isdn/capi/
 F:	drivers/staging/isdn/

