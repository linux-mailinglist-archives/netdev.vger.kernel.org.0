Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F6E267EE6
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 11:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgIMJO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 05:14:27 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48931 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbgIMJOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 05:14:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 57DBB455;
        Sun, 13 Sep 2020 05:14:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 13 Sep 2020 05:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6caHZu
        FWNbhXAoG/AuiV8OBLt+yyQM+UA4eajeJzjFE=; b=eV76RELtFhr0evByPB0cet
        goCUmxIcUC5786rNQTt737LGvLqYthF6CjQydE+cJ+3bRgd6dI6G2/YggP0+ECVN
        w6e1iKf/HtnKF4dT8MrqDEKX9iQamSEqTkcjJyWIhv/sbSJ6jnksC5t106nM0pV/
        Zu1xrVAQxYYAePdCsDQRSQQN+BiqZ+gpPbBJai9urYst6GIifDWhjpzww++4zHXX
        NXtLFQvj0YlwdW+U6qvanjgwZxUhSlh5MfbiT6bn2CjnqK0bumZ0cF8rpPRMZ8x9
        yW3pICavCGjDQ7FUzXSSahqH54HpaXIoHRCHHVnlc9tqFgKj2ZjQISRosfCB+4jw
        ==
X-ME-Sender: <xms:7OJdX8D3lR4d4EV64NcuK1lV_5DjLVMEzOcC4NSE9tQZmGEaiQ3Ijw>
    <xme:7OJdX-gYZ--n69HSGH_wp_Ncww9V5oFqMQA6P4siooLJ-I7qQvyL6q8H5ND2COlNo
    Kc5HmTQX6fyrfk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeifedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepvddtvddrudeigedrvdehrdehnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:7OJdX_lihqyPBMv28c33aFsLZLhdD_UcxN8D4-uQi-9O6do8Id5LHw>
    <xmx:7OJdXyxGk6LoM1pxKhAMNiDq5H8UoeiEprlHImIqH6uSm3neIOWKyA>
    <xmx:7OJdXxQtlJ5JD9DdozqhAUM4vMe1FrzzetjBdE9ERv4Umt6LCD4skg>
    <xmx:7eJdX6Kfa7oCXrlAmr9J7wWkv0OvvdXGV552ElmUR54g8PRHw_tqqw>
Received: from localhost (unknown [202.164.25.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0BF7306467D;
        Sun, 13 Sep 2020 05:14:19 -0400 (EDT)
Date:   Sun, 13 Sep 2020 12:14:14 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Michael Chan <michael.chan@broadcom.com>, tariqt@nvidia.com,
        saeedm@nvidia.com, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 7/8] ixgbe: add pause frame stats
Message-ID: <20200913091414.GA3208846@shredder>
References: <20200911195258.1048468-1-kuba@kernel.org>
 <20200911195258.1048468-8-kuba@kernel.org>
 <CAKgT0UccY586mhxRjf+W5gKZdhDMOCXW=p+reEivPnqyFryUbQ@mail.gmail.com>
 <20200911151343.25fbbdec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911151343.25fbbdec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 03:13:43PM -0700, Jakub Kicinski wrote:
> On Fri, 11 Sep 2020 14:12:50 -0700 Alexander Duyck wrote:
> > On Fri, Sep 11, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > @@ -3546,6 +3556,7 @@ static const struct ethtool_ops ixgbe_ethtool_ops = {
> > >         .set_eeprom             = ixgbe_set_eeprom,
> > >         .get_ringparam          = ixgbe_get_ringparam,
> > >         .set_ringparam          = ixgbe_set_ringparam,
> > > +       .get_pause_stats        = ixgbe_get_pause_stats,
> > >         .get_pauseparam         = ixgbe_get_pauseparam,
> > >         .set_pauseparam         = ixgbe_set_pauseparam,
> > >         .get_msglevel           = ixgbe_get_msglevel,  
> > 
> > So the count for this is simpler in igb than it is for ixgbe. I'm
> > assuming you want just standard link flow control frames. If so then
> > this patch is correct. Otherwise if you are wanting to capture
> > priority flow control data then those are a seperate array of stats
> > prefixed with a "p" instead of an "l". Otherwise this looks fine to
> > me.
> 
> That's my interpretation, although I haven't found any place the
> standard would address this directly. Non-PFC pause has a different
> opcode, so I'm reasonably certain this makes sense.
> 
> BTW I'm not entirely clear on what "global PFC pause" is either.
> 
> Maybe someone can clarify? Mellanox folks?

I checked IEEE 802.1Qaz and could not find anything relevant. My only
guess is that it might be a PFC frame with all the priorities set.

Where did you see it?

> 
> > Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Thanks!
> 
