Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C399488B18
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 18:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbiAIRZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 12:25:53 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51677 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236281AbiAIRZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 12:25:44 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A809D5C0114;
        Sun,  9 Jan 2022 12:25:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 09 Jan 2022 12:25:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dDXiPB
        +UM6LhboqmZ+CbqM2N+jP1/BTYbZMLrWP+9T0=; b=Wd7Ih9liRGcycRcZZ60uHT
        22YKUw3g2RIXtjXXJnuN+Wc/T3oppWfxEYcHu/PwglKpaFERonyw9gursiGAMgMF
        HtylK4iEQjFGsxEF5pIf2pcdsTqAKsQ5Nye9U9/X1Cv6auT4phsVxoM+duYHteNq
        Gh10WMv09FSLpCJljRbrMvInzelQL902ftdlqGu0pXP5Ro7vlpE4TeXYJ1Yc9y3q
        6QWP48XuE+bYwc7PdncI5TyF7ux618VpyApgdFefDVbrWnak/0yB7I4+ZqLH0z/O
        X6j5uDhPi5OtLHb6t7CCpItlJwmciBjReIimI7gTV6yVDDf5tYa8k2m3V+jTU8tA
        ==
X-ME-Sender: <xms:lxrbYXVL5ebQFaxqVvkYI53rUCEezwR-F6J_A-Y1H2Sr178-Hd25Kw>
    <xme:lxrbYflaPp9sQG0ccDHbjl5wsSmKlE192S7lzO1AgkjAQAcK1S28QWR3_OQKBH3QV
    iBTAXQdfoBbhMw>
X-ME-Received: <xmr:lxrbYTbKNJZFnte7IKrrJV1Dcvi2ThSkBafHo7akiudXYY88vnnKvp-5V5FQ_XOSutZUAl9pZJwEojVqPHI48yfFfIPY4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudegkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:lxrbYSUJ0uQEXeDaq2Pt5IEatO-8u0rTjbVMH179IU06VskN5Vruew>
    <xmx:lxrbYRnnBOKSXaxsVtrdx2ABmGVryGCydxdeJ4NZRnaKd5QodhsE7A>
    <xmx:lxrbYfd3qd2zendOVddlmMwPlee8-3F2MsTrpaSLQZ52Ir3E_eKoFg>
    <xmx:lxrbYWxekthsPrM0NR2teGkon5fkb03t5r9zO5SyAQ_NnqY-CkyB2g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 9 Jan 2022 12:25:42 -0500 (EST)
Date:   Sun, 9 Jan 2022 19:25:38 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: remove ndo_get_phys_port_name
 and ndo_get_port_parent_id
Message-ID: <YdsakgRku3ZgF77f@shredder>
References: <20220107184842.550334-1-vladimir.oltean@nxp.com>
 <20220107184842.550334-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107184842.550334-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 08:48:41PM +0200, Vladimir Oltean wrote:
> There are no legacy ports, DSA registers a devlink instance with ports
> unconditionally for all switch drivers. Therefore, delete the old-style
> ndo operations used for determining bridge forwarding domains.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Looks correct to me.

If ndo_get_phys_port_name() is not implemented, then
devlink_compat_phys_port_name_get() is called which invokes
ndo_get_devlink_port() that you have implemented. Similarly, for
ndo_get_port_parent_id().

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
