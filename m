Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4B8370D83
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 17:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhEBO7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 10:59:41 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:48031 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBO7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 10:59:40 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 06A5D580789;
        Sun,  2 May 2021 10:58:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 02 May 2021 10:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VQZqUm
        PAipEQ3F6paRnDKa1ranMI53JGXUptVU2DPVM=; b=QS3+4HRSYVmnrgO0R8KBAU
        ZPpdkELhL5kMONYMdXovC0OsD/FeS5Dxj5WZF1Ah4AD4SFpPlje8Gy9IEcg/sM27
        JrzXtc1KtNS5OabNtx/57XS6fDod5b4ZBcUYIzrm80zURBtYN4EL+PZuL0u/WEBR
        ioozKWwh+QAAxn04lS8OwD0VLWIFWeRt/V/23cfwajGP+8TDZ7isrpavmvHsjuVR
        idyLMJUHuSsNk6MSSlmVuVSgwB2WbK0kN2ouEaCUIUw3biZwRRBRDlp6vgpA8pbq
        oJ12jTXgEdwRm+7sHZltiaINri+xFnIn5/it2A2yk6agH8UEj2xdNNauvwiK8iqw
        ==
X-ME-Sender: <xms:KL6OYL5TuX8se5qCwQng6wa1zNVn3MWgL59snorr7sdUUSsuZ7xPUw>
    <xme:KL6OYA54QyIxdv5Is1NWOrgt40aItk9car8rYE-kPDO9lHPaaSmIFgiIAYSkzqTjA
    VUQ9OsbcNZJqT8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefuddgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:KL6OYCcK3_ySb6g3jNGdRs7i3rl-IwTNsqAQDF63zR3Sfu0H9uGIEw>
    <xmx:KL6OYMLI7YCoxoNMruCZ5Ii1POlVZW3OspynDBQxDnSrn2SyPwfjLw>
    <xmx:KL6OYPKKuBIyDH2iNHNS9EkFnVuT-ssp_6WQbNk3oIwdGKLsL588hA>
    <xmx:Kb6OYAWe7mzKf1voDa-xb5_FlNXgzNjN5lZICAYppsKFkcDxfB7s1A>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 10:58:47 -0400 (EDT)
Date:   Sun, 2 May 2021 17:58:45 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        roopa@nvidia.com, nikolay@nvidia.com, jiri@resnulli.us,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 0/9] net: bridge: Forward offloading
Message-ID: <YI6+JXDG/4K30G5L@shredder>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426170411.1789186-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 07:04:02PM +0200, Tobias Waldekranz wrote:
> ## Overview
> 
>    vlan1   vlan2
>        \   /
>    .-----------.
>    |    br0    |
>    '-----------'
>    /   /   \   \
> swp0 swp1 swp2 eth0
>   :   :   :
>   (hwdom 1)
> 
> Up to this point, switchdevs have been trusted with offloading
> forwarding between bridge ports, e.g. forwarding a unicast from swp0
> to swp1 or flooding a broadcast from swp2 to swp1 and swp0. This
> series extends forward offloading to include some new classes of
> traffic:
> 
> - Locally originating flows, i.e. packets that ingress on br0 that are
>   to be forwarded to one or several of the ports swp{0,1,2}. Notably
>   this also includes routed flows, e.g. a packet ingressing swp0 on
>   VLAN 1 which is then routed over to VLAN 2 by the CPU and then
>   forwarded to swp1 is "locally originating" from br0's point of view.
> 
> - Flows originating from "foreign" interfaces, i.e. an interface that
>   is not offloaded by a particular switchdev instance. This includes
>   ports belonging to other switchdev instances. A typical example
>   would be flows from eth0 towards swp{0,1,2}.
> 
> The bridge still looks up its FDB/MDB as usual and then notifies the
> switchdev driver that a particular skb should be offloaded if it
> matches one of the classes above. It does so by using the _accel
> version of dev_queue_xmit, supplying its own netdev as the
> "subordinate" device. The driver can react to the presence of the
> subordinate in its .ndo_select_queue in what ever way it needs to make
> sure to forward the skb in much the same way that it would for packets
> ingressing on regular ports.
> 
> Hardware domains to which a particular skb has been forwarded are
> recorded so that duplicates are avoided.
> 
> The main performance benefit is thus seen on multicast flows. Imagine
> for example that:
> 
> - An IP camera is connected to swp0 (VLAN 1)
> 
> - The CPU is acting as a multicast router, routing the group from VLAN
>   1 to VLAN 2.
> 
> - There are subscribers for the group in question behind both swp1 and
>   swp2 (VLAN 2).

IIUC, this falls under the first use case ("Locally originating flows").
Do you have a need for this optimization in the forwarding case? Asking
because it might allow us to avoid unnecessary modifications to the
forwarding path. I have yet to look at the code, so maybe it's not a big
deal.

> 
> With this offloading in place, the bridge need only send a single skb
> to the driver, which will send it to the hardware marked in such a way
> that the switch will perform the multicast replication according to
> the MDB configuration. Naturally, the number of saved skb_clones
> increase linearly with the number of subscribed ports.

Yes, this is clear. FWIW, Spectrum has something similar. You can send
packets as either "data" or "control". Data packets are injected via the
CPU port and forwarded according to the hardware database. Control
packets are sent as-is via the specified front panel port, bypassing the
hardware data path. mlxsw is always sending packets as "control".

> 
> As an extra benefit, on mv88e6xxx, this also allows the switch to
> perform source address learning on these flows, which avoids having to
> sync dynamic FDB entries over slow configuration interfaces like MDIO
> to avoid flows directed towards the CPU being flooded as unknown
> unicast by the switch.

Since you are not syncing FDBs, it is possible that you are needlessly
flooding locally generated packets. This optimization avoids it.

> 
> 
> ## RFC
> 
> - In general, what do you think about this idea?

Looks sane to me

> 
> - hwdom. What do you think about this terminology? Personally I feel
>   that we had too many things called offload_fwd_mark, and that as the
>   use of the bridge internal ID (nbp->offload_fwd_mark) expands, it
>   might be useful to have a separate term for it.

Sounds OK

> 
> - .dfwd_{add,del}_station. Am I stretching this abstraction too far,
>   and if so do you have any suggestion/preference on how to signal the
>   offloading from the bridge down to the switchdev driver?

I was not aware of this interface before the RFC, but your use case
seems to fit the kdoc: "Called by upper layer devices to accelerate
switching or other station functionality into hardware".

Do you expect this optimization to only work when physical netdevs are
enslaved to the bridge? What about LAG/VLANs?

> 
> - The way that flooding is implemented in br_forward.c (lazily cloning
>   skbs) means that you have to mark the forwarding as completed very
>   early (right after should_deliver in maybe_deliver) in order to
>   avoid duplicates. Is there some way to move this decision point to a
>   later stage that I am missing?
> 
> - BR_MULTICAST_TO_UNICAST. Right now, I expect that this series is not
>   compatible with unicast-to-multicast being used on a port. Then
>   again, I think that this would also be broken for regular switchdev
>   bridge offloading as this flag is not offloaded to the switchdev
>   port, so there is no way for the driver to refuse it. Any ideas on
>   how to handle this?
> 
> 
> ## mv88e6xxx Specifics
> 
> Since we are now only receiving a single skb for both unicast and
> multicast flows, we can tag the packets with the FORWARD command
> instead of FROM_CPU. The swich(es) will then forward the packet in
> accordance with its ATU, VTU, STU, and PVT configuration - just like
> for packets ingressing on user ports.
> 
> Crucially, FROM_CPU is still used for:
> 
> - Ports in standalone mode.
> 
> - Flows that are trapped to the CPU and software-forwarded by a
>   bridge. Note that these flows match neither of the classes discussed
>   in the overview.
> 
> - Packets that are sent directly to a port netdev without going
>   through the bridge, e.g. lldpd sending out PDU via an AF_PACKET
>   socket.
> 
> We thus have a pretty clean separation where the data plane uses
> FORWARDs and the control plane uses TO_/FROM_CPU.
> 
> The barrier between different bridges is enforced by port based VLANs
> on mv88e6xxx, which in essence is a mapping from a source device/port
> pair to an allowed set of egress ports. In order to have a FORWARD
> frame (which carries a _source_ device/port) correctly mapped by the
> PVT, we must use a unique pair for each bridge.
> 
> Fortunately, there is typically lots of unused address space in most
> switch trees. When was the last time you saw an mv88e6xxx product
> using more than 4 chips? Even if you found one with 16 (!) devices,
> you would still have room to allocate 16*16 virtual ports to software
> bridges.
> 
> Therefore, the mv88e6xxx driver will allocate a virtual device/port
> pair to each bridge that it offloads. All members of the same bridge
> are then configured to allow packets from this virtual port in their
> PVTs.
> 
> Tobias Waldekranz (9):
>   net: dfwd: Constrain existing users to macvlan subordinates
>   net: bridge: Disambiguate offload_fwd_mark
>   net: bridge: switchdev: Recycle unused hwdoms
>   net: bridge: switchdev: Forward offloading
>   net: dsa: Track port PVIDs
>   net: dsa: Forward offloading
>   net: dsa: mv88e6xxx: Allocate a virtual DSA port for each bridge
>   net: dsa: mv88e6xxx: Map virtual bridge port in PVT
>   net: dsa: mv88e6xxx: Forward offloading
> 
>  MAINTAINERS                                   |   1 +
>  drivers/net/dsa/mv88e6xxx/Makefile            |   1 +
>  drivers/net/dsa/mv88e6xxx/chip.c              |  61 ++++++-
>  drivers/net/dsa/mv88e6xxx/dst.c               | 160 ++++++++++++++++++
>  drivers/net/dsa/mv88e6xxx/dst.h               |  14 ++
>  .../net/ethernet/intel/fm10k/fm10k_netdev.c   |   3 +
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   3 +
>  include/linux/dsa/mv88e6xxx.h                 |  13 ++
>  include/net/dsa.h                             |  13 ++
>  net/bridge/br_forward.c                       |  11 +-
>  net/bridge/br_if.c                            |   4 +-
>  net/bridge/br_private.h                       |  54 +++++-
>  net/bridge/br_switchdev.c                     | 141 +++++++++++----
>  net/dsa/port.c                                |  16 +-
>  net/dsa/slave.c                               |  36 +++-
>  net/dsa/tag_dsa.c                             |  33 +++-
>  17 files changed, 510 insertions(+), 57 deletions(-)
>  create mode 100644 drivers/net/dsa/mv88e6xxx/dst.c
>  create mode 100644 drivers/net/dsa/mv88e6xxx/dst.h
>  create mode 100644 include/linux/dsa/mv88e6xxx.h
> 
> -- 
> 2.25.1
> 
