Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE5D1A6377
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 09:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbgDMHSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 03:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbgDMHSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 03:18:02 -0400
Received: from smtprelay.hostedemail.com (smtprelay0112.hostedemail.com [216.40.44.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2E2C008651;
        Mon, 13 Apr 2020 00:18:02 -0700 (PDT)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 56D5F4DC3;
        Mon, 13 Apr 2020 07:18:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:196:355:379:599:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1622:1711:1730:1747:1777:1792:2198:2199:2393:2525:2561:2564:2682:2685:2731:2828:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4184:4250:4321:5007:6671:8985:9025:10004:10400:10450:10455:10848:11232:11658:11914:12043:12297:12438:12555:12663:12740:12895:12986:13007:13069:13311:13357:13439:13618:13894:14180:14181:14659:14721:19904:19999:21060:21080:21324:21433:21627:30029:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:17,LUA_SUMMARY:none
X-HE-Tag: trees54_28c6c4fb2e643
X-Filterd-Recvd-Size: 2146
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Mon, 13 Apr 2020 07:18:00 +0000 (UTC)
Message-ID: <f1033e80969fce39d9cc97fb924f7d68e5f96f74.camel@perches.com>
Subject: Re: [PATCH] net: mvneta: Fix a typo
From:   Joe Perches <joe@perches.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        thomas.petazzoni@bootlin.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Mon, 13 Apr 2020 00:15:53 -0700
In-Reply-To: <eea1b700-4559-c8d1-1960-1858ed3d90ef@wanadoo.fr>
References: <20200412212034.4532-1-christophe.jaillet@wanadoo.fr>
         <6ecfa6cb686af1452101c0b727c9eb34d5582610.camel@perches.com>
         <eea1b700-4559-c8d1-1960-1858ed3d90ef@wanadoo.fr>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-04-13 at 08:56 +0200, Christophe JAILLET wrote:
> Le 12/04/2020 à 23:35, Joe Perches a écrit :
> > On Sun, 2020-04-12 at 23:20 +0200, Christophe JAILLET wrote:
> > > s/mvmeta/mvneta/
> > nice. how did you find this?
> 
> Hi,
> 
> This is based on a bash script I've made a while ago (see [1])
> I've slightly updated it, but the idea is still the same. I search 
> strings in a file with some variation on the file name (2 inverted 
> chars, 1 missing char or 1 modified char).
> 
> The output is horrible, and a lot of filtering should be done.
> It is much like noise, with MANY false positives. But I manage to dig 
> some interesting stuff out of it.
> 
> If interested in the updated script, just ask, but except the concept 
> itself, I'm not sure than anything else worth anything and is should be 
> rewritten from scratch.
> 
> The update includes some tweaks in order to search into Kconfig files 
> instead.
> 
> CJ
> 
> [1]: https://marc.info/?l=kernel-janitors&m=156382201306781&w=4

Nice.

I was wondering if you used levenshtein distance or something else.

https://en.wikipedia.org/wiki/Levenshtein_distance


