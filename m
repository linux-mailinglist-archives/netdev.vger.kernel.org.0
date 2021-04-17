Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B153631F8
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 21:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhDQT23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 15:28:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58959 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236212AbhDQT22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 15:28:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 355DD5C033A;
        Sat, 17 Apr 2021 15:28:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 17 Apr 2021 15:28:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ODJ3/X
        pbMsZBNAS3ravrUEZ5EFgq7pewJA2ZZ09Bsag=; b=e8ESYVq790fF+8zL0mBBPR
        z9tRDP4je/6JliO6gUrmkSojw7V8zJW3hET+Q85MhiprwKiGbPVAhcaBp3wBD7qR
        ntJWuzc/vakbTg5shH4eS17u9XBCiflRmYGOfDr2MlFdE1cEKrwvClds7U88F/48
        oQTdTUep4Jlt/uxw7kyn4dW64qDdX/Hm8wBshSm2tKPBM/u9K8TEanteDWhkdlqk
        P50HGGmNBgFPUa9uYJE9YPSAHetXf2kzzO1zHkbhFNkki6cc97QBSGbkIu48n1Nj
        kvJJdM74PTtRd0MrYMi5uRNuleorSNyuY1e0XxHWCITSiI/zzIwdrW8y+ZAxOTzg
        ==
X-ME-Sender: <xms:vzZ7YNcY3Y0-hPTga_pvrI-pdpdOKVLrQJpR6PEn6v8ruuXeMFvf3g>
    <xme:vzZ7YLPZnquaT1HejMN7nZJD4d_cLrrSG6C26egtwbdmbm-2ao3M15YzlfRHvp6GE
    YyAflsNm3K73Zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeliedgvdeiiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucfkphepkeegrddvvdelrdduheefrddu
    keejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vzZ7YGjbnawccaGdz7FqUVtjhP4VM5QrnL0JAYaKLQve7wx2kfKcgg>
    <xmx:vzZ7YG9HGQtmDEW00C2QVdkm5tsc_RIiD-CmH5asJgzu6aoQK3JyuQ>
    <xmx:vzZ7YJvoiMjpvpMF-p3XfQsFGLXdEtKj_Nn6cXI2daPULl3ywgcfKQ>
    <xmx:wTZ7YDLuPeNsnXQkjTe0Pnhr3cZaWwjlOz4n49QeiQyzDoX4shqlaA>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id B39EE1080063;
        Sat, 17 Apr 2021 15:27:58 -0400 (EDT)
Date:   Sat, 17 Apr 2021 22:27:55 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <YHs2u5efmpZgQuXi@shredder.lan>
References: <20210416192745.2851044-1-kuba@kernel.org>
 <20210416192745.2851044-4-kuba@kernel.org>
 <YHsXnzqVDjL9Q0Bz@shredder.lan>
 <20210417105742.76bb2461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210417111351.27c54b99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YHsutM6vesbQq+Ju@shredder.lan>
 <20210417121520.242b0c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210417121808.593e221d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417121808.593e221d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 12:18:08PM -0700, Jakub Kicinski wrote:
> On Sat, 17 Apr 2021 12:15:20 -0700 Jakub Kicinski wrote:
> > On Sat, 17 Apr 2021 21:53:40 +0300 Ido Schimmel wrote:
> > > On Sat, Apr 17, 2021 at 11:13:51AM -0700, Jakub Kicinski wrote:  
> > > > On Sat, 17 Apr 2021 10:57:42 -0700 Jakub Kicinski wrote:    
> > > >
> > > > FWIW ethnl_parse_bit() -> ETHTOOL_A_BITSET_BIT_NAME
> > > > User space can also use raw flags like --groups 0xf but that's perhaps
> > > > too spartan for serious use.    
> > > 
> > > So the kernel can work with ETHTOOL_A_BITSET_BIT_INDEX /
> > > ETHTOOL_A_BITSET_BIT_NAME, but I was wondering if using ethtool binary
> > > we can query the strings that the kernel will accept. I think not?  
> 
> Heh, I misunderstood your question. You're asking if the strings can be
> queried from the command line.

Yea :)

> 
> No, I don't think so. We could add some form of "porcelain" command if
> needed.

Can be useful for automatic bash completion, but if you need to patch
mag page / help message, then also patching bash completion is not a big
deal.
