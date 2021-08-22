Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D76F3F3E30
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 09:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhHVGtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 02:49:09 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:47869 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229934AbhHVGtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 02:49:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9D7E7580BEF;
        Sun, 22 Aug 2021 02:48:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 22 Aug 2021 02:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IYBAjT
        GZXP84SBGXA+FO8TM3iABaZyRPOiJ5J8ezgAo=; b=P2mLYDHnHo01tAhU2wgW6H
        KyHeSKv/x3+KkuZD/XdWBOZ47ZLMpvsP5R5WPxe/XnoyXROhgoP24WKn7t44GLG5
        KoK9CvbU3UamUtrLTzhRkl+n6kH4eO5Ku1dnV0reIYC6mHG8pdAoV4xi1QHT6gub
        KcyoPI7zIfavY3jhDjYn/B1uj9mn7hNQQ7/YdvN849zdXf9Orq1PALwbWpQ7Zikj
        nRSzHj+mTlNbTOerARaQtnqbnz78VC9ExmeS1jqHhKjBuWQ0sYT5GABwfR0knyx5
        gqyxMVt29IslhkadloOKQM50ugEH0KOzkfkGHAdg3HCvsjErhhc0cuTY7OSxe84A
        ==
X-ME-Sender: <xms:MvMhYclASetQxn0vDAC0iNwo01QYyHRCtcBZCefe8aJ6tDjf7hT-AQ>
    <xme:MvMhYb1Hp03QLm1_G71j-rE3MjzTR9F7Y5sUP9LAR9gHqvYs6i6Q75O2J6w8yS1bA
    DzAkpf371wdq58>
X-ME-Received: <xmr:MvMhYaqxSVp1D9EdPm50Qk8yWSEDd2VlHm_2m0UV_GHAvda6EyqCNRvztk57rHRRwI4k6j_s4GgoSSJY8QKmBEOi2SvVoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtvddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MvMhYYnNmiAYocM30YrGl5AmNc6Zg8aBA5uIAVkh92_6x7qVNaA20A>
    <xmx:MvMhYa1dIns4lwoeUmThVq0VGyAXoE9o0CZrdFhLLc8m1qqWwJ8tYQ>
    <xmx:MvMhYfvsLTDE7TN40ediVn-Iepi4hsUpLSs3wTq7Of56zjp7iRvRog>
    <xmx:NvMhYakFkGpDgMxjcswEJVPrG8oocfVLp3ezPFVnQZleVbmVJqr64w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Aug 2021 02:48:17 -0400 (EDT)
Date:   Sun, 22 Aug 2021 09:48:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
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
Message-ID: <YSHzLKpixhCrrgJ0@shredder>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder>
 <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder>
 <20210820170639.rvzlh4b6agvrkv2w@skbuf>
 <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 02:36:26AM +0300, Nikolay Aleksandrov wrote:
> On 20/08/2021 20:06, Vladimir Oltean wrote:
> > On Fri, Aug 20, 2021 at 07:09:18PM +0300, Ido Schimmel wrote:
> >> On Fri, Aug 20, 2021 at 12:37:23PM +0300, Vladimir Oltean wrote:
> >>> On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
> >>>> On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
> >>>>> Problem statement:
> >>>>>
> >>>>> Any time a driver needs to create a private association between a bridge
> >>>>> upper interface and use that association within its
> >>>>> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
> >>>>> entries deleted by the bridge when the port leaves. The issue is that
> >>>>> all switchdev drivers schedule a work item to have sleepable context,
> >>>>> and that work item can be actually scheduled after the port has left the
> >>>>> bridge, which means the association might have already been broken by
> >>>>> the time the scheduled FDB work item attempts to use it.
> >>>>
> >>>> This is handled in mlxsw by telling the device to flush the FDB entries
> >>>> pointing to the {port, FID} when the VLAN is deleted (synchronously).
> >>>
> >>> Again, central solution vs mlxsw solution.
> >>
> >> Again, a solution is forced on everyone regardless if it benefits them
> >> or not. List is bombarded with version after version until patches are
> >> applied. *EXHAUSTING*.
> > 
> > So if I replace "bombarded" with a more neutral word, isn't that how
> > it's done though? What would you do if you wanted to achieve something
> > but the framework stood in your way? Would you work around it to avoid
> > bombarding the list?
> > 
> >> With these patches, except DSA, everyone gets another queue_work() for
> >> each FDB entry. In some cases, it completely misses the purpose of the
> >> patchset.
> > 
> > I also fail to see the point. Patch 3 will have to make things worse
> > before they get better. It is like that in DSA too, and made more
> > reasonable only in the last patch from the series.
> > 
> > If I saw any middle-ground way, like keeping the notifiers on the atomic
> > chain for unconverted drivers, I would have done it. But what do you do
> > if more than one driver listens for one event, one driver wants it
> > blocking, the other wants it atomic. Do you make the bridge emit it
> > twice? That's even worse than having one useless queue_work() in some
> > drivers.
> > 
> > So if you think I can avoid that please tell me how.
> > 
> 
> Hi,
> I don't like the double-queuing for each fdb for everyone either, it's forcing them
> to rework it asap due to inefficiency even though that shouldn't be necessary. In the
> long run I hope everyone would migrate to such scheme, but perhaps we can do it gradually.

The fundamental problem is that these operations need to be deferred in
the first place. It would have been much better if user space could get
a synchronous feedback.

It all stems from the fact that control plane operations need to be done
under a spin lock because the shared databases (e.g., FDB, MDB) or
states (e.g., STP) that they are updating can also be updated from the
data plane in softIRQ.

I don't have a clean solution to this problem without doing a surgery in
the bridge driver. Deferring updates from the data plane using a work
queue and converting the spin locks to mutexes. This will also allow us
to emit netlink notifications from process context and convert
GFP_ATOMIC to GFP_KERNEL.

Is that something you consider as acceptable? Does anybody have a better
idea?

> For most drivers this is introducing more work (as in processing) rather than helping
> them right now, give them the option to convert to it on their own accord or bite
> the bullet and convert everyone so the change won't affect them, it holds rtnl, it is blocking
> I don't see why not convert everyone to just execute their otherwise queued work.
> I'm sure driver maintainers would appreciate such help and would test and review it. You're
> halfway there already..
> 
> Cheers,
>  Nik
> 
> 
> 
> 
> 
> 
> 
> 
