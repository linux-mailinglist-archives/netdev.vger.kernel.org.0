Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EB8139D00
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 23:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgAMW5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 17:57:55 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12990 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgAMW5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 17:57:55 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: uLdyb5/8R7WdrAuvZZJHHEW+0FURP8Mm7nPewEH2KVe415sRQZBrXTBFgHGr82rS96k4G+y9ZN
 5Knjg7uZxTqBsg55Kd+EQFNnqmnwYYiwbgZc4BUmPTRBZx4DCoRfoIDcF/d2vPeS33qmRIiGaH
 y7udqvM+Y/3eEx6VInACJRR0lz7nKbF9N0P32Ez78dNlCZkyP0UxpK6Lud29bDFNqq4G6/Fgmf
 qDk6mqEx892r/ff3Jakj7LeNegALia07v1Q1SY6Oq2KDRP+hw7dLXOGeE4drnrUTXCGJUXUk4K
 eeo=
X-IronPort-AV: E=Sophos;i="5.69,430,1571727600"; 
   d="scan'208";a="62491319"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2020 15:57:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jan 2020 15:57:52 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 13 Jan 2020 15:57:51 -0700
Date:   Mon, 13 Jan 2020 23:57:51 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <jakub.kicinski@netronome.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <anirudh.venkataramanan@intel.com>,
        <dsahern@gmail.com>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next Patch v2 4/4] net: bridge: mrp: switchdev: Add HW
 offload
Message-ID: <20200113225751.jkkio4rztyuff4xj@soft-dev3.microsemi.net>
References: <20200113124620.18657-1-horatiu.vultur@microchip.com>
 <20200113124620.18657-5-horatiu.vultur@microchip.com>
 <20200113140053.GE11788@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200113140053.GE11788@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/13/2020 15:00, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, Jan 13, 2020 at 01:46:20PM +0100, Horatiu Vultur wrote:
> > +#ifdef CONFIG_BRIDGE_MRP
> > +/* SWITCHDEV_OBJ_ID_PORT_MRP */
> > +struct switchdev_obj_port_mrp {
> > +     struct switchdev_obj obj;
> > +     struct net_device *port;
> > +     u32 ring_nr;
> > +};
> > +
> > +#define SWITCHDEV_OBJ_PORT_MRP(OBJ) \
> > +     container_of((OBJ), struct switchdev_obj_port_mrp, obj)
> > +
> > +/* SWITCHDEV_OBJ_ID_RING_TEST_MRP */
> > +struct switchdev_obj_ring_test_mrp {
> > +     struct switchdev_obj obj;
> > +     /* The value is in us and a value of 0 represents to stop */
> > +     u32 interval;
> > +     u8 max;
> > +     u32 ring_nr;
> > +};
> > +
> > +#define SWITCHDEV_OBJ_RING_TEST_MRP(OBJ) \
> > +     container_of((OBJ), struct switchdev_obj_ring_test_mrp, obj)
> > +
> > +/* SWITCHDEV_OBJ_ID_RING_ROLE_MRP */
> > +struct switchdev_obj_ring_role_mrp {
> > +     struct switchdev_obj obj;
> > +     u8 ring_role;
> > +     u32 ring_nr;
> > +};
> 
> Hi Horatiu
> 
> The structures above should give me enough information to build this,
> correct?

Hi Andrew,

You will need also these attributes to build a minimum MRP_Test frame:
SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
SWITCHDEV_ATTR_ID_MRP_RING_STATE,
SWITCHDEV_ATTR_ID_MRP_RING_TRANS,

> 
> Ethernet II, Src: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1), Dst: Iec_00:00:01 (01:15:4e:00:00:01)
>     Destination: Iec_00:00:01 (01:15:4e:00:00:01)
>     Source: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1)
>     Type: MRP (0x88e3)
> PROFINET MRP MRP_Test, MRP_Common, MRP_End
>     MRP_Version: 1
>     MRP_TLVHeader.Type: MRP_Test (0x02)
>         MRP_TLVHeader.Type: MRP_Test (0x02)
>         MRP_TLVHeader.Length: 18
>         MRP_Prio: 0x1f40 High priorities
>         MRP_SA: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1)
>         MRP_PortRole: Primary ring port (0x0000)
>         MRP_RingState: Ring closed (0x0001)
>         MRP_Transition: 0x0001
>         MRP_TimeStamp [ms]: 0x000cf574             <---------- Updated automatic
>     MRP_TLVHeader.Type: MRP_Common (0x01)
>         MRP_TLVHeader.Type: MRP_Common (0x01)
>         MRP_TLVHeader.Length: 18
>         MRP_SequenceID: 0x00e9                     <---------- Updated automatic
>         MRP_DomainUUID: ffffffff-ffff-ffff-ffff-ffffffffffff
>     MRP_TLVHeader.Type: MRP_End (0x00)
>         MRP_TLVHeader.Type: MRP_End (0x00)
>         MRP_TLVHeader.Length: 0
> 
> There are a couple of fields i don't see. MRP_SA, MRP_Transition.

Regarding the MRP_SA, which represents the bridge MAC address, we could
get this information from listening to the notifications in the driver.
So I don't think we need a special call for this.

The same could be for MRP_Transition, which counts the number of times
the ring goes in open state. In theory we could get information by
counting in the driver how many times the ring gets in the open state.
And we get this information through the attribute
SWITCHDEV_ATTR_ID_MRP_RING_STATE.

The other fields that are missing are MRP_Prio and MRP_DomainUUID. But
these values could be set to a default values for now because they are
used by MRA(Media Redundancy Auto-manager), which is not part of this
patch series.

> 
> What are max and ring_nr used for?

The max represents the number of MRP_Test frames that can be missed
by receiver before it declares the ring open. For example if the
receiver expects a MRP_Frame every 10ms and it sets the max to 3. Then
it means that if it didn't receive a frame in 30ms, it would set that
the port didn't receive MRP_Test.
The ring_nr represents the ID of the MRP instance. For example, on a
switch which has 8 ports, there can be 4 MRP instances. Because each
instance requires 2 ports. And to be able to differences them, each
instance has it's own ID, which is this ring_nr.

> 
> Do you need to set the first value MRP_SequenceID uses? Often, in
> order to detect a reset, a random value is used to initialise the
> sequence number. Also, does the time stamp need initializing?

I couldn't see in the standard if they required an initial for
MRP_SequenceID. From what I have seen on some switches that have their
own MRP implementation, they set the initial value of MRP_SequenceID to
0 and they increase for it frame.
Regarding the timestamp, again the standard doesn't say anything about
initial value. This timestamp is used by MRM to determine the maximum
travel time of the MRP_Test frames in a ring.
> 
> Thanks
>         Andrew

-- 
/Horatiu
