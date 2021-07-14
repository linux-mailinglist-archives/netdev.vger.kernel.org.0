Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20AE3C948D
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 01:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbhGNXhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 19:37:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55936 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhGNXhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 19:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u3G6BqU7sSMT895PvjPmJ0ASSYFzAHrjU4wEyV1BmdY=; b=hP9ehzbID+IVy9Aw0/yLGjRoaq
        lRL7RcIK1YEbdc3CfsHRXqORDJr6p3hIiP0f7ko9V0UoTQOdxJLX3BHW5k7NlKYJWglPgLH+Rn+xy
        an55p1eLPcNCmz0EjIh969LWUTnJxCxXNT4D6L2WDA1EK35IW6Md909IlpRTxGItzGIw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3oOL-00DQaS-Tq; Thu, 15 Jul 2021 01:34:13 +0200
Date:   Thu, 15 Jul 2021 01:34:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rob Herring <robh@kernel.org>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V1 net-next 2/5] dt-bindings: fec: add RGMII delayed
 clock property
Message-ID: <YO90dbgVtqR2rRAK@lunn.ch>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
 <20210709081823.18696-3-qiangqing.zhang@nxp.com>
 <20210714231937.GC3723991@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714231937.GC3723991@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 05:19:37PM -0600, Rob Herring wrote:
> On Fri, Jul 09, 2021 at 04:18:20PM +0800, Joakim Zhang wrote:
> > From: Fugang Duan <fugang.duan@nxp.com>
> > 
> > Add property for RGMII delayed clock.
> > 
> > Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
> > Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> > ---
> >  Documentation/devicetree/bindings/net/fsl-fec.txt | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
> > index 6754be1b91c4..f93b9552cfc5 100644
> > --- a/Documentation/devicetree/bindings/net/fsl-fec.txt
> > +++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
> > @@ -50,6 +50,10 @@ Optional properties:
> >      SOC internal PLL.
> >    - "enet_out"(option), output clock for external device, like supply clock
> >      for PHY. The clock is required if PHY clock source from SOC.
> > +  - "enet_2x_txclk"(option), for RGMII sampleing clock which fixed at 250Mhz.
> > +    The clock is required if SOC RGMII enable clock delay.
> > +- fsl,rgmii_txc_dly: add RGMII TXC delayed clock from MAC.
> > +- fsl,rgmii_rxc_dly: add RGMII RXC delayed clock from MAC.
> 
> Don't we have standard properties for this?

Yes, rx-internal-delay-ps and tx-internal-delay-ps defined in
ethernet-controller.yaml

     Andrew
