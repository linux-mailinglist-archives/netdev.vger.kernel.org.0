Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5029C28529B
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 21:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgJFTjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 15:39:19 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48835 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbgJFTjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 15:39:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CE6385C017C;
        Tue,  6 Oct 2020 15:39:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 06 Oct 2020 15:39:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1BxYUn
        Novr8v6HeLCCrQ0Lav1yajqu2dCR0rXErgD2k=; b=DpcjF+YCY8oP0jFFyKQxEG
        NnJFWkhojQ5e7Vu3lEKxQlnWxxoNd6ZFKAm6FflWwZ3XM8ocTze4Zbh97Hlu6ibA
        n6R0sZF+gQ5/3pkjSsCiZ8rwtM92Zl/MAK4Z2G9DQBd3R0Q2IEC82VUXm1JmxPuR
        cGVLSyDvTp5kGNspyPWa32prpoknHPYaP9YmaKh5OON6zJSNLfLPjWhHn0rgbjs7
        m1iKpFf52YBWTXbwOqAolIzvEly88OuIaIo0pMq5L8FFgg4CG8PE2tCKH3ub1yoc
        oFYJDKAJq5ZG934ona/IRF4lY1h0FRuljmReSvuQpQdKZ/waWtwOL6BpN5NeLrSg
        ==
X-ME-Sender: <xms:5cd8X0cE-2rvXYKAdxEaCt43mp-mccYDzXctRYPx0HCb8derSHHV_g>
    <xme:5cd8X2O4It4UgcB6S_3NWBtHPvDsuGkPbMp3ZZLW2CNxFhCD-Bapr4FC7WzTdxOxq
    7GnShZccsJ7-QE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgeeggddufeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepgfevgfevueduueffieffheeifffgje
    elvedtteeuteeuffekvefggfdtudfgkeevnecuffhomhgrihhnpehkvghrnhgvlhdrohhr
    ghenucfkphepkeegrddvvdelrdefjedrudegkeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:5cd8X1jMFZO8B5jEOcbsILQu91xYs77O5RTvm8FE_eXPO8uquPsa7Q>
    <xmx:5cd8X5994iux8Tn2t7JyV0-M-jt7Pmt6iUNENuDV4wXAuIwXxEFUmw>
    <xmx:5cd8XwsbJBkPfe6DgOd3w3MrvW2VTAgYkjsjY60X-6pY-mZAu8Y5Ug>
    <xmx:5cd8X20cv9grq13R-JUSLbi2ZBtXvmi-KCuQ6yulM_d5BZAlLBdA6Q>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC2DD328005E;
        Tue,  6 Oct 2020 15:39:16 -0400 (EDT)
Date:   Tue, 6 Oct 2020 22:39:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH ethtool-next v2 5/6] netlink: use policy dumping to check
 if stats flag is supported
Message-ID: <20201006193913.GA2932230@shredder>
References: <20201006150425.2631432-1-kuba@kernel.org>
 <20201006150425.2631432-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006150425.2631432-6-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 08:04:24AM -0700, Jakub Kicinski wrote:
> Older kernels don't support statistics, to avoid retries
> make use of netlink policy dumps to figure out which
> flags kernel actually supports.

Thanks for working on this, Jakub.

Michal, should I try something similar for the legacy flag we have been
discussing earlier this week [1]?

[1] https://lore.kernel.org/netdev/20201005074600.xkbomksbbuliuyft@lion.mk-sys.cz/#t
