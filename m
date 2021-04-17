Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2F4363152
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 19:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhDQRPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 13:15:45 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49001 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236568AbhDQRPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 13:15:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A204E5C026A;
        Sat, 17 Apr 2021 13:15:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 17 Apr 2021 13:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6GPDOu
        Tlb3tsWnMmti2/j2Ug1YIaGPuh2cYLkS0UqGY=; b=l7nWSqTizg6DbS29zzqbNS
        ZclZDm3gVg9xG+fXG2jFQHnwj3CYAbve+khJFF1NFXM9HO6DBP2AFZaj6DPxoqxT
        fIC3znhQ05VrbEInMnMFBRb+E+oabrEgjgJvrld4e72dOKLWyYTOGs7LpyyXj+6X
        u6VzkIWAyaGiRJLZWRJYQoJLNq0GP3PBXNtds6Og55XuokSGmdy0eH3KSaGAFbjm
        zgxuxQU3iOm7xcAuLo6ZHwWOPBTUUgW6O6r9j343Ora40pA7AdUfTFJu/ptYmK+F
        JOAsHhBDhFotEusHeJnhscPlMo0CrCnx6yC2rsdQjGx/dul3RjEYOmH3Iq3rvjcA
        ==
X-ME-Sender: <xms:pBd7YOk0TXu-BCyE7901czHgOzo62zg5RCAnDtfmlpRETIqMpU7zUQ>
    <xme:pBd7YF35KvrrUXz9wCuc-DlucbDkZGNnjKMJuTcD4hBoJ72Em8DlYHnYjojBC2Nsu
    R_0IEWjLnDoNDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeliedgvdegtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucfkphepkeegrddvvdelrdduheefrddu
    keejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:pBd7YMoScp-iOSCG03gLc8IBhuaeogoS9kNXZ6A2KE2nxbguvAmLBw>
    <xmx:pBd7YCnojiPJsCYV3QKspH45Ye5tNtXYmK4mzVPzWY0PeGMAXEdUlA>
    <xmx:pBd7YM1zfViyHJPI4xwM7AK7GAnFZ5PuV0swX97Xu5vib35jodY7Ng>
    <xmx:pRd7YPQnTFi1n0Ea-yJtZ52jo1rs0p7EX-tccpzqTz9nO9KOSFuajA>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18056108005B;
        Sat, 17 Apr 2021 13:15:15 -0400 (EDT)
Date:   Sat, 17 Apr 2021 20:15:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <YHsXnzqVDjL9Q0Bz@shredder.lan>
References: <20210416192745.2851044-1-kuba@kernel.org>
 <20210416192745.2851044-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416192745.2851044-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 12:27:39PM -0700, Jakub Kicinski wrote:
> Add an interface for reading standard stats, including
> stats which don't have a corresponding control interface.
> 
> Start with IEEE 802.3 PHY stats. There seems to be only
> one stat to expose there.
> 
> Define API to not require user space changes when new
> stats or groups are added. Groups are based on bitset,
> stats have a string set associated.

I tried to understand how you add new groups without user space
changes and I think this statement is not entirely accurate.

At minimum, user space needs to know the names of these groups, but
currently there is no way to query the information, so it's added to
ethtool's help message:

ethtool [ FLAGS ] -S|--statistics DEVNAME       Show adapter statistics       
       [ --groups [eth-phy] [eth-mac] [eth-ctrl] [rmon] ]

I was thinking about adding a new command (e.g.,
ETHTOOL_MSG_STATS_GROUP_GET) to query available groups, but maybe it's
an overkill. How about adding a new flag to ethtool:

ethtool [ FLAGS ] -S|--statistics DEVNAME       Show adapter statistics       
       [ { --groups [eth-phy] [eth-mac] [eth-ctrl] [rmon] | --all-groups } ]

Which will be a new flag attribute (e.g., ETHTOOL_A_STATS_ALL_GROUPS) in
ETHTOOL_MSG_STATS_GET. Kernel will validate that
ETHTOOL_A_STATS_ALL_GROUPS and ETHTOOL_A_STATS_GROUPS are not passed
together.

It's not the end of the world to leave it as-is, but the new flag will
indeed allow you to continue using your existing ethtool binary when
upgrading the kernel and still getting all the new stats.

Actually, if we ever get an exporter to query this information, it will
probably want to use the new flag instead of having to be patched
whenever a new group is added.
