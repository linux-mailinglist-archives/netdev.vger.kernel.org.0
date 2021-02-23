Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F371322B7F
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 14:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhBWNbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 08:31:47 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:55368 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbhBWNbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 08:31:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614087105; x=1645623105;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OGj+tzeCAGyt894YZiouuBAdi7Lv7A6Y0JqBHcmsakc=;
  b=A51rhoizRuT7e4QOih+oj3vtCIx1307gmvvUOTx54fdGW5XI42GGfY7a
   abcWU3uR2iIqNngfphUD3PP/+3/OKzwDMyfRbCa+i2BA4EwrtrpfsJjzH
   fmpm+oDWbjRjY07K2/uIpMtv6LWTjRhJFgjNbrxHSEJ/e0HxjdyxA44qV
   Hf/wnCeCtbFlS/qoOV1Mk43wcOFA3bMUFYXeLo4SHgkmiXTUIBUqmG06X
   SBf9dzdlEXlp12daBSU3KV2v3A4R8yDvjSHAbQEDIpKPowOluW4TvUGAo
   wBe21+3MRnYg0xWeA/YjDJJCTH41ZNtNLTiFxs0xh+1zGnH0wgy200NVW
   g==;
IronPort-SDR: wvU6xwjI6zz4sV4p+iVwLkelMr5+Bc1X+LDY9qBzzLgSH7C5QSPapPiK2MJ+unLZArsIdwxZ+H
 n49F0sODqeV4XxruirsU0WU7aPzXqfJTdvk4ZIBK+J9gLgM0C8YTAcyKHPaicNPT2RADo/+8pu
 eASR/hDAoM/L5BH2QCdHKRLUgIXKZCPoMn/fVnU9fzVVCheYq6DSc3hysCT60BY8RODrSxxGlN
 +EGaGF/OVsI8qqrCuK7meLCnpFA4JFzHSv+63OfvRnjkRN/ivJbufASwMjkxzVogFsIF+/aHts
 7b4=
X-IronPort-AV: E=Sophos;i="5.81,200,1610434800"; 
   d="scan'208";a="45143412"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Feb 2021 06:30:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 06:30:28 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 23 Feb 2021 06:30:28 -0700
Date:   Tue, 23 Feb 2021 14:30:28 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 09/12] Documentation: networking: dsa: add
 paragraph for the MRP offload
Message-ID: <20210223133028.sem3hykvm5ld2unq@soft-dev3-1.localhost>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-10-olteanv@gmail.com>
 <20210222194626.srj7wwafyzfc355t@soft-dev3.localdomain>
 <20210222202506.27qp2ltdkgmqgmec@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210222202506.27qp2ltdkgmqgmec@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/22/2021 22:25, Vladimir Oltean wrote:
> 
Hi Vladimir,
> Hi Horatiu,
> 
> On Mon, Feb 22, 2021 at 08:46:26PM +0100, Horatiu Vultur wrote:
> > > - Why does ocelot support a single MRP ring if all it does is trap the
> > >   MRP PDUs to the CPU? What is stopping it from supporting more than
> > >   one ring?
> >
> > So the HW can support to run multiple rings. But to have an initial
> > basic implementation I have decided to support only one ring. So
> > basically is just a limitation in the driver.
> 
> What should change in the current sw_backup implementation such that
> multiple rings are supported?

Instead of single mrp_ring_id, mrp_p_port and mrp_s_port is to have a
list of these. And then when a new MRP instance is added/removed this
list should be updated. When the role is changed then find the MRP ports
from this list and put the rules to these ports.

> 
> > > - Why is listening for SWITCHDEV_OBJ_ID_MRP necessary at all, since it
> > >   does nothing related to hardware configuration?
> >
> > It is listening because it needs to know which ports are part of the
> > ring. In case you have multiple rings and do forwarding in HW you need
> > to know which ports are part of which ring. Also in case a MRP frame
> > will come on a port which is not part of the ring then that frame should
> > be flooded.
> 
> If I understand correctly, you just said below that this is not
> applicable to the current implementation because it is simplistic enough
> that it doesn't care what ring role does the application use, because it
> doesn't attempt to do any forwarding of MRP PDUs at all. If all that
> there is to do for a port with sw_backup is to add a trapping rule per
> port (rule which is already added per port), then what extra logic is
> there to add for the second MRP instance on a different set of 2 ports?

Regarding rules nothing should be changed. You just need to know which
is this new MRP instance so to put the same rules on these 2 ports. And
you can use the ring_id to determin which MRP instance it is and from
there you can find the ports.

> 
> > > - Why is ocelot_mrp_del_vcap called from both ocelot_mrp_del and from
> > >   ocelot_mrp_del_ring_role?
> >
> > To clean after itself. Lets say a user creates a node and sets it up.
> > Then when she decides to delete the node, what should happen? Should it
> > first disable the node and then do the cleaning or just do the cleaning?
> > This userspace application[1] does the second option but I didn't want
> > to implement the driver to be specific to this application so I have put
> > the call in both places.
> 
> I was actually thinking that the bridge could clean up after itself and
> delete the SWITCHDEV_OBJ_ID_RING_ROLE_MRP object.
> 
> > > - Why does ocelot not look at the MRM/MRC ring role at all, and it traps
> > >   all MRP PDUs to the CPU, even those which it could forward as an MRC?
> > >   I understood from your commit d8ea7ff3995e ("net: mscc: ocelot: Add
> > >   support for MRP") description that the hardware should be able of
> > >   forwarding the Test PDUs as a client, however it is obviously not
> > >   doing that.
> >
> > It doesn't look at the role because it doesn't care. Because in both
> > cases is looking at the sw_backup because it doesn't support any role
> > completely. Maybe comment was misleading but I have put it under
> > 'current limitations' meaning that the HW can do that but the driver
> > doesn't take advantage of that yet. The same applies to multiple rings
> > support.
> >
> > The idea is to remove these limitations in the next patches and
> > to be able to remove these limitations then the driver will look also
> > at the role.
> >
> > [1] https://github.com/microchip-ung/mrp
> 
> By the way, how can Ocelot trap some PDUs to the CPU but forward others?
> Doesn't it need to parse the MRP TLVs in order to determine whether they
> are Test packets or something else?

No it doesn't need to do that. Because Test packets are send to dmac
01:15:4e:00:00:01 while the other ring MRP frames are send to
01:15:4e:00:00:02. And Ocelot can trap frames based on the dmac.

I will create a patch with these changes when the net-next tree will
open.

-- 
/Horatiu
