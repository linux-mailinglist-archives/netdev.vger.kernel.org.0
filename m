Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C46418A04B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 17:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgCRQOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 12:14:53 -0400
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:37834 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726473AbgCRQOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 12:14:53 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 22426181D3030;
        Wed, 18 Mar 2020 16:14:52 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2565:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:7576:8985:9025:9121:10004:10400:10848:11232:11233:11658:11914:12043:12048:12297:12663:12740:12760:12895:13069:13161:13229:13311:13357:13439:13845:14040:14096:14097:14181:14581:14659:14721:14764:21080:21324:21433:21627:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: size14_d38f1d1e6128
X-Filterd-Recvd-Size: 2078
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Wed, 18 Mar 2020 16:14:50 +0000 (UTC)
Message-ID: <1bcfc53c523f120a4cf0f19490de506c5704d306.camel@perches.com>
Subject: Re: [PATCH] bnx2x: fix spelling mistake "pauseable" -> "pausable"
From:   Joe Perches <joe@perches.com>
To:     Colin Ian King <colin.king@canonical.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 18 Mar 2020 09:13:02 -0700
In-Reply-To: <7ce6d58f-a2d0-7173-0163-f1e3b5f93e65@canonical.com>
References: <20200317182921.482606-1-colin.king@canonical.com>
         <8d9544fe6d413cdd600504e48f301e023b99e17b.camel@perches.com>
         <7ce6d58f-a2d0-7173-0163-f1e3b5f93e65@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-03-18 at 09:16 +0000, Colin Ian King wrote:
> On 18/03/2020 03:37, Joe Perches wrote:
> > On Tue, 2020-03-17 at 18:29 +0000, Colin King wrote:
> > > From: Colin Ian King <colin.king@canonical.com>
> > > 
> > > Bulk rename of variables and literal strings. No functional
> > > changes.
> > 
> > I'm not sure either spelling is a "real" word and
> > pauseable seems more intelligible and less likely
> > to be intended to be a typo of "possible" to me.
> 
> It's indeed of marginal benefit. However..
> 
> https://www.yourdictionary.com/pausable

Then again there's this:
https://www.spellcheck.net/misspelled-words/pausable

Correct spelling for PAUSABLE
        
            We think the word pausable is a misspelling.

and

https://www.anagrammer.com/crossword/answer/pausable

The word PAUSABLE is NOT valid in any word game. (Sorry, you cannot play
PAUSABLE in Scrabble, Words With Friends etc) 
    

                
        

