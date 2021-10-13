Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73842BC4E
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbhJMKCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:02:09 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45679 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239124AbhJMKCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:02:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ED0775C0189;
        Wed, 13 Oct 2021 06:00:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 13 Oct 2021 06:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8KAisP
        64AHvIeWJABka7qeBaw3Sm8vfWFHVcuI/7TcQ=; b=JBjgqt2cf+xZVbhWr7DUPX
        MHoS7qugwanQ9WNXSACSTsYkRojx/O/6E7yTfdqF2HwgMO11zf4YQ7zGZo/uibUz
        p+WAybTVlDVwAJ6E6C+wt7QSYy5ZRhyUCo2YjVslem76eKLER2Y6IxLwEWboLPQa
        BpmkSY+ThDM7k0AR3F914nkVpWuAVuKh6VHQNMWq00CBOB6yeQjv1W2SBIGBg5kM
        iqES5BgarlWgMsMvvD+K5xWyIMmK/O3+BUJHXIBJV3SaLz56l8xJiXn4pVTMgRoO
        eHpQMmDme1UARQPtD8Ye7MVvkdnWDsKXnn30JuOEJei8ROtqY8lkY86ycEUjMBew
        ==
X-ME-Sender: <xms:I65mYXBYzABWW2FuVtqp5A1T_l_WqNkIctz84H3jaUI_Q-ZsldApjw>
    <xme:I65mYdhjrN2KPU-l29YyzJ3KforVzLtw0mF8SHKVf_ngAhekvQ-doQ6iJhmc6FCqi
    E-Y5p2hskQDHm8>
X-ME-Received: <xmr:I65mYSnrmpa4P5-X6NrRAw0Q1EpoYGdpXeTaXkfCi_yJ8pjf4auP-LMAbYl6_6lZIEATNv2fkQQG1bzIX0sUaqvwTqiFkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddutddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:I65mYZxi7OuwJe4L4fpSHzTdOSryJi9TS2T6ghC1agFLm3zoSMFLzQ>
    <xmx:I65mYcToUUDWaNJlAH38pQPXvh8_fsdJBabDj477LDCalshlfnsQng>
    <xmx:I65mYcbPlgebTEBLxdEQfqTouSu2r48wnttAKr7VOBrAgV8Nx8i8Qw>
    <xmx:JK5mYbG5wIqfxPiA1v-V_uTOTNh2sEii_jOl56crAchAMOQtpsiuew>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Oct 2021 06:00:03 -0400 (EDT)
Date:   Wed, 13 Oct 2021 12:59:59 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        dsahern@kernel.org, m@lambda.lt, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for
 managed neighbor entries
Message-ID: <YWauH/k8tfuLzsU5@shredder>
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net>
 <YWW4alF5eSUS0QVK@shredder>
 <959fd23f-27ad-8b5b-930f-1eca1a9d8fcc@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <959fd23f-27ad-8b5b-930f-1eca1a9d8fcc@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 11:26:50AM +0200, Daniel Borkmann wrote:
> On 10/12/21 6:31 PM, Ido Schimmel wrote:
> > In our HW the nexthop table is squashed together with the neighbour
> > table, so that it provides {netdev, MAC} and not {netdev, IP} with which
> > the kernel performs another lookup in its neighbour table. We want to
> > avoid situations where we perform multipathing between valid and failed
> > nexthop (basically, fib_multipath_use_neigh=1), so we only program valid
> > nexthop. But it means that nothing will trigger the resolution of the
> > failed nexthops, thus the need to probe the neighbours.
> 
> Makes sense. Given you have the setup/HW, if you have a chance to consolidate
> the mlxsw logic with the new NTF_MANAGED entries, that would be awesome!

Yes, I will take care of that
