Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E629221ACD
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgGPDXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:23:35 -0400
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:46076 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726960AbgGPDXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:23:35 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 5037F181D341E;
        Thu, 16 Jul 2020 03:23:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:12:41:355:379:599:800:960:967:973:988:989:1260:1263:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2525:2553:2559:2562:2828:2902:2945:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3874:3936:3953:4250:4321:4605:5007:6117:7901:7903:8814:9388:9707:10004:10400:10848:10967:11232:11658:11914:12297:12740:12760:12895:13019:13069:13311:13357:13439:14094:14181:14659:14721:21080:21324:21433:21451:21627:21740:21939:21990:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: pump70_0116adc26efe
X-Filterd-Recvd-Size: 2024
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Thu, 16 Jul 2020 03:23:32 +0000 (UTC)
Message-ID: <04d15af886da8c91309134b67c0d3e8d69089188.camel@perches.com>
Subject: Re: [PATCH] SUNDANCE NETWORK DRIVER: Replace HTTP links with HTTPS
 ones
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     kda@linux-powerpc.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 15 Jul 2020 20:23:31 -0700
In-Reply-To: <20200715174437.04890794@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200709204925.27287-1-grandmaster@al2klimov.de>
         <20200715174437.04890794@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-07-15 at 17:44 -0700, Jakub Kicinski wrote:
> On Thu,  9 Jul 2020 22:49:25 +0200 Alexander A. Klimov wrote:
> > Rationale:
> > Reduces attack surface on kernel devs opening the links for MITM
> > as HTTPS traffic is much harder to manipulate.
> > 
> > Deterministic algorithm:
> > For each file:
> >   If not .svg:
> >     For each line:
> >       If doesn't contain `\bxmlns\b`:
> >         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> > 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
> >             If both the HTTP and HTTPS versions
> >             return 200 OK and serve the same content:
> >               Replace HTTP with HTTPS.
> > 
> > Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> 
> Applied to net-next, but please find a better algorithm for generating
> the subject prefixes. 

Suggestions welcomed for automating patch subject prefixes
for generic treewide conversions by subsystem.

git history doesn't work particularly well for that.



