Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96BF222EB6
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgGPXKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgGPXJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:09:20 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D293C08C5E3;
        Thu, 16 Jul 2020 15:38:26 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id br7so8462405ejb.5;
        Thu, 16 Jul 2020 15:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LmdF87AgMThrWVMnKDsPrAO+JtBMhojr7BAJuj4Mos4=;
        b=B/RPdWvQDiakdK6Rsjt4FftXkqJwuPOHipdMdoDczJI6xEo/Yf0yPur7/sRo32E+zw
         BkU4vwctVyFhUWohOj+WYAxWNzSRRfqR5QSJph4gN7VeSFffiVQBEtdDkfyeOS1Ih598
         QlfGI/HQ/sEpLLQxJMJgQMB0fZlH1OCEL0bTCK0QDQfTgTzCKMr2YmzF+PAdWY8hyeJq
         qHA5FbWo2GZFjSeQE3eZMYMB09MYnMxWhDPk2Qdc4RMIffPBYQ+QNIXUdf3w4r2xkRHR
         lLuhgsC7e8e13TLM+t3cPhqU4Ci2T/HhWMoX29cyKkFSZPdy2D9F4rD5PP6vuduiuHn8
         ECxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LmdF87AgMThrWVMnKDsPrAO+JtBMhojr7BAJuj4Mos4=;
        b=iI48WuQw9+ekELFUV1EpJ/TeM4UeiLhSkgQIKM+EmYVhdVcQ0svserVwJQVX+6sqrx
         zcpO+Qp23Zv0PI2vp6kZQDMJsIUHnApiPlkg9vInIAhBe4GTe8ItadvASCLvilqJFPI1
         F9DCWqs9vK+Q5yiIzNCWIb2MBheZyjz/DrXMKqpdRx7YVxKSk6J9Ln1W4QNFDwkcZj+Z
         nwmKG9S1JhxqA2ajuoRmkDiy6zcwiudER12L6W/7ttpXWnZbf/2yVesu607aocO5pq/1
         vkkCVM+dpweo79MWM+qPD32e3blpm2cvj6XpU3L7o4/uq2fm81CZwp3cb+nrtwzG50ln
         fl2Q==
X-Gm-Message-State: AOAM5322Vo4dn12nrB9aE4sEc2EpsD3s9TFK/IyX+eq6vPrKTb0+7a96
        k8FukaKNzKPNaUdlrzJhAdU=
X-Google-Smtp-Source: ABdhPJzapfHHGhirfMsPtF3vhw+bi57Qr2t0qUC2pIbXuSMdeTeBYSATfLh5F/krFsl8XJs1du6ucg==
X-Received: by 2002:a17:906:82d2:: with SMTP id a18mr5751822ejy.522.1594939105148;
        Thu, 16 Jul 2020 15:38:25 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bm21sm6077578ejb.13.2020.07.16.15.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 15:38:24 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:38:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Matthew Hagan <mnhagan88@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
Message-ID: <20200716223822.yptldqqn36fbp2i7@skbuf>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 03:09:25PM -0700, Jakub Kicinski wrote:
> On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
> > Add names and decriptions of additional PORT0_PAD_CTRL properties.
> > 
> > Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> > ---
> >  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > index ccbc6d89325d..3d34c4f2e891 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> > @@ -13,6 +13,14 @@ Optional properties:
> >  
> >  - reset-gpios: GPIO to be used to reset the whole device
> >  
> > +Optional MAC configuration properties:
> > +
> > +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
> 
> Perhaps we can say a little more here?
> 
> > +- qca,sgmii-rxclk-falling-edge:	If present, sets receive clock phase to
> > +				falling edge.
> > +- qca,sgmii-txclk-falling-edge:	If present, sets transmit clock phase to
> > +				falling edge.
> 
> These are not something that other vendors may implement and therefore
> something we may want to make generic? Andrew?
> 

It was asked before whether this device uses source-synchronous clock
for SGMII or if it recovers the clock from the data stream. Just "pass"
was given for a response.

https://patchwork.ozlabs.org/project/netdev/patch/8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li/

One can, in principle, tell easily by examining schematics. If the SGMII
is only connected via RX_P, RX_N, TX_P, TX_N (and optionally there might
be external reference clocks for the SERDES lanes, but these are not
part of the data connection itself), then the clock is recovered from
the serial data stream, and we have no idea what "SGMII delays" are.

If the schematic shows 2 extra clock signals, one in each transmit
direction, then this is, in Russell King's words, "a new world of RGMII
delay pain but for SGMII". In principle I would fully expect clock skews
to be necessary for any high-speed protocol with source-synchronous
clocking. The problem, really, is that we aren't ready to deal with this
properly. We aren't distinguishing "SGMII with clock" from "SGMII
without clock" in any way. We have no idea who else is using such a
thing. Depending on the magnitude of this new world, it may be wise to
let these bindings go in as-is, or do something more kernel-wide...

One simple question to ask Matthew is what are you connecting to these
SGMII lanes, and if you need any special configuration on the other end
of those lanes too (and what is the configuration you are using on the
qca8k: enable the "SGMII delays" in both directions?).

> >  Subnodes:
> >  
> >  The integrated switch subnode should be specified according to the binding
> 

Thanks,
-Vladimir
