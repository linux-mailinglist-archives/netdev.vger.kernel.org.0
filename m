Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08C42B69C0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgKQQQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:16:05 -0500
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:38320 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727127AbgKQQQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:16:04 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id B98D51822563C;
        Tue, 17 Nov 2020 16:16:02 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4362:5007:6119:7903:9025:10004:10400:10848:11232:11658:11914:12043:12048:12297:12555:12698:12737:12740:12760:12895:13069:13311:13357:13439:13845:14181:14659:14721:21080:21627:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: rake43_3008f7827332
X-Filterd-Recvd-Size: 1517
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Tue, 17 Nov 2020 16:16:00 +0000 (UTC)
Message-ID: <b9989e7d048765111826d1df549a364485ea546f.camel@perches.com>
Subject: Re: [PATCH][next] mwifiex: Fix fall-through warnings for Clang
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Tue, 17 Nov 2020 08:15:59 -0800
In-Reply-To: <20201117160958.GA18807@embeddedor>
References: <20201117160958.GA18807@embeddedor>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-17 at 10:09 -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> warnings by explicitly adding multiple break statements instead of
> letting the code fall through to the next case.

Thanks Gustavo.

I think this is better style than the gcc allowed
undescribed fallthrough to break;

gcc developers disagree though:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91432


