Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF6D2AD8E9
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 15:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgKJOh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 09:37:26 -0500
Received: from mailout05.rmx.de ([94.199.90.90]:36085 "EHLO mailout05.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgKJOh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 09:37:26 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout05.rmx.de (Postfix) with ESMTPS id 4CVr6p1WvBz9tQx;
        Tue, 10 Nov 2020 15:37:22 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CVr6Y3mW3z2xbQ;
        Tue, 10 Nov 2020 15:37:09 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.16) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 10 Nov
 2020 15:36:03 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Tue, 10 Nov 2020 15:36:02 +0100
Message-ID: <1909178.Ky26jPeFT0@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201110014234.b3qdmc2e74poawpz@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <5844018.3araiXeC39@n95hx1g2> <20201110014234.b3qdmc2e74poawpz@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.16]
X-RMX-ID: 20201110-153709-4CVr6Y3mW3z2xbQ-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, 10 November 2020, 02:42:34 CET, Vladimir Oltean wrote:
> Sorry for getting back late to you. It did not compute when I read your
> email the first time around, then I let it sit for a while.
> 
> On Thu, Nov 05, 2020 at 09:18:04PM +0100, Christian Eggers wrote:
> > unfortunately I made a mistake when testing. Actually the timestamp *must*
> > be moved from the correction field (negative) to the egress tail tag.
> That doesn't sound very good at all.
I think that is no drawback. It is implemented and works.

> I have a simple question. Can your driver, when operating as a PTP
> master clock, distribute a time in 2020 into your network? (you can
> check with "phc_ctl /dev/ptp0 get")
# phc_ctl /dev/ptp2 get
phc_ctl[2141.093]: clock time is 1605018671.788481458 or Tue Nov 10 14:31:11 2020

The KSZ PTP clock has 32 bit seconds (and 30 bit nanoseconds).

I hope I can send the new series tonight. Had today no 5 minutes without the telephone ringing...



