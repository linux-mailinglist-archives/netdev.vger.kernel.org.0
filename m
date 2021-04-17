Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB83F3631E0
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 20:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbhDQSyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 14:54:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43223 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230064AbhDQSyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 14:54:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DD2FC5C032F;
        Sat, 17 Apr 2021 14:53:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 17 Apr 2021 14:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0f6Co2
        TBsWET5dKmcvK5GrDaBpX6MwfpWYAcHC8Za/c=; b=Crf+iXoCzC84BUd/UiXtnc
        XmjGdknjnOzwkc8yYEJGxbieG8dfO1q3dEdBFvml11o3HMsOyZI72aUcL55q9YYH
        Bfjv8iaP5Nhm34s1bqIO02l19Xty0L7GIqvTxkQuHYQ9LLwbtMG247tKC8Xfdn+2
        BvEB7+O2ZyhSLcjsWUxLDe8xkIpk+p2wTZVrk7Wm1dloxQ7rNVBr6FbG7QJ+QSzq
        guaXEAs/qcDJsnupOYGiyQ7QqKIKExz2n6t1AGEkS5Mcd7V/eybR5azKzApVPqpd
        opivCiFLRPmTk801KKRY1EZviU3l9ImoTlUOhaPJIKUOnvS5Ki8nIp6IE7zAYlPw
        ==
X-ME-Sender: <xms:ui57YP0upj31w6we09pLjDEZne7i4hGkKljrJfJ0TWDyfQIVut7Xtg>
    <xme:ui57YOFrK43aGOUX8VuvZoidyKch3R-hCW6hJd9QycN0Iy3NfZVm6Qqqr4LLO3NXB
    0ng0_9_wmQPDrs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeliedgvdeitdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucfkphepkeegrddvvdelrdduheefrddu
    keejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ui57YP5sNadRZFXbM9d1A-xqcR2BCb12JstRDQEgQQ9OalJAuVU7BQ>
    <xmx:ui57YE0ItzTWVUR0ddEJGe-i_R4MxxLVvwIHq0LNE4cXt1BKzWkyzg>
    <xmx:ui57YCF7o4za4kH5wA65U1eXc4TdiyMAgGtmNDxFG8jd-iKY9iHVNw>
    <xmx:uy57YOirWqlopZ5Zuq385LRujBe5qF4iSjvVPO2OltkZYXmYy9Qr6A>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id C15C01080066;
        Sat, 17 Apr 2021 14:53:45 -0400 (EDT)
Date:   Sat, 17 Apr 2021 21:53:40 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, idosch@nvidia.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 3/9] ethtool: add a new command for reading
 standard stats
Message-ID: <YHsutM6vesbQq+Ju@shredder.lan>
References: <20210416192745.2851044-1-kuba@kernel.org>
 <20210416192745.2851044-4-kuba@kernel.org>
 <YHsXnzqVDjL9Q0Bz@shredder.lan>
 <20210417105742.76bb2461@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210417111351.27c54b99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417111351.27c54b99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 11:13:51AM -0700, Jakub Kicinski wrote:
> On Sat, 17 Apr 2021 10:57:42 -0700 Jakub Kicinski wrote:
> > > I tried to understand how you add new groups without user space
> > > changes and I think this statement is not entirely accurate.
> > > 
> > > At minimum, user space needs to know the names of these groups, but
> > > currently there is no way to query the information, so it's added to
> > > ethtool's help message:
> > > 
> > > ethtool [ FLAGS ] -S|--statistics DEVNAME       Show adapter statistics       
> > >        [ --groups [eth-phy] [eth-mac] [eth-ctrl] [rmon] ]  
> > 
> > Um, yes and now. The only places the user space puts those names 
> > is the help message and man page.
> > 
> > Thru the magic of bitsets it doesn't actually interpret them, so
> > with old user space you can still query a new group, it will just 
> > not show up in "ethtool -h".
> > 
> > Is that what you're saying?
> 
> FWIW ethnl_parse_bit() -> ETHTOOL_A_BITSET_BIT_NAME
> User space can also use raw flags like --groups 0xf but that's perhaps
> too spartan for serious use.

So the kernel can work with ETHTOOL_A_BITSET_BIT_INDEX /
ETHTOOL_A_BITSET_BIT_NAME, but I was wondering if using ethtool binary
we can query the strings that the kernel will accept. I think not?

Anyway, I'm fine with implementing '--all-groups' via
ETHTOOL_MSG_STRSET_GET. We can always add a new attribute later, but I
don't see a reason to do so.
