Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EE0468A47
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 10:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhLEJ4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 04:56:35 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:44659 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232727AbhLEJ4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 04:56:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8B5E73200A51;
        Sun,  5 Dec 2021 04:53:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 05 Dec 2021 04:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lAndXG
        0tQJGAJ4uUceIro5KXDsyQfKo3MfK/sCuHGpo=; b=AoGERFS1PPef4UQ2o6RyaO
        QRHuawQeZWrAiY+UM7dcrp9DEB1kKKcJ3qKA37hwO5p1s3zdnnl0WIp9GpTcrNVd
        BusktJ+DSFKXPpPqY4G6GWMlEXtudK0D+48CpQ77AqX7exirgJQ8reDXdMwL3T6L
        8yvzgVpw33n3nfQHnztR7tWazlgYo9Md/AXRQLy00TH3+ir1gNdCj60lAoD3x/0c
        xMNcNvSWfbS+NDEuqbYegD+0uFOESZh3yNysmavfmuAcO/amJaoZ7KNzFhwkObzZ
        xx0eo7bDZgIHSrkldz5ridP+mbhncCHuNH/j5a/Twg7F9tbEg4Uevm1TkKV92A8g
        ==
X-ME-Sender: <xms:AoysYRriaHCK1kx4DYMyxtKbuwRntrw07UfggV4D0yHun5Z0OZo1Gw>
    <xme:AoysYTq9uVs7j2W-SWTXi0erwDv57HHoIFax8o2F2Wl7c0SoRqpf5VDJ1GbxbCYZ7
    0GlVr28UXof-r4>
X-ME-Received: <xmr:AoysYeMF8KLgF3yZ3qND_qs-MI4V5FkqmutGDMtRdxXSOENdzvs42dOiyMsP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrjedugddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:AoysYc7fo5HJ-_FHX7Z54cEhd8eKGa_zDoOXmGXDD0-nXHeObi_7Tg>
    <xmx:AoysYQ4jBXB4WL2VsfmwX0cTv9q77RHKQ6KZEDGVKCRFUQm4mongNQ>
    <xmx:AoysYUgdfUVRhK4vjNFgBj5xkr_I233HHhe7Ldmu_1SM0G8z8HBgyQ>
    <xmx:A4ysYeTWPfRhcwUG41snmRiy_W2rfyoPyc0rd5WgSkoykoiISn5Chw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 5 Dec 2021 04:53:06 -0500 (EST)
Date:   Sun, 5 Dec 2021 11:53:03 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <YayL/7d/hm3TYjtV@shredder>
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202174502.28903-1-lschlesinger@drivenets.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 07:45:02PM +0200, Lahav Schlesinger wrote:
> Under large scale, some routers are required to support tens of thousands
> of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> vrfs, etc).
> At times such routers are required to delete massive amounts of devices
> at once, such as when a factory reset is performed on the router (causing
> a deletion of all devices), or when a configuration is restored after an
> upgrade, or as a request from an operator.
> 
> Currently there are 2 means of deleting devices using Netlink:
> 1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
> or by name using IFLA_IFNAME)
> 2. Delete all device that belong to a group (using IFLA_GROUP)
> 
> Deletion of devices one-by-one has poor performance on large scale of
> devices compared to "group deletion":
> After all device are handled, netdev_run_todo() is called which
> calls rcu_barrier() to finish any outstanding RCU callbacks that were
> registered during the deletion of the device, then wait until the
> refcount of all the devices is 0, then perform final cleanups.
> 
> However, calling rcu_barrier() is a very costly operation, each call
> taking in the order of 10s of milliseconds.
> 
> When deleting a large number of device one-by-one, rcu_barrier()
> will be called for each device being deleted.
> As an example, following benchmark deletes 10K loopback devices,
> all of which are UP and with only IPv6 LLA being configured:
> 
> 1. Deleting one-by-one using 1 thread : 243 seconds
> 2. Deleting one-by-one using 10 thread: 70 seconds
> 3. Deleting one-by-one using 50 thread: 54 seconds
> 4. Deleting all using "group deletion": 30 seconds
> 
> Note that even though the deletion logic takes place under the rtnl
> lock, since the call to rcu_barrier() is outside the lock we gain
> some improvements.
> 
> But, while "group deletion" is the fastest, it is not suited for
> deleting large number of arbitrary devices which are unknown a head of
> time. Furthermore, moving large number of devices to a group is also a
> costly operation.

These are the number I get in a VM running on my laptop.

Moving 16k dummy netdevs to a group:

# time -p ip -b group.batch 
real 1.91
user 0.04
sys 0.27

Deleting the group:

# time -p ip link del group 10
real 6.15
user 0.00
sys 3.02

IMO, these numbers do not justify a new API. Also, your user space can
be taught to create all the netdevs in the same group to begin with:

# ip link add name dummy1 group 10 type dummy
# ip link show dev dummy1
10: dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group 10 qlen 1000
    link/ether 12:b6:7d:ff:48:99 brd ff:ff:ff:ff:ff:ff

Moreover, unlike the list API that is specific to deletion, the group
API also lets you batch set operations:

# ip link set group 10 mtu 2000
# ip link show dev dummy1
10: dummy1: <BROADCAST,NOARP> mtu 2000 qdisc noop state DOWN mode
DEFAULT group 10 qlen 1000
    link/ether 12:b6:7d:ff:48:99 brd ff:ff:ff:ff:ff:ff

If you are using namespaces, then during "factory reset" you can delete
the namespace which should trigger batch deletion of the netdevs inside
it.

> 
> This patch adds support for passing an arbitrary list of ifindex of
> devices to delete with a new IFLA_IFINDEX attribute. A single message
> may contain multiple instances of this attribute).
> This gives a more fine-grained control over which devices to delete,
> while still resulting in rcu_barrier() being called only once.
> Indeed, the timings of using this new API to delete 10K devices is
> the same as using the existing "group" deletion.
> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
