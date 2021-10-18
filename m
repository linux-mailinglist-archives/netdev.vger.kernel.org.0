Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080F04325D4
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhJRSDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:03:03 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:39716 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhJRSDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:03:02 -0400
Received: by mail-oi1-f173.google.com with SMTP id m67so904102oif.6;
        Mon, 18 Oct 2021 11:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fJW+JPWEfavDVityhwlsFWcBG/x4wTATfK/QnHQWFdU=;
        b=VtrkeaTzApa9g4wXc64SVOr7nDcMg4gZONPqXXXoe2J3DPW8JfFNWNtZwqzqMihKqc
         vyrYGaYQN2ekAPYGvOAR2P8wgMY9FvvBMaWDGpH407PfbTjloSrWRfW2wyK8jzmEXIxJ
         N4S4OQDBY9VrvK1Et05klmN9v1eu+q/17RFOaiMOWDZOjaJcLFd1Ty+G4OKbvdgB8T19
         agjEhL7CN05Ou2Y58lJPHoyK0g2ompUcD4xcNOxcOHFeacAN9se3Gbgo46rMLLfYtiyx
         NXwRRpKTImpRr/PyOdbILjx3jIT+VbCUaicO0dL7t07mcTQjgkytC7Br6rEXjiHxRdGb
         qkmg==
X-Gm-Message-State: AOAM530ObzdZG1rcBQ+u1wr3+gegQ115HnZ+Y4AsttJtfTlV/aSmMyjS
        39t+5XX3KK200co/A3tQCw==
X-Google-Smtp-Source: ABdhPJx0zMKQn0IsUB6FiRV3VCu0QuhyImdpIY9W6aijL2TTnDHJplBHXgjLwQiM85yFBPL95REEQA==
X-Received: by 2002:a05:6808:14d6:: with SMTP id f22mr310894oiw.152.1634580050834;
        Mon, 18 Oct 2021 11:00:50 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id p133sm3049367oia.11.2021.10.18.11.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 11:00:50 -0700 (PDT)
Received: (nullmailer pid 2662534 invoked by uid 1000);
        Mon, 18 Oct 2021 18:00:48 -0000
Date:   Mon, 18 Oct 2021 13:00:48 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        netdev@vger.kernel.org, olteanv@gmail.com,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 net-next 01/10] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <YW22UEelVFoNVYrG@robh.at.kernel.org>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
 <20211007151200.748944-2-prasanna.vengateshan@microchip.com>
 <YV9pk13TT9W7X2i1@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV9pk13TT9W7X2i1@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 11:41:39PM +0200, Andrew Lunn wrote:
> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    //Ethernet switch connected via spi to the host
> > +    ethernet {
> > +      #address-cells = <1>;
> > +      #size-cells = <0>;
> > +
> > +      fixed-link {
> > +        speed = <1000>;
> > +        full-duplex;
> > +      };
> > +    };
> > +
> > +    spi {
> > +      #address-cells = <1>;
> > +      #size-cells = <0>;
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
> > +            phy-mode = "internal";
> > +            phy-handle = <&t1phy0>;
> > +          };
> 
> ...
> 
> > +        mdio {
> > +          #address-cells = <1>;
> > +          #size-cells = <0>;
> > +
> > +          t1phy0: ethernet-phy@0{
> > +            reg = <0x0>;
> > +          };
> 
> Does this pass Rob's DT schema proof tools? You don't have any
> description of the mdio properties.

Good catch. It will pass ATM only because 'unevaluatedProperties' is not 
yet implemented (should be in place soon). So it needs:

mdio:
  $ref: /schemas/net/mdio.yaml#
  unevaluatedProperties: false

Otherwise, this looks fine.

Rob
