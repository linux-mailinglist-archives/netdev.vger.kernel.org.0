Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3510F468B40
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 14:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhLENxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 08:53:30 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49491 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234224AbhLENxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 08:53:30 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id DE48B5C00E8;
        Sun,  5 Dec 2021 08:50:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 05 Dec 2021 08:50:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=XgDbCu
        9zy9LSqZyd/0JFkSd+H84jhOTyX7buBDSXOKE=; b=O1/IFAcovcyh2rMFAIr5w6
        RGF/Rd276S7UKhrobiwT2NJ9bUIfPhU6SoZVxBQYCHnvo/kNzkdgGHUTVL1qpgAU
        EjkzL2C5h/PA3zg87+yWY7nJKFRb9u5X/X4ga3l2m/hRrMJ9QYyW7LW3OPXql4ep
        QhFic6yp8x6TR/oP4ECCK2bTNe0aljsh4Ol+K4KYUABA8dTKqDsaTp9HNDTbx3gU
        ehyf+KIE3zPGBxzyCLJx1PfjGXEL6oO9L+A+BJAEitK7vbeJ6q5pn7AwpT8gYEOi
        dRgvf7v3ZxIC4oxUmm3EQPV9w797eUSN5XPcgG2QZXw4n1N8Nb9RBBnYAVTLLtpA
        ==
X-ME-Sender: <xms:isOsYSmVLMnulQ96n5aHyLg4SkuOGH8cYsAAeq62vRqRU5p0sh3Cgg>
    <xme:isOsYZ10wA3ANaPndAuLddPqMToZXWrWEZRhpYxajelrFArjoWSMQpZM98HXhobSy
    S_uSBktFEaH8C8>
X-ME-Received: <xmr:isOsYQoN02HVdfFRs94hayVGuFQeD3AkNSMvQDmdhub9zbLRLGJyQShcX3-c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrjedugdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:isOsYWn1rjpY6ilusCKSGgj59p4n1JTlpMsuICGctuKtcjty5OpWYw>
    <xmx:isOsYQ2YCrT76iCtSar8_4fogohQIyJT-ho7MPx40Qe_fZdQJ_QcKQ>
    <xmx:isOsYdsHASAM2CVpDG8mXR1MN5RWU3_YlIjP7AZnIJ4tSrM82_4t-g>
    <xmx:isOsYd_kfQWmfY0iyvqN1w8nIkbFnVVn04hz83JC7PmQ45zb7LtRyw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 5 Dec 2021 08:50:01 -0500 (EST)
Date:   Sun, 5 Dec 2021 15:49:59 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <YazDh1HkLBM4BiCW@shredder>
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
 <YayL/7d/hm3TYjtV@shredder>
 <20211205121059.btshgxt7s7hfnmtr@kgollan-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205121059.btshgxt7s7hfnmtr@kgollan-pc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 02:11:00PM +0200, Lahav Schlesinger wrote:
> On Sun, Dec 05, 2021 at 11:53:03AM +0200, Ido Schimmel wrote:
> > CAUTION: External E-Mail - Use caution with links and attachments
> >
> >
> > On Thu, Dec 02, 2021 at 07:45:02PM +0200, Lahav Schlesinger wrote:
> > > Under large scale, some routers are required to support tens of thousands
> > > of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> > > vrfs, etc).
> > > At times such routers are required to delete massive amounts of devices
> > > at once, such as when a factory reset is performed on the router (causing
> > > a deletion of all devices), or when a configuration is restored after an
> > > upgrade, or as a request from an operator.
> > >
> > > Currently there are 2 means of deleting devices using Netlink:
> > > 1. Deleting a single device (either by ifindex using ifinfomsg::ifi_index,
> > > or by name using IFLA_IFNAME)
> > > 2. Delete all device that belong to a group (using IFLA_GROUP)
> > >
> > > Deletion of devices one-by-one has poor performance on large scale of
> > > devices compared to "group deletion":
> > > After all device are handled, netdev_run_todo() is called which
> > > calls rcu_barrier() to finish any outstanding RCU callbacks that were
> > > registered during the deletion of the device, then wait until the
> > > refcount of all the devices is 0, then perform final cleanups.
> > >
> > > However, calling rcu_barrier() is a very costly operation, each call
> > > taking in the order of 10s of milliseconds.
> > >
> > > When deleting a large number of device one-by-one, rcu_barrier()
> > > will be called for each device being deleted.
> > > As an example, following benchmark deletes 10K loopback devices,
> > > all of which are UP and with only IPv6 LLA being configured:
> > >
> > > 1. Deleting one-by-one using 1 thread : 243 seconds
> > > 2. Deleting one-by-one using 10 thread: 70 seconds
> > > 3. Deleting one-by-one using 50 thread: 54 seconds
> > > 4. Deleting all using "group deletion": 30 seconds
> > >
> > > Note that even though the deletion logic takes place under the rtnl
> > > lock, since the call to rcu_barrier() is outside the lock we gain
> > > some improvements.
> > >
> > > But, while "group deletion" is the fastest, it is not suited for
> > > deleting large number of arbitrary devices which are unknown a head of
> > > time. Furthermore, moving large number of devices to a group is also a
> > > costly operation.
> >
> > These are the number I get in a VM running on my laptop.
> >
> > Moving 16k dummy netdevs to a group:
> >
> > # time -p ip -b group.batch
> > real 1.91
> > user 0.04
> > sys 0.27
> >
> > Deleting the group:
> >
> > # time -p ip link del group 10
> > real 6.15
> > user 0.00
> > sys 3.02
> >
> 
> Hi Ido, in your tests in which state the dummy devices are before
> deleting/changing group?
> When they are DOWN I get similar numbers to yours (16k devices):
> 
> # time ip -b group_16000_batch
> real	0m0.640s
> user	0m0.152s
> sys	0m0.478s
> 
> # time ip link delete group 100
> real	0m5.324s
> user	0m0.017s
> sys	0m4.991s
> 
> But when the devices are in state UP, I get:
> 
> # time ip -b group_16000_batch
> real	0m48.605s
> user	0m0.218s
> sys	0m48.244s
> 
> # time ip link delete group 100
> real	1m13.219s
> user	0m0.010s
> sys	1m9.117s
> 
> And for completeness, setting the devices to DOWN prior to deleting them
> is as fast as deleting them in the first place while they're UP.
> 
> Also, while this is probably a minuscule issue, changing the group of
> 10ks+ of interfaces will result in a storm of netlink events that will
> make any userspace program listening on link events to spend time
> handling these events.  This will result in twice as many events
> compared to directly deleting the devices.

Yes, in my setup the netdevs were down. Looking at the code, I think the
reason for the 75x increase in latency is the fact that netlink
notifications are not generated when the netdev is down. See
netdev_state_change().

In your specific case, it is quite useless for the kernel to generate
16k notifications when moving the netdevs to a group since the entire
reason they are moved to a group is so that they could be deleted in a
batch.

I assume that there are other use cases where having the kernel suppress
notifications can be useful. Did you consider adding such a flag to the
request? I think such a mechanism is more generic/useful than an ad-hoc
API to delete a list of netdevs and should allow you to utilize the
existing group deletion mechanism.

> 
> > IMO, these numbers do not justify a new API. Also, your user space can
> > be taught to create all the netdevs in the same group to begin with:
> >
> > # ip link add name dummy1 group 10 type dummy
> > # ip link show dev dummy1
> > 10: dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group 10 qlen 1000
> >     link/ether 12:b6:7d:ff:48:99 brd ff:ff:ff:ff:ff:ff
> >
> > Moreover, unlike the list API that is specific to deletion, the group
> > API also lets you batch set operations:
> >
> > # ip link set group 10 mtu 2000
> > # ip link show dev dummy1
> > 10: dummy1: <BROADCAST,NOARP> mtu 2000 qdisc noop state DOWN mode
> > DEFAULT group 10 qlen 1000
> >     link/ether 12:b6:7d:ff:48:99 brd ff:ff:ff:ff:ff:ff
> 
> The list API can be extended to support other operations as well
> (similar to group set operations, we can call do_setlink() for each
> device specified in an IFLA_IFINDEX).
> I didn't implement it in this patch because we don't have a use for it
> currently.
> 
> >
> > If you are using namespaces, then during "factory reset" you can delete
> > the namespace which should trigger batch deletion of the netdevs inside
> > it.
> >
> 
> In some scenarios we are required to delete only a subset of devices
> (e.g. when a physical link becomes DOWN, we need to delete all the VLANs
> and any tunnels configured on that device).  Furthermore, a user is
> allowed to load a new configuration in which he deletes only some of the
> devices (e.g. delete all of the loopbacks in the system), while not
> touching the other devices.
> 
> > >
> > > This patch adds support for passing an arbitrary list of ifindex of
> > > devices to delete with a new IFLA_IFINDEX attribute. A single message
> > > may contain multiple instances of this attribute).
> > > This gives a more fine-grained control over which devices to delete,
> > > while still resulting in rcu_barrier() being called only once.
> > > Indeed, the timings of using this new API to delete 10K devices is
> > > the same as using the existing "group" deletion.
> > >
> > > Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
