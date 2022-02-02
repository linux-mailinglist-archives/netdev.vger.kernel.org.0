Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8424A7886
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346871AbiBBTKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:10:18 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42091 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230380AbiBBTKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 14:10:17 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CA6E05C0211;
        Wed,  2 Feb 2022 14:10:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 02 Feb 2022 14:10:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=a8NQiCCeGYULo55oR
        /YsdFKaN5+fz/zKpwhE3X+lbb0=; b=E7ZXSr8OpmfukC456ySkHeJO4Uu6HkkPa
        qNAULPg1PhBhmOcU/JUk7dBUorMbCzk9VYpguI5JhFeFLFxQoI5L1l5PWaA0Dg+Y
        gqEywGgsRAW6u33dIJO6pJmpqob854V/Y3n6mZDiboMwGiJX7ZwZcDjOW+KFLN8n
        de9a6U+3i+TJlSnRBgVVh34aZcimAsP+Rtz8XMleBr3Fb8D3gAIEPpW8AinNBhuF
        NbVFMMkrBdPPFzW6fNPIxr0FBhWUMjHZKy4vrAViAxS8OqW4LW0cskK9KsTkx5+A
        BSurUZmCFcc2+WJO7RJFXZkMxm866vF99M5Ab0l7iKUCU5Us/r4uw==
X-ME-Sender: <xms:GNf6YdQQ9dMC63FDmXJG0mDd6vv7V1aNciKuxnOmIyZMahgpwKddIA>
    <xme:GNf6YWy-3A8_7uQ69a5P2gUkzSBZPURULRmnoBD19InGj9BTimv3IZ8l_pDF8grMb
    okitpqJMfWmA1k>
X-ME-Received: <xmr:GNf6YS10Aj_j8rQY3P4_sIS036C5fXqkF_AGfsISx0I8I94W6upFK6IA-p_8Kd4O-Z6MK_zWNHBOylqGLgXnyW6ADmspwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrgeehgdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:GNf6YVBRy2x785QrQcMX_jJMBy4OZQuGmv81u4nzareLB7NvFzIrmA>
    <xmx:GNf6YWhDo4_1gxEw1t8i0pqGJ3ZMAsLhgxk1yvzUVvtp7b8i_1YR9A>
    <xmx:GNf6YZq_2avhZswYlQeXYv-b8i1qbskBJaj83WfC16YPtSQXGYmkJw>
    <xmx:GNf6YYYBE0ha0xG9gyJrdES4sSq_05Qbvcwp5lbQ8qZ9oVdPvv16Fw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Feb 2022 14:10:15 -0500 (EST)
Date:   Wed, 2 Feb 2022 21:10:12 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next] selftests: fib offload: use sensible tos values
Message-ID: <YfrXFGKOje6Y7o6G@shredder>
References: <5e43b343720360a1c0e4f5947d9e917b26f30fbf.1643826556.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e43b343720360a1c0e4f5947d9e917b26f30fbf.1643826556.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 07:30:28PM +0100, Guillaume Nault wrote:
> Although both iproute2 and the kernel accept 1 and 2 as tos values for
> new routes, those are invalid. These values only set ECN bits, which
> are ignored during IPv4 fib lookups. Therefore, no packet can actually
> match such routes. This selftest therefore only succeeds because it
> doesn't verify that the new routes do actually work in practice (it
> just checks if the routes are offloaded or not).
> 
> It makes more sense to use tos values that don't conflict with ECN.
> This way, the selftest won't be affected if we later decide to warn or
> even reject invalid tos configurations for new routes.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks
