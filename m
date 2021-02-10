Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DBF3166EF
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhBJMlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:41:25 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:51383 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231690AbhBJMje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:39:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 759BB580338;
        Wed, 10 Feb 2021 07:38:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 10 Feb 2021 07:38:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=414D1z
        xT2INxEG5/snbrdVQ7zhGupvA0v9cAD+u44oU=; b=jAjnZaSZrYMbtdF9FbDYco
        5ckP5C2HhGY42c9wrm3FsPlmkejqLkvx1Wk2JF+BjX67P6T90uIpRTkBN3tsljQw
        mwzo8uGlBMuZPyaddO1j7oYCw7QfZ7+Y/5NeDMxP+wqv/xQMo1z9RbHYDLBG5yuM
        y2ZQN67mq1GzP1GYdp4gp2FLdnl17phD+sJld3xCMYzZxxFzANtyqrysuhUpzm2N
        CPh670wfu9/a/JCHwiCUPHOa84pC06LR3exaxIWum14sLueh7v2vorTlj7HXmMFr
        AcZnoAmWQhQgwhZxg+rJ7bim62vPMaWAr/T+7oqURTdaobT3mWaBjc+lVy5pjp9w
        ==
X-ME-Sender: <xms:wtMjYHFLjHwbUNQko6KhCVGYYYCafxJZn_cMbKYO8wH2YSwL881HFA>
    <xme:wtMjYEXBpeUGBrQ4Hyhn0A0wrE6suNlWod_ax-gT9WNAfNOCT1fUtHfkZ1wfHi4qM
    770SFdKaMZ6K8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheejgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:wtMjYJKgM6y0PQH1y3braeVU-Ym0X45nyx5LjM4uWTaSf1T2Yxkhfw>
    <xmx:wtMjYFH2uZveDFBYBiAUGw-zAi3JYxQdebylkRvSHyoTRBmMWLPFTg>
    <xmx:wtMjYNVqau4hdISrCdvO0nA9wckVRTRiCYHL24jz74sPYrM38zzNbg>
    <xmx:xNMjYHZ_1O2C4-MiljuMIBFMXoYEA4vN2327lOjQ57JEAUE479ggFA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 722EC24005B;
        Wed, 10 Feb 2021 07:38:26 -0500 (EST)
Date:   Wed, 10 Feb 2021 14:38:23 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/11] Cleanup in brport flags switchdev
 offload for DSA
Message-ID: <20210210123823.GA294900@shredder.lan>
References: <20210210091445.741269-1-olteanv@gmail.com>
 <a8e9284b-f0a6-0343-175d-8c323371ef8d@nvidia.com>
 <20210210104549.ga3lgjafn5x3htwj@skbuf>
 <a58e9615-036c-0431-4ea6-004af4988b27@nvidia.com>
 <20210210110125.rw6fvjtsqmmuglcg@skbuf>
 <90b255e6-efd2-b234-7bfc-4285331e56b1@nvidia.com>
 <20210210120106.g7blqje3wq4j5l6j@skbuf>
 <20210210122105.GA294287@shredder.lan>
 <20210210122936.rpvdh7ksjfh2ee6b@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210122936.rpvdh7ksjfh2ee6b@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 02:29:36PM +0200, Vladimir Oltean wrote:
> On Wed, Feb 10, 2021 at 02:21:05PM +0200, Ido Schimmel wrote:
> > On Wed, Feb 10, 2021 at 02:01:06PM +0200, Vladimir Oltean wrote:
> > > On Wed, Feb 10, 2021 at 01:05:57PM +0200, Nikolay Aleksandrov wrote:
> > > > On 10/02/2021 13:01, Vladimir Oltean wrote:
> > > > > On Wed, Feb 10, 2021 at 12:52:33PM +0200, Nikolay Aleksandrov wrote:
> > > > >> On 10/02/2021 12:45, Vladimir Oltean wrote:
> > > > >>> Hi Nikolay,
> > > > >>>
> > > > >>> On Wed, Feb 10, 2021 at 12:31:43PM +0200, Nikolay Aleksandrov wrote:
> > > > >>>> Hi Vladimir,
> > > > >>>> Let's take a step back for a moment and discuss the bridge unlock/lock sequences
> > > > >>>> that come with this set. I'd really like to avoid those as they're a recipe
> > > > >>>> for future problems. The only good way to achieve that currently is to keep
> > > > >>>> the PRE_FLAGS call and do that in unsleepable context but move the FLAGS call
> > > > >>>> after the flags have been changed (if they have changed obviously). That would
> > > > >>>> make the code read much easier since we'll have all our lock/unlock sequences
> > > > >>>> in the same code blocks and won't play games to get sleepable context.
> > > > >>>> Please let's think and work in that direction, rather than having:
> > > > >>>> +	spin_lock_bh(&p->br->lock);
> > > > >>>> +	if (err) {
> > > > >>>> +		netdev_err(p->dev, "%s\n", extack._msg);
> > > > >>>> +		return err;
> > > > >>>>  	}
> > > > >>>> +
> > > > >>>>
> > > > >>>> which immediately looks like a bug even though after some code checking we can
> > > > >>>> verify it's ok. WDYT?
> > > > >>>>
> > > > >>>> I plan to get rid of most of the br->lock since it's been abused for a very long
> > > > >>>> time because it's essentially STP lock, but people have started using it for other
> > > > >>>> things and I plan to fix that when I get more time.
> > > > >>>
> > > > >>> This won't make the sysfs codepath any nicer, will it?
> > > > >>>
> > > > >>
> > > > >> Currently we'll have to live with a hack that checks if the flags have changed. I agree
> > > > >> it won't be pretty, but we won't have to unlock and lock again in the middle of the
> > > > >> called function and we'll have all our locking in the same place, easier to verify and
> > > > >> later easier to remove. Once I get rid of most of the br->lock usage we can revisit
> > > > >> the drop of PRE_FLAGS if it's a problem. The alternative is to change the flags, then
> > > > >> send the switchdev notification outside of the lock and revert the flags if it doesn't
> > > > >> go through which doesn't sound much better.
> > > > >> I'm open to any other suggestions, but definitely would like to avoid playing locking games.
> > > > >> Even if it means casing out flag setting from all other store_ functions for sysfs.
> > > > >
> > > > > By casing out flag settings you mean something like this?
> > > > >
> > > > >
> > > > > #define BRPORT_ATTR(_name, _mode, _show, _store)		\
> > > > > const struct brport_attribute brport_attr_##_name = { 	        \
> > > > > 	.attr = {.name = __stringify(_name), 			\
> > > > > 		 .mode = _mode },				\
> > > > > 	.show	= _show,					\
> > > > > 	.store_unlocked	= _store,				\
> > > > > };
> > > > >
> > > > > #define BRPORT_ATTR_FLAG(_name, _mask)				\
> > > > > static ssize_t show_##_name(struct net_bridge_port *p, char *buf) \
> > > > > {								\
> > > > > 	return sprintf(buf, "%d\n", !!(p->flags & _mask));	\
> > > > > }								\
> > > > > static int store_##_name(struct net_bridge_port *p, unsigned long v) \
> > > > > {								\
> > > > > 	return store_flag(p, v, _mask);				\
> > > > > }								\
> > > > > static BRPORT_ATTR(_name, 0644,					\
> > > > > 		   show_##_name, store_##_name)
> > > > >
> > > > > static ssize_t brport_store(struct kobject *kobj,
> > > > > 			    struct attribute *attr,
> > > > > 			    const char *buf, size_t count)
> > > > > {
> > > > > 	...
> > > > >
> > > > > 	} else if (brport_attr->store_unlocked) {
> > > > > 		val = simple_strtoul(buf, &endp, 0);
> > > > > 		if (endp == buf)
> > > > > 			goto out_unlock;
> > > > > 		ret = brport_attr->store_unlocked(p, val);
> > > > > 	}
> > > > >
> > > >
> > > > Yes, this can work but will need a bit more changes because of br_port_flags_change().
> > > > Then the netlink side can be modeled in a similar way.
> > > 
> > > What I just don't understand is how others can get away with doing
> > > sleepable work in atomic context but I can't make the notifier blocking
> > > by dropping a spinlock which isn't needed there, because it looks ugly :D
> > 
> > Can you please point to the bug? I'm not following
> 
> For example, mlxsw eventually calls mlxsw_sp_fid_flood_set from the
> SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS handling data path, and this
> function allocates memory with GFP_KERNEL.
> 
> Another example is prestera which eventually calls prestera_fw_send_req
> which takes a mutex_lock.
> 
> Yet another example are mv88e6xxx and b53 which use MDIO and SPI
> from their .port_egress_floods implementation, buses which have
> might_sleep() in them.

Right, but see the code:

```
	attr.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS;
	attr.flags = SWITCHDEV_F_DEFER;
	attr.u.brport_flags = flags;

	err = switchdev_port_attr_set(p->dev, &attr);
```

And check how SWITCHDEV_F_DEFER is used.

We can squash SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS and
SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS into one blocking notification
by reducing the scope of the bridge lock like Nik suggested. Currently
it's just blindly taken around br_setport().
