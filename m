Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15442572
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438815AbfFLMUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:20:30 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39734 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438796AbfFLMUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:20:25 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id F038E25AEA9;
        Wed, 12 Jun 2019 22:20:22 +1000 (AEST)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id E8276E21FE5; Wed, 12 Jun 2019 14:20:20 +0200 (CEST)
Date:   Wed, 12 Jun 2019 14:20:20 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH repost 0/5] Repost CAN and CANFD dt-bindings
Message-ID: <20190612122020.sgp5q427ilh6bbbg@verge.net.au>
References: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <TY1PR01MB1770D2AAF2ED748575CA4CBFC0100@TY1PR01MB1770.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TY1PR01MB1770D2AAF2ED748575CA4CBFC0100@TY1PR01MB1770.jpnprd01.prod.outlook.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave,

are you comfortable with me taking these patches
through the renesas tree? Or perhaps should they be reposted
to you for inclusion in net-next?

They have been stuck for a long time now.

On Fri, Jun 07, 2019 at 10:02:13AM +0000, Fabrizio Castro wrote:
> Dear All,
> 
> These patches have been around for a very long time now, is anybody willing to take them?
> 
> Cheers,
> Fab
> 
> > From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > Sent: 09 May 2019 20:20
> > Subject: [PATCH repost 0/5] Repost CAN and CANFD dt-bindings
> > 
> > Dear All,
> > 
> > I am reposting some CAN and CANFD related dt-bindings changes for
> > Renesas' R-Car and RZ/G devices that have been originally sent
> > end of last year and beginning of this year.
> > 
> > Thanks,
> > Fab
> > 
> > Fabrizio Castro (3):
> >   dt-bindings: can: rcar_can: Fix RZ/G2 CAN clocks
> >   dt-bindings: can: rcar_can: Add r8a774c0 support
> >   dt-bindings: can: rcar_canfd: document r8a774c0 support
> > 
> > Marek Vasut (2):
> >   dt-bindings: can: rcar_canfd: document r8a77965 support
> >   dt-bindings: can: rcar_canfd: document r8a77990 support
> > 
> >  Documentation/devicetree/bindings/net/can/rcar_can.txt   | 13 ++++---------
> >  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 16 ++++++++++------
> >  2 files changed, 14 insertions(+), 15 deletions(-)
> > 
> > --
> > 2.7.4
> 
