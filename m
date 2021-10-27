Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613DD43D630
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhJ0WDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:03:33 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56607 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbhJ0WDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:03:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 20C005C01EB;
        Wed, 27 Oct 2021 18:01:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 27 Oct 2021 18:01:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hIQiAt
        6HwJSkBFPrZaazJIIeuuWWJ9hj7zkiVYITl5Y=; b=k3YKySGziO+UR6UNlRhBCJ
        La+xKZAwbU5wLx80stFWGnntTanJBQbrA/V8NW1yswm8miK8OxlHdUXYoF2BGPXd
        paTZWGRhq1Oo3baF1/wbe46JZEwqLVfOzs+33snpfQu34Kn2/6dcUhBrKGL/Cyex
        HuGucbgqq9sUNX9xJE2HK8qLi2tQBZBUQ+j9aka/jgarfzwicTiUfLO86mSkhrUx
        vvLfQu94SzxrEtu5Y4o4A9JYTOLEY/LvhHUH8Rq8GG9krbGDN5vAgan8l5hwksMo
        Pcbv7joPi2hF53BSyI5rWhLQiVZvGFu65JjXd8ESdUkJTZ4fKsrWNZ3THLSyIR+Q
        ==
X-ME-Sender: <xms:IMx5YbFIznkaX_vxJwqBGRnNS0FPMC3nIgEI0_ivannaWkkuQEfAIQ>
    <xme:IMx5YYUVRvsD5lijt8MqxIUCElG6fiJdbED6RJJOv2-IVBa7_3FwirZ24qwgcV0BJ
    gbog4iVXQWwdQ4>
X-ME-Received: <xmr:IMx5YdL_KBghx8p5hoJAKC-joix9biHjUdFOcba7n2iL8gbkhgMu6zk-B6g8wosmvbQLCYsa1iYf3kmk6eqpgRr5T5Epgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:IMx5YZEEx1Uv7EInsPmctStedo8TEGdyT6PWTdboTWQuhkJDdagMAg>
    <xmx:IMx5YRX8xoN_5w7miBJuuDn-Bw4pEad_4rfJyBMNVEuosuwb1KZI5A>
    <xmx:IMx5YUPPdvyTB21WZnKgg4OlfFUAnZLjkHLCb2gt4UvamSKTulCzmg>
    <xmx:Icx5YXwGpq2bMshpaSXubCZedN8t_Dd_1UIynyRHiGFq9XD1AoJnWA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 18:01:03 -0400 (EDT)
Date:   Thu, 28 Oct 2021 01:00:59 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 00/14] ethtool: Use memory maps for EEPROM
 parsing
Message-ID: <YXnMG6e7mglldHIZ@shredder>
References: <20211012132525.457323-1-idosch@idosch.org>
 <20211027203045.sfauzpf3rarx5iro@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027203045.sfauzpf3rarx5iro@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 10:30:45PM +0200, Michal Kubecek wrote:
> On Tue, Oct 12, 2021 at 04:25:11PM +0300, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > This patchset prepares ethtool(8) for retrieval and parsing of optional
> > and banked module EEPROM pages, such as the ones present in CMIS. This
> > is done by better integration of the recent 'MODULE_EEPROM_GET' netlink
> > interface into ethtool(8).
> 
> I still need to take a closer look at some of the patches but just to be
> sure: the only reason to leave this series for 5.16 cycle is that it's
> rather big and intrusive change (i.e. it does not depend on any kernel
> functionality not present in 5.15), right?

Right, it does not depend on any kernel functionality not present in
5.15
