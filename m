Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C4F312CB7
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhBHJBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:01:22 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47729 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230396AbhBHI7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:59:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EED5D5C00A8;
        Mon,  8 Feb 2021 03:57:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 08 Feb 2021 03:57:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=E13TQs
        BoaxVCxwWy0u6LmmqMbL2S0NKqFGO1RJLm1EU=; b=woy3zTfTqjUfl3wpeebYgj
        Ej2Q+wF1PugUkZiv9L2S2Zq6c/PAQ4n1djbFJIzXLQNpNBtsx39/Gfu8P0voRVei
        U0LwOTFVI9Dw1jXgYbBI7Z2poJojagaieEOKu9JfacCmZ2uGQH04ZsgumuVbQEE1
        sjFbObZ50+1dgOd/kzW/pTIK2oUMBwIC/yKdzO57RMGg0+x9CE2GobcDhGZx6jbG
        U+KczfMjk5SHfnhpnw4Os/fVKtRg24ncdbG6vEchQCEWbTSlzu2Sl+nI/PngtBuF
        h3qwuCoCK+o5pHV0dWR0c/RZZSEa9Iut/Zmem3cI5I7j2lyt+/x5zH3vTLMB6BnQ
        ==
X-ME-Sender: <xms:Df0gYGcrq_kcazoAz1VEdP_8z_M7_jKtxzDvfBfrrI4a3X6c9F2iwA>
    <xme:Df0gYAMhyrOhNXAk75eb0P8d9U25Djs_bTFX1oYfG_dglXAMvGUps7eeIS0333Rl4
    dqLL5Rb8nnRUIM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrhedvgdduvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Df0gYHgY3SZeuCJVIv4Byp4VI2QTyi-S3LOZ9O6a20RVl1d1eZ4l_A>
    <xmx:Df0gYD-nohMGUIJ-rl8z6dwQ_WLyAf-9_3iwXZ_4p8esfE7Z2SFkYA>
    <xmx:Df0gYCuU24rIEbL5pXGeOfozl2DzSt25i1kk3FVyhjaEz-gXHWRsnw>
    <xmx:Df0gYEKedYYkIqXXqCnlFtikskCP9ER3RYWMiLWTLlV5jG45H1uvMg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4359624005B;
        Mon,  8 Feb 2021 03:57:49 -0500 (EST)
Date:   Mon, 8 Feb 2021 10:57:46 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Chris Mi <cmi@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210208085746.GA179437@shredder.lan>
References: <20210128014543.521151-1-cmi@nvidia.com>
 <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
 <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
 <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan>
 <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
 <20210201180837.GB3456040@shredder.lan>
 <20210208070350.GB4656@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208070350.GB4656@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 09:03:50AM +0200, Leon Romanovsky wrote:
> On Mon, Feb 01, 2021 at 08:08:37PM +0200, Ido Schimmel wrote:
> > On Mon, Feb 01, 2021 at 09:37:11AM +0800, Chris Mi wrote:
> > > Hi Ido,
> > >
> > > On 1/30/2021 10:42 PM, Ido Schimmel wrote:
> > > > On Fri, Jan 29, 2021 at 12:30:09PM -0800, Jakub Kicinski wrote:
> > > > > On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:
> > > > > > Instead of discussing it several days, maybe it's better to review
> > > > > > current patch, so that we can move forward :)
> > > > > It took you 4 revisions to post a patch which builds cleanly and now
> > > > > you want to hasten the review? My favorite kind of submission.
> > > > >
> > > > > The mlxsw core + spectrum drivers are 65 times the size of psample
> > > > > on my system. Why is the dependency a problem?
> > > > mlxsw has been using psample for ~4 years and I don't remember seeing a
> > > > single complaint about the dependency. I don't understand why this patch
> > > > is needed.
> > > Please see Saeed's comment in previous email:
> > >
> > > "
> > >
> > > The issue is with distros who ship modules independently.. having a
> > > hard dependency will make it impossible for basic mlx5_core.ko users to
> > > load the driver when psample is not installed/loaded.
> > >
> > > I prefer to have 0 dependency on external modules in a HW driver.
> > > "
> >
> > I saw it, but it basically comes down to personal preferences.
> 
> It is more than personal preferences. In opposite to the mlxsw which is
> used for netdev only, the mlx5_core is used by other subsystems, e.g. RDMA,
> so Saeed's request to avoid extra dependencies makes sense.
> 
> We don't need psample dependency to run RDMA traffic.

Right, you don't need it. The dependency is "PSAMPLE || PSAMPLE=n". You
can compile out psample and RDMA will work.

> 
> >
> > >
> > > We are working on a tc sample offload feature for mlx5_core. The distros
> > > are likely to request us to do this. So we address it before submitting
> > > the driver changes.
> >
> > Which distros? Can they comment here? mlxsw is in RHEL and I don't
> > remember queries from them about the psample module.
> 
> There is a huge difference between being in RHEL and actively work with
> partners as mlx5 does.
> 
> The open mailing list is not the right place to discuss our partnership
> relations.

I did not ask about "partnership relations". I asked for someone more
familiar with the problem that can explain the distro issue. But if such
a basic question can't be asked, then the distro argument should not
have been made in the first place.
