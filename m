Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2633731648A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhBJLDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:03:19 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:52755 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhBJLAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:00:41 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 328AC580324;
        Wed, 10 Feb 2021 05:59:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 10 Feb 2021 05:59:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5fXHGY
        xrTC05uatkM7mitonKpiC7Bf6g34qbrlEBtbI=; b=at1X+c2FFqoR2jFLPaHr1d
        yGhAM34eDzIBMRNapWY8+VUEC/TmkZ084CKIrfWdRFIM1H/1b6dVxKh9nx0EIbfL
        rGA9VnThnFISRUKQx/2LTY054kmJuePF46eJjOzQ9MFRrcuTia2vklPuVkS236y1
        SUqfO7qMtKDlnh7Z/5f1rZBpE/BkxB6WIH9IikGLn110LovjtAzosWbsLxJCTU74
        e08In/xIwgktwJKaB/ZGPA4EcV5EWOA2cza8KiSINZYV0SDCaQdr+Tl7f2Al4yqq
        O0zda5STP5HavurJfYdnTP1W6iXPqU2ZdscLGGTrA9XAojBgQ8dKFoZswuv+YsqQ
        ==
X-ME-Sender: <xms:qbwjYEtZELEeVD7gxEvs3Gqu4JlzcqyWrZdIhCrN4uzPRAXL9MLOIQ>
    <xme:qbwjYBeDSbe-a0NSHyVgS7RQXW6C9cSxJRKJF_5U6Trli3Bvgg-EDm_Ys9GIIosAr
    O0Z9bf75lS2tm8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheejgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qbwjYPzSp9gaoDvNT1Gl6d8mHObNdXeivImHPxN53G0B-UjST2pQug>
    <xmx:qbwjYHOpNlR1EV43rgfe61x32BHw65rKVBYwjccbd8PU8Tb8NejrNA>
    <xmx:qbwjYE88yyP54Rt5qIUwmqoX4IlxMl74qFGXFgLdM4xs6OoZe70TVg>
    <xmx:q7wjYFjRs-lfmFBy1tN56HTaUSRM14Ia0A7MY_FfxrFDHN_MIymJwQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id C464B24005D;
        Wed, 10 Feb 2021 05:59:52 -0500 (EST)
Date:   Wed, 10 Feb 2021 12:59:49 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 04/11] net: bridge: offload initial and final
 port flags through switchdev
Message-ID: <20210210105949.GB287766@shredder.lan>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-5-olteanv@gmail.com>
 <20210209185100.GA266253@shredder.lan>
 <20210209202045.obayorcud4fg2qqb@skbuf>
 <20210209220124.GA271860@shredder.lan>
 <20210209225153.j7u6zwnpdgskvr2v@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209225153.j7u6zwnpdgskvr2v@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:51:53AM +0200, Vladimir Oltean wrote:
> On Wed, Feb 10, 2021 at 12:01:24AM +0200, Ido Schimmel wrote:
> > On Tue, Feb 09, 2021 at 10:20:45PM +0200, Vladimir Oltean wrote:
> > > On Tue, Feb 09, 2021 at 08:51:00PM +0200, Ido Schimmel wrote:
> > > > On Tue, Feb 09, 2021 at 05:19:29PM +0200, Vladimir Oltean wrote:
> > > > > So switchdev drivers operating in standalone mode should disable address
> > > > > learning. As a matter of practicality, we can reduce code duplication in
> > > > > drivers by having the bridge notify through switchdev of the initial and
> > > > > final brport flags. Then, drivers can simply start up hardcoded for no
> > > > > address learning (similar to how they already start up hardcoded for no
> > > > > forwarding), then they only need to listen for
> > > > > SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS and their job is basically done, no
> > > > > need for special cases when the port joins or leaves the bridge etc.
> > > >
> > > > How are you handling the case where a port leaves a LAG that is linked
> > > > to a bridge? In this case the port becomes a standalone port, but will
> > > > not get this notification.
> > >
> > > Apparently the answer to that question is "I delete the code that makes
> > > this use case work", how smart of me. Thanks.
> >
> > Not sure how you expect to interpret this.
> 
> Next patch (05/11) deletes that explicit notification from dsa_port_bridge_leave,
> function which is called from dsa_port_lag_leave too, apparently with good reason.
> 
> > > Unless you have any idea how I could move the logic into the bridge, I
> > > guess I'm stuck with DSA and all the other switchdev drivers having this
> > > forest of corner cases to deal with. At least I can add a comment so I'm
> > > not tempted to delete it next time.
> >
> > There are too many moving pieces with stacked devices. It is not only
> > LAG/bridge. In L3 you have VRFs, SVIs, macvlans etc. It might be better
> > to gracefully / explicitly not handle a case rather than pretending to
> > handle it correctly with complex / buggy code.
> >
> > For example, you should refuse to be enslaved to a LAG that already has
> > upper devices such as a bridge. You are probably not handling this
> > correctly / at all. This is easy. Just a call to
> > netdev_has_any_upper_dev().
> 
> Correct, good point, in particular this means that joining a bridged LAG
> will not get me any notifications of that LAG's CHANGEUPPER because that
> was consumed a long time ago. An equally valid approach seems to be to
> check for netdev_master_upper_dev_get_rcu in dsa_port_lag_join, and call
> dsa_port_bridge_join on the upper if that is present.

The bridge might already have a state you are not familiar with (e.g.,
FDB entry pointing to the LAG), so best to just forbid this. I think
it's fair to impose such limitations (assuming they are properly
communicated to user space) given it results in a much less
buggy/complex code to maintain.

> 
> > The reverse, during unlinking, would be to refuse unlinking if the upper
> > has uppers of its own. netdev_upper_dev_unlink() needs to learn to
> > return an error and callers such as team/bond need to learn to handle
> > it, but it seems patchable.
> 
> Again, this was treated prior to my deletion in this series and not by
> erroring out, I just really didn't think it through.
> 
> So you're saying that if we impose that all switchdev drivers restrict
> the house of cards to be constructed from the bottom up, and destructed
> from the top down, then the notification of bridge port flags can stay
> in the bridge layer?

I actually don't think it's a good idea to have this in the bridge in
any case. I understand that it makes sense for some devices where
learning, flooding, etc are port attributes, but in other devices these
can be {port,vlan} attributes and then you need to take care of them
when a vlan is added / deleted and not only when a port is removed from
the bridge. So for such devices this really won't save anything. I would
thus leave it to the lower levels to decide.
