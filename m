Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6758722F30D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgG0Owj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 10:52:39 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:49920 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729015AbgG0Owj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 10:52:39 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 8B7171730851;
        Mon, 27 Jul 2020 14:52:38 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3867:3868:3872:3873:4321:5007:8531:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13311:13357:13439:14659:21080:21627:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: help13_470362226f62
X-Filterd-Recvd-Size: 1689
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Jul 2020 14:52:36 +0000 (UTC)
Message-ID: <6e0c07bc3d2f48d4a62a9e270366c536cfe56783.camel@perches.com>
Subject: Re: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg
 uses
From:   Joe Perches <joe@perches.com>
To:     Pkshih <pkshih@realtek.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Date:   Mon, 27 Jul 2020 07:52:35 -0700
In-Reply-To: <1595840670.17671.4.camel@realtek.com>
References: <cover.1595706419.git.joe@perches.com>
         <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
         <1595830034.12227.7.camel@realtek.com>
         <ae9d562ec9ef765dddd1491d4cfb5f6d18f7025f.camel@perches.com>
         <1595840670.17671.4.camel@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-07-27 at 09:04 +0000, Pkshih wrote:
> So, I think you would like to have parenthesis intentionally.
> If so, 
> test1 ? : (test2 ? :)
> would be better.
> 
> 
> If not,
> test1 ? : test2 ? :
> may be what you want (without any parenthesis).

Use whatever style you like, it's unimportant to me
and it's not worth spending any real time on it.


