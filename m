Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF6D22BB16
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgGXAna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgGXAna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 20:43:30 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82017C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 17:43:29 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id lx13so8263261ejb.4
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 17:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tM3taAGvodCjwfKZIxhST1gHAcFskP8Hor4OS74ErIs=;
        b=HGRAWi9OWolc0K+CCSYKZNmzGurBrrv4bvYu/Qhabtp9pZZQtZvwUwOwfObIynBuQ1
         D6nYqqw0H9R/LpMrwhDtLHaqdAeRxX8SCw6yy8ZNaKxkZf64Eisiitur3NC6YRsVg7Ew
         fqHdd+92ARrIpoYIHnlJ0LYoOuxP8X7CeBrMhJIz9+siVKV4j46Z/m8WpkE7ExL08y9/
         /W3n3QHa4S6PPI+BAhYhmRvYBg7NfBdvh0Oo1XALuc7DtrApXQxZwN6jP4RBpXd5UazW
         LTIKAhUPX0GXzNO03WJNlc2B36nfqvjsdu7RdSC5qxLi/ChcGkYLDC0lpzNBkkLXvKkg
         pBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tM3taAGvodCjwfKZIxhST1gHAcFskP8Hor4OS74ErIs=;
        b=RaW/1ezdZCxbj7avGSRI198zSZcMfvm9J4Jsebu+SlpDBRoPwVi2rM/sgnHbmG9Nyt
         BJk4eiEr8etfDpf8Jm6n/oWThF1nChNo64/MB6QhWnjGixGmKsbdXJl4i9OL+EdddNh7
         u5qN54XpSHoQJX+u1g9W/HU27QAoVFNZhYBRe3UmiUFWprNU98/CmapPQ2RIjJ/8kyGE
         Cquz+R1P+2TIvV9FjF896r3k1PvZuhWivYj7P4CU8clmANo/G1hPVyN2IWLqP/WIehuF
         alVjgSXxNoxNTu0SiZPkSbU15B4aQfpeW/4iDUrUcswCiB8LrCuNIdLO/wYcf7o1bTkQ
         xv7g==
X-Gm-Message-State: AOAM530gmItnIDCHUs4+0/2ubIck05gaHzlCn8gfH9GgiCbM8R0gjGFT
        V3YBS0wMIF9cbeDrgn3RV+I=
X-Google-Smtp-Source: ABdhPJyv4E+Dp27n1vMEXbyjrgrCBzpcSUmyiRx2V1IqLkHYU17TNYjTFJzMoLYmzXyxiuxjOM+WZA==
X-Received: by 2002:a17:906:3842:: with SMTP id w2mr7023529ejc.273.1595551407589;
        Thu, 23 Jul 2020 17:43:27 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x16sm3079974edr.52.2020.07.23.17.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 17:43:26 -0700 (PDT)
Date:   Fri, 24 Jul 2020 03:43:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        vivien.didelot@gmail.com, cphealy@gmail.com, idosch@mellanox.com,
        jiri@mellanox.com, bridge@lists.linux-foundation.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        rdunlap@infradead.org, ilias.apalodimas@linaro.org,
        ivan.khoronzhuk@linaro.org, kuba@kernel.org
Subject: Re: [PATCH net-next] Documentation: networking: Clarify switchdev
 devices behavior
Message-ID: <20200724004324.yfcwlysger2vo7y5@skbuf>
References: <20200722225253.28848-1-f.fainelli@gmail.com>
 <20200723221151.qdt4yowfktuddrkd@skbuf>
 <d8ce0a04-3d3a-5d11-d3e6-861e6cbcca24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8ce0a04-3d3a-5d11-d3e6-861e6cbcca24@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:58:24PM -0700, Florian Fainelli wrote:
> On 7/23/20 3:11 PM, Vladimir Oltean wrote:
> > On Wed, Jul 22, 2020 at 03:52:53PM -0700, Florian Fainelli wrote:
> >> This patch provides details on the expected behavior of switchdev
> >> enabled network devices when operating in a "stand alone" mode, as well
> >> as when being bridge members. This clarifies a number of things that
> >> recently came up during a bug fixing session on the b53 DSA switch
> >> driver.
> >>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> ---
> >> Since this has been submitted in a while, removing the patch numbering,
> >> but previous patches and discussions can be found here:
> >>
> >> http://patchwork.ozlabs.org/project/netdev/patch/20190103224702.21541-1-f.fainelli@gmail.com/
> >> http://patchwork.ozlabs.org/project/netdev/patch/20190109043930.8534-1-f.fainelli@gmail.com/
> >> http://patchwork.ozlabs.org/project/netdev/patch/20190110193206.9872-1-f.fainelli@gmail.com/
> >>
> >> David, I would like to hear from Vladimir and Ido specifically to make
> >> sure that the documentation is up to date with expectations or desired
> >> behavior so we can move forward with Vladimir's DSA rx filtering patch
> >> series. So don't apply this just yet ;)
> >>
> >> Thanks!
> >>
> > 
> > Thanks for giving me the opportunity to speak up.
> > 
> > Your addition to switchdev.rst is more than welcome, and the content is
> > good. I had opened this file a few days ago searching for a few words on
> > address filtering, but alas, there were none. And even now, with your
> > addition - there is something, but it's more focused on multicast, and I
> > haven't used that nearly enough to have a strong opinion about it. Let
> > me try to add my 2 cents about what concerns me on this particular topic.
> > 
> > I'm not asking you to add it to your documentation patch - not that you
> > could even do that, as I'm talking more about how things should be than
> > how they are, things like IVDF aren't even in mainline.
> > 
> > If people agree at least in principle with my words below, I can make
> > the necessary changes to the bridge driver to conform to this
> > interpretation of things.
> > 
> > 
> > Address filtering
> > ^^^^^^^^^^^^^^^^^
> > 
> > With regular network interface cards, address filters are used to drop
> > in hardware the frames that have a destination address different than
> > what the card is configured to perform termination on.
> > 
> > With switchdev, the hardware is usually geared towards accepting traffic
> > regardless of destination MAC address, because the primary objective is
> > forwarding to another host based on that address, and not termination.
> > 
> > Therefore, the address filters of a switchdev interface cannot typically
> > be implemented at the same hardware layer as they are for a regular
> > interface. The behavior as seen by the operating system should, however,
> > be the same.
> > 
> > In the case of a regular NIC, the expectation is that only the frames
> > having a destination that is present in the RX filtering lists (managed
> > through dev_uc_add() and dev_mc_add()) are accepted, while the others
> > are dropped. The filters can be bypassed using the IFF_PROMISC and
> > IFF_ALLMULTI flags.
> > 
> > A switchdev interface that is capable of offloading the Linux bridge
> > should have hardware provisioning for flooding unknown destination
> > addresses and learning from source addresses. Strictly speaking, the
> > hardware design of such an interface should be promiscuous out of
> > necessity: as long as flooding is enabled, hardware promiscuity is
> > implied.
> > 
> > However, this is of no relevance to the operating system. Since flooding
> > and forwarding happen autonomously, it makes no difference to the end
> > result whether the forwarded and flooded addresses are, or aren't,
> > present in the address list of the network interface corresponding to
> > the switchdev port.
> > 
> > To achieve a similar behavior between switchdev and non-switchdev
> > interfaces, address filtering for switchdev can be defined in terms of
> > the frames that the CPU sees.
> 
> Nit here, I don't know if we want to refer to CPU, host or management
> interface of the switch, all terms are IMHO inter changeable and clear
> in the context below, though I wonder what "pure" switchdev drivers
> would prefer to see being used.
> 

I really meant 'CPU' and not 'CPU port'. As in, 'the thing on which
Linux runs'. I can change to 'operating system' if that is clearer.

> > 
> > - Primary MAC address: A driver should deliver to the CPU, and only to
> >   the CPU, for termination purposes, frames having a destination address
> >   that matches the MAC address of the ingress interface.
> 
> Ack. We could go one step further and say that this is the MAC address
> of the Ethernet MAC connected to the CPU port. As we say in French this
> would be busting through an open door.
> 

We should.
This stuff may be basic, but I want it to be very clear.

> > 
> > - Secondary MAC addresses: A driver should deliver to the CPU frames
> >   having a destination address that matches an entry added with
> >   dev_uc_add() or dev_mc_add(). These typically correspond to upper
> >   interfaces configured on top of the switchdev interface, such as
> >   8021q, bridge, macvlan.
> 
> Ack.
> 
> > 
> > - A driver is allowed to not deliver to the CPU frames that don't have a
> >   match in the ingress interface's primary and secondary address lists.
> >   An exception to this rule is when the interface is configured as
> >   promiscuous, or to receive all multicast traffic.
> 
> Ack.
> 
> > 
> > - An interface can be configured as promiscuous when it is required that
> >   the CPU sees frames with an unknown destination (same as in the
> >   non-switchdev case). Otherwise said, promiscuous mode manages the
> >   presence (or the absence) of the CPU in the flooding domain of the
> >   switch. A similar comment applies to IFF_ALLMULTI, although that case
> >   applies only to unknown multicast traffic.
> 
> Ack.
> 
> > 
> > - Other layers of the network stack that actively make use of switchdev
> >   offloads should not request promiscuous mode for the sole purpose of
> >   accepting ingress frames that will end up reinjected in the hardware
> >   data path anyway. The switchdev framework can be considered to offload
> >   the need of promiscuity for this purpose. An example of valid use of
> >   promiscuous mode for a switchdev driver is when it is bridged with a
> >   non-switchdev interface, and the CPU needs to perform termination
> >   (from the hardware's perspective) of unknown-destination traffic, in
> >   order to forward it in software to the other network interfaces.
> 
> Ack.
> 
> > 
> > - If the hardware supports filtering MAC addresses per VLAN domain, then
> >   CPU membership of a VLAN could be managed through IVDF (Individual
> >   Virtual Device Filtering). Namely, the CPU should join the VLAN of all
> >   IVDF addresses in its filter list, and can exit all VLANs that are not
> >   there.
> 
> Ack. A complication can exist if VLAN filtering applies globally to the
> switch and the CPU interface is put in promiscuous mode. We would then
> expect the CPU interface to join all VLANs for the sake of receiving all
> frames.
> 

Yes, if a network interface is part of a switch that has other ports in
a VLAN-aware bridge, then this interface should join all 4096 VLANs when
put in IFF_PROMISC mode, to deactivate the VLAN filtering the hard way,
while also preserving VLAN information in frames sent to the CPU. Note
that there is a risk for untagged frames and pvid-tagged frames to be
indistinguishable from one another if you do that. This is where
installing a reserved VLAN as pvid, such as 4095 as pvid, which cannot
be sent on the network, can come in handy.

> > 
> >>  Documentation/networking/switchdev.rst | 118 +++++++++++++++++++++++++
> >>  1 file changed, 118 insertions(+)
> >>
> >> diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
> >> index ddc3f35775dc..2e4f50e6c63c 100644
> >> --- a/Documentation/networking/switchdev.rst
> >> +++ b/Documentation/networking/switchdev.rst
> >> @@ -385,3 +385,121 @@ The driver can monitor for updates to arp_tbl using the netevent notifier
> >>  NETEVENT_NEIGH_UPDATE.  The device can be programmed with resolved nexthops
> >>  for the routes as arp_tbl updates.  The driver implements ndo_neigh_destroy
> >>  to know when arp_tbl neighbor entries are purged from the port.
> >> +
> >> +Device driver expected behavior
> >> +-------------------------------
> >> +
> >> +Below is a set of defined behavior that switchdev enabled network devices must
> >> +adhere to.
> >> +
> >> +Configuration less state
> >> +^^^^^^^^^^^^^^^^^^^^^^^^
> >> +
> >> +Upon driver bring up, the network devices must be fully operational, and the
> >> +backing driver must configure the network device such that it is possible to
> >> +send and receive traffic to this network device and it is properly separated
> >> +from other network devices/ports (e.g.: as is frequent with a switch ASIC). How
> >> +this is achieved is heavily hardware dependent, but a simple solution can be to
> >> +use per-port VLAN identifiers unless a better mechanism is available
> >> +(proprietary metadata for each network port for instance).
> >> +
> >> +The network device must be capable of running a full IP protocol stack
> >> +including multicast, DHCP, IPv4/6, etc. If necessary, it should program the
> >> +appropriate filters for VLAN, multicast, unicast etc. The underlying device
> >> +driver must effectively be configured in a similar fashion to what it would do
> >> +when IGMP snooping is enabled for IP multicast over these switchdev network
> >> +devices and unsolicited multicast must be filtered as early as possible into
> >> +the hardware.
> >> +
> >> +When configuring VLANs on top of the network device, all VLANs must be working,
> >> +irrespective of the state of other network devices (e.g.: other ports being part
> >> +of a VLAN aware bridge doing ingress VID checking). See below for details.
> >> +
> >> +If the device implements e.g.: VLAN filtering, putting the interface in
> >> +promiscuous mode should allow the reception of all VLAN tags (including those
> >> +not present in the filter(s)).
> >> +
> >> +Bridged switch ports
> >> +^^^^^^^^^^^^^^^^^^^^
> >> +
> >> +When a switchdev enabled network device is added as a bridge member, it should
> >> +not disrupt any functionality of non-bridged network devices and they
> >> +should continue to behave as normal network devices. Depending on the bridge
> >> +configuration knobs below, the expected behavior is documented.
> >> +
> >> +Bridge VLAN filtering
> >> +^^^^^^^^^^^^^^^^^^^^^
> >> +
> >> +The Linux bridge allows the configuration of a VLAN filtering mode (compile and
> >> +run time) which must be observed by the underlying switchdev network
> > 
> > s/compile and run time/statically, at interface creation time, and dynamically/
> 
> Thanks.
> 
> > 
> >> +device/hardware:
> >> +
> >> +- with VLAN filtering turned off: the bridge is strictly VLAN unaware and its
> >> +  data path will only process untagged Ethernet frames. Frames ingressing the
> >> +  device with a VID that is not programmed into the bridge/switch's VLAN table
> >> +  must be forwarded and may be processed using a VLAN device (see below).
> >> +
> >> +- with VLAN filtering turned on: the bridge is VLAN aware and frames ingressing
> >> +  the device with a VID that is not programmed into the bridges/switch's VLAN
> >> +  table must be dropped (strict VID checking).
> >> +
> >> +Non-bridged network ports of the same switch fabric must not be disturbed in any
> >> +way by the enabling of VLAN filtering on the bridge device(s).
> >> +
> >> +VLAN devices configured on top of a switchdev network device (e.g: sw0p1.100)
> >> +which is a bridge port member must also observe the following behavior:
> >> +
> >> +- with VLAN filtering turned off, enslaving VLAN devices into the bridge might
> >> +  be allowed provided that there is sufficient separation using e.g.: a
> >> +  reserved VLAN ID (4095 for instance) for untagged traffic. The VLAN data path
> >> +  is used to pop/push the VLAN tag such that the bridge's data path only
> >> +  processes untagged traffic.
> >> +
> > 
> > Why does the bridge's data path only process untagged traffic?
> > It should process frames that are untagged or have a VLAN ID which does
> > not match the VLAN ID of any 8021q upper of the ingress interface.
> > Which brings me to the question: how is a VLAN frame having an unknown
> > (to 8021q) VLAN ID going to be treated by such a switchdev interface? It
> > should accept it. Will it? Well, I don't really understand the advice
> > given here, about the separation, and how does the pvid of 4095 help
> > with frames that are already VLAN-tagged.
> 
> I was trying to capture a discussion Ido and I had on IRC a while ago.
> He clarified that the VLAN-unaware bridge should only see untagged
> traffic within its data path. To answer your question, a VLAN frame with
> an unknown VID may be accepted by the switch hardware, but should not be
> delivered to the bridge data path because there is no software VLAN to
> process that VID.
> 

In my understanding it is the exact opposite: a VLAN frame is delivered
to the bridge data path _only_if_ there is no software VLAN to consume
it. At least, this is what is happening with software-only interfaces.

> The advice regarding separation is about the following use case: we have
> two physical switch ports sw0p0 and sw0p1. sw0p1.100 is created to
> terminate VID 100 tagged, and sw0p1.100 is created to terminate VID 100
> tagged as well.
> 
> sw0p0 is added to a bridge, and so is sw0p1.100, it seems to me that
> sw0p0.100 and sw0p1.100 should still be separate because they are not
> part of the same broadcast domain. One port (sw0p0) is part of the
> bridge, whereas the other (sw0p1) is not. Without a FID or internal
> double tagging, I am not sure how you can maintain that separation.
> 
> Maybe this is not worth mentioning, or maybe I am wrong, having some
> feedback would be welcome here.
> 

No, I think it's definitely worth mentioning, corner cases are always
the trickiest.

If we interpret an 8021q upper as "deliver this VLAN only to the CPU,
extract it from the hardware data path", then we're ok, given that we
can satisfy that request. Both sw0p0.100 and sw0p1.100 are delivered to
the CPU, where they are isolated enough that they are not going to be
software-bridged. That is, _if_ sw0p0.100 exists. In this model, We
might end up having to create it, just in order to maintain the
isolation.

By the way, I think that with the current model, offloading more fluid
setups like this sw0p0 <-> sw0p1.100 scenario is going to be a little
tricky. Maybe it would be wiser to simply bridge sw0p0 and sw1p1, and
add a 'matchall action vlan push' to the egress qdisc of sw1p1 and a
'flower protocol 802.1Q vlan_id 100 action vlan pop' to its ingress
qdisc. This lends itself a lot better to offloading.

> > 
> >> +- with VLAN filtering turned on, these VLAN devices can be created as long as
> >> +  there is not an existing VLAN entry into the bridge with an identical VID and
> >> +  port membership. These VLAN devices cannot be enslaved into the bridge since
> >> +  because they duplicate functionality/use case with the bridge's VLAN data path
> >> +  processing.
> >> +
> > 
> > The way I visualize things for myself, it's not so much that the bridge
> > and 8021q modules are duplicating functionality, but rather that the
> > requirements are contradictory. 'bridge vlan add ...' wants to configure
> > the forwarding data path, while 'ip link add link ... type vlan' wants
> > to steal frames from the data path and deliver them to the CPU.
> 
> Yes, that is a good way to look at it. With a VLAN aware bridge you can
> terminate VLAN traffic at the bridge level too, if your bridge master is
> also part of the VLAN group, which is why I felt that explaining that
> would be necessary.
> 

Correct. I wasn't thinking of the 'bridge fdb add dev br0
00:01:02:03:04:05 self master' and 'bridge vlan add dev swp0 vid 101
master' cases, but this is a good point. These addresses should be sent
upstream, towards the CPU. And a VLAN that is added 'in bulk' without a
specific IVDF address, such as one added through 'bridge vlan ..
master', should also contribute to the flood mask of the CPU.

> > 
> >> +Because VLAN filtering can be turned on/off at runtime, the switchdev driver
> >> +must be able to re-configure the underlying hardware on the fly to honor the
> >> +toggling of that option and behave appropriately.
> >> +
> >> +A switchdev driver can also refuse to support dynamic toggling of the VLAN
> >> +filtering knob at runtime and require a destruction of the bridge device(s) and
> >> +creation of new bridge device(s) with a different VLAN filtering value to
> >> +ensure VLAN awareness is pushed down to the HW.
> >> +
> >> +Finally, even when VLAN filtering in the bridge is turned off, the underlying
> >> +switch hardware and driver may still configured itself in a VLAN aware mode
> >> +provided that the behavior described above is observed.
> >> +
> > 
> > Otherwise stated: VLAN filtering shall be considered from the
> > perspective of observable behavior, and not from the perspective of
> > hardware configuration.
> 
> Yes, that is clearer.
> 
> > 
> >> +Bridge IGMP snooping
> >> +^^^^^^^^^^^^^^^^^^^^
> >> +
> >> +The Linux bridge allows the configuration of IGMP snooping (compile and run
> >> +time) which must be observed by the underlying switchdev network device/hardware
> > 
> > Same comment about "compile and run time" as above.
> > 
> >> +in the following way:
> >> +
> >> +- when IGMP snooping is turned off, multicast traffic must be flooded to all
> >> +  switch ports within the same broadcast domain. The CPU/management port
> > 
> > I think that if mc_disabled == true, multicast should be flooded only to
> > the ports which have mc_flood == true.
> 
> OK.
> 
> > 
> >> +  should ideally not be flooded and continue to learn multicast traffic through
> > 
> > unless the ingress interface has IFF_ALLMULTI or IFF_PROMISC, then I
> > suppose the CPU should be flooded from that particular port.
> 
> Yes indeed.
> 
> > 
> >> +  the network stack notifications. If the hardware is not capable of doing that
> >> +  then the CPU/management port must also be flooded and multicast filtering
> >> +  happens in software.
> >> +
> >> +- when IGMP snooping is turned on, multicast traffic must selectively flow
> >> +  to the appropriate network ports (including CPU/management port) and not be
> >> +  unnecessarily flooding.
> >> +
> > 
> > I believe that when mc_disabled == false, unknown multicast should be
> > flooded only to the ports connected to a multicast router. The local
> > device may also act as a multicast router.
> 
> OK that makes sense.
> 
> > 
> >> +The switch must adhere to RFC 4541 and flood multicast traffic accordingly
> >> +since that is what the Linux bridge implementation does.
> >> +
> > 
> > I have a lot of questions in this area.
> > Mainly, what should a driver do if the hardware can't parse IGMP/MLD but
> > just route by (maskable) layer 2 destination address?
> 
> Which hardware would fall in that category? Would that be sja1105 for
> instance?
> -- 
> Florian

Yes, that would be sja1105, although I'm sure it isn't the only one to
fall into this category.

Thanks,
-Vladimir
