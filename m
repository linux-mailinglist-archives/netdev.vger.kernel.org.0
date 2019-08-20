Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96B996225
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbfHTONe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:13:34 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60577 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729762AbfHTONe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:13:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5715A45B;
        Tue, 20 Aug 2019 10:13:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 20 Aug 2019 10:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TM1y1m
        5mUDdALJbEa/kxdffbL8mes0pBL8m2Q8+L714=; b=AZbFaApxsVf1LSQwFwuMjF
        JcHomHWzuz1dTTSEh1lNjbu6QZw7/jt3B7Htf26JfF7fWwO3DEnBfY//r/KgFNm0
        C+hmUf4Bpw3ZzTPpxKE4v8r+rVgZfkQJAcgXV+XZBhFFza9suztqMZa1ER1zF9H1
        khHVp7RNZRnRoHx2hk8bZ0yAbZM1szjCeDksmV7lkO/VjQKeilAofXOv9JQ+KUZZ
        C7R00ysCu0HX3XLjn48Yv4hLJ7JJFPet2gCGJxxUfiCIHGTrCFgC75CeMBdw9FOG
        RgDI7fVqUCTEgn5u1X3r23UKBMRudbTJn4D5tqFM2dVGiycmDrJGYN9p1bJb1IFQ
        ==
X-ME-Sender: <xms:CQBcXT-6Ra3cbIIXPBNNUBtZvml3_xkKOyQfUv2C61DWBfP5T3Knqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeguddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuffhomhgrih
    hnpehoiihlrggsshdrohhrghenucfkphepjeelrddujeejrddvuddrudektdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhush
    htvghrufhiiigvpedt
X-ME-Proxy: <xmx:CQBcXX9ak_2u1B2F6QphP5OhbvGduq-T9pCmI2AP4jN7Uo1ff-axlA>
    <xmx:CQBcXU8nwJ9E6wboBS6TBknJakJv6ZjfQykEOHx20B2_Fr_KcST0Zw>
    <xmx:CQBcXWxbvw2Ll552sqAUIKcGP3PLj0ZvVLzz7SVS26Iht9FoVpsDfg>
    <xmx:CwBcXSXToNka_kTXMLaWohgMNoHC83FJeWLvI1ptP4Uf8us57Y1JwQ>
Received: from localhost (bzq-79-177-21-180.red.bezeqint.net [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3B4980059;
        Tue, 20 Aug 2019 10:13:28 -0400 (EDT)
Date:   Tue, 20 Aug 2019 17:13:24 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 19 (drivers/net/netdevsim/dev.o)
Message-ID: <20190820141324.GC31968@splinter>
References: <20190819191832.03f1a579@canb.auug.org.au>
 <92ef45a5-c933-0493-b2ff-50352fa8bf3f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92ef45a5-c933-0493-b2ff-50352fa8bf3f@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 09:16:13PM -0700, Randy Dunlap wrote:
> On 8/19/19 2:18 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20190816:
> > 
> 
> on x86_64:
> # CONFIG_INET is not set
> 
> ld: drivers/net/netdevsim/dev.o: in function `nsim_dev_trap_report_work':
> dev.c:(.text+0x52f): undefined reference to `ip_send_check'

Thanks, Randy.

There is a fix here [1], but some changes were requested. I will send a
fix later today and Cc you.

[1] https://patchwork.ozlabs.org/patch/1149229/
