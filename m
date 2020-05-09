Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692A61CC539
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 01:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgEIXli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 19:41:38 -0400
Received: from smtprelay0250.hostedemail.com ([216.40.44.250]:51344 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728842AbgEIXle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 19:41:34 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 47A3518029120;
        Sat,  9 May 2020 23:41:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2540:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3870:3871:3872:3873:4321:5007:7576:10004:10400:10848:10967:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21451:21627:21740:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: magic98_64b48ef0ebc31
X-Filterd-Recvd-Size: 1718
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Sat,  9 May 2020 23:41:31 +0000 (UTC)
Message-ID: <1870db200ffa03e3fce935b5e35e4562989d2dcf.camel@perches.com>
Subject: Re: [PATCH] net/sonic: Fix some resource leaks in error handling
 paths
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, christophe.jaillet@wanadoo.fr,
        fthain@telegraphics.com.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Sat, 09 May 2020 16:41:30 -0700
In-Reply-To: <20200509.163217.1372289149714306397.davem@davemloft.net>
References: <50ef36cd-d095-9abe-26ea-d363d11ce521@wanadoo.fr>
         <20200509111321.51419b19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <fc5cf8da8e70ebb981a9fc3aec6834c74197f0ed.camel@perches.com>
         <20200509.163217.1372289149714306397.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-05-09 at 16:32 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Sat, 09 May 2020 15:42:36 -0700
> 
> > David, maybe I missed some notification about Jakub's role.
> > 
> > What is Jakub's role in relation to the networking tree?
> 
> He is the co-maintainer of the networking tree and you should respect
> his actions and feedback as if it were coming from me.

If he's committing drivers then presumably then
he should be added to this section as well.

NETWORKING DRIVERS
M:	"David S. Miller" <davem@davemloft.net>
L:	netdev@vger.kernel.org
S:	Odd Fixes

