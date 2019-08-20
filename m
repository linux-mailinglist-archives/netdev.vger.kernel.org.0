Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7942C96202
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730359AbfHTOIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:08:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45727 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729968AbfHTOIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 10:08:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 02F9C22281;
        Tue, 20 Aug 2019 10:08:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 20 Aug 2019 10:08:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O7Kzrf
        ohIuSvPtd1UzngE8AJHpkANJ/fKm2MTfi1JuU=; b=krT8hvBs1ZEc9ptZTRpdZ1
        2yhlowAcD4n+UQEeOcVg+CTNdLDi5yoj1449hHWtZUvII3GgNsh82ubS8eQXy/PO
        XCWc0zZ7oxeb+eSWSZVMipNJquR6qkSi1UgbPT7eyTUqjqMuifZnWCH7OfB95Caj
        g/5PqSPmI5SdsRxjgqAUnfSrOskw0tOVeCmNBsYwXWRimU9uBd7QqwOS3YK47OwL
        J490bSwEIDVpFlYPtxwhtpNARIvLg9JDWj7FsRNrKnvvmIF68qFgf9fWOg/Vg454
        X00fjLI8XHYA0yH64vDq9GOYjZSFnpkO7813IXz4ZYG4EphkmjWPYhbpBI6LoCow
        ==
X-ME-Sender: <xms:6_5bXU8HOIaQ9hzRMvpBXGoSxMTXj8n-Pbd_O9Sii12pGioCWduO-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeguddgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeejle
    drudejjedrvddurddukedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6_5bXQ80BC18pZKIbuXj9sVBt1jCYV13BL_IAsTGiUiPlmX7MLpd5w>
    <xmx:6_5bXVaCUQgkaZBDed6LFbUdQ4hD72U919odT-Cih1p3JyQVwBgFKQ>
    <xmx:6_5bXRV7yNbwITfrNHXs-WPpSbnEdXUC9AcplshoEE7ism-KKiwt7w>
    <xmx:7P5bXSiki45pPxWlEbU_Ls9zsSFkZyyZJHHJDYNj5OZ1eo1H9lLRrw>
Received: from localhost (unknown [79.177.21.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id BD30D38008A;
        Tue, 20 Aug 2019 10:08:42 -0400 (EDT)
Date:   Tue, 20 Aug 2019 17:08:04 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        idosch@mellanox.com, jiri@mellanox.com, mcroce@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netdevsim: Fix build error without CONFIG_INET
Message-ID: <20190820140804.GA31968@splinter>
References: <20190819120825.74460-1-yuehaibing@huawei.com>
 <20190819145900.5d9cc1f3@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819145900.5d9cc1f3@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 02:59:00PM -0700, Jakub Kicinski wrote:
> On Mon, 19 Aug 2019 20:08:25 +0800, YueHaibing wrote:
> > If CONFIG_INET is not set, building fails:
> > 
> > drivers/net/netdevsim/dev.o: In function `nsim_dev_trap_report_work':
> > dev.c:(.text+0x67b): undefined reference to `ip_send_check'
> > 
> > Add CONFIG_INET Kconfig dependency to fix this.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Fixes: da58f90f11f5 ("netdevsim: Add devlink-trap support")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Hmm.. I'd rather the test module did not have hard dependencies on
> marginally important config options. We have done a pretty good job
> so far limiting the requirements though separating the code out at
> compilation object level. The more tests depend on netdevsim and the
> more bots we have running tests against randconfig - the more important
> this is.
> 
> This missing reference here is for calculating a checksum over a
> constant header.. could we perhaps just hard code the checksum?

Sure. I was AFK today, will send a patch later today when I get home.

Thanks
