Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8647C22F56F
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732282AbgG0Qd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:33:59 -0400
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:34052 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729315AbgG0Qd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:33:59 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 87C41181D3026;
        Mon, 27 Jul 2020 16:33:58 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3868:3870:3872:3873:3874:4321:5007:6119:6248:7903:8531:10004:10400:10848:11232:11658:11914:12050:12297:12663:12740:12760:12895:13069:13095:13311:13357:13439:14096:14097:14659:14777:21080:21433:21627:21740:30054:30063:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: time94_1817cae26f62
X-Filterd-Recvd-Size: 2286
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Jul 2020 16:33:56 +0000 (UTC)
Message-ID: <f5162c93f70b9f47314eda2403b80816d12ce7e0.camel@perches.com>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
From:   Joe Perches <joe@perches.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Date:   Mon, 27 Jul 2020 09:33:55 -0700
In-Reply-To: <374359f9-8199-f4b9-0596-adc41c8c664f@lwfinger.net>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
         <1595830034.12227.7.camel@realtek.com>
         <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
         <1595840670.17671.4.camel@realtek.com>
         <6e0c07bc3d2f48d4a62a9e270366c536cfe56783.camel@perches.com>
         <374359f9-8199-f4b9-0596-adc41c8c664f@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-07-27 at 11:25 -0500, Larry Finger wrote:
> On 7/27/20 9:52 AM, Joe Perches wrote:
> > On Mon, 2020-07-27 at 09:04 +0000, Pkshih wrote:
> > > So, I think you would like to have parenthesis intentionally.
> > > If so,
> > > test1 ? : (test2 ? :)
> > > would be better.
> > > 
> > > 
> > > If not,
> > > test1 ? : test2 ? :
> > > may be what you want (without any parenthesis).
> > 
> > Use whatever style you like, it's unimportant to me
> > and it's not worth spending any real time on it.
> 
> If you are so busy, why did you jump in with patches that you knew I was already 
> working on? You knew because you critiqued my first submission.

Because it was over a week and you didn't reply
to my original message nor did you cc me on any
changes you made to your patch?

I can't read every patch I'm not cc'd on.


