Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3BA30AEBD
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 19:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhBASJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 13:09:48 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44335 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhBASJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 13:09:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 381A65C0117;
        Mon,  1 Feb 2021 13:08:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 13:08:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=P6V5zw
        hvdkgX9CEKWr1Xik4kt8vW8ILtjmdEVAHYkUQ=; b=pxkhNCScKxGySo3SwjMXpX
        FTWsPQQyXOq1ebSv4ebUl6Ei6GzQgdHoogcTrzz1WNnIjEJAdRKW0WcFgRKzIbOT
        sbIx9ANYqjAnaDS4qIxVFlol8q/W14kQROXs/cj0Hcua0hrHEDFr6xRUDVNcOca1
        1lNXjnWRB/02gmzevJxKJDnWs0gUsZaMZDD6lK110tShEdQSOD+QKBDlgItEFEgT
        16wSaSo6+hvHQ0xv7i4+xM0FD+Xte/YuzNp7j6Gp2EmQHV5QflgZNdqzCpyVuzsQ
        YzB5IZkVyyKuWV4G7Wc8/pNtL33xBcrweKwGoudRf0XTwq0EWb4m0c8SlGesuNHw
        ==
X-ME-Sender: <xms:qEMYYP7PzgQ-edZuNTOqItxUs-w1D2gj7J0H8JxQkZnJzpsEuh4-MA>
    <xme:qEMYYE7fCiUWnC27uVOuYsuT1G1FUAVXpGA3SzZTSRkE845nI3yO1PvXF7g9xa8Jl
    yQWRbmAADJZGFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:qEMYYGeAiQEAxUT01OP-yVEAp5ICVpNKW8oZ3jjTdywJAnnl7X33Xw>
    <xmx:qEMYYAKivybL4E1B6oPCTj3_s3CZfwxhWoLfAtoLqPZ63Pb5MIsYvw>
    <xmx:qEMYYDKLQf1JCaxFjWrhJ8OhWzYapnZkb-yQPIzQz8mORJPy1ewGpA>
    <xmx:qUMYYL2p-MtdWIduPRhWe8H42wNiDbCNUlQS8YK6pqcqnOwcZI7mdQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 745BC24005E;
        Mon,  1 Feb 2021 13:08:40 -0500 (EST)
Date:   Mon, 1 Feb 2021 20:08:37 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210201180837.GB3456040@shredder.lan>
References: <20210128014543.521151-1-cmi@nvidia.com>
 <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
 <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
 <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan>
 <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 09:37:11AM +0800, Chris Mi wrote:
> Hi Ido,
> 
> On 1/30/2021 10:42 PM, Ido Schimmel wrote:
> > On Fri, Jan 29, 2021 at 12:30:09PM -0800, Jakub Kicinski wrote:
> > > On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:
> > > > Instead of discussing it several days, maybe it's better to review
> > > > current patch, so that we can move forward :)
> > > It took you 4 revisions to post a patch which builds cleanly and now
> > > you want to hasten the review? My favorite kind of submission.
> > > 
> > > The mlxsw core + spectrum drivers are 65 times the size of psample
> > > on my system. Why is the dependency a problem?
> > mlxsw has been using psample for ~4 years and I don't remember seeing a
> > single complaint about the dependency. I don't understand why this patch
> > is needed.
> Please see Saeed's comment in previous email:
> 
> "
> 
> The issue is with distros who ship modules independently.. having a
> hard dependency will make it impossible for basic mlx5_core.ko users to
> load the driver when psample is not installed/loaded.
> 
> I prefer to have 0 dependency on external modules in a HW driver.
> "

I saw it, but it basically comes down to personal preferences.

> 
> We are working on a tc sample offload feature for mlx5_core. The distros
> are likely to request us to do this. So we address it before submitting
> the driver changes.

Which distros? Can they comment here? mlxsw is in RHEL and I don't
remember queries from them about the psample module.

> 
> Regards,
> Chris
> 
