Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A0F20B408
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 16:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgFZOxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 10:53:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38637 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726139AbgFZOxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 10:53:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8C4AB5C006A;
        Fri, 26 Jun 2020 10:53:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 26 Jun 2020 10:53:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ppZcc6
        03iZn95ZqH2ovrXacyyBp5RdzHQ02K3FixuTg=; b=n7fePcpbAmf3TX7L9n3T+H
        QNviJ4heRg/AxCCLSFELugAxBkgMc8NkGS3YG/1LJQYhVnXa8gHwrldCMxmsD3yZ
        9VsnfQq+K4UA4Biokb0P0SX37XpHeCfq1hX/F6qVdVNVic6Wwah7mGkGYLpr1AsN
        FyCcABpNmRVrn99UV82z199UZXTCVqv4W1Ds01hAYCI2gm1fkNYQMoKLp83zPRqU
        3T2bx64E0rV7nIJxxfZc/wodJULX1cuftOgfyhUbs4mMiwwsD6o7HBUfkRzES5OE
        Jyf56qlpY920gRXPgsesbB3qtAjlCIoMnYFOvFgqyuC1dTMXM9bWrwYQlgpRRQ6A
        ==
X-ME-Sender: <xms:-gv2XjEStHTEamhZ8osv6J2iSLIxFb0nHfRiVaNeHypZ-jCn_wQmOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeluddgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepvdfgleejfeelgfdvteffteetleekve
    ejffejteegvdfghfejvdffleehheetvdegnecuffhomhgrihhnpehoiihlrggsshdrohhr
    ghenucfkphepuddtledrieeirdduledrudeffeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-gv2XgXhJQS9xAcmWZDWQXyP1DlsiUB_pt5niLYBn-5wuviWNtO4Ow>
    <xmx:-gv2XlKlR4pQf5NxCfqU7M6qUMA70CLynrqXqIOj-EOcOV7u9auFEw>
    <xmx:-gv2XhF8hAdxXRdJM5c-VnilofRQNIBrwXZKsNJdd1hQLgKakxg_8g>
    <xmx:_Qv2Xvyz-5_YRW653FYcPmOzKpIxy5Dfjn8UxbxWty0TORM3A4qWoQ>
Received: from localhost (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9880F328005A;
        Fri, 26 Jun 2020 10:53:45 -0400 (EDT)
Date:   Fri, 26 Jun 2020 17:53:42 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, popadrian1996@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/2] mlxsw: Add support for QSFP-DD transceiver
 type
Message-ID: <20200626145342.GA224557@shredder>
References: <20200626144724.224372-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626144724.224372-1-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 05:47:22PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set from Vadim adds support for Quad Small Form Factor
> Pluggable Double Density (QSFP-DD) modules in mlxsw.

Adrian,

In November you sent a patch that adds QSFP-DD support in ethtool user
space utility:
https://patchwork.ozlabs.org/project/netdev/patch/20191109124205.11273-1-popadrian1996@gmail.com/

Back then Andrew rightfully noted that no driver in the upstream kernel
supports QSFP-DD and the patch was deferred.

If this patch set is accepted, would it be possible for you to re-post
your patch?

Thanks
