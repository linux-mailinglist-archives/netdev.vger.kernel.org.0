Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CBD3165A5
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhBJLuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:50:37 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:14715 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhBJLsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:48:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612957701; x=1644493701;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9diNDRqQHFEjVdCdXqYmIwlaA+jvd0iVcd4+rjBiIks=;
  b=GtwOBdveErlu+ERoE84axo2ar+t30sLhdOvSx6EwQGMJTcvKo0Wg4aY8
   ejdcqgejML6qGS5+37wVGLToi+Cmd+kAxIpcd1GAvMz1DhHASlEPOlHe7
   nkk5vpqwqg22sWIJv0fvlfMAgKsllzivS0l2JRM+jYXY2dxLj7R1Cihku
   gsh52vCj2O0vnSkFFQOiSSiDm25yuza06Hz647ZbZb+YH9bgm5dNotsoZ
   s7NYfG9JzLt7CwyUoHfjKN+LNH+iOMBoQtvoPdQ9yULxOsztsqYWaUlfm
   8ASWfEHA9dqQNPwmHDI58Nz8piv2be+eAc+4oI699N/AoiwazPpfxVt+Q
   A==;
IronPort-SDR: C/yerYggcc94jp9199Q0gtGSIRD0uRmUqh5NSFwjeLOjk0fVGi8cHj4tsUj7OE/2KgSKcy3B9e
 6po4ufSk++LmlYIUvfQOPNMMxF61MHhHoRiYqkYWHc4ScSN8jrniRRA11QVQAQVpbcgDAUfS6f
 iUqPzmjHkB/V5pjZBnDa+7AV68QtXy2TgJzSxnMUzbCawSvvMiYHq2gnU/VyZunZetfJLA5Kfh
 PW2ZTlb1U3VtF68y0Myva9IdD1mvel67/SCKPk4ogeBfnj2FEm5LjHMgDc39UDIr26VLIRrOzS
 +S0=
X-IronPort-AV: E=Sophos;i="5.81,168,1610434800"; 
   d="scan'208";a="109198247"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2021 04:47:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 04:46:55 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 10 Feb 2021 04:46:51 -0700
Message-ID: <6531ab6c7e40b7e2f73a6087b31ecfe0a8f214e4.camel@microchip.com>
Subject: Re: [PATCH net-next 1/8] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
From:   Prasanna Vengateshan Varadharajan 
        <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Date:   Wed, 10 Feb 2021 17:16:49 +0530
In-Reply-To: <20210130020227.ahiee4goetpp2hb7@skbuf>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
         <20210128064112.372883-2-prasanna.vengateshan@microchip.com>
         <20210130020227.ahiee4goetpp2hb7@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-30 at 04:02 +0200, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
Thanks for your time on reviewing the patch series.

> On Thu, Jan 28, 2021 at 12:11:05PM +0530, Prasanna Vengateshan wrote:
> > +  spi-max-frequency:
> > +    maximum: 50000000
> 
> And it actually works at 50 MHz? Cool.
Yes.

> 
> > +
> > +  reset-gpios:
> > +    description: Optional gpio specifier for a reset line
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +unevaluatedProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    //Ethernet switch connected via spi to the host, CPU port
> > wired to eth1
> > +    eth1 {
> 
> So if you do bother to add the DSA master in the example, can this be
> &eth1 so that we could associate with the phandle below?
Sure.

> 
> > +      #address-cells = <1>;
> > +      #size-cells = <0>;
> > +
> > +      fixed-link {
> > +        speed = <1000>;
> > +        full-duplex;
> > +      };
> > +    };
> > +
> > +    spi1 {
> 
> Is this a label or a node name? spi1 or spi@1?
This is a label.

> 
> > +      #address-cells = <1>;
> > +      #size-cells = <0>;
> > +      pinctrl-0 = <&pinctrl_spi_ksz>;
> > +      cs-gpios = <0>, <0>, <0>, <&pioC 28 0>;
> > +      id = <1>;
> 
> I know this is the SPI controller and thus mostly irrelevant, but
> what
> is "id = <1>"?
id is not needed, i will remove it.

> 
> > +
> > +      lan9374: switch@0 {
> > +        compatible = "microchip,lan9374";
> > +        reg = <0>;
> > +
> > +        spi-max-frequency = <44000000>;
> > +
> > +        ethernet-ports {
> > +          #address-cells = <1>;
> > +          #size-cells = <0>;
> > +          port@0 {
> > +            reg = <0>;
> > +            label = "lan1";
> > +          };
> > +          port@1 {
> > +            reg = <1>;
> > +            label = "lan2";
> > +          };
> > +          port@2 {
> > +            reg = <7>;
> 
> reg should match node index (port@2), here and everywhere below. As
> for
> the net device labels, I'm not sure if the mismatch is deliberate
> there.
reg & port node indexes are different here because to match with the
 physical to logical port mapping done in the LAN9374. I realized that
the description is missing and that is to be added. However, should reg
& port node index match for the net dev? 
If it should be the same, then the same can be acheived by renaming a
label (lanx) as well.

> 
> > +            label = "lan3";
> > +          };
> > +          port@3 {
> > +            reg = <2>;
> > +            label = "lan4";
> > +          };
> > +          port@4 {
> > +            reg = <6>;
> > +            label = "lan5";
> > +          };
> > +          port@5 {
> > +            reg = <3>;
> > +            label = "lan6";
> > +          };
> > +          port@6 {
> > +            reg = <4>;
> > +            label = "cpu";
> 
> label for CPU port is not needed/used.
Sure, will remove it.

> 
> > +            ethernet = <&eth1>;
> > +            fixed-link {
> > +              speed = <1000>;
> > +              full-duplex;
> > +            };
> > +          };
> > +          port@7 {
> > +            reg = <5>;
> > +            label = "lan7";
> > +            fixed-link {
> > +              speed = <1000>;
> > +              full-duplex;
> > +            };
> > +          };
> > +        };
> > +      };
> > +    };

