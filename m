Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1378A2B8B0B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 06:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgKSFad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 00:30:33 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:54399 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgKSFad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 00:30:33 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4Cc7Yc5wLvz3qt1r;
        Thu, 19 Nov 2020 06:30:28 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4Cc7YN1H1Pz2xGL;
        Thu, 19 Nov 2020 06:30:16 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.21) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 19 Nov
 2020 06:28:50 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "Richard Cochran" <richardcochran@gmail.com>,
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
Subject: Re: [PATCH net-next v3 00/12] net: dsa: microchip: PTP support for KSZ956x
Date:   Thu, 19 Nov 2020 06:28:06 +0100
Message-ID: <2452899.Bt8PnbAPR0@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201118234018.jltisnhjesddt6kf@skbuf>
References: <20201118203013.5077-1-ceggers@arri.de> <20201118234018.jltisnhjesddt6kf@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.21]
X-RMX-ID: 20201119-063016-4Cc7YN1H1Pz2xGL-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thursday, 19 November 2020, 00:40:18 CET, Vladimir Oltean wrote:
> On Wed, Nov 18, 2020 at 09:30:01PM +0100, Christian Eggers wrote:
> > This series adds support for PTP to the KSZ956x and KSZ9477 devices.
> > 
> > There is only little documentation for PTP available on the data sheet
> > [1] (more or less only the register reference). Questions to the
> > Microchip support were seldom answered comprehensively or in reasonable
> > time. So this is more or less the result of reverse engineering.
> 
> [...]
> One thing that should definitely not be part of this series though is
> patch 11/12. Christian, given the conversation we had on your previous
> patch:
> https://lore.kernel.org/netdev/20201113025311.jpkplhmacjz6lkc5@skbuf/
sorry, I didn't read that carefully enough. Some of the other requested changes
were quite challenging for me. Additionally, finding the UDP checksum bug
needed some time for identifying because I didn't recognize that when it got
introduced.

> as well as the documentation patch that was submitted in the meantime:
> https://lore.kernel.org/netdev/20201117213826.18235-1-a.fatoum@pengutronix.de/ 
I am not subscribed to the list. 

> obviously you chose to completely disregard that. May we know why? How
> are you even making use of the PTP_CLK_REQ_PPS feature?
Of course I will drop that patch from the next series.

regards
Christian



