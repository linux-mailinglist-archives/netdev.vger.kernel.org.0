Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EB83F4DEF
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhHWQDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 12:03:10 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:33093 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhHWQDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 12:03:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 37720580B58;
        Mon, 23 Aug 2021 12:02:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Aug 2021 12:02:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gW/RqC
        tO/g3GW3DLfeFGTdBFULFHlIlYaLnhXnKYViQ=; b=UzVntjazTRDjN2K0HQDXTQ
        R0zU/wnZKQ+Ro/sDM7DM/juX+ESAT49anq5ndK6eUtHNw3m4QN2Q93hX1PTtXuUk
        LaURW+rHoA5G/H1s3zcnjkGI9TSCEQMB7YSMZfYtrLqH8kulvMgCDo4a0P+CQQDm
        UZRqPYT/4QElp+ZzZt8Zc1XrBM3xDKCqH85GvL53zyVbgczcGUydAKk4nFe1edIv
        MgXMn/3R7hupn2/saxZk1z391uHrqsaHCxitcQRW64j43x2w9Eafo15W0aMLIIfR
        6LzFw8dHOuKFW2BaW9aBafl1PqJqF7ak5e4WrSYu1oo50PlaOW6w6X4+JFx/uYyA
        ==
X-ME-Sender: <xms:jMYjYRVXv2RlQLzhP6repe6izekIWBMZPJuoY4K_ekMQbRsrssELJQ>
    <xme:jMYjYRkOB5NvNNU7FDZvJ2J1wOlmJH_vldp_4BbkOsX-IQnL6neUaK05TwpianjMB
    X9W-irfHWobPks>
X-ME-Received: <xmr:jMYjYdbOF5WxDYVZ81-N4CvlAk4176PQLrxBNY5ClUpxoo6TS8ZdgScnX9PkMrWY7sb4YcHXGrSEBgM-STGaY7leTq9R6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddthedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:jcYjYUXBImURPuC0vrqvep43i8GX3XfTiFeviBjGTw963CqlO6jz8A>
    <xmx:jcYjYbkMUIcvPFVHj7Cl1S46IQo4kpzwgqcSYak1TUCPOhdQEKfdBw>
    <xmx:jcYjYRc99jEJ3uFhducWZ49zHrbFeJXRLVgjyzE8Ef2BR3pib2bwfA>
    <xmx:ksYjYWVufC-ZyfgO1I-PyQcnyipyRd5LpLG3oBNmteegclqcBdN4MQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Aug 2021 12:02:20 -0400 (EDT)
Date:   Mon, 23 Aug 2021 19:02:15 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
Message-ID: <YSPGh4Fj3idApeFx@shredder>
References: <fbfce8d7-5bd8-723a-8ab3-0ce5bc6b073a@nvidia.com>
 <20210822133145.jjgryhlkgk4av3c7@skbuf>
 <YSKD+DK4kavYJrRK@shredder>
 <20210822174449.nby7gmrjhwv3walp@skbuf>
 <YSN83d+wwLnba349@shredder>
 <20210823110046.xuuo37kpsxdbl6c2@skbuf>
 <YSORsKDOwklF19Gm@shredder>
 <20210823142953.gwapkdvwfgdvfrys@skbuf>
 <YSO8MK5Alv0yF9pr@shredder>
 <20210823154244.4a53faquqrljov7g@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823154244.4a53faquqrljov7g@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 06:42:44PM +0300, Vladimir Oltean wrote:
> On Mon, Aug 23, 2021 at 06:18:08PM +0300, Ido Schimmel wrote:
> > On Mon, Aug 23, 2021 at 05:29:53PM +0300, Vladimir Oltean wrote:
> > > On Mon, Aug 23, 2021 at 03:16:48PM +0300, Ido Schimmel wrote:
> > > > I was thinking about the following case:
> > > >
> > > > t0 - <MAC1,VID1,P1> is added in syscall context under 'hash_lock'
> > > > t1 - br_fdb_delete_by_port() flushes entries under 'hash_lock' in
> > > >      response to STP state. Notifications are added to 'deferred' list
> > > > t2 - switchdev_deferred_process() is called in syscall context
> > > > t3 - <MAC1,VID1,P1> is notified as blocking
> > > >
> > > > Updates to the SW FDB are protected by 'hash_lock', but updates to the
> > > > HW FDB are not. In this case, <MAC1,VID1,P1> does not exist in SW, but
> > > > it will exist in HW.
> > > >
> > > > Another case assuming switchdev_deferred_process() is called first:
> > > >
> > > > t0 - switchdev_deferred_process() is called in syscall context
> > > > t1 - <MAC1,VID,P1> is learned under 'hash_lock'. Notification is added
> > > >      to 'deferred' list
> > > > t2 - <MAC1,VID1,P1> is modified in syscall context under 'hash_lock' to
> > > >      <MAC1,VID1,P2>
> > > > t3 - <MAC1,VID1,P2> is notified as blocking
> > > > t4 - <MAC1,VID1,P1> is notified as blocking (next time the 'deferred'
> > > >      list is processed)
> > > >
> > > > In this case, the HW will have <MAC1,VID1,P1>, but SW will have
> > > > <MAC1,VID1,P2>
> > >
> > > Ok, so if the hardware FDB entry needs to be updated under the same
> > > hash_lock as the software FDB entry, then it seems that the goal of
> > > updating the hardware FDB synchronously and in a sleepable manner is if
> > > the data path defers the learning to sleepable context too. That in turn
> > > means that there will be 'dead time' between the reception of a packet
> > > from a given {MAC SA, VID} flow and the learning of that address. So I
> > > don't think that is really desirable. So I don't know if it is actually
> > > realistic to do this.
> > >
> > > Can we drop it from the requirements of this change, or do you feel like
> > > it's not worth it to make my change if this problem is not solved?
> >
> > I didn't pose it as a requirement, but as a desirable goal that I don't
> > know how to achieve w/o a surgery in the bridge driver that Nik and you
> > (understandably) don't like.
> >
> > Regarding a more practical solution, earlier versions (not what you
> > posted yesterday) have the undesirable properties of being both
> > asynchronous (current state) and mandating RTNL to be held. If we are
> > going with the asynchronous model, then I think we should have a model
> > that doesn't force RTNL and allows batching.
> >
> > I have the following proposal, which I believe solves your problem and
> > allows for batching without RTNL:
> >
> > The pattern of enqueuing a work item per-entry is not very smart.
> > Instead, it is better to to add the notification info to a list
> > (protected by a spin lock) and scheduling a single work item whose
> > purpose is to dequeue entries from this list and batch process them.
> 
> I don't have hardware where FDB entries can be installed in bulk, so
> this is new to me. Might make sense though where you are in fact talking
> to firmware, and the firmware is in fact still committing to hardware
> one by one, you are still reducing the number of round trips.

Yes

> 
> > Inside the work item you would do something like:
> >
> > spin_lock_bh()
> > list_splice_init()
> > spin_unlock_bh()
> >
> > mutex_lock() // rtnl or preferably private lock
> > list_for_each_entry_safe()
> > 	// process entry
> > 	cond_resched()
> > mutex_unlock()
> 
> When is the work item scheduled in your proposal?

Calling queue_work() whenever you get a notification. The work item
might already be queued, which is fine.

> I assume not only when SWITCHDEV_FDB_FLUSH_TO_DEVICE is emitted. Is
> there some sort of timer to allow for some batching to occur?

You can add an hysteresis timer if you want, but I don't think it's
necessary. Assuming user space is programming entries at a high rate,
then by the time you finish a batch, you will have a new one enqueued.

> 
> >
> > In del_nbp(), after br_fdb_delete_by_port(), the bridge will emit some
> > new blocking event (e.g., SWITCHDEV_FDB_FLUSH_TO_DEVICE) that will
> > instruct the driver to flush all its pending FDB notifications. You
> > don't strictly need this notification because of the
> > netdev_upper_dev_unlink() that follows, but it helps in making things
> > more structured.
> >
> > Pros:
> >
> > 1. Solves your problem?
> > 2. Pattern is not worse than what we currently have
> > 3. Does not force RTNL
> > 4. Allows for batching. For example, mlxsw has the ability to program up
> > to 64 entries in one transaction with the device. I assume other devices
> > in the same grade have similar capabilities
> >
> > Cons:
> >
> > 1. Asynchronous
> > 2. Pattern we will see in multiple drivers? Can consider migrating it
> > into switchdev itself at some point
> 
> I can already flush_workqueue(dsa_owq) in dsa_port_pre_bridge_leave()
> and this will solve the problem in the same way, will it not?

Problem is that you will deadlock if your work item tries to take RTNL.

> 
> It's not that I don't have driver-level solutions and hook points.
> My concern is that there are way too many moving parts and the entrance
> barrier for a new switchdev driver is getting higher and higher to
> achieve even basic stuff.

I understand the frustration, but that's my best proposal at the moment.
IMO, it doesn't make things worse and has some nice advantages.

> 
> For example, I need to maintain a DSA driver and a switchdev driver for
> the exact same class of hardware (ocelot is switchdev, felix is DSA, but
> the hardware is the same) and it is just so annoying that the interaction
> with switchdev is so verbose and open-coded, it just leads to so much
> duplication of basic patterns.
> When I add support for SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE in ocelot I
> really don't want to add a boatload of code, all copied from DSA.
> 
> > 3. Something I missed / overlooked
> >
> > > There is of course the option of going half-way too, just like for
> > > SWITCHDEV_PORT_ATTR_SET. You notify it once, synchronously, on the
> > > atomic chain, the switchdev throws as many errors as it can reasonably
> > > can, then you defer the actual installation which means a hardware access.
> >
> > Yes, the above proposal has the same property. You can throw errors
> > before enqueueing the notification info on your list.
