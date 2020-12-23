Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD23D2E203F
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 18:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgLWR6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 12:58:43 -0500
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:36632 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgLWR6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 12:58:43 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 195C818045A48;
        Wed, 23 Dec 2020 17:58:02 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:967:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2691:2693:2828:2859:2911:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3698:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4425:5007:6742:6743:7576:9010:9012:9025:9040:10004:10400:10848:10967:11232:11596:11658:11783:11914:12043:12297:12679:12740:12895:13019:13069:13161:13229:13311:13357:13439:13846:13894:14180:14181:14659:14721:14777:21080:21324:21433:21451:21611:21627:21740:21819:21990:30022:30029:30030:30054:30060:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: smell21_3f007b52746a
X-Filterd-Recvd-Size: 2644
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Wed, 23 Dec 2020 17:57:58 +0000 (UTC)
Message-ID: <36399d76993cf04661b4ade819b3245951ae650b.camel@perches.com>
Subject: Re: [PATCH net] MAINTAINERS: remove names from mailing list
 maintainers
From:   Joe Perches <joe@perches.com>
To:     patchwork-bot+netdevbpf@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
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
Date:   Wed, 23 Dec 2020 09:57:57 -0800
In-Reply-To: <160869180729.29227.5706578456404319351.git-patchwork-notify@kernel.org>
References: <20201219185538.750076-1-kuba@kernel.org>
         <160869180729.29227.5706578456404319351.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-23 at 02:50 +0000, patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (refs/heads/master):
> 
> On Sat, 19 Dec 2020 10:55:38 -0800 you wrote:
> > When searching for inactive maintainers it's useful to filter
> > out mailing list addresses. Such "maintainers" will obviously
> > never feature in a "From:" line of an email or a review tag.
> > 
> > Since "L:" entries only provide the address of a mailing list
> > without a fancy name extend this pattern to "M:" entries.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net] MAINTAINERS: remove names from mailing list maintainers
>     https://git.kernel.org/netdev/net/c/8b0f64b113d6
> 
> You are awesome, thank you!

I still think this is not a good patch nor mechanism to
show what is generally used as exploders rather than
individuals.

Effectively only individuals can submit patches and so
can be M: Maintainers.

I believe these entries should really use R: Reviewer
entries and keep the descriptive naming content.

The descriptive naming does add value and this patch
loses that value.



