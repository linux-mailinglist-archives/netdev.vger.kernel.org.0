Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E1049CEB5
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242966AbiAZPhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:37:19 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36111 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242985AbiAZPhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:37:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D324E5C0108;
        Wed, 26 Jan 2022 10:37:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Jan 2022 10:37:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=O8qEGdovf6SA2nHa3
        /DdAa3UlZo2NS9uEJeVjKOp408=; b=Odk1XVkKTGBC63Dqi2Jdl7ejmECOONL0v
        RXmCf64EqGCRUPcy9LxOpj35g/aR9exXJHV2kq/rDakczxr25TdYE32p7oCW1Dfr
        LpVl2MGBNauGlo0NhjK6CgiKNooKGMdTWZTYOtmgTMjm53C1FaGxiKRMnuIxVi4g
        OLT31vLQQSyVri4IYxtMweaTj7HpaFhF8MQJd2De80coXC7y6Rys9ulsqTHtXj5B
        /Fp9MqK3tImL9pu9gRSVMykEMKMV3Ff7CZNyywyqYrZ+PaiS7V/KtjMYbjk3uQSU
        Enxqjgv/njUNg5Am/nizih/FdV/5lW4TQ7zoRsKD2bMqCbs9YR0pA==
X-ME-Sender: <xms:rWrxYSbqT-GYQk_d8fNPjoTwN5gR9hv7r-DobA-v4aa1S7h-2kt5ig>
    <xme:rWrxYVbyYtJC51ZL8lwf2YRcMmZPg-d8RJmyac5WGT9MHQaMXMdOZ2pufZ-M8cEjQ
    KEJQXJ9nFS76wE>
X-ME-Received: <xmr:rWrxYc_Kgmzlay5picOgiBOAwrfPs8mqS_HxlFyleZA9G8wlaqguEy3slCazeR-e-Vfn7pZg14Vd6T7r2W0wC9WLSZsHOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfedugdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:rWrxYUrAnXNtysH8_VL5js7FZw6yQp1wTbFKrXmYKr3XGZ3GIDienQ>
    <xmx:rWrxYdofaaE9duQ9LIMlRZkGXyTUccdIYKApycxsXYWGRHua2XtWCg>
    <xmx:rWrxYSQIPxablPnmEVSZ2lrX4__OzjsrRW0YXMAOAwcNztcn-Y2hww>
    <xmx:rWrxYeckxNlX9gmiyDqG2G4obyWmoj4aX4DgqnV-k9lPJ738RBKWmw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Jan 2022 10:37:16 -0500 (EST)
Date:   Wed, 26 Jan 2022 17:37:11 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 4/9] mlxsw: spectrum_ethtool: Add support for
 two new link modes
Message-ID: <YfFqp4vtqQLqOH6C@shredder>
References: <20220126103037.234986-1-idosch@nvidia.com>
 <20220126103037.234986-5-idosch@nvidia.com>
 <YfFQG7iuOdhvaRw/@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfFQG7iuOdhvaRw/@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 02:43:55PM +0100, Andrew Lunn wrote:
> On Wed, Jan 26, 2022 at 12:30:32PM +0200, Ido Schimmel wrote:
> > From: Danielle Ratson <danieller@nvidia.com>
> > 
> > As part of a process for supporting a new system with RJ45 connectors,
> > 100BaseT and 1000BaseT link modes need to be supported.
> 
> I'm surprised you don't have 2500BaseT, 5000baseT and 10000BaseT?

I believe there weren't any requirements for these link modes on the new
system, so it wasn't designed to support them. I see it is still not
listed on the web site. Will send you a link once it's there.
