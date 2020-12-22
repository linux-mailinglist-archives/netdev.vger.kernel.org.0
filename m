Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170452E09B6
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 12:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgLVLbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 06:31:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:5395 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgLVLbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 06:31:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608636684; x=1640172684;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version:content-transfer-encoding;
  bh=g8yIvISp9TCwCdGa24nm2oJMHerDtBdiqZ7iBjlRmMY=;
  b=K8mDpOlQDLkURC/RKfvNtZx8YWkjg8mpWH688VHhY492wV2eC8MeBNuT
   HNPcCvdz8+tE03RwC70+IUpdFDZ0garo5T9ppHTrS5wS6qRdSNO8+djOy
   RIk8CFBn+BW/g0S8LxEWolclCUy2XOMw0DcG0szOPSC+WwXVw5dycR6YR
   p+tofN4yPntr9AyIj4HybTVo8/tw25HpR8kCSvwOouvsG5UhfH3XrCVzc
   SOu8QQi1CxRpK8Yc0l6R0kOuSyIcQaLXeTCn9paI3jb60iQU/Upu69D8a
   LMhGRZLvbj3+cc7EwrtOJRYAxknT3oT9tL1fSeWk4pOHx1ghA7MYyhLka
   A==;
IronPort-SDR: henkgIWC94c14Qhr1XSRvgQJofrXY0bmSXcBAwSZ9jG/0cYA0nSKBm07L103CL06BEZx+awfdx
 D4Kt53F2rfZhbE7ZeNvqIK46SnqhcEfy7Pf0ne/YQkIMRKlWV6RUVYiYnqo7mo6kB13Lpe4nRv
 3jM85fay4oZGvZ38LsdIsobM5LNMoWWsD+96MvieMyPQD7iviPP+DXvveSIVqn1Mt+NT4kt/Do
 m/KEX9fvtA+ovxI4dWOgkhuO96hGLhnXaWRCuuIJz6J2kALOw6sU48kYoJi4hrkxEefZcdrC5X
 XTc=
X-IronPort-AV: E=Sophos;i="5.78,438,1599548400"; 
   d="scan'208";a="38266841"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Dec 2020 04:30:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Dec 2020 04:30:07 -0700
Received: from soft-dev10.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 22 Dec 2020 04:30:04 -0700
References: <20201217075134.919699-1-steen.hegelund@microchip.com> <6645f038-7101-67e4-0843-35125f74597a@gmail.com>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Lars Povlsen <lars.povlsen@microchip.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <Torkil.Oelgaard@microchip.com>, <Ioannis.Kotleas@microchip.com>
Subject: Re: [RFC PATCH v2 0/8] Adding the Sparx5 Switch Driver
In-Reply-To: <6645f038-7101-67e4-0843-35125f74597a@gmail.com>
Date:   Tue, 22 Dec 2020 12:29:55 +0100
Message-ID: <87czz2oz7w.fsf@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Florian Fainelli writes:

> On 12/16/2020 11:51 PM, Steen Hegelund wrote:
>> This series provides the Microchip Sparx5 Switch Driver
>>
>> The Sparx5 Carrier Ethernet and Industrial switch family delivers 64
>> Ethernet ports and up to 200 Gbps of switching bandwidth.
>>
>> It provides a rich set of Ethernet switching features such as hierarchic=
al
>> QoS, hardware-based OAM  and service activation testing, protection
>> switching, IEEE 1588, and Synchronous Ethernet.
>>
>> Using provider bridging (Q-in-Q) and MPLS/MPLS-TP technology, it delivers
>> MEF CE
>> 2.0 Ethernet virtual connections (EVCs) and features advanced TCAM
>>   classification in both ingress and egress.
>>
>> Per-EVC features include advanced L3-aware classification, a rich set of
>> statistics, OAM for end-to-end performance monitoring, and dual-rate
>> policing and shaping.
>>
>> Time sensitive networking (TSN) is supported through a comprehensive set=
 of
>> features including frame preemption, cut-through, frame replication and
>> elimination for reliability, enhanced scheduling: credit-based shaping,
>> time-aware shaping, cyclic queuing, and forwarding, and per-stream polic=
ing
>> and filtering.
>>
>> Together with IEEE 1588 and IEEE 802.1AS support, this guarantees
>> low-latency deterministic networking for Fronthaul, Carrier, and Industr=
ial
>> Ethernet.
>>
>> The Sparx5 switch family consists of following SKUs:
>>
>> - VSC7546 Sparx5-64 up to 64 Gbps of bandwidth with the following primary
>>   port configurations:
>>   - 6 *10G
>>   - 16 * 2.5G + 2 * 10G
>>   - 24 * 1G + 4 * 10G
>>
>> - VSC7549 Sparx5-90 up to 90 Gbps of bandwidth with the following primary
>>   port configurations:
>>   - 9 * 10G
>>   - 16 * 2.5G + 4 * 10G
>>   - 48 * 1G + 4 * 10G
>>
>> - VSC7552 Sparx5-128 up to 128 Gbps of bandwidth with the following prim=
ary
>>   port configurations:
>>   - 12 * 10G
>>   - 16 * 2.5G + 8 * 10G
>>   - 48 * 1G + 8 * 10G
>>
>> - VSC7556 Sparx5-160 up to 160 Gbps of bandwidth with the following prim=
ary
>>   port configurations:
>>   - 16 * 10G
>>   - 10 * 10G + 2 * 25G
>>   - 16 * 2.5G + 10 * 10G
>>   - 48 * 1G + 10 * 10G
>>
>> - VSC7558 Sparx5-200 up to 200 Gbps of bandwidth with the following prim=
ary
>>   port configurations:
>>   - 20 * 10G
>>   - 8 * 25G
>>
>> In addition, the device supports one 10/100/1000/2500/5000 Mbps
>> SGMII/SerDes node processor interface (NPI) Ethernet port.
>>
>> The Sparx5 support is developed on the PCB134 and PCB135 evaluation boar=
ds.
>>
>> - PCB134 main networking features:
>>   - 12x SFP+ front 10G module slots (connected to Sparx5 through SFI).
>>   - 8x SFP28 front 25G module slots (connected to Sparx5 through SFI high
>>     speed).
>>   - Optional, one additional 10/100/1000BASE-T (RJ45) Ethernet port
>>     (on-board VSC8211 PHY connected to Sparx5 through SGMII).
>>
>> - PCB135 main networking features:
>>   - 48x1G (10/100/1000M) RJ45 front ports using 12xVSC8514 QuadPHY=E2=80=
=99s each
>>     connected to VSC7558 through QSGMII.
>>   - 4x10G (1G/2.5G/5G/10G) RJ45 front ports using the AQR407 10G QuadPHY
>>     each port connects to VSC7558 through SFI.
>>   - 4x SFP28 25G module slots on back connected to VSC7558 through SFI h=
igh
>>     speed.
>>   - Optional, one additional 1G (10/100/1000M) RJ45 port using an on-boa=
rd
>>     VSC8211 PHY, which can be connected to VSC7558 NPI port through SGMII
>>     using a loopback add-on PCB)
>>
>> This series provides support for:
>>   - SFPs and DAC cables via PHYLINK with a number of 5G, 10G and 25G
>>     devices and media types.
>>   - Port module configuration for 10M to 25G speeds with SGMII, QSGMII,
>>     1000BASEX, 2500BASEX and 10GBASER as appropriate for these modes.
>>   - SerDes configuration via the Sparx5 SerDes driver (see below).
>>   - Host mode providing register based injection and extraction.
>>   - Switch mode providing MAC/VLAN table learning and Layer2 switching
>>     offloaded to the Sparx5 switch.
>>   - STP state, VLAN support, host/bridge port mode, Forwarding DB, and
>>     configuration and statistics via ethtool.
>>
>> More support will be added at a later stage.
>>
>> The Sparx5 Switch chip register model can be browsed here:
>> Link: https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.ht=
ml
>
> Out of curiosity, what tool was used to generate the register
> information page? It looks really neat and well organized.

Florian,

It is an in-house tool. The input data is in a proprietary XML-like
format.

We're pleased that you like it, we do too. We are also pleased that
being a Microchip entity, we can actually make this kind of information
public.

I'll pass your praise on.

---Lars

--
Lars Povlsen,
Microchip
