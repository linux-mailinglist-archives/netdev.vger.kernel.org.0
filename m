Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145872BC610
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 15:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgKVOgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 09:36:01 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:34325 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727740AbgKVOgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 09:36:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id B06BA5804B5;
        Sun, 22 Nov 2020 09:35:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 22 Nov 2020 09:35:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nXFQXK
        fZiozbO2A2p5WSuZcESUVebhywiKS6xDiDX6s=; b=U8PwL9v3InYmP4l5vq69A1
        CZxjNImJAt8FcmHH040X+sqsnC9VFXehMowLP5QvqJ6QaAeHBsn5R6Bkp4obCw2o
        d16m5A2EDJccAnmZPBPQXgs3DmjaJdvI1M9H3F/1GKgdc22RwtBU5CfvKlVsiOrT
        NwjM3LEKZge03FGN+kDzRni8BXfMaAz1F+5ZTfGnP02QCKesSRA/EAowOPY3YLge
        +PbFYNHfDLo8JaZKqtdGDO48z3NvNzbdoXH5bfaKEbJ2GydjTYJExheD1SsbaiIA
        kWwsQLZorMa90gmnZ4DrF0b31xzlzODisxfPXGT0OzbFnHPjqqQqEgdWOPFtZBpw
        ==
X-ME-Sender: <xms:Tne6X5LrjUt_QQRuBQu2QaF245DPbWILcuOrwCe1ezXEl-Wn32BAJQ>
    <xme:Tne6X1KVoLtWHnRUiS47OWpxNxsgOGSVZ6l7GR3mOHUlmtWnf-wEOfAhirrAIutZi
    Iq9HJVWPA1WL5k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeggedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepfffhvffukfhfgggtuggj
    sehttdertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthh
    esihguohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeehfeetvdeihefhhedugefh
    udehfeeugffhgeeuleeiteeludfgvddtheehtddtffenucffohhmrghinhepkhgvrhhnvg
    hlrdhorhhgpdhhohhpthhordhorhhgnecukfhppeekgedrvddvledrudehgedrudegjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Tne6XxuYf-TnrJ2SU1upU008v6QTwk_2IamOrxDR1KesnA-o8cGfng>
    <xmx:Tne6X6Zxw9SRc03FJVN-9sJBIRvxHZVzZjlAC2Exd75_FKlnF-5Ukg>
    <xmx:Tne6XwZMniS5pLq4nLKPHxMUmXzpG3figNKPesLSSTS4ZJeCitXZuw>
    <xmx:T3e6X9Tr58szJ3NekbSv1wvau56RxxKqy-FLtKPehFiEgSkBx-slGw>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id C4E043280063;
        Sun, 22 Nov 2020 09:35:57 -0500 (EST)
Date:   Sun, 22 Nov 2020 16:35:55 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christian Eggers <ceggers@gmx.de>,
        Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/3] mlxsw: spectrum_ptp: use PTP wide message
 type definitions
Message-ID: <20201122143555.GA515025@shredder.lan>
References: <20201122082636.12451-1-ceggers@arri.de>
 <20201122082636.12451-3-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201122082636.12451-3-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 09:26:35AM +0100, Christian Eggers wrote:
> Use recently introduced PTP wide defines instead of a driver internal
> enumeration.
> 
> Signed-off-by: Christian Eggers <ceggers@gmx.de>
> Cc: Petr Machata <petrm@mellanox.com>
> Cc: Jiri Pirko <jiri@nvidia.com>
> Cc: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

But:

1. Checkpatch complains about:
WARNING: From:/Signed-off-by: email address mismatch: 'From: Christian Eggers <ceggers@arri.de>' != 'Signed-off-by: Christian Eggers <ceggers@gmx.de>'

2. This series does not build, which fails the CI [1][2] and also
required me to fetch the dependencies that are currently under review
[3]. I believe it is generally discouraged to create dependencies
between patch sets that are under review for exactly these reasons. I
don't know what are Jakub's preferences, but had this happened on our
internal patchwork instance, I would just ask the author to submit
another version with all the patches.

Anyway, I added all six patches to our regression as we have some PTP
tests. Will let you know tomorrow.

Thanks

[1] https://lore.kernel.org/netdev/20201122082636.12451-1-ceggers@arri.de/T/#mcef35858585d23b72b8f75450a51618d5c5d3260
[2] https://patchwork.hopto.org/static/nipa/389053/11923809/build_allmodconfig_warn/summary
[3] https://patchwork.kernel.org/project/netdevbpf/cover/20201120084106.10046-1-ceggers@arri.de/
