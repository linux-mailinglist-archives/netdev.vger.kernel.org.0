Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B041D224C03
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 16:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgGROtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 10:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgGROti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 10:49:38 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128A7C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 07:49:38 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id l1so13305698ioh.5
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 07:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y4qO1TK6O6xuosM4koIKWKbuRFUJib1z+xqR9GC1XEg=;
        b=onRz0uzmibogZcL94/w4ZYEpWlywfYT2FQDFNtuw1W5h3cQRtyF0iQOERZRxVukFOc
         vcZrGlAoEnwmKI2w6fMJ2ytZHWAY8swOVFOVNqY8MltrZG/86SfpqJnbwD079wKurARN
         AoHq9ILGooEB6gb2R7rn5n8QFCKUgkPg+5bphRpzQlIctRmsX3NfWMmKXwVZqO7z9hGF
         l17v80TiOIZBPTeIMNj2kVE/wqAr04MWOgRPbP3tKPSe41205ebdB2kHxlCj0H73AYcB
         GOj1VW2jvJOA71/HQiJg/80r20hj23d7jWCp5PATQat4Mzlef41MrswqndlNTi/0fEdg
         hXIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y4qO1TK6O6xuosM4koIKWKbuRFUJib1z+xqR9GC1XEg=;
        b=b4iZv/2ONySuBkbRLDlaW4BIAkytOskTR70qpfZBGAXkYWQS+JEI/C5g2x5jm7xkJL
         0shg43GR03amIKaF3Gbo7dhauzsyNLxY8D/Fwr39KijWcyi2nlVjA2YVN/biBL5mo+kO
         bamnqxokZ3sqHPb4BC4WXxmZlTjt449rXW7jQI/aiD+bOs5sBJcby+g4Iqes0TNinkgE
         TviMXGS4F06eBzgBdC5EW6ormrhTXA7adOAJuXviC/AfY8or1S52X+cKjPvBi0rF/FVz
         D29kZS+huG/56LhIOgeOPTggJ3YEUbJsksqfnF4a1Y1M6GaAAPnJ5BCePvosNMvJvsX+
         Ygow==
X-Gm-Message-State: AOAM530bg6x66L12jQ6lHkeoGSJ7jUXBma8/PU35gSPQwwlon6v0EawT
        xbLjY2in4/6ybHvqehFvIbgWVJdgzGFfVhFYGwYWWhtosKQ=
X-Google-Smtp-Source: ABdhPJxJn9bdMZIxDEgzrhcikzAtIWGDKvlTWCO7e0mVIn58VAO/73qcLLKPzsemKDOic3y/hqh7PqV7enZeioc+nMM=
X-Received: by 2002:a5d:9dc4:: with SMTP id 4mr14747541ioo.172.1595083777164;
 Sat, 18 Jul 2020 07:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAFXsbZodM0W87aH=qeZCRDSwyNOAXwF=aO8zf1UpkhwNkSAczA@mail.gmail.com>
 <20200718164239.40ded692@nic.cz>
In-Reply-To: <20200718164239.40ded692@nic.cz>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sat, 18 Jul 2020 07:49:26 -0700
Message-ID: <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com>
Subject: Re: bug: net: dsa: mv88e6xxx: serdes Unable to communicate on fiber
 with vf610-zii-dev-rev-c
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 7:42 AM Marek Behun <marek.behun@nic.cz> wrote:
>
> Hmm, nothing sticks out in the register dump.
>
> I encountered a similar problem 2 years ago on Topaz SERDES port when
> the cmode was set to 2500BASE-X but the speed register was set to speed
> incompatible with 2500BASE-X (I don't remember what, though). This
> issue was solved by a patch I sent to netdev.
>
> Are you sure that your board isn't broken? Maybe the SerDes traces on
> RX path are damaged...

In my case, both the SERDES and the MAC are inside the switch so I
don't think it's likely that the SERDES traces are broken in there.
If you are referring to the traces between the SERDES and the fiber
module, that doesn't feel likely either as the SERDES appears to be
reporting successfully received frames:

From "ethtool -S" after sending 6 packets to the unit:
serdes_rx_pkts: 6
serdes_rx_bytes: 384
serdes_rx_pkts_error: 0

If the traces were broken between the fiber module and the SERDES, I
should not see these counters incrementing.

>
> Marek
>
> On Sat, 18 Jul 2020 07:27:33 -0700
> Chris Healy <cphealy@gmail.com> wrote:
>
> > I've been trying to get the fiber interface of the vf610-zii-dev-rev-c
> > board working with net-next to no avail.  This platform utilizes a
> > Cotsworks SFF attached to port 9 of a Marvell 88E6390X.
> >
> > I have fiber link up on port 9 and am able to send packets from the
> > management CPU of the switch through the switch and out port 9 through
> > the fiber interface to a fiber link partner successfully.  I'm also
> > able to send packets from that fiber link partner back (to the point
> > of the switches SERDES) and am seeing the fiber ports SERDES RX
> > counters increment for each packet transmitted by the link partner.
> > The switches port 9 MAC is not showing any RX counters incrementing
> > though and I do not receive the frames at the management CPU.
> >
> > Because the SERDES RX counters are incrementing while the MAC RX
> > counters are not incrementing, it seems to me that the issue is
> > between the MAC and SERDES.  This is odd to me given that TX works
> > fine.
> >
> > In support of debugging this issue, I've applied an ethtool patch
> > which allows decoding the 88E6390X SERDES registers from userspace.
> > Looking at the register dump, nothing obvious sticks out to me though.
> >
> > I'm not sure what the right next steps are and would appreciate any
> > theories on what to try/test to root cause this issue.
> >
> > Below is an ethtool register dump and an ethtool statistics dump from
> > when the link is up and I have done some attempts at pinging a remote
> > host over fiber.
> >
> > root@(none):~$ ethtool -d sff2
> > 88E6390X Switch Port Registers
> > ------------------------------
> > 00: Port Status                            0xce49
> >       Transmit Pause Enable bit            1
> >       Receive Pause Enable bit             1
> >       802.3 PHY Detected                   0
> >       Link Status                          Up
> >       Duplex                               Full
> >       Speed                                1000 Mbps
> >       Duplex Fixed                         0
> >       EEE Enabled                          1
> >       Transmitter Paused                   0
> >       Flow Control                         0
> >       Config Mode                          0x9
> > 01: Physical Control                       0x203e
> >       RGMII Receive Timing Control         Default
> >       RGMII Transmit Timing Control        Default
> >       Force Speed                          1
> >       Alternate Speed Mode                 Normal
> >       MII PHY Mode                         MAC
> >       EEE force value                      0
> >       Force EEE                            0
> >       Link's Forced value                  Up
> >       Force Link                           1
> >       Duplex's Forced value                Full
> >       Force Duplex                         1
> >       Force Speed                          1000 Mbps
> > 02: Flow Control                           0x0100
> > 03: Switch Identifier                      0x0a11
> > 04: Port Control                           0x0433
> >       Source Address Filtering controls    Disabled
> >       Egress Mode                          Unmodified
> >       Ingress & Egress Header Mode         0
> >       IGMP and MLD Snooping                1
> >       Frame Mode                           Normal
> >       VLAN Tunnel                          0
> >       TagIfBoth                            0
> >       Initial Priority assignment          Tag & IP Priority
> >       Egress Flooding mode                 No unknown DA
> >       Port State                           Forwarding
> > 05: Port Control 1                         0x0000
> >       Message Port                         0
> >       LAG Port                             0
> >       VTU Page                             0
> >       LAG ID                               0
> >       FID[11:4]                            0x000
> > 06: Port Base VLAN Map (Header)            0x0400
> >       FID[3:0]                             0x000
> >       Force Mapping                        0
> >       VLANTable                            10
> > 07: Default VLAN ID & Priority             0x0000
> >       Default Priority                     0x0
> >       Force to use Default VID             0
> >       Default VLAN Identifier              0
> > 08: Port Control 2                         0x0080
> >       Force good FCS in the frame          0
> >       Allow bad FCS                        0
> >       Jumbo Mode                           1522
> >       802.1QMode                           Disabled
> >       Discard Tagged Frames                0
> >       Discard Untagged Frames              0
> >       Map using DA hits                    1
> >       ARP Mirror enable                    0
> >       Egress Monitor Source Port           0
> >       Ingress Monitor Source Port          0
> >       Allow VID of Zero                    0
> >       Default Queue Priority               0x0
> > 09: Egress Rate Control                    0x0001
> > 10: Egress Rate Control 2                  0x0000
> > 11: Port Association Vector                0x0200
> > 12: Port ATU Control                       0x0000
> > 13: Override                               0x0000
> > 14: Policy Control                         0x0000
> > 15: Port Ether Type                        0x9100
> > 16: Reserved                               0x0000
> > 17: Reserved                               0x0000
> > 18: Reserved                               0x0000
> > 19: Reserved                               0x0000
> > 20: Reserved                               0x0000
> > 21: Reserved                               0x0000
> > 22: LED Control                            0x0033
> > 23: IP Priority Mapping Table              0x0000
> > 24: IEEE Priority Mapping Table            0x3e07
> > 25: Port Control 3                         0x0000
> > 26: Reserved                               0x0000
> > 27: Queue Counters                         0x8000
> > 28: Queue Control                          0x0000
> > 29: Reserved                               0x0000
> > 30: Cut Through Control                    0x0000
> > 31: Debug Counters                         0x0000
> >
> > 88E6390X Switch Port SERDES Registers
> > -------------------------------------
> > f000: Global Clock Configuration 1           0x0000
> > f001: Global Clock Configuration 2           0x0002
> > f002: Port Operational Configuration         0x0003
> > f00a: FIFO and CRC Int Enable                0x0000
> > f00b: FIFO and CRC Int Status                0x0000
> > f00c: PPM FIFO Control 1                     0x0000
> > f00d: PPM FIFO Control 2                     0x0000
> > f00e: PPM FIFO Status                        0x0000
> > f010: Packet Generation Control 1            0x0501
> > f011: Packet Generation Control 2            0x0000
> > f012: Initial Payload 0-1/Packet Generation  0x0000
> > f013: Initial Payload 2-3/Packet Generation  0x0000
> > f016: Packet Generation Length               0x0000
> > f017: Packet Generation Burst Sequence       0x0000
> > f018: Packet Generation IPG                  0x0002
> > f019: Packet Gen_Chkr Clock Control          0x0000
> > f01a: Transmit Powerdown Delay               0x0032
> > f01b: Transmit Packet Counter [15:0]         0x0000
> > f01c: Transmit Packet Counter [31:16]        0x0000
> > f01d: Transmit Packet Counter [47:32]        0x0000
> > f01e: Transmit Byte Counter [15:0]           0x0000
> > f01f: Transmit Byte Counter [31:16]          0x0000
> > f020: Transmit Byte Counter [47:32]          0x0000
> > f021: Receive Packet Counter [15:0]          0x0000
> > f022: Receive Packet Counter [31:16]         0x0000
> > f023: Receive Packet Counter [47:32]         0x0000
> > f024: Receive Byte Count [15:0]              0x0000
> > f025: Receive Byte Count [31:16]             0x0000
> > f026: Receive Byte Count [47:32]             0x0000
> > f027: Receive Packet Error Count [15:0]      0x0000
> > f028: Receive Packet Error Count [31:16]     0x0000
> > f029: Receive Packet Error Count [47:32]     0x0000
> > f030: PRBS Control                           0x0200
> > f031: PRBS Symbol Tx Counter [15:0]          0x0000
> > f032: PRBS Symbol Tx Counter [31:16]         0x0000
> > f033: PRBS Symbol Tx Counter [47:32]         0x0000
> > f034: PRBS Symbol Rx Counter [15:0]          0x0000
> > f035: PRBS Symbol Rx Counter [31:16]         0x0000
> > f036: PRBS Symbol RX Counter [47:32]         0x0000
> > f037: PRBS Error Count [15:0]                0x0000
> > f038: PRBS Error Count [31:16]               0x0000
> > f039: PRBS Error Count [47:32]               0x0000
> > 2000: 1000BASE-X/SGMII Control Register      0x1140
> >       Reset                                0
> >       Loopback                             0
> >       SGMII Speed                          1000 Mbps
> >       Autoneg Enable                       1
> >       Power down                           0
> >       Isolate                              0
> >       Restart Autonet                      0
> >       Duplex                               Full
> > 2001: 1000BASE-X/SGMII Status Register       0x016d
> >       Autoneg Complete                     1
> >       Remote Fault                         0
> >       Link Status                          Up
> > 2002: PHY Identifier                         0x0141
> > 2003: PHY Identifier                         0x0c00
> > 2004: SGMII (Media side) Auto-Negotiation Ad 0x00a0
> >       Link Status                          Down
> >       Duplex                               Half
> >       SGMII Speed                          10 Mbps
> >       Transmit Pause                       0
> >       Receive Pause                        0
> >       Fibre/Copper                         Fibre
> >       EEE mode                             0
> >       Clock stopped during LPI             1
> > 2005: SGMII (Media side) Link Partner Abilit 0x40a0
> >       Acknowledge                          1
> > 2006: 1000BASE-X Auto-Negotiation Expansion  0x0007
> > 2007: 1000BASE-X Next Page Transmit Register 0x2801
> > 2008: 1000BASE-X Link Partner Next Page Regi 0x0000
> > 200f: Extended Status Register               0x8000
> > a000: 1000BASE-X Timer Mode Select Register  0x2000
> > a001: 1000BASE-X Interrupt Enable Register   0x0600
> >       Speed Changed                        0
> >       Duplex Changed                       0
> >       Page Received                        0
> >       Autoneg Complete                     0
> >       Link Up->Link Down                   1
> >       Link Down->Link Up                   1
> >       Symbol Error                         0
> >       False Carrier                        0
> > a002: 1000BASE-X Interrupt Status Register   0x0000
> >       Speed Changed                        0
> >       Duplex Changed                       0
> >       Page Received                        0
> >       Autoneg Complete                     0
> >       Link Up->Link Down                   0
> >       Link Down->Link Up                   0
> >       Symbol Error                         0
> >       False Carrier                        0
> > a003: 1000BASE-X PHY Specific Status         0xac2c
> >       Speed                                1000 Mbps
> >       Duplex                               Full
> >       Page Received                        0
> >       Speed/Duplex Resolved                1
> >       Link                                 Up
> >       Sync                                 1
> >       Energy Detect                        0
> >       Transmit Pause                       0
> >       Receive Pause                        0
> > 1000: 10GBASE-X4 PCS Control 1               0x2040
> > 1001: 10GBASE-X4 PCS Status 1                0x0082
> > 1002: PCS Device Identifier 1                0x0141
> > 1003: PCS Device Identifier 2                0x0c00
> > 1004: PCS Speed Ability                      0x0001
> > 1005: PCS Devices In Package 1               0x009a
> > 1006: PCS Devices In Package 2               0x4000
> > 1007: Reserved                               0x0001
> > 1008: 10GBASE-X4 PCS Status 2                0x8402
> > 100e: PCS Package Identifier 1               0x0141
> > 100f: PCS Package Identifier 2               0x0c00
> > 1014: PCS EEE Capability Register            0x0000
> > 1018: 10GBase-X Lane Status                  0x0c01
> > 1019: 10GBase-X Test Control                 0x0000
> > 9000: 10GBase-X Control                      0x0001
> > 9001: 10GBase-X Interrupt Enable 1           0x0000
> > 9002: 10GBase-X Interrupt Enable 2           0x0000
> > 9003: 10GBase-X Interrupt Status 1           0x0000
> > 9004: 10GBase-X Interrupt Status 2           0x00e1
> > 9006: 10GBase-X Real Time Status             0x0011
> > 9010: 10GBase-X Random Sequence Control      0x0000
> > 9011: 10GBase-X Jitter Packet Transmit Count 0x0000
> > 9012: 10GBase-X Jitter Packet Transmit Count 0x0000
> > 9013: 10GBase-X Jitter Packet Received Count 0x0000
> > 9014: 10GBase-X Jitter Packet Received Count 0x0000
> > 9015: 10GBase-X Jitter Packet Error Counter  0x0000
> > 9016: 10GBase-X Jitter Packet Error Counter  0x0000
> > 1020: 10GBASE-R PCS Status 1                 0x0000
> > 1021: 10GBASE-R PCS Status 2                 0x0000
> > 1022: 10GBASE-R PCS Test Pattern Seed A 0    0x0000
> > 1023: 10GBASE-R PCS Test Pattern Seed A 1    0x0000
> > 1024: 10GBASE-R PCS Test Pattern Seed A 2    0x0000
> > 1025: 10GBASE-R PCS Test Pattern Seed A 3    0x0000
> > 1026: 10GBASE-R PCS Test Pattern Seed B 0    0x0000
> > 1027: 10GBASE-R PCS Test Pattern Seed B 1    0x0000
> > 1028: 10GBASE-R PCS Test Pattern Seed B 2    0x0000
> > 1029: 10GBASE-R PCS Test Pattern Seed B 3    0x0000
> > 102a: 10GBASE-R PCS Test Pattern Control     0x0000
> > 102b: 10GBASE-R PCS Test Error Counter       0x0000
> >
> > root@(none):~$ ethtool -S sff2
> > NIC statistics:
> >      tx_packets: 3
> >      tx_bytes: 126
> >      rx_packets: 0
> >      rx_bytes: 0
> >      in_good_octets: 0
> >      in_bad_octets: 0
> >      in_unicast: 0
> >      in_broadcasts: 0
> >      in_multicasts: 0
> >      in_pause: 0
> >      in_undersize: 0
> >      in_fragments: 0
> >      in_oversize: 0
> >      in_jabber: 0
> >      in_rx_error: 0
> >      in_fcs_error: 0
> >      out_octets: 192
> >      out_unicast: 0
> >      out_broadcasts: 3
> >      out_multicasts: 0
> >      out_pause: 0
> >      excessive: 0
> >      collisions: 0
> >      deferred: 0
> >      single: 0
> >      multiple: 0
> >      out_fcs_error: 0
> >      late: 0
> >      hist_64bytes: 3
> >      hist_65_127bytes: 0
> >      hist_128_255bytes: 0
> >      hist_256_511bytes: 0
> >      hist_512_1023bytes: 0
> >      hist_1024_max_bytes: 0
> >      in_discards: 0
> >      in_filtered: 0
> >      in_accepted: 0
> >      in_bad_accepted: 0
> >      in_good_avb_class_a: 0
> >      in_good_avb_class_b: 0
> >      in_bad_avb_class_a: 0
> >      in_bad_avb_class_b: 0
> >      tcam_counter_0: 0
> >      tcam_counter_1: 0
> >      tcam_counter_2: 0
> >      tcam_counter_3: 0
> >      in_da_unknown: 0
> >      in_management: 0
> >      out_queue_0: 3
> >      out_queue_1: 0
> >      out_queue_2: 0
> >      out_queue_3: 0
> >      out_queue_4: 0
> >      out_queue_5: 0
> >      out_queue_6: 0
> >      out_queue_7: 0
> >      out_cut_through: 0
> >      out_octets_a: 0
> >      out_octets_b: 0
> >      out_management: 3
> >      serdes_rx_pkts: 6
> >      serdes_rx_bytes: 384
> >      serdes_rx_pkts_error: 0
> >      atu_member_violation: 0
> >      atu_miss_violation: 0
> >      atu_full_violation: 0
> >      vtu_member_violation: 0
> >      vtu_miss_violation: 0
>
