Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D5D2DF188
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 21:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgLSUVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 15:21:43 -0500
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:52270 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727599AbgLSUVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 15:21:43 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 8984B837F24A;
        Sat, 19 Dec 2020 20:21:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:152:355:379:582:599:982:988:989:1152:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2693:2911:3138:3139:3140:3141:3142:3350:3698:3865:3866:3867:3868:3870:3872:4321:4425:5007:6261:6742:6743:7576:9010:9012:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:14659:14685:14777:21080:21324:21433:21451:21627:21819:30022:30029:30030:30054:30060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: trail89_47117a927448
X-Filterd-Recvd-Size: 1890
Received: from perches-mx.perches.com (imap-ext [216.40.42.5])
        (Authenticated sender: webmail@joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sat, 19 Dec 2020 20:21:00 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 19 Dec 2020 12:20:59 -0800
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pv-drivers@vmware.com,
        doshir@vmware.com, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, woojung.huh@microchip.com,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        drivers@pensando.io, snelson@pensando.io, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        bryan.whitehead@microchip.com, o.rempel@pengutronix.de,
        kernel@pengutronix.de, robin@protonic.nl, hkallweit1@gmail.com,
        nic_swsd@realtek.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, linux-kernel@vger.kernel.org,
        corbet@lwn.net
Subject: Re: [PATCH net] MAINTAINERS: remove names from mailing list
 maintainers
In-Reply-To: <20201219185538.750076-1-kuba@kernel.org>
References: <20201219185538.750076-1-kuba@kernel.org>
User-Agent: Roundcube Webmail/1.4-rc2
Message-ID: <53a3855a184f5af5b829065962ae5773@perches.com>
X-Sender: joe@perches.com
X-Originating-IP: [172.58.31.245]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-19 10:55, Jakub Kicinski wrote:
> When searching for inactive maintainers it's useful to filter
> out mailing list addresses. Such "maintainers" will obviously
> never feature in a "From:" line of an email or a review tag.
> 
> Since "L:" entries only provide the address of a mailing list
> without a fancy name extend this pattern to "M:" entries.


As these are not actual people I suggest using
R: entries and not removing the more descriptive names.
