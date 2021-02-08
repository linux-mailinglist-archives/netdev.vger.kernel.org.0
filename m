Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6459313A85
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhBHRLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:11:00 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34361 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233723AbhBHRIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:08:46 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 974AC5C01C6;
        Mon,  8 Feb 2021 12:07:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 08 Feb 2021 12:07:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7dh66K
        AODHGD6SL8zgD57iQt+oATBwtDgh4n16vfM7Y=; b=VpwYUJAxXA3/SEww1d8RNJ
        5rDZXuWvlepjPoCKEfwsj+HMD8MBbzc5x4ugaPTLrabC/+ndP2DXr6ahVq0+Y91J
        HHGhWnatdq6pj1/gyHUrLFRqxST86jqElWlcfBaKzPqxHv1D+kJ4DPOx2u7jwmpm
        pdGzJBQR4mIdpIZtk8pOHgkPF5Cn6/gkNWISLTniJXGfoJAtcoauVGYTVFFL5d5s
        cQFTDqayQxFwQ6Phx9eEQOINeeXM0ekHhScHDakQ/JexF4maBpOMwy5CSqX7bFpC
        OJOrIgw45pdlYEqp3nTVSZWKTOjd38/AJrSENTr3nii43woFC3UTIGYJ0iK59L2Q
        ==
X-ME-Sender: <xms:2m8hYP_zW7OZQ1FZNwWK5ilDYjVrZuvawntA-lne4hMT2mimr3aQ2g>
    <xme:2m8hYNMnE5Iblm2dP8G1M_1QwkdrdE0QYFS7Kod1BwKihLeF-M5PFNXyj4GeCUgGQ
    UIE6eu2b9xo3_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:2m8hYNFDiU2_UF7ZGwso47qi3SEzbzpbjZ9rGAEOtBrr919SQTZ1CQ>
    <xmx:2m8hYLT_Bx3_k_4eKGQwutCUJ8at6dqQMKZMvbVyv9W9KqaNrHD1Ww>
    <xmx:2m8hYKvfTLSFnJFVG-ftCfDZpIaWmOEb9kDniGI9ihDf0SIJf7zjDA>
    <xmx:2m8hYFh2O-Qc_2wi9aXcW0O2wbkbPcANBYrrUwOBlisOksL0hZ8VZw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCB2824006B;
        Mon,  8 Feb 2021 12:07:37 -0500 (EST)
Date:   Mon, 8 Feb 2021 19:07:35 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Chris Mi <cmi@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210208170735.GA207830@shredder.lan>
References: <20210128014543.521151-1-cmi@nvidia.com>
 <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
 <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
 <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan>
 <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
 <20210201180837.GB3456040@shredder.lan>
 <20210208070350.GB4656@unreal>
 <20210208085746.GA179437@shredder.lan>
 <20210208090702.GB20265@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208090702.GB20265@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 11:07:02AM +0200, Leon Romanovsky wrote:
> On Mon, Feb 08, 2021 at 10:57:46AM +0200, Ido Schimmel wrote:
> > On Mon, Feb 08, 2021 at 09:03:50AM +0200, Leon Romanovsky wrote:
> > > On Mon, Feb 01, 2021 at 08:08:37PM +0200, Ido Schimmel wrote:
> > > > On Mon, Feb 01, 2021 at 09:37:11AM +0800, Chris Mi wrote:
> > > > > Hi Ido,
> > > > >
> > > > > On 1/30/2021 10:42 PM, Ido Schimmel wrote:
> > > > > > On Fri, Jan 29, 2021 at 12:30:09PM -0800, Jakub Kicinski wrote:
> > > > > > > On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:
> > > > > > > > Instead of discussing it several days, maybe it's better to review
> > > > > > > > current patch, so that we can move forward :)
> > > > > > > It took you 4 revisions to post a patch which builds cleanly and now
> > > > > > > you want to hasten the review? My favorite kind of submission.
> > > > > > >
> > > > > > > The mlxsw core + spectrum drivers are 65 times the size of psample
> > > > > > > on my system. Why is the dependency a problem?
> > > > > > mlxsw has been using psample for ~4 years and I don't remember seeing a
> > > > > > single complaint about the dependency. I don't understand why this patch
> > > > > > is needed.
> > > > > Please see Saeed's comment in previous email:
> > > > >
> > > > > "
> > > > >
> > > > > The issue is with distros who ship modules independently.. having a
> > > > > hard dependency will make it impossible for basic mlx5_core.ko users to
> > > > > load the driver when psample is not installed/loaded.
> > > > >
> > > > > I prefer to have 0 dependency on external modules in a HW driver.
> > > > > "
> > > >
> > > > I saw it, but it basically comes down to personal preferences.
> > >
> > > It is more than personal preferences. In opposite to the mlxsw which is
> > > used for netdev only, the mlx5_core is used by other subsystems, e.g. RDMA,
> > > so Saeed's request to avoid extra dependencies makes sense.
> > >
> > > We don't need psample dependency to run RDMA traffic.
> >
> > Right, you don't need it. The dependency is "PSAMPLE || PSAMPLE=n". You
> > can compile out psample and RDMA will work.
> 
> So do you suggest to all our HPC users recompile their distribution kernel
> just to make sure that psample is not called?

I don't know. What are they complaining about? That psample needs to be
installed for mlx5_core to be loaded? How come the rest of the
dependencies are installed?

Or are they complaining about the size / memory footprint of psample?
Because then they should first check mlx5_core when all of its options
are blindly enabled as part of a distribution config.

AFAICS, mlx5 still does not have any code that uses psample. You can
wrap it in a config option and keep the weak dependency on psample.
Something like:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index ad45d20f9d44..d17d03d8cc8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -104,6 +104,15 @@ config MLX5_TC_CT
 
          If unsure, set to Y
 
+config MLX5_TC_SAMPLE
+       bool "MLX5 TC sample offload support"
+       depends on MLX5_CLS_ACT
+       depends on PSAMPLE || PSAMPLE=n
+       default n
+       help
+         Say Y here if you want to support offloading tc rules that use sample
+          action.
+
 config MLX5_CORE_EN_DCB
        bool "Data Center Bridging (DCB) Support"
        default y

> 
> >
> > >
> > > >
> > > > >
> > > > > We are working on a tc sample offload feature for mlx5_core. The distros
> > > > > are likely to request us to do this. So we address it before submitting
> > > > > the driver changes.
> > > >
> > > > Which distros? Can they comment here? mlxsw is in RHEL and I don't
> > > > remember queries from them about the psample module.
> > >
> > > There is a huge difference between being in RHEL and actively work with
> > > partners as mlx5 does.
> > >
> > > The open mailing list is not the right place to discuss our partnership
> > > relations.
> >
> > I did not ask about "partnership relations". I asked for someone more
> > familiar with the problem that can explain the distro issue. But if such
> > a basic question can't be asked, then the distro argument should not
> > have been made in the first place.
> 
> It is not what you wrote, but if you don't want to take distro argument
> into account, please don't bring mlxsw either.
> 
> Thanks
