Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B4F3CFF8F
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 18:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhGTPxn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Jul 2021 11:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhGTPxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 11:53:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA90C061768
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 09:33:45 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m5sgX-0001iW-Qe; Tue, 20 Jul 2021 18:33:33 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1m5sgW-0002xT-0G; Tue, 20 Jul 2021 18:33:32 +0200
Message-ID: <a129d6ea0b2706d290418db5bfe4a5f3f274dce1.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/5] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Date:   Tue, 20 Jul 2021 18:33:31 +0200
In-Reply-To: <CA+V-a8v-54QXtcT-gPy5vj9drqZ6Ntr0-3j=42Dedi-kojNtXQ@mail.gmail.com>
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
         <20210719143811.2135-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
         <dc2de27b087c7030ea7e76dd31bb3d8bce18d97f.camel@pengutronix.de>
         <CA+V-a8v-54QXtcT-gPy5vj9drqZ6Ntr0-3j=42Dedi-kojNtXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Tue, 2021-07-20 at 15:31 +0100, Lad, Prabhakar wrote:
> Hi Philipp,
> 
> Thank you for the review.
> 
> On Tue, Jul 20, 2021 at 11:22 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Hi Lad,

Sorry I mixed up your name.

> > On Mon, 2021-07-19 at 15:38 +0100, Lad Prabhakar wrote:
> > > Add CANFD binding documentation for Renesas RZ/G2L SoC.
> > > 
> > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > ---
> > >  .../bindings/net/can/renesas,rcar-canfd.yaml  | 66 +++++++++++++++++--
> > >  1 file changed, 60 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > > index 0b33ba9ccb47..4fb6dd370904 100644
> > > --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > > +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > > @@ -30,13 +30,15 @@ properties:
> > >                - renesas,r8a77995-canfd     # R-Car D3
> > >            - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
> > > 
> > > +      - items:
> > > +          - enum:
> > > +              - renesas,r9a07g044-canfd    # RZ/G2{L,LC}
> > > +          - const: renesas,rzg2l-canfd     # RZ/G2L family
> > > +
> > >    reg:
> > >      maxItems: 1
> > > 
> > > -  interrupts:
> > > -    items:
> > > -      - description: Channel interrupt
> > > -      - description: Global interrupt
> > > +  interrupts: true
> > > 
> > >    clocks:
> > >      maxItems: 3
> > > @@ -50,8 +52,7 @@ properties:
> > >    power-domains:
> > >      maxItems: 1
> > > 
> > > -  resets:
> > > -    maxItems: 1
> > > +  resets: true
> > > 
> > >    renesas,no-can-fd:
> > >      $ref: /schemas/types.yaml#/definitions/flag
> > > @@ -91,6 +92,59 @@ required:
> > >    - channel0
> > >    - channel1
> > > 
> > > +if:
> > > +  properties:
> > > +    compatible:
> > > +      contains:
> > > +        enum:
> > > +          - renesas,rzg2l-canfd
> > > +then:
> > > +  properties:
> > > +    interrupts:
> > > +      items:
> > > +        - description: CAN global error interrupt
> > > +        - description: CAN receive FIFO interrupt
> > > +        - description: CAN0 error interrupt
> > > +        - description: CAN0 transmit interrupt
> > > +        - description: CAN0 transmit/receive FIFO receive completion interrupt
> > > +        - description: CAN1 error interrupt
> > > +        - description: CAN1 transmit interrupt
> > > +        - description: CAN1 transmit/receive FIFO receive completion interrupt
> > > +
> > > +    interrupt-names:
> > > +      items:
> > > +        - const: g_error
> > > +        - const: g_rx_fifo
> > > +        - const: can0_error
> > > +        - const: can0_tx
> > > +        - const: can0_tx_rx_fifo_receive_completion
> > > +        - const: can1_error
> > > +        - const: can1_tx
> > > +        - const: can1_tx_rx_fifo_receive_completion
> > > +
> > > +    resets:
> > > +      items:
> > > +        - description: CANFD_RSTP_N
> > > +        - description: CANFD_RSTC_N
> > 
> > Do you know what the "P" and "C" stands for? It would be nice if the
> > description could tell us what the reset lines are used for.
> > 
> unfortunately the HW manual does not mention  anything about "P" and "C" :(

Yes, unfortunately this is all too common.

> > I would prefer if you used these names (or shortened versions, for
> > example "rstp_n", "rstc_n") as "reset-names" and let the driver
> > reference the resets by name instead of by index.
> > 
> OK will do that and maxItems:2 for resets.
> 
> @Geert, for R-Car Gen3 does "canfd_rst" (as it's a module reset)
> sounds good for reset-names? Or do you have any other suggestions?

I agree with Geert here. Assuming no second reset will be discovered for
R-Car Gen3 later, there is no need to invent a name.

regards
Philipp
