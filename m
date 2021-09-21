Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B44413404
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhIUN13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:27:29 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42203 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232906AbhIUN12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 09:27:28 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 035A53200987;
        Tue, 21 Sep 2021 09:25:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 21 Sep 2021 09:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FlxnQ1
        G0tyJvkWQzOxKMOHkauuw5F5XxO64w6ivhM9I=; b=Akj2woKoe0MjMfRpR4lg+B
        akSbxXhneKhRxa8mQcO3Sql5UzLBN1dFldjShd7Kae0Jt8k1JPcW1YDBDzGybApq
        uSslHf7SumXCmVF7OMLWxoDCUIKXkFJ9ySIIAVdazEtv2JvaOwV+A/UcTUmhlauA
        vxbCNmxRIAxbWs9KVBlzjF1N5F7snzM9o/qRZxTSRdTkdfDCx0U7nJYsB6BYTCh2
        lVO63+Tms49VvRI79biLcZ+k9uvDxMUZ9gWd1w2prHzbVKAOWIh0PSpoEC7NByjm
        7RyKT4jg3Z/8K4jwU5r6/jJ21jw7W22bAksRa2OC9W1PNynSilM1g1VsavbxImiQ
        ==
X-ME-Sender: <xms:Zt1JYekr4SLoSFBi_cXYkiMXatsSj7phcDndqiVlOavgd_YDlaPBWQ>
    <xme:Zt1JYV0kFfjJophw3YBEISJPOq_59DYdJcFC42OOLZZTIki5jzV9pUsTEEcBDIF5H
    KVLixAa_OvfNJs>
X-ME-Received: <xmr:Zt1JYcphyMJ9QRwUeffUbHrFH22OicoAIy3uQI2cTV0PRzML1dT7tR5oDhAvNay1aLjCKWLYjk6WFKvq8q7VA_lpwyXEcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeigedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Zt1JYSmLSI7RyU9lELLNbrVduxQtWzZAQ9GlervbL_fdyok3A6S4aw>
    <xmx:Zt1JYc3a-dV9i-yth0NSzf4i9aX_NX7MuBxoljwo1OzVi0LzP8tLxg>
    <xmx:Zt1JYZvz2JEKo19Vi4QytdeBSdTyyXQZLXkNjMQx5Xck3COucimkwA>
    <xmx:Z91JYWpdhY7522FWW0ltvF_EmoIt8vIW5e9l3Xu9bP3mN1y6HOEGRw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Sep 2021 09:25:57 -0400 (EDT)
Date:   Tue, 21 Sep 2021 16:25:54 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Maciej Machnikowski <maciej.machnikowski@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ice: add support for reading SyncE DPLL
 state
Message-ID: <YUndYq8EcpyPnPud@shredder>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
 <20210903151436.529478-3-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903151436.529478-3-maciej.machnikowski@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 05:14:36PM +0200, Maciej Machnikowski wrote:
> Implement SyncE DPLL monitoring for E810-T devices.
> Poll loop will periodically check the state of the DPLL and cache it
> in the pf structure. State changes will be logged in the system log.
> 
> Cached state can be read using the RTM_GETEECSTATE rtnetlink
> message.

This seems sub-optimal. My understanding is that this information is of
importance to the user space process that takes care of the ESMC
protocol. It would probably want to receive a notification when the
state of the DPLL/EEC changes as opposed to polling the kernel or poking
into its log.

So I think that whatever netlink-based interface we agree on to
represent the EEC (devlink or something else), should have the ability
to send a notification when the state changes.
