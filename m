Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BBB254427
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 13:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgH0KzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:55:10 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:58514 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727066AbgH0Kwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:52:53 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id BDA19181D3028;
        Thu, 27 Aug 2020 10:52:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2692:2828:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4425:5007:6119:7903:8531:10004:10400:10450:10455:10848:11232:11658:11914:12050:12297:12740:12760:12895:13069:13311:13357:13439:14096:14097:14181:14659:14721:19904:19999:21080:21627:21740:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:3,LUA_SUMMARY:none
X-HE-Tag: grip29_510e74c2706c
X-Filterd-Recvd-Size: 2584
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Thu, 27 Aug 2020 10:52:44 +0000 (UTC)
Message-ID: <1a23235e40b8089629ca784d8e33851b715a6599.camel@perches.com>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Pkshih <pkshih@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Date:   Thu, 27 Aug 2020 03:52:42 -0700
In-Reply-To: <87v9h4bfqz.fsf@codeaurora.org>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
         <1595830034.12227.7.camel@realtek.com>
         <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
         <1595840670.17671.4.camel@realtek.com>
         <6e0c07bc3d2f48d4a62a9e270366c536cfe56783.camel@perches.com>
         <374359f9-8199-f4b9-0596-adc41c8c664f@lwfinger.net>
         <87v9h4bfqz.fsf@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-08-27 at 12:27 +0300, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> > On 7/27/20 9:52 AM, Joe Perches wrote:
> > > On Mon, 2020-07-27 at 09:04 +0000, Pkshih wrote:
> > > > So, I think you would like to have parenthesis intentionally.
> > > > If so,
> > > > test1 ? : (test2 ? :)
> > > > would be better.
> > > > 
> > > > 
> > > > If not,
> > > > test1 ? : test2 ? :
> > > > may be what you want (without any parenthesis).
> > > 
> > > Use whatever style you like, it's unimportant to me
> > > and it's not worth spending any real time on it.
> > 
> > If you are so busy, why did you jump in with patches that you knew I
> > was already working on? You knew because you critiqued my first
> > submission.
> 
> Yeah, I don't understand this either. First stepping on Larry's work and
> when after getting review comments claiming being busy and not caring is
> contradicting.

I didn't say I was busy, I said I didn't care.

And it's not stepping on anyone's work, it's
a trivial contribution.  Take it or not.
It's been months btw, the pace of the work isn't
particularly fast here.


