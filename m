Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930C224D25E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgHUKat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 06:30:49 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42217 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728631AbgHUKaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 06:30:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8BA75580370;
        Fri, 21 Aug 2020 06:30:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 21 Aug 2020 06:30:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8NCQ01
        kqfznEalwAgda3uxxPHtO8p/aD9TgD23y0Qkg=; b=c3sZPWac9uufvn/QU90vm3
        cqdikTPcFL5an4vhvwFpgOFYfJBq0qAhIiH4fE11IOpDd4w+Y54Pb0Dlz21QcMKk
        pVaMS9iFe28+roqjgBaN/lhfXCJiuwSqTxYIdc/soZ4G+huQickVoQhmNLI91qld
        7GyGcFIeGEY0LY3no1W/x9M85/kVSwG84gVFUF5J8SrYJLhgNFVNDGsm3ZZAJCyS
        ye5QUA1LH+4eeDSeZYcjKK+wjO2SHbyLD5ayHi42XUjoZwawp7tRgWDhxG5HUH1S
        spo6+JvhYxHEWX7rLk2pJQwiJKoBTvdlQtaXXTkriIg6c5EU9RMMs01vojVwfsSQ
        ==
X-ME-Sender: <xms:QaI_XxBkGYH26681WrS04eT3D0U5uGVY3PYAoiLXjPvqVGpRHUM3BQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduvddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeejfeeuhfevtdfhgedugedtieetteelfeevvdefleetjeeuvdejveeuleeludet
    tdenucffohhmrghinhepmhgvlhhlrghnohigrdgtohhmpdhkvghrnhgvlhdrohhrghenuc
    fkphepjeelrddujeekrddufedurdefheenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:QaI_X_gWbC7WtyiZiRdstg9EvKmDhd0qm169V00FJyQWaG5veqmNIg>
    <xmx:QaI_X8nvqBRHyXP4wKQt1tlWPBOVINy4aUplro2ufYzEmx32vKCCQQ>
    <xmx:QaI_X7wajDM_3fte3meHEATTkUdIdx9IgGt_EiXycvcvJq796gykcA>
    <xmx:QqI_Xyat5w9jNn5U_EQrJ_rKP_tc4B4AJCwS8Udsy-zusIAlqh6Wag>
Received: from localhost (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id C686530600B4;
        Fri, 21 Aug 2020 06:30:24 -0400 (EDT)
Date:   Fri, 21 Aug 2020 13:30:21 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        tariqt@nvidia.com, ayal@nvidia.com, mkubecek@suse.cz,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/6] devlink: Add device metric support
Message-ID: <20200821103021.GA331448@shredder>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200818172419.5b86801b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <58a0356d-3e15-f805-ae52-dc44f265661d@gmail.com>
 <20200818203501.5c51e61a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <55e40430-a52f-f77b-0d1e-ef79386a0a53@gmail.com>
 <20200819091843.33ddd113@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e4fd9b1c-5f7c-d560-9da0-362ddf93165c@gmail.com>
 <20200819110725.6e8744ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d0c24aad-b7f3-7fd9-0b34-c695686e3a86@gmail.com>
 <20200820090942.55dc3182@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820090942.55dc3182@kicinski-fedora-PC1C0HJN>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 09:09:42AM -0700, Jakub Kicinski wrote:
> On Thu, 20 Aug 2020 08:35:25 -0600 David Ahern wrote:
> > On 8/19/20 12:07 PM, Jakub Kicinski wrote:
> > > I don't have a great way forward in mind, sadly. All I can think of is
> > > that we should try to create more well defined interfaces and steer
> > > away from free-form ones.  
> > 
> > There is a lot of value in free-form too.
> 
> On Tue, 18 Aug 2020 20:35:01 -0700 Jakub Kicinski wrote:
> > It's a question of interface, not the value of exposed data.
> 
> > > Example, here if the stats are vxlan decap/encap/error - we should
> > > expose that from the vxlan module. That way vxlan module defines one
> > > set of stats for everyone.
> > > 
> > > In general unless we attach stats to the object they relate to, we will
> > > end up building parallel structures for exposing statistics from the
> > > drivers. I posted a set once which was implementing hierarchical stats,
> > > but I've abandoned it for this reason.
> > > > [...]
> > > 
> > > IDK. I just don't feel like this is going to fly, see how many names
> > > people invented for the CRC error statistic in ethtool -S, even tho
> > > there is a standard stat for that! And users are actually parsing the
> > > output of ethtool -S to get CRC stats because (a) it became the go-to
> > > place for NIC stats and (b) some drivers forget to report in the
> > > standard place.
> > > 
> > > The cover letter says this set replaces the bad debugfs with a good,
> > > standard API. It may look good and standard for _vendors_ because they
> > > will know where to dump their counters, but it makes very little
> > > difference for _users_. If I have to parse names for every vendor I use,
> > > I can as well add a per-vendor debugfs path to my script.
> > > 
> > > The bar for implementation-specific driver stats has to be high.  
> > 
> > My take away from this is you do not like the names - the strings side
> > of it.
> > 
> > Do you object to the netlink API? The netlink API via devlink?
> > 
> > 'perf' has json files to describe and document counters
> > (tools/perf/pmu-events). Would something like that be acceptable as a
> > form of in-tree documentation of counters? (vs Documentation/networking
> > or URLs like
> > https://community.mellanox.com/s/article/understanding-mlx5-ethtool-counters)
> 
> Please refer to what I said twice now about the definition of the stats
> exposed here belonging with the VxLAN code, not the driver.

Please refer to the changelog:

"The Spectrum ASICs have a single hardware VTEP that is able to perform
VXLAN encapsulation and decapsulation. The VTEP is logically mapped by
mlxsw to the multiple VXLAN netdevs that are using it. Exposing the
counters of this VTEP via the multiple VXLAN netdevs that are using it
would be both inaccurate and confusing for users.
    
Instead, expose the counters of the VTEP via devlink-metric. Note that
Spectrum-1 supports a different set of counters compared to newer ASICs
in the Spectrum family."

Hardware implementations will rarely fit 1:1 to the nice and discrete
software implementations that they try to accelerate. The purpose of
this API is exposing metrics specific to these hardware implementations.
This results in better visibility which can be leveraged for faster
debugging and more thorough testing.

The reason I came up with this interface is not the specific VXLAN
metrics that bother you, but a new platform we are working on. It uses
the ASIC as a cache that refers lookups to an external device in case of
cache misses. It is completely transparent to user space (you get better
scale), but the driver is very much aware of this stuff as it needs to
insert objects (e.g., routes) in a way that will minimize cache misses.
Just checking that ping works is hardly enough. We must be able to read
the cache counters to ensure we do not see cache misses when we do not
expect them.

As another example, consider the algorithmic TCAM implementation we have
in Spectrum-2 for ACLs [1]. While a user simply adds / deletes filters,
the driver needs to jump through multiple hops in order to program them
in a way that will result in a better scale and reduced latency. We
currently do not have an interface through which we can expose metrics
related to this specific implementation.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=756cd36626f773e9a72a39c1dd12da4deacfacdf

> 
> > > Okay, fair. I just think that in datacenter deployments we are way
> > > closer to the SDK model than people may want to admit.
> > 
> > I do not agree with that; the SDK model means you *must* use vendor code
> > to make something work. Your argument here is about labels for stats and
> > an understanding of their meaning.
> 
> Sure, no "must" for passing packets, but you "must" use vendor tooling
> to operate a fleet.
> 
> Since everybody already has vendor tools what value does this API add?

We don't have any "vendor tools" to get this information. Our team is
doing everything it possibly can in order to move away from such an
approach.

> I still need per vendor logic. Let's try to build APIs which will
> actually make user's life easier, which users will want to switch to.

Developers are also users and they should be able to read whatever
information they need from the device in order to help them do their
work. You have a multitude of tools (e.g., kprobes, tracepoints) to get
better visibility into the software data path. Commonality is not a
reason to be blind as a bat when looking into the hardware data path.
