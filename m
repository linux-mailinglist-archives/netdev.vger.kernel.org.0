Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730512DBAF2
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725879AbgLPGCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:02:45 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:37622 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgLPGCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:02:45 -0500
Date:   Wed, 16 Dec 2020 09:02:00 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh@kernel.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Joao Pinto <jpinto@synopsys.com>,
        Lars Persson <larper@axis.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/25] dt-bindings: net: dwmac: Add Tx/Rx clock sources
Message-ID: <20201216060200.azftg2denbvtmrip@mobilestation>
References: <20201214091616.13545-1-Sergey.Semin@baikalelectronics.ru>
 <20201214091616.13545-7-Sergey.Semin@baikalelectronics.ru>
 <20201215173204.GA4072234@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201215173204.GA4072234@robh.at.kernel.org>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 11:32:04AM -0600, Rob Herring wrote:
> On Mon, Dec 14, 2020 at 12:15:56PM +0300, Serge Semin wrote:
> > Generic DW *MAC can be connected to an external Tramit and Receive clock
> 

> s/Tramit/Transmit/

Thanks. I'll fix it in v2.

-Sergey

> 
> > generators. Add the corresponding clocks description and clock-names to
> > the generic bindings schema so new DW *MAC-based bindings wouldn't declare
> > its own names of the same clocks.
> > 
> > Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > ---
> >  .../devicetree/bindings/net/snps,dwmac.yaml        | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > index e1ebe5c8b1da..74820f491346 100644
> > --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > @@ -126,6 +126,18 @@ properties:
> >            MCI, CSR and SMA interfaces run on this clock. If it's omitted,
> >            the CSR interfaces are considered as synchronous to the system
> >            clock domain.
> > +      - description:
> > +          GMAC Tx clock or so called Transmit clock. The clock is supplied
> > +          by an external with respect to the DW MAC clock generator.
> > +          The clock source and its frequency depends on the DW MAC xMII mode.
> > +          In case if it's supplied by PHY/SerDes this property can be
> > +          omitted.
> > +      - description:
> > +          GMAC Rx clock or so called Receive clock. The clock is supplied
> > +          by an external with respect to the DW MAC clock generator.
> > +          The clock source and its frequency depends on the DW MAC xMII mode.
> > +          In case if it's supplied by PHY/SerDes or it's synchronous to
> > +          the Tx clock this property can be omitted.
> >        - description:
> >            PTP reference clock. This clock is used for programming the
> >            Timestamp Addend Register. If not passed then the system
> > @@ -139,6 +151,8 @@ properties:
> >        enum:
> >          - stmmaceth
> >          - pclk
> > +        - tx
> > +        - rx
> >          - ptp_ref
> >  
> >    resets:
> > -- 
> > 2.29.2
> > 
