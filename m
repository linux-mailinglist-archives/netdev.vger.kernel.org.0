Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C1C4D870D
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238929AbiCNOip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiCNOio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:38:44 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03453C72E
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:37:34 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4D6313201F88;
        Mon, 14 Mar 2022 10:37:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 14 Mar 2022 10:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+GFG3cE3D/a0UsXuZ
        kCeLugMB13nfXbEphP6aX9s3z8=; b=DQjc7YxRUPovuTv7A+xYYvMBMP9nHyowI
        SX/U4E7soQ0xDUev0xp4kopZiI1UUYfBaLS8BOTnYOdj5p/lVk1QT1BzTwPyfmx8
        NJDCpkmA2vVysjLgDKGoRzn5RqjmkkmlpAOYlN0QcRxsdwsqO7kPLoXEyTL+bqKR
        xy2yKEiKtSKMpOSp2jHUiZKxiG27vKilsCDFzb6cQV5y3sKzM0Djzeqhks7i00jf
        K6pblB72gpySKVIzGRBgTz/+gQupGwn/OGhTPIMnwnJ1eUM3ikFwwG9LxopP/Pqg
        Qb2aYU0ME42TYtvAo+JCcxsqTwzdIKkJY4svhLd73XIdCmfPXf1qQ==
X-ME-Sender: <xms:K1MvYoARlH51KQsUL8ntzGYC9K4PAKVQ9ml0XwxkbyQObEVC5Yb6ZA>
    <xme:K1MvYqiPulaHMRdZ_w_3pZ2s8aDun5wBASQ77vIwNPYhae-7QtyYqLX4F2e7ee5Sp
    giGerMyzzRjmKI>
X-ME-Received: <xmr:K1MvYrlywKC_6xY2OBvJLLHPVRF6m3Z9qyMVB2EFEY9v5aIb6i-rQW0nYGLM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddvkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:K1MvYux6cs6Zak3tysfGST5ko1TBpmVFpEjHO7XSdb7KSYrezFY-9w>
    <xmx:K1MvYtQiAvcLBrTLw1TQ-vm-B4mjee7a5VsS7oxvoiYIPvZVbwa2UQ>
    <xmx:K1MvYpboiYv3nnFGE6_Q6x1SsA5WW0HsTtoYMCtHB2oIxuLn1o2SNA>
    <xmx:K1MvYoc2V5wajgQqRm1p0EG0g_qqB8gUo2Qx7ZFTTJh5mPn_ySjEOA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Mar 2022 10:37:31 -0400 (EDT)
Date:   Mon, 14 Mar 2022 16:37:29 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next v3 1/3] netdevsim: Introduce support for L3
 offload xstats
Message-ID: <Yi9TKbmuhj0xtyuT@shredder>
References: <cover.1647265833.git.petrm@nvidia.com>
 <fa28d4ff7f55fec4928990850dc1abf8fac3eb45.1647265833.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa28d4ff7f55fec4928990850dc1abf8fac3eb45.1647265833.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 03:01:15PM +0100, Petr Machata wrote:
> Add support for testing of HW stats support that was added recently, namely
> the L3 stats support. L3 stats are provided for devices for which the L3
> stats have been turned on, and that were enabled for netdevsim through a
> debugfs toggle:
> 
>     # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/enable_ifindex
> 
> For fully enabled netdevices, netdevsim counts 10pps of ingress traffic and
> 20pps of egress traffic. Similarly, L3 stats can be disabled for a given
> device, and netdevsim ceases pretending there is any HW traffic going on:
> 
>     # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/disable_ifindex
> 
> Besides this, there is a third toggle to mark a device for future failure:
> 
>     # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/fail_next_enable
> 
> A future request to enable L3 stats on such netdevice will be bounced by
> netdevsim:
> 
>     # ip -j l sh dev d | jq '.[].ifindex'
>     66
>     # echo 66 > /sys/kernel/debug/netdevsim/netdevsim10/hwstats/l3/enable_ifindex
>     # echo 66 > /sys/kernel/debug/netdevsim/netdevsim10/hwstats/l3/fail_next_enable
>     # ip stats set dev d l3_stats on
>     Error: netdevsim: Stats enablement set to fail.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
