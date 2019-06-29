Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72A55AC2B
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 17:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfF2Pbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 11:31:45 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:58309 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726836AbfF2Pbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 11:31:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 362A52CF;
        Sat, 29 Jun 2019 11:31:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 29 Jun 2019 11:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=h4IoQt
        S8zRT80Ep+ouWOPOrpV1T1e5qhvVuN5URCl28=; b=Pun2zrEzjdcXNJ/AbTsekk
        kAr//jtp+dtvzTX04OdbNmUtV9aNRGX0kxdcD4/GO1c8v3DB0LkFvBhritV3sECy
        67/got8jZWzPxToEkKG3XWmjL2uM2anCdAGxi5AHRjpv4VoSea1HjChN5hx8t0BB
        DluFv39ujnBLAK/OnWd7fYOVrUwMWDPc68/PlYeGbZFHvf4uRGLqNJ9hf4EugVAp
        3nMDa2TKKK+Mm2bk067Da0hp76+qUBiSfjwfiLzXfZMd/FK/dkUPyDnoYi6MOKpF
        2YQcBdOsaTlgghdF4UeSGG11aS5I+kjUYrlA2u4V9PqG4Yi/ZGXOuIrKnMGWxYJg
        ==
X-ME-Sender: <xms:W4QXXa6ftTxQcy5hr9jtcg_RI9CH3XJoCahuo0iudW58Z-6Tg3AQzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvddvgdeludcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepuddtle
    drieehrdeifedruddtudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:W4QXXYJGWMBMTm-dY_poLl1oZ3BfgltrSJ4EFTo2Hy3PlNCutBXKjQ>
    <xmx:W4QXXUe-cbIqcBQ2rGzfMgcom2ZGAHHIwE9FUSCEmRrY7Ry9LMRwKA>
    <xmx:W4QXXbfX1DV7TkV5zq4piW8HzNQx9omCmXiT-HCq_K6wI6hyXFWWsA>
    <xmx:XIQXXYKkobkK8XOAOLFxirKoendaALw7r5zPBMhxbtHlqjcqP2x7XQ>
Received: from localhost (bzq-109-65-63-101.red.bezeqint.net [109.65.63.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A0E4380076;
        Sat, 29 Jun 2019 11:31:38 -0400 (EDT)
Date:   Sat, 29 Jun 2019 18:31:35 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: dsa: add support for MC_DISABLED attribute
Message-ID: <20190629153135.GA17143@splinter>
References: <20190620235639.24102-1-vivien.didelot@gmail.com>
 <5d653a4d-3270-8e53-a5e0-88ea5e7a4d3f@gmail.com>
 <20190623064838.GA13466@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623064838.GA13466@splinter>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 06:48:41AM +0000, Ido Schimmel wrote:
> On Thu, Jun 20, 2019 at 07:24:47PM -0700, Florian Fainelli wrote:
> > On 6/20/2019 4:56 PM, Vivien Didelot wrote:
> > > This patch adds support for enabling or disabling the flooding of
> > > unknown multicast traffic on the CPU ports, depending on the value
> > > of the switchdev SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED attribute.
> > > 
> > > This allows the user to prevent the CPU to be flooded with a lot of
> > > undesirable traffic that the network stack needs to filter in software.
> > > 
> > > The bridge has multicast snooping enabled by default, hence CPU ports
> > > aren't bottlenecked with arbitrary network applications anymore.
> > > But this can be an issue in some scenarios such as pinging the bridge's
> > > IPv6 address. Setting /sys/class/net/br0/bridge/multicast_snooping to
> > > 0 would restore unknown multicast flooding and thus fix ICMPv6. As
> > > an alternative, enabling multicast_querier would program the bridge
> > > address into the switch.
> > From what I can read from mlxsw, we should probably also implement the
> > SWITCHDEV_ATTR_ID_PORT_MROUTER attribute in order to be consistent.
> > 
> > Since the attribute MC_DISABLED is on the bridge master, we should also
> > iterate over the list of switch ports being a member of that bridge and
> > change their flooding attribute, taking into account whether
> > BR_MCAST_FLOOD is set on that particular port or not. Just paraphrasing
> > what mlxsw does here again...
> 
> When multicast snooping is enabled, unregistered multicast traffic
> should be flooded to mrouter ports only. Otherwise, it should be flooded
> to all ports.
> 
> > Once you act on the user-facing ports, you might be able to leave the
> > CPU port flooding unconditionally, since it would only "flood" the CPU
> > port either because an user-facing port has BR_MCAST_FLOOD set, or
> > because this is known MC traffic that got programmed via the bridge's
> > MDB. Would that work?
> > 
> > On a higher level, I really wish we did not have to re-implement a lot
> > of identical or similar logic in each switch drivers and had a more
> > central model of what is behaviorally expected.
> 
> Well, that model is the bridge driver... But I agree that we can
> probably simplify the interface towards drivers and move more code up
> the stack.
> 
> For example, two things mlxsw is doing when multicast snooping is
> enabled:
> 
> 1. Writing MDB entries to the device. When multicast snooping is
> disabled, MDB entries are ignored by the bridge driver. Can we agree to
> have the bridge driver generate SWITCHDEV_OBJ_ID_PORT_MDB add / delete
> for all MDB entries when multicast snooping is toggled?
> 
> 2. Flooding unregistered multicast traffic only to mrouter ports. The
> bridge driver can iterate over the bridge members and toggle
> BR_MCAST_FLOOD accordingly. It will not actually change this value. Only
> emulate this change towards drivers.
> 
> I will try to come up with a more detailed list later this week.

I reviewed the MC logic in mlxsw again and while I found some things
that can be improved, I don't think major simplification can happen
there.

Regarding "central model of what is behaviorally expected". IMO, the
best thing is to make sure that all the implementations pass tests that
codify what is to be expected. Given that the model is the Linux bridge,
the tests should of course pass with veth pairs.

We have some tests under tools/testing/selftests/net/forwarding/, but
not so much for MC. However, even if such tests were to be contributed,
would you be able to run them on your hardware? I remember that in the
past you complained about the number of required ports. Is there
something you can do about it? How many ports are available on your
platforms?
