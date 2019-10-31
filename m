Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3DEEAF20
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfJaLsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:48:08 -0400
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:41040 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726540AbfJaLsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:48:08 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id F17C6838434C;
        Thu, 31 Oct 2019 11:48:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:599:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3874:4250:4321:4385:5007:6119:8660:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12297:12438:12740:12760:12895:13069:13148:13230:13311:13357:13439:14659:14721:21080:21627:21795:21939:30051:30054:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: rose10_46b8522c0bd5a
X-Filterd-Recvd-Size: 1802
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Thu, 31 Oct 2019 11:48:05 +0000 (UTC)
Message-ID: <78c289a25faaa5dab2975f050199c93142718ab6.camel@perches.com>
Subject: Re: [net-next 10/13] dpaa_eth: remove netdev_err() for user errors
From:   Joe Perches <joe@perches.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, jakub.kicinski@netronome.com
Date:   Thu, 31 Oct 2019 04:47:57 -0700
In-Reply-To: <1572521819-10458-11-git-send-email-madalin.bucur@nxp.com>
References: <1572521819-10458-1-git-send-email-madalin.bucur@nxp.com>
         <1572521819-10458-11-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-31 at 13:36 +0200, Madalin Bucur wrote:
> User reports that an application making an (incorrect) call to
> restart AN on a fixed link DPAA interface triggers an error in
> the kernel log while the returned EINVAL should be enough.
[]
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
[]
> @@ -81,7 +81,6 @@ static int dpaa_get_link_ksettings(struct net_device *net_dev,
>  				   struct ethtool_link_ksettings *cmd)
>  {
>  	if (!net_dev->phydev) {
> -		netdev_dbg(net_dev, "phy device not initialized\n");
>  		return 0;
>  	}

ideally the now excess braces would be removed too.
 
> @@ -96,7 +95,6 @@ static int dpaa_set_link_ksettings(struct net_device *net_dev,
>  	int err;
>  
>  	if (!net_dev->phydev) {
> -		netdev_err(net_dev, "phy device not initialized\n");
>  		return -ENODEV;
>  	}

etc...


