Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3669A2B2423
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgKMS6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:58:20 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:36384 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgKMS6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 13:58:20 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CXnmR5LG2z3qy9M;
        Fri, 13 Nov 2020 19:58:15 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CXnmC0c7wz2TRmB;
        Fri, 13 Nov 2020 19:58:03 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.24) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 13 Nov
 2020 19:57:01 +0100
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
Subject: Re: [PATCH net-next v2 05/11] dt-bindings: net: dsa: microchip,ksz: add interrupt property
Date:   Fri, 13 Nov 2020 19:57:00 +0100
Message-ID: <13390157.M6Fu2mDLuP@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201112230732.5spb6qgsu3zdtq4d@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de> <20201112153537.22383-6-ceggers@arri.de> <20201112230732.5spb6qgsu3zdtq4d@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.24]
X-RMX-ID: 20201113-195803-4CXnmC0c7wz2TRmB-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, 13 November 2020, 00:07:32 CET, Vladimir Oltean wrote:
> On Thu, Nov 12, 2020 at 04:35:31PM +0100, Christian Eggers wrote:
> > The devices have an optional interrupt line.
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > ---
> > 
> >  .../devicetree/bindings/net/dsa/microchip,ksz.yaml        | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> > b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml index
> > 431ca5c498a8..b2613d6c97cf 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> > +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> > 
...
> > +            interrupt-parent = <&gpio5>;
> > +            interrupts = <1 IRQ_TYPE_LEVEL_LOW>;  /* INTRP_N line */
> 
> Isn't it preferable to use this syntax?
> 
> 		interrupts-extended = <&gpio5 1 IRQ_TYPE_LEVEL_LOW>;  /* INTRP_N line */

After reading Documentation/devicetree/bindings/interrupt-controller/interrupts.txt,
I would say that "interrupts-extended" is more flexible as it allows different
interrupt parents for the case there is more than one interrupt line. Although
there is only one line on the KSZ, I will change this.



