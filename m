Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E1231957B
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBKWBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:01:03 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41381 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhBKWBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 17:01:03 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F3F945C00B3;
        Thu, 11 Feb 2021 16:59:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 11 Feb 2021 16:59:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=aIPY7mPEbkU+0ge2mduIyB1fDJBslP+8dl8k4LOTY
        7U=; b=s5o3EDlXjt0VkTyJlhtCWWM5nPkJD8/uEGH2h6XWUVPc4JwaqceCVOO96
        OW5MRTDQMHoJfagDPIrALL3Hzzc+Wep0P5Otw2sNndQXN8Nk6e796GLTL6pFgSW/
        We/w9hUx5wylTRFGx6sV1axn2TwCfttX05L6aD3aQjzhkKOoF0nhHrqWvlavJNBd
        NVsG4+vDiUfXQdIrPNgTed/VEaIvxsEqe9NxIKDEZdHiD9gxtoS4GzOxdNDXqf8w
        TUM+XlVaw92Px3LDoZ1Kr6Tmh1d5a6ZNrlsk6x57Nn36CMi3Hinu/6ujGZJBJyKX
        LkarA20IMOGBO1YYnUQEuF3j3YOGw==
X-ME-Sender: <xms:3KglYNCNunqBNqtg154E4pUo0buSq-GwLfRti8ypt2u-Del85tWDOA>
    <xme:3KglYLhdjUCaIMAiKk2iaoQKnGPJvDJ2pib_JRXWUEHPoLmHqHrAdLCwMfofJ7Fxk
    yWBsROVzz2z914>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheelgdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepueettdegjedvgeektddtteekheehkeejueeiueeftdekteehffekudeikeet
    gfeknecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphepkeegrddvvdelrdduhe
    efrdeggeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:3KglYImPZGt8uJG_pn7HpKhEkF6YUpiavnNcHDHrnNIphn1gqsnkdQ>
    <xmx:3KglYHyf9XeYcuK7IJeMKvEgf5I4hBCgSwWxtQmKzpT_3x1jb4kIVA>
    <xmx:3KglYCQUcouYswjKFztbYsKEIJVJmZLqjcpfb04GPMvRNy8i04_tUA>
    <xmx:3KglYIM42XiwS_xl9t-ZarP3lgc2p1FJQM5Tj8FpzZrX6Kkqm_Vv8g>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6068024005A;
        Thu, 11 Feb 2021 16:59:56 -0500 (EST)
Date:   Thu, 11 Feb 2021 23:59:52 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, Chris Mi <cmi@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210211215952.GA374617@shredder.lan>
References: <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan>
 <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
 <20210201180837.GB3456040@shredder.lan>
 <20210208070350.GB4656@unreal>
 <20210208085746.GA179437@shredder.lan>
 <20210208090702.GB20265@unreal>
 <20210208170735.GA207830@shredder.lan>
 <20210209064702.GB139298@unreal>
 <30482e059a48fb35f90a7594355bc27dcd71dacc.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30482e059a48fb35f90a7594355bc27dcd71dacc.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 09:09:41PM -0800, Saeed Mahameed wrote:
> This won't solve anything other than compilation time dependency
> between built-in modules to external modules, this is not the case.
> 
> our case is when both mlx5 and psample are modules, you can't load mlx5
> without loading psample, even if you are not planning to use psample or
> mlx5 psample features, which is 99.99% of the cases.

You are again explaining what are the implications of the dependency,
but you are not explaining why it is the end of the world for you. All I
hear are hypotheticals. Dependencies are also a common practice in the
kernel and mlx5 has a few of its own (I see that pci_hyperv_intf was
loaded by mlx5_core on my system, for example).

> What we are asking for here is not new, and is a common practice in
> netdev stack
> 
> see :
> udp_tunnel_nic_ops
> netfilter is full of these, see nf_ct_hook..
> 
> I don't see anything wrong with either repeating this practice for any
> module or having some sort of a generic proxy in the built-in netdev
> layer..

If you want to move forward with patch, then I ask that you provide a
proper commit message with all the information that was exchanged in
this thread so that multiple people wouldn't need to milk it again upon
re-submission. For example:

"
The tc-sample action sends sampled packets to the psample module which
encapsulates them in generic netlink messages along with associated
metadata and emits notifications to user space.

Device drivers that offload this action are expected to report sampled
packets directly to the psample module by calling
psample_sample_packet(). This creates a dependency between these drivers
and the psample module.

While we are not aware of a problem this dependency can create, we
prefer to avoid it due to past experience with other dependencies. For
example, we discovered that a dependency of mlx5_core on nf_conntrack
will result in mlx5_core being unloaded upon a restart of the firewalld
service. This is because the firewalld service iterates over all the
dependants of nf_conntrack and unloads them so that it could eventually
unload nf_conntrack [1]. In addition, the psample module is only needed
in a small subset of deployments.

Therefore, avoid this dependency by doing XYZ. This is a common way to
reduce dependencies and employed by XYZ, for example.

Note that while the psample module will not be loaded upon the loading
of offloading drivers, it will be loaded by act_sample, which depends on
it. And since drivers offload the act_sample action, psample will be
loaded when needed.

Encapsulating the sampling code in a driver with a config option and
making it depend on psample will result in the psample module being
loaded in most cases given that some distributions blindly enable all
config options.

[1] https://github.com/firewalld/firewalld/blob/master/src/firewall/core/modules.py#L97
"

I also ask that this patch will be routed via the mlxsw queue. Few
reasons:

1. mlxsw already depends on psample while mlx5 does not. Therefore, this
patch needs to take care of mlxsw first. There is no reason to call into
psample differently from different drivers

2. We are about to queue changes (for 5.13) to psample that are going to
conflict with this patch. To avoid the conflict, I want to queue this
patch on top of these changes. The changes also contain selftests which
will provide better test coverage for this patch

Thanks
