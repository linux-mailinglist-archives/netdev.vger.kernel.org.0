Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9394FAA7
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 09:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfFWHod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 03:44:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39183 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbfFWHod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 03:44:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 61A1D21CFD;
        Sun, 23 Jun 2019 03:44:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 23 Jun 2019 03:44:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Zy9jd1
        FEKuM1HhjkkRrTqOax06ALBC6nO+8+aiDWMw0=; b=0+9WQ8fqHZtN/Yi9i2dxd3
        xFDo+JK1sIr7MIk8l6bJHATaRFL9/97k2uF3aj2Z23CHNTNh1Eq9uj6boHf8ZZs0
        oj1vJ38+HZO4y3y2SNFpJkpHM6bmhGKXRIkWZiOhmV3u2BAGVlkQPv7ZI44klnEn
        og33v/k5hYGYZmy9sXIKETxNHZ1G2hGYtCfp61zCHPixaOYaVsK2FNBLHcNaw/qk
        vDMktl8F/6okVjHEyIDeevbum1N6TJXCQyH5EoPArgqZPzlE/9GgosEN1wYKmdxo
        2smFjAf4VdMCKWRYvrhSy2wAWzT9zRByUqj3IClPmDzPlVerq1lIwdnmaMGOD8Pg
        ==
X-ME-Sender: <xms:3i0PXTvUamMKtNRLIDXn9GZto1FK6JTRNTsXLOYVDx5wHC49BzgUvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtdelgdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:3i0PXfV6iZXd1SX7ZCwZWu-bYhhzmBEHNfhgXgwv3C4NXHwRmSKmZQ>
    <xmx:3i0PXQ_EQ9GWi4U7CCo2w_HmhXI7wdwsRfdgHFvYF2_GhvMXtswkPA>
    <xmx:3i0PXT4y04uAaFBN7dvQ6vk1qE_11PrJwXyN7UqFJ_b3sVurhOkFAw>
    <xmx:4C0PXTF1qBxWsh6ARGUqg8el7bckeIHJ3rI2cQm0IGiZeJm-kq15Bw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C8FD380079;
        Sun, 23 Jun 2019 03:44:29 -0400 (EDT)
Date:   Sun, 23 Jun 2019 10:44:27 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Message-ID: <20190623074427.GA21875@splinter>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190621172952.GB9284@t480s.localdomain>
 <20190623070949.GB13466@splinter>
 <20190623072605.2xqb56tjydqz2jkx@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623072605.2xqb56tjydqz2jkx@shell.armlinux.org.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 08:26:05AM +0100, Russell King - ARM Linux admin wrote:
> On Sun, Jun 23, 2019 at 07:09:52AM +0000, Ido Schimmel wrote:
> > When multicast snooping is enabled unregistered multicast traffic should
> > only be flooded to mrouter ports.
> 
> Given that IPv6 relies upon multicast working, and multicast snooping
> is a kernel configuration option, and MLD messages will only be sent
> when whenever the configuration on the target changes, and there may
> not be a multicast querier in the system, who does that ensure that
> IPv6 can work on a bridge where the kernel configured and built with
> multicast snooping enabled?

See commit b00589af3b04 ("bridge: disable snooping if there is no
querier"). I think that's unfortunate behavior that we need because
multicast snooping is enabled by default. If it weren't enabled by
default, then anyone enabling it would also make sure there's a querier
in the network.
