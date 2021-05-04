Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A09A3727D4
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 11:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhEDJKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 05:10:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229980AbhEDJKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 05:10:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620119368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LUsKHmziCSi5JNXUl60FZbloFw8P9ckc/ChGpQzCJ+o=;
        b=EPklkGgQqDkb3rmNP+G5SUD8mzzMLEuu/cRvyXX8IpjMqRypklUxjCnA47EVwwBiNkU/Gt
        j1SQHcImsi2pFnobp7duWRLzu3E3FKNn9PlH7kXsTHr15sie+qOmyS6CZy8DCIeZubYRq6
        /78cwR8rFMvqpUOC5cKHV3Jh/6R6C3g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-oEWd_9DiP56wuvTBuvGUEA-1; Tue, 04 May 2021 05:09:23 -0400
X-MC-Unique: oEWd_9DiP56wuvTBuvGUEA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC5F28049C5;
        Tue,  4 May 2021 09:09:21 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7490D421F;
        Tue,  4 May 2021 09:09:10 +0000 (UTC)
Date:   Tue, 4 May 2021 11:09:09 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        David Ahern <dsahern@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jens Steen Krogh <jskro@vestas.com>,
        Joao Pedro Barros Silva <jopbs@vestas.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        brouer@redhat.com, Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: PTP RX & TX time-stamp and TX Time in XDP ZC socket
Message-ID: <20210504110909.4a6e44ac@carbon>
In-Reply-To: <20210430142635.3791-1-alexandr.lobakin@intel.com>
References: <DM6PR11MB27800045D6EE4A69B1A65C45CA479@DM6PR11MB2780.namprd11.prod.outlook.com>
        <20210421103948.5a453e6d@carbon>
        <DM6PR11MB2780B29F0045B76119AFC388CA469@DM6PR11MB2780.namprd11.prod.outlook.com>
        <20210423183731.7279808a@carbon>
        <20210430142635.3791-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 30 Apr 2021 16:26:35 +0200
Alexander Lobakin <alexandr.lobakin@intel.com> wrote:

> Hi, just to let you know,
> We at Intel are currently working on flexible XDP hints that include
> both generic (i.e. that every single driver/HW has) and custom
> hints/metadata and are planning to publish a first RFC soon.
> Feel free to join if you wish, we could cooperate and work together.

I'm eager to join. I'm really looking forward to see the RFC and
collaborate with you. Lets all work together on this RFC and the
design of these flexible XDP hints.

I'm keeping my notes on this projects here:
 https://github.com/xdp-project/xdp-project/tree/master/areas/tsn

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

(No inlined comments below, just kept full quote for history)

On Fri, 30 Apr 2021 16:26:35 +0200
Alexander Lobakin <alexandr.lobakin@intel.com> wrote:

> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Fri, 23 Apr 2021 18:37:31 +0200
>=20
> > Cc, netdev, as I think we get upstream feedback as early as possible.
> > (Maybe Alexei will be critique my idea of storing btf_id in struct?)
> >=20
> >=20
> > On Thu, 22 Apr 2021 07:34:23 +0000
> > "Ong, Boon Leong" <boon.leong.ong@intel.com> wrote:
> >  =20
> > > >> Now that stmmac driver has been added with XDP ZC, we would like
> > > >> to know if there is any on-going POC or discussion on XDP ZC
> > > >> socket for adding below:
> > > >>
> > > >> 1) PTP RX & TX time-stamp
> > > >> 2) Per-packet TX transmit time (similar to SO_TXTIME)   =20
> > > >
> > > > Well, this is actually perfect timing! (pun intended)
> > > >
> > > > I'm actually going to work on adding this to XDP.  I was reading igc
> > > > driver and i225 sw datasheet last night, trying to figure out a des=
ign
> > > > based on what hardware can do. My design ideas obviously involve BT=
F,
> > > > but a lot of missing pieces like an XDP TX hook is also missing.   =
=20
> > >=20
> > > Currently, we are using a non-standard/not elegant way to provide for=
=20
> > > internal real-time KPI measurement purpose as follow=20
> > >
> > > 1) TX time stored in a newly introduced 64-bit timestamp in XDP descr=
iptor. =20
> >=20
> > Did you create a separate XDP descriptor?
> > If so what memory is backing that?
> >=20
> > My idea[1] is to use the meta-data area (xdp_buff->data_meta), that is
> > located in-front of the packet headers.  Or the area in top of the
> > "packet" memory, which is already used by struct xdp_frame, except that
> > zero-copy AF_XDP don't have the xdp_frame.  Due to AF_XDP limits I'm
> > leaning towards using xdp_buff->data_meta area.
> >=20
> > [1] https://people.netfilter.org/hawk/presentations/KernelRecipes2019/x=
dp-netstack-concert.pdf
> >=20
> > I should mention that I want a generic solution (based on BTF), that can
> > support many types of hardware hints.  Like existing RX-hash, VLAN,
> > checksum, mark and timestamps.  And newer HW hints that netstack
> > doesn't support yet, e.g. I know mlx5 can assign unique (64-bit)
> > flow-marks.
> >=20
> > I should also mention that I also want the solution to work for (struct)
> > xdp_frame packets that gets redirected from RX to TX.  And work when/if
> > an xdp_frame gets converted to an SKB (happens for veth and cpumap)
> > then the RX-hash, VLAN, checksum, mark, timestamp should be transferred
> > to the SKB. =20
>=20
> Hi, just to let you know,
> We at Intel are currently working on flexible XDP hints that include
> both generic (i.e. that every single driver/HW has) and custom
> hints/metadata and are planning to publish a first RFC soon.
> Feel free to join if you wish, we could cooperate and work together.
>=20
> > > 2) RX T/S is stored in the meta-data of the RX frame. =20
> >=20
> > Yes, I also want to store the RX-timestamp the meta-data area.  This
> > means that RX-timestamp is stored memory-wise just before the packet
> > header starts.
> >=20
> > For AF_XDP how does the userspace program know that info is stored in
> > this area(?).  As you know, it might only be some packets that contain
> > the timestamp, e.g. for some NIC is it only the PTP packets.
> >=20
> > I've discussed this with OVS VMware people before (they requested
> > RX-hash), and in that discussion Bj=C3=B8rn came up with the idea, that=
 the
> > "-32 bit" could contain the BTF-id number.  Meaning the last u32 member
> > of the metadata is btf_id (example below).
> >=20
> >  struct my_metadata {
> > 	u64 rx_timestamp;
> > 	u32 rx_hash32;
> > 	u32 btf_id;
> >  };
> >=20
> > When having the btf_id then the memory layout basically becomes self
> > describing.  I guess, we still need a single bit in the AF_XDP
> > RX-descriptor telling us that meta-data area is populated, or perhaps
> > we should store the btf_id in the AF_XDP RX-descriptor?
> >=20
> > Same goes for xdp_frame, should it store btf_id or have a single bit
> > that says, btf_id is located in data_meta area.
> >  =20
> > > 3) TX T/S is simply trace_printk out as there is missing XDP TX hook
> > >    like you pointed out. =20
> >=20
> > Again I want to use BTF to describe that a driver supports of
> > TX-timestamp features.  Like Saeed did for RX, the driver should export
> > (a number) of BTF-id's that it support.
> >=20
> > E.g when the LaunchTime features is configured;
> >=20
> >  struct my_metadata_tx {
> > 	u64 LaunchTime_ktime;
> > 	u32 btf_id;
> >  };
> >=20
> > When AF_XDP (or xdp_frame) want to transmit a frame as a specific time,
> > e.g. via LaunchTime feature in i210 (igb) and i225 (igc).
> >=20
> > I've read up on i210 and i225 capabilities, and I think this will help
> > us guide our design choices.  We need to support different BTF-desc per
> > TX queue basis, because the LaunchTime is configured per TX queue, and
> > further more, i210 only support this on queue 0 and 1.
> >=20
> > Currently the LaunchTime config happens via TC config when attaching a
> > ETF qdisc and doing TC-offloading.  For now, I'm not suggesting
> > changing that.  Instead we can simply export/expose that the driver now
> > support LaunchTime BTF-desc, when the config gets enabled.
> >=20
> >  =20
> > > So, if there is some ready work that we can evaluate, it will have us
> > > greatly in extending it to stmmac driver.  =20
> >=20
> > Saeed have done a number of different implementation attempts on RX
> > side with BTF.  We might be able to leverage some of that work.  That
> > said, the kernels BTF API have become more advanced since Saeed worked
> > on this. Thus, I expect that we might be able to leverage some of this
> > to simplify the approach.
> >=20
> >  =20
> > > >I have a practical project with a wind-turbine producer Vestas (they
> > > >have even approved we can say this publicly on mailing lists). Thus,=
 I
> > > >can actually dedicate some time for this.
> > > >
> > > >You also have a practical project that needs this? (And I/we can kee=
p it
> > > >off the mailing lists if you prefer/need-to).   =20
> > >=20
> > > Yes, we are about to start a a 3-way joint-development project that is
> > > evaluating the suitability of using preempt-RT + XDP ZC + TSN for
> > > integrating high level Industrial Ethernet stack on-top of Linux main=
line
> > > interface. So, there is couple of area that we will be looking into a=
nd
> > > above two capabilities are foundational in adding "time-aware" to
> > > XDP ZC interface.  But, our current focus on getting the Linux mainli=
ne
> > > capability ready, so we can discuss in ML. =20
> >=20
> > It sounds like our projects align very well! :-)))
> > My customer also want the combination preempt-RT + XDP ZC + TSN.
> >  =20
> > > >My plans: I will try to understand the hardware and drivers better, =
and
> > > >then I will work on a design proposal that I will share with you for
> > > >review.
> > > >
> > > >What are your plans?   =20
> > >=20
> > > Siang and myself are looking into this area starting next week and
> > > hopefully our time is aligned and we are hopeful to get this
> > > capability available in stmmac for next RC cycles. Is the time-line
> > > aligned to yours? =20
> >=20
> > Yes, this aligns with my time-line.  I want to start prototyping some
> > things next week, so I can start to run experiments with TSN.  The
> > TSN capable hardware for our PoC is being shipped to my house and
> > should arrive next week.
> >=20
> > Looking forward to collaborate with all of you.  You can let me know
> > (offlist) if you prefer not getting Cc'ed on these mails. Some of you
> > are bcc'ed and you have to opt-in if you are interested in collaboratin=
g.
> > --=20
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer =20
>=20
> Thanks,
> Al
>=20


