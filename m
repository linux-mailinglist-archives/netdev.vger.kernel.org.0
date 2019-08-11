Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14DB88EF3
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 03:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfHKBDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 21:03:14 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:44163 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726292AbfHKBDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 21:03:14 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 5F5DA1822563C;
        Sun, 11 Aug 2019 01:03:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2902:3138:3139:3140:3141:3142:3352:3622:3865:3867:4321:5007:9036:10004:10400:10848:11026:11232:11658:11914:12043:12296:12297:12438:12679:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21627:30045:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: town85_38e2295c5af30
X-Filterd-Recvd-Size: 2035
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Sun, 11 Aug 2019 01:03:10 +0000 (UTC)
Message-ID: <67dd4fe22f197700a7bc3b663a63383ce51346df.camel@perches.com>
Subject: Re: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out
 of staging
From:   Joe Perches <joe@perches.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Date:   Sat, 10 Aug 2019 18:03:09 -0700
In-Reply-To: <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1565366213-20063-1-git-send-email-ioana.ciornei@nxp.com>
         <20190809190459.GW27917@lunn.ch>
         <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-08-10 at 21:45 +0000, Ioana Ciornei wrote:
> On 8/9/19 10:05 PM, Andrew Lunn wrote:
[]
>  >> +static int
>  >> +ethsw_get_link_ksettings(struct net_device *netdev,
>  >> +			 struct ethtool_link_ksettings *link_ksettings)
>  >> +{
>  >> +	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
>  >> +	struct dpsw_link_state state = {0};
>  >> +	int err = 0;
>  >> +
>  >> +	err = dpsw_if_get_link_state(port_priv->ethsw_data->mc_io, 0,
>  >> +				     port_priv->ethsw_data->dpsw_handle,
>  >> +				     port_priv->idx,
>  >> +				     &state);
>  >> +	if (err) {
>  >> +		netdev_err(netdev, "ERROR %d getting link state", err);

trivia:  Do please add terminating '\n's to all the formats.


