Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125AB2CDA31
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 16:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbgLCPhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 10:37:48 -0500
Received: from mailout10.rmx.de ([94.199.88.75]:39212 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgLCPhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 10:37:48 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4Cn0M45Zrwz36Dj;
        Thu,  3 Dec 2020 16:37:04 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4Cn0Lr2Y4cz2TTL1;
        Thu,  3 Dec 2020 16:36:52 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.174) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 3 Dec
 2020 16:36:32 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v5 9/9] net: dsa: microchip: ksz9477: add periodic output support
Date:   Thu, 3 Dec 2020 16:36:26 +0100
Message-ID: <11406377.LS7tM95F4J@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201203141255.GF4734@hoboy.vegasvil.org>
References: <20201203102117.8995-1-ceggers@arri.de> <20201203102117.8995-10-ceggers@arri.de> <20201203141255.GF4734@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.174]
X-RMX-ID: 20201203-163652-xZDbsPjsymKS-0@out02.hq
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 3 December 2020, 15:12:55 CET, Richard Cochran wrote:
> On Thu, Dec 03, 2020 at 11:21:17AM +0100, Christian Eggers wrote:
> > The KSZ9563 has a Trigger Output Unit (TOU) which can be used to
> > generate periodic signals.
> > 
> > The pulse length can be altered via a device attribute.
> 
> Device tree is the wrong place for that.
I meant a device specfic sysfs attribute.
/sys/class/ptp/ptp2/device/pulse

But this is not true anymore, as I moved the sysfs attribute to a later 
patch (not submitted yet).

> Aren't you using PTP_PEROUT_DUTY_CYCLE anyhow?
I also use PTP_PEROUT_DUTY_CYCLE. But this cannot be set via a shell
script. The existing "period" sysfs attribute doesn't allow to set
the pulse length, so I added a device specific attribute for this.

Should ptp_sysfs be extended with a "pulse" attribute with calls
enable() with only PTP_PEROUT_DUTY_CYCLE set?

> 
> Thanks,
> Richard
> 
> 
regards
Christian




