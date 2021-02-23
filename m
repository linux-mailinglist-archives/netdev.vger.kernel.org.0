Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F21322C14
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhBWOTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:19:30 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:48632 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbhBWOT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 09:19:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614089966; x=1645625966;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o0zp8AWBquesTWNviQRf/nnMybuq136QmcMVBlvkuew=;
  b=LCZcaYdGZtWidp34CxvGwU7wCoxUKa5ywZJtCpTIszPVx/QXmo8TMkXK
   jwzMUJKlQcLWoP7xDkBuVbASJve9Z4KmlkBzUevEEjUbm4HviaqnTAFfe
   jElNZSkQCrrWuk0EBJzjy9Of49tjQHvowL91/ujQWzZdxM2nSukvizi4t
   IdBA3aaU1Xc9Ut8VkCsvUxpGO4ma/gk3GRU15g292nS5SC3Iv2mVOOyCi
   1f/+ROdWsZvEQcE8++HzoJ2AhpeUl0Ot0w/O+w7FSfU3Vs+gEHqJd2DkV
   PGLGhgzmcEC/D4MslolvVoytxEC2h+GiTav6T9qBt3gj+WHKoSIWjB6aq
   w==;
IronPort-SDR: 6H91QKyiCvAxOO8HmxAKsjGxDKx0gf/xYaY4/nrQW+cG7CpWj+v0EoyhDixhdtITv/PMKtn7xu
 K2JjsmECHVtaP4XJTlH4OL6hczW5WxvpAQj5F3Yj+YubbnjyPPQtnexI22ewy3Rg1eW2HQiA+q
 AdGvTCrLdTZodS8XLRo+V8K8emuBHk2d1ChEY0kK3M2kDZzegfZEqBfIbVGpq+Hnn5BIDqHgck
 IuQ+5pybzQkEppvCiGvPiKCcVcTTASVyvtaCyw5JiiLoYxubkJnP3YgtpapnDupZgfNi88SmuP
 ev4=
X-IronPort-AV: E=Sophos;i="5.81,200,1610434800"; 
   d="scan'208";a="110305471"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Feb 2021 07:18:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Feb 2021 07:18:07 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 23 Feb 2021 07:18:06 -0700
Date:   Tue, 23 Feb 2021 15:18:07 +0100
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
Message-ID: <20210223141807.mt4ihjvosmstf2i4@soft-dev3-1.localhost>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-10-olteanv@gmail.com>
 <20210222194626.srj7wwafyzfc355t@soft-dev3.localdomain>
 <20210222202506.27qp2ltdkgmqgmec@skbuf>
 <20210223133028.sem3hykvm5ld2unq@soft-dev3-1.localhost>
 <20210223135015.ssqm3t7fajplceyx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210223135015.ssqm3t7fajplceyx@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/23/2021 15:50, Vladimir Oltean wrote:
> On Tue, Feb 23, 2021 at 02:30:28PM +0100, Horatiu Vultur wrote:
> > The 02/22/2021 22:25, Vladimir Oltean wrote:
> > >
> > Hi Vladimir,
> > > Hi Horatiu,
> > >
> > > On Mon, Feb 22, 2021 at 08:46:26PM +0100, Horatiu Vultur wrote:
> > > > > - Why does ocelot support a single MRP ring if all it does is trap the
> > > > >   MRP PDUs to the CPU? What is stopping it from supporting more than
> > > > >   one ring?
> > > >
> > > > So the HW can support to run multiple rings. But to have an initial
> > > > basic implementation I have decided to support only one ring. So
> > > > basically is just a limitation in the driver.
> > >
> > > What should change in the current sw_backup implementation such that
> > > multiple rings are supported?
> >
> > Instead of single mrp_ring_id, mrp_p_port and mrp_s_port is to have a
> > list of these. And then when a new MRP instance is added/removed this
> > list should be updated. When the role is changed then find the MRP ports
> > from this list and put the rules to these ports.
> 
> A physical port can't offload more than one ring id under any
> circumstance, no? So why keep a list and not just keep the MRP ring id
> in the ocelot_port structure, then when the ring role changes, just
> iterate through all ports and update the trapping rule on those having
> the same ring id?

Yes, a port can be part of only one ring. Yes, you should be able to do
it also like that, I don't see any issues with that approach.

> 
> Also, why is it important to know which port is primary and which is
> secondary?

In this context is not important. It is important when MRM role is
offloaded to HW.

> 
> > > > > - Why does ocelot not look at the MRM/MRC ring role at all, and it traps
> > > > >   all MRP PDUs to the CPU, even those which it could forward as an MRC?
> > > > >   I understood from your commit d8ea7ff3995e ("net: mscc: ocelot: Add
> > > > >   support for MRP") description that the hardware should be able of
> > > > >   forwarding the Test PDUs as a client, however it is obviously not
> > > > >   doing that.
> > > >
> > > > It doesn't look at the role because it doesn't care. Because in both
> > > > cases is looking at the sw_backup because it doesn't support any role
> > > > completely. Maybe comment was misleading but I have put it under
> > > > 'current limitations' meaning that the HW can do that but the driver
> > > > doesn't take advantage of that yet. The same applies to multiple rings
> > > > support.
> > > >
> > > > The idea is to remove these limitations in the next patches and
> > > > to be able to remove these limitations then the driver will look also
> > > > at the role.
> > > >
> > > > [1] https://github.com/microchip-ung/mrp
> > >
> > > By the way, how can Ocelot trap some PDUs to the CPU but forward others?
> > > Doesn't it need to parse the MRP TLVs in order to determine whether they
> > > are Test packets or something else?
> >
> > No it doesn't need to do that. Because Test packets are send to dmac
> > 01:15:4e:00:00:01 while the other ring MRP frames are send to
> > 01:15:4e:00:00:02. And Ocelot can trap frames based on the dmac.
> 
> Interesting, so I think with a little bit more forethought, the
> intentions with this MRP hardware assist would have been much clearer.
> From what you explained, the better implementation wouldn't have been
> more complicated than the current one is, just cleaner.

A better implementation will be to have also interconnect support. Again
the idea of the patch was to add minimum support for Ocelot and from
there to build on.


-- 
/Horatiu
