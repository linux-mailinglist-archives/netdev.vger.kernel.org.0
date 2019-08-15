Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB248E4EC
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 08:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfHOGeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 02:34:11 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:59197 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730317AbfHOGeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 02:34:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6F4743388;
        Thu, 15 Aug 2019 02:34:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 15 Aug 2019 02:34:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QC24EC
        KPUrZPJ/qHruIRrpiPoSoBJgNwc4JceP+DXM4=; b=o49fefrYbANoTYHNtDtMSX
        MCgkCAfPBJVHVsRtofW/K/PgINU8L87LIUuor89F6tFS/CiK01mxD/F0G7xy6C7z
        u1VeFoX2N8XK0yMT2etJuMSR8V+wErfiDT2fwakjsbMGoA0DV+0S9h1HsY4pgZl+
        bn3EohXZppXnqvgF7a1ciYgjPT80UoRfmZV1hBBpDy3W5Fla3Z8lrBc9JH8E+HBY
        /Z4CVyDCj9WuCm4DM5fH1jSDveTlxIOUO+I0S87dl/ztrvZyNGE01p9595NrlelG
        aJzjXv6B4J0G7MOT7VQ7i3KiZHO9DT6NL9MNU6/FUh0TVHAt0FOtShX4cAreTgfA
        ==
X-ME-Sender: <xms:3_xUXWscQj3aUoL91sulWd2EHsGXt4qe1Ot_pdjpoquGnSKgbov2BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeftddgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:3_xUXeg8x6fUqk5mhk6WwmHN95wVrkrkEqs5DHWhxJIc3i0RWK5ALQ>
    <xmx:3_xUXcY2iyKvucMkV1PZg1RcJeCJAt4DcCIMF4_3rJIVBHdYflJ-xA>
    <xmx:3_xUXdatBtQ3ovTaYy1QdixKX9qpJBgum4xwzeCpi2F7Y2MiyEJX9Q>
    <xmx:4fxUXbDpkC1GZq1880JsWqbyu12DGTEoVc3sSUaTt8g4zFcrwcvdsA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53D1780060;
        Thu, 15 Aug 2019 02:34:07 -0400 (EDT)
Date:   Thu, 15 Aug 2019 09:34:05 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jiri@mellanox.com, toke@redhat.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 13/14] selftests: devlink_trap: Add test
 cases for devlink-trap
Message-ID: <20190815063405.GB12222@splinter>
References: <20190813075400.11841-1-idosch@idosch.org>
 <20190813075400.11841-14-idosch@idosch.org>
 <20190814174229.1ab4fd1b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814174229.1ab4fd1b@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 05:42:29PM -0700, Jakub Kicinski wrote:
> On Tue, 13 Aug 2019 10:53:59 +0300, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@mellanox.com>
> > 
> > Add test cases for devlink-trap on top of the netdevsim implementation.
> > 
> > The tests focus on the devlink-trap core infrastructure and user space
> > API. They test both good and bad flows and also dismantle of the netdev
> > and devlink device used to report trapped packets.
> > 
> > This allows device drivers to focus their tests on device-specific
> > functionality.
> > 
> > Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> > Acked-by: Jiri Pirko <jiri@mellanox.com>
> 
> Thanks for the test!
> 
> Should it perhaps live in:
> tools/testing/selftests/drivers/net/netdevsim/
> ?
> 
> That's where Jiri puts his devlink tests..

Yea, good point. Will move it there.

> 
> Also the test seems to require netdevsim to be loaded, otherwise:
> # ./devlink_trap.sh 
> SKIP: No netdevsim support
> 
> Is that expected?

No, my bad. I need to change the check to see if netdevsim is loaded and
otherwise load the module.

Thanks!
