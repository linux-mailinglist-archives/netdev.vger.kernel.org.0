Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B020101A67
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfKSHjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:39:11 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34213 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbfKSHjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:39:11 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C48E522314;
        Tue, 19 Nov 2019 02:39:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 19 Nov 2019 02:39:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KAYKld
        rTMvXruG869CCJN/LRVyXg5vAUs/vRDSip7Xc=; b=LxBgNXp4Nc0mLaAL+iurJp
        upjEoVhpkzGdxtm92X4Uh391tRR2AG2VENJD0LzRoZ38Rwt7HTMr68kUFVWTDTbN
        cO0Pg5gNiHXFcsZU6RUysOyZe0IEFJyq8ruRXtNp/B74InI8fotM8AoR+RE5OIVk
        VZiD2exsRdO+zj6cvpWevqrzCqj8g1YHepCkb4/bygw+BFty0SeWnKJERGDGsQzd
        0vopGW6jDbOfqrxzW54I4vSwJBCVdyvxzc3W/fzkvH7rYF25UBDwq+PmB3BVSu9w
        Azvkdfebj8g9I7pQsG1x079cZBGHekDjgS9mp0c/VRy+m2qQkaT+0VClO8SA/03w
        ==
X-ME-Sender: <xms:HJzTXWG2txDNmtlMzj5r0eOWtGD65vdfpLQRGG9UZ-4ffZl7K7rBFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudegjedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrg
    hinhepnhigphdrtghomhenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptd
X-ME-Proxy: <xmx:HJzTXV0LBkt91R_m3DHX9dAtj8wcBiu47wPqK1WC2oi42oat1pqFJw>
    <xmx:HJzTXW-AgPXt_80wpDGv5rE2ymBZiCtKpgtgrmmDDF6TyFMjjeU9bw>
    <xmx:HJzTXQG11HQLwxWM4BGqFNarbmiusv1Lxbpx37GlARtVikWGcalOsQ>
    <xmx:HZzTXVcfV16wUaXJXVAzPZ56pIZtUt7iDdbIpXLj8h_9XDV4T_gsTw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 555C280060;
        Tue, 19 Nov 2019 02:39:08 -0500 (EST)
Date:   Tue, 19 Nov 2019 09:39:06 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, jiri@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: Make HOSTPRIO a devlink
 param
Message-ID: <20191119073906.GA27697@splinter>
References: <20191116172325.13310-1-olteanv@gmail.com>
 <20191118083624.GA2149@splinter>
 <CA+h21hrDoTjSvqfpCJRgrzJJ0P1nwfFdxK533dTGSi4y7_-BNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrDoTjSvqfpCJRgrzJJ0P1nwfFdxK533dTGSi4y7_-BNA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 12:51:01PM +0200, Vladimir Oltean wrote:
> Hi Ido,
> 
> On Mon, 18 Nov 2019 at 10:36, Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Sat, Nov 16, 2019 at 07:23:25PM +0200, Vladimir Oltean wrote:
> > > Unfortunately with this hardware, there is no way to transmit in-band
> > > QoS hints with management frames (i.e. VLAN PCP is ignored). The traffic
> > > class for these is fixed in the static config (which in turn requires a
> > > reset to change).
> > >
> > > With the new ability to add time gates for individual traffic classes,
> > > there is a real danger that the user might unknowingly turn off the
> > > traffic class for PTP, BPDUs, LLDP etc.
> > >
> > > So we need to manage this situation the best we can. There isn't any
> > > knob in Linux for this, so create a driver-specific devlink param which
> > > is a runtime u8. The default value is 7 (the highest priority traffic
> > > class).
> > >
> > > Patch is largely inspired by the mv88e6xxx ATU_hash devlink param
> > > implementation.
> > >
> > > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > > ---
> > > Changes in v2:
> > > Turned the NET_DSA_SJA1105_HOSTPRIO kernel config into a "hostprio"
> > > runtime devlink param.
> > >
> > >  .../networking/devlink-params-sja1105.txt     |  9 ++
> > >  Documentation/networking/dsa/sja1105.rst      | 19 +++-
> > >  MAINTAINERS                                   |  1 +
> > >  drivers/net/dsa/sja1105/sja1105.h             |  1 +
> > >  drivers/net/dsa/sja1105/sja1105_main.c        | 94 +++++++++++++++++++
> > >  5 files changed, 122 insertions(+), 2 deletions(-)
> > >  create mode 100644 Documentation/networking/devlink-params-sja1105.txt
> > >
> > > diff --git a/Documentation/networking/devlink-params-sja1105.txt b/Documentation/networking/devlink-params-sja1105.txt
> > > new file mode 100644
> > > index 000000000000..5096a4cf923c
> > > --- /dev/null
> > > +++ b/Documentation/networking/devlink-params-sja1105.txt
> > > @@ -0,0 +1,9 @@
> > > +hostprio             [DEVICE, DRIVER-SPECIFIC]
> > > +                     Configure the traffic class which will be used for
> > > +                     management (link-local) traffic injected and trapped
> > > +                     to/from the CPU. This includes STP, PTP, LLDP etc, as
> > > +                     well as hardware-specific meta frames with RX
> > > +                     timestamps.  Higher is better as long as you care about
> > > +                     your PTP frames.
> >
> > Vladimir,
> >
> > I have some concerns about this. Firstly, I'm not sure why you need to
> > expose this and who do you expect to be able to configure this? I'm
> > asking because once you expose it to users there might not be a way
> > back. mlxsw is upstream for over four years and the traffic classes for
> > the different packet types towards the CPU are hard coded in the driver
> > and based on "sane" defaults. It is therefore surprising to me that you
> > already see the need to expose this.
> >
> 
> WIth tc-taprio, it is up to the user / system administrator which of
> the 8 traffic classes has access to the Ethernet media and when (if
> ever).
> For example, take this command:
> 
> sudo tc qdisc replace dev swp3 parent root handle 100 taprio \
>         num_tc 8 \
>         map 0 1 2 3 4 5 6 7 \
>         queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
>         base-time $base_time \
>         sched-entry S 03 300000 \
>         sched-entry S 02 300000 \
>         sched-entry S 06 400000 \
>         flags 2
> 
> It will allow access to traffic classes 0 and 1 (S 03) for 300000 ns,
> traffic class 1 (S 02) for another 300000 ns, and to traffic classes 1
> and 2 (S 06) for 400000 ns, then repeat the schedule. This is just an
> example.
> But the base-time is a PTP time, so the switch needs a PTP daemon to
> keep track of time. But notice that the traffic class for PTP traffic
> (which is hardcoded as 7 in the driver) is not present in the
> tc-taprio schedule, so effectively PTP will be denied access to the
> media, so it won't work, so it will completely break the schedule. The
> user will be horribly confused by this.

OK, but I don't see how adding a new knob helps to avoid the confusion?
Maybe add an extack here saying that HOSTPRIO traffic class has no
access to the media. Alternatively, you can veto such configurations if
it's acceptable (in which case you don't need the parameter).

> I also don't want to keep the PTP traffic class hardcoded at 7, since
> the system administrator might have other cyclic traffic schedules
> that are more time-sensitive than PTP itself.
> 
> > Secondly, I find the name confusing. You call it "hostprio", but the
> > description says "traffic class". These are two different things.
> > Priority is a packet attribute based on which you can classify the
> > packet to a transmission queue (traffic class). And if you have multiple
> > transmission queues towards the CPU, how do you configure their
> > scheduling and AQM? This relates to my next point.
> >
> 
> HOSTPRIO is the way it is called in the hardware user guide:
> https://www.nxp.com/docs/en/user-guide/UM10944.pdf
> I don't see why I should call it something else, especially since it
> does not map over any other concept.

It would be good to add the explanation you provided in this response
to the documentation. It is not clear where the name comes from
otherwise.

> And since it is DSA, the Ethernet link between the CPU port and the
> DSA master is inherently single queue, even though the switch is
> multi-queue and the DSA master is multi-queue. Both the DSA master and
> the front-panel switch can have independent qdiscs that operate
> independently. It is a separate discussion.
> 
> > Thirdly, the fact that "there isn't any knob in Linux for this" does not
> > mean that we should not create a proper one. As I see it, the CPU port
> > (switch side, not DSA master) is a port like any other and therefore
> > should have a netdev. With a netdev you can properly configure its
> > different QoS attributes using tc instead of introducing driver-specific
> > devlink-params.
> >
> 
> Right, but let me summarize the hardware operation to understand what
> this is really doing.
> The switch has 2 MAC filters for link-local management traffic. I
> hardcoded them in the driver to 01-80-C2-xx-xx-xx and
> 01-1B-19-xx-xx-xx so that STP and PTP work by default. The switch
> checks the DMAC of frames against these masks very early in the packet
> processing pipeline, and if they match, they are trapped to the CPU.
> In fact, the match is so early that the analyzer module is bypassed
> and the frames do not get classified to a TC based on any QoS
> classification rules. The hardware designers recognized that this
> might be a problem, so they just invented a knob called HOSTPRIO,
> which all frames that are trapped to the CPU get assigned.
> On xmit, the MAC filters are active on the CPU port as well. So the
> switch wants to trap the link-local frames coming from the CPU and
> redirect them to the CPU, which it won't do because it's configured to
> avoid hairpinning. So it drops those frames when they come from the
> CPU port, due to lack of valid destinations. So the hardware designers
> invented another concept called "management routes" which are meant to
> bypass the MAC filters (which themselves bypass L2 forwarding). You
> pre-program a one-shot "management route" in the switch for a frame
> matching a certain DMAC, then you send it, then the switch figures out
> it matches this "management route" and properly sends it out the
> correct front-panel port. The point is that on xmit, the switch uses
> HOSTPRIO for the "management route" frames as well.

Very weird model :( I understand your need for this knob now, but I
suggest to add an extack in qdisc offload to make it clear to users that
they are potentially shooting themselves in the foot.
