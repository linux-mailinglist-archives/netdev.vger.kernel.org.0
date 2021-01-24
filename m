Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3578301AB6
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbhAXIrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:47:00 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52833 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726592AbhAXIq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:46:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DE93E5C00E7;
        Sun, 24 Jan 2021 03:45:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 24 Jan 2021 03:45:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=tQc55K
        YVSxLgWJmYupooMPn2+fiI0zkIa6CSiAZLPjc=; b=E3FDju3v3+T+8QNo5kRZij
        abi9lfWg+uIRA+dzynXZE5nBzOLrzxkgARa8ZE4UoYnELtlojIj0+d73LHm+AE1b
        O2ZJjhQ529xaU9T08+phcN9TwslH6GdCc3ZpBViLDGKMw7orSYdjqKXmqsTEDHYx
        Aj2pfEfHkPi6/eKwTiTuEreLNohPBj0AbWMtqDeGMIn9fm0hAcXl9tREVoB02NEf
        gUKofWq+Qz5TRUsBgmG/HcuT/AdBYRoyEmS+VsAhlok5OFeqksolpTeyjFyhKiYe
        EwzcoBAyRZsKbfwYPftlFSGrMyT0Vjs4tf4UGHeszJH/1Ft4yUY83dcQEpKH8WxA
        ==
X-ME-Sender: <xms:nTMNYK51eRTvWkLzSTlNgsc9lYR4fUGDvywpTwW4JDyStvT_r8rjrg>
    <xme:nTMNYD6Lz39EMUDPwPksINIlW56FH6KL8TiNSaDrvjHbPefIb5bB1YHOUWoOHjPof
    qxPAW10iYPO8PQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddtgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:nTMNYJdVAPsX5E2wxMCQtI2-LP-CKRUWvNXjbF8AaN2yG0WLVj8oVQ>
    <xmx:nTMNYHKHIUr_y7i_LD5xdo9uk788cYo3c8eu0xOL76-JFPRH2ZQLQQ>
    <xmx:nTMNYOLbUqUqpELMIXUIDTKNWXmky6dVJ_reYEhOpzp78BiYGy0Pnw>
    <xmx:nTMNYFXDtKh5oEc7_QqSndqvBN2INwXJQ4LQ_RH8nB3oqPjV0_txtw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 30C92108005B;
        Sun, 24 Jan 2021 03:45:16 -0500 (EST)
Date:   Sun, 24 Jan 2021 10:45:14 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Message-ID: <20210124084514.GB2819717@shredder.lan>
References: <AM0P190MB073828252FFDA3215387765CE4A00@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
 <20210123160348.GB2799851@shredder.lan>
 <20210123121439.4290b002@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123121439.4290b002@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 12:14:39PM -0800, Jakub Kicinski wrote:
> On Sat, 23 Jan 2021 18:03:48 +0200 Ido Schimmel wrote:
> > 	[DEVLINK_ATTR_STATS_RX_DROPPED]
> 
> nit: maybe discarded? dropped sounds like may have been due to an
> overflow or something

Well, it's an existing attribute which is why I suggested using it.
