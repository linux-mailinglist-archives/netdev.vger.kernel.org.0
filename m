Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720792EAA41
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbhAEL4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:56:23 -0500
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:35568 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726074AbhAEL4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 06:56:23 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id C3DED12FB;
        Tue,  5 Jan 2021 11:55:41 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3872:3873:4321:5007:6691:6742:7652:10004:10400:10848:11232:11658:11914:12297:12663:12740:12760:12895:13069:13161:13229:13255:13311:13357:13439:14180:14659:21060:21080:21627:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: talk84_2e09490274d8
X-Filterd-Recvd-Size: 1813
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Tue,  5 Jan 2021 11:55:39 +0000 (UTC)
Message-ID: <d6ee8f44f9ca285f17bdec972bcd0abb89fe64d6.camel@perches.com>
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word
 association defautly de-faulty
From:   Joe Perches <joe@perches.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Julian Calaby <julian.calaby@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        zhengbin13@huawei.com, baijiaju1990@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Tue, 05 Jan 2021 03:55:38 -0800
In-Reply-To: <X/RQeqAikxaCO2o0@Gentoo>
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
         <CAGRGNgX-JSPW8LSmAUbm=2jkx+K4EYdntCq6P2i8td0TUk7Nww@mail.gmail.com>
         <X/RD/pll4UoRJG0w@Gentoo>
         <CAGRGNgVHcOjt4at+tzgrPxn=04_Y3b16pihDw6xucg4Eh1GFSA@mail.gmail.com>
         <X/RQeqAikxaCO2o0@Gentoo>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-05 at 17:11 +0530, Bhaskar Chowdhury wrote:
> On 22:24 Tue 05 Jan 2021, Julian Calaby wrote:
> > Hi Bhaskar,
[]
> > and your change is just making this comment worse.
> really??? Not sure about it.

I agree with Julian.  I'm fairly sure it's worse.
The change you suggest doesn't parse well and is extremely odd.
If you _really_ want to just change this use (and the others),
I repeat his suggestion of "by default".


