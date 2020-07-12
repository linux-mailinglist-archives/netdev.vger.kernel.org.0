Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422AA21C7BD
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 08:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgGLGct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 02:32:49 -0400
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:54016 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727777AbgGLGct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 02:32:49 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 84F7C837F24A;
        Sun, 12 Jul 2020 06:32:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:196:355:379:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1567:1593:1594:1622:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3870:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:6671:7903:9025:10004:10400:10848:11232:11658:11914:12043:12048:12297:12555:12740:12895:12986:13007:13069:13161:13229:13311:13357:13439:13894:14181:14659:14721:21080:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: bead16_0f1504526edd
X-Filterd-Recvd-Size: 1575
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Sun, 12 Jul 2020 06:32:47 +0000 (UTC)
Message-ID: <866325009f9ae73b3a563dd745f901260a372242.camel@perches.com>
Subject: Re: [PATCH] net: sky2: switch from 'pci_' to 'dma_' API
From:   Joe Perches <joe@perches.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        mlindner@marvell.com, stephen@networkplumber.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Sat, 11 Jul 2020 23:32:45 -0700
In-Reply-To: <8a3e5514-9cc9-18f3-9a98-81007419a20a@wanadoo.fr>
References: <20200711204944.259152-1-christophe.jaillet@wanadoo.fr>
         <2181026e68d2948c396cc7a7b6bfb7146c1cd5f6.camel@perches.com>
         <8a3e5514-9cc9-18f3-9a98-81007419a20a@wanadoo.fr>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-07-12 at 08:29 +0200, Christophe JAILLET wrote:
> Le 11/07/2020 à 23:20, Joe Perches a écrit :
> > On Sat, 2020-07-11 at 22:49 +0200, Christophe JAILLET wrote:
> > > The wrappers in include/linux/pci-dma-compat.h should go away.
> > why?
> > 
> > 
>  From Christoph Hellwig 
> https://marc.info/?l=kernel-janitors&m=158745678307186&w=4

There's no why there.
There's just an assertion a wrapper should "go away".

"the wrappers in include/linux/pci-dma-compat.h should go away"

wrappers aren't all bad.

