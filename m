Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1221947BA
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgCZToJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:44:09 -0400
Received: from smtprelay0223.hostedemail.com ([216.40.44.223]:42186 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728317AbgCZToH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:44:07 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 9A217181D41BF;
        Thu, 26 Mar 2020 19:44:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2917:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:6248:6742:7576:7774:7901:8985:9025:9036:10004:10400:10848:10967:11026:11232:11658:11914:12043:12296:12297:12438:12740:12760:12895:13019:13069:13311:13357:13439:14096:14097:14181:14659:14721:14764:14777:21080:21433:21451:21627:30012:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: laugh42_7acb8a21a4a4b
X-Filterd-Recvd-Size: 2711
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Thu, 26 Mar 2020 19:44:03 +0000 (UTC)
Message-ID: <385ff77269e5df76c917d494de012a8f83fea31e.camel@perches.com>
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>
Cc:     florinel.iordache@nxp.com, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Date:   Thu, 26 Mar 2020 12:42:11 -0700
In-Reply-To: <20200326.120743.1932411612374465145.davem@davemloft.net>
References: <1585230682-24417-7-git-send-email-florinel.iordache@nxp.com>
         <20200326.115330.2250343131621391364.davem@davemloft.net>
         <46bf05a81237ed716bf06b48891fcd7c129eae5d.camel@perches.com>
         <20200326.120743.1932411612374465145.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-03-26 at 12:07 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Thu, 26 Mar 2020 11:55:17 -0700
> 
> > On Thu, 2020-03-26 at 11:53 -0700, David Miller wrote:
> >> From: Florinel Iordache <florinel.iordache@nxp.com>
> >> Date: Thu, 26 Mar 2020 15:51:19 +0200
> >> 
> >> > +static void kr_reset_master_lane(struct kr_lane_info *krln)
> >> > +{
> >> > +     struct phy_device *bpphy = krln->bpphy;
> >> > +     struct backplane_phy_info *bp_phy = bpphy->priv;
> >> > +     const struct lane_io_ops *lane_ops = krln->bp_phy->bp_dev.lane_ops;
> >> 
> >> Please use reverse christmas tree ordering for local variables.
> > 
> > How (any why) do you suggest the first 2 entries here
> > should be ordered?
> 
> You have to sometimes put assignments into the code body rather than
> the declarations in situations like this.

No "why" reply given.

An option is not using reverse christmas tree to both
avoid ordering
constraints and reduce overall line count.

I think this is your own personal taste rather than an
actual valuable addition for subsystem maintenance.

And if this a serious requirement for the subsystem
you oversee, you should add it to something like a
maintainer-entry-profile with a "P:" line in MAINTAINERS.

https://www.kernel.org/doc/html/latest/maintainer/maintainer-entry-profile.html



