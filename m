Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7535CFCB
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244029AbhDLRuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:50:18 -0400
Received: from mail-oo1-f54.google.com ([209.85.161.54]:44613 "EHLO
        mail-oo1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238145AbhDLRuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 13:50:17 -0400
Received: by mail-oo1-f54.google.com with SMTP id p2-20020a4aa8420000b02901bc7a7148c4so3219220oom.11;
        Mon, 12 Apr 2021 10:49:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bFCs+VpPyphB2HOiiJJru9pRy8xratHPzgF28m8aMpo=;
        b=eWmdhNexzswXIYBAGvB7gNcD8tkf1THk3qltjNB9vBeCQVNGm5CMEW7mZ6hwiHah1O
         CxSPM/TzfHBk5bN/HcVl2eGjYNJWn6Mv8Uy8bf9ZBGIw7izF/OM/hp85l1Bghicfe2nz
         fgVWrHbBcrBbWG0KdG0pNx4RHfmWsTjDFsgY5UdlDT35o7rcBSVqIXt9iaP4Nug7AirF
         lqpleG9Y2c4gchiViIF4bZlv4HosagYGtKxgVA8/Os+6/0F2scP4TtXHjisvTzLgP+xj
         4K/3zu0EZ6PZWUmFZKwcwr9hgBEqhyNIwVzRNtSZEv5wLEXgLkpuH6TIbmONxKB0OyQ6
         TAIA==
X-Gm-Message-State: AOAM532MK6uSrF9T3pUUngqflvHMANGjFT6voMIAleMJrCn8Dlgsdju5
        0z+f0q8NFJoi4OC81Ul0ZQ==
X-Google-Smtp-Source: ABdhPJzYjjV91KasGRlpdX2d8GjTfvG8l5nL7+XHdF2vj7lCJ8IP3juCXaE7zPb2z5C2tsbupG+PCw==
X-Received: by 2002:a4a:6b04:: with SMTP id g4mr23753024ooc.78.1618249798739;
        Mon, 12 Apr 2021 10:49:58 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 3sm2791398otw.58.2021.04.12.10.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 10:49:57 -0700 (PDT)
Received: (nullmailer pid 4108783 invoked by uid 1000);
        Mon, 12 Apr 2021 17:49:56 -0000
Date:   Mon, 12 Apr 2021 12:49:56 -0500
From:   Rob Herring <robh@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: Re: [PATCH 1/4] dt-bindings: phy: Add binding for TI TCAN104x CAN
 transceivers
Message-ID: <20210412174956.GA4049952@robh.at.kernel.org>
References: <20210409134056.18740-1-a-govindraju@ti.com>
 <20210409134056.18740-2-a-govindraju@ti.com>
 <f9b04d93-c249-970e-3721-50eb268a948f@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9b04d93-c249-970e-3721-50eb268a948f@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 12:19:30PM +0200, Marc Kleine-Budde wrote:
> On 4/9/21 3:40 PM, Aswath Govindraju wrote:
> > Add binding documentation for TI TCAN104x CAN transceivers.
> > 
> > Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> > ---
> >  .../bindings/phy/ti,tcan104x-can.yaml         | 56 +++++++++++++++++++
> >  1 file changed, 56 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> > new file mode 100644
> > index 000000000000..4abfc30a97d0
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> > @@ -0,0 +1,56 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/phy/ti,tcan104x-can.yaml#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > +
> > +title: TCAN104x CAN TRANSCEIVER PHY
> > +
> > +maintainers:
> > +  - Aswath Govindraju <a-govindraju@ti.com>
> > +
> > +properties:
> > +  $nodename:
> > +    pattern: "^tcan104x-phy"
> > +
> > +  compatible:
> > +    enum:
> > +      - ti,tcan1042
> > +      - ti,tcan1043
> 
> Can you create a generic standby only and a generic standby and enable transceiver?

As a fallback compatible fine, but no generic binding please. A generic 
binding can't describe any timing requirements between the 2 GPIO as 
well as supplies when someone wants to add those (and they will).

> 
> > +
> > +  '#phy-cells':
> > +    const: 0
> > +
> > +  standby-gpios:
> > +    description:
> > +      gpio node to toggle standby signal on transceiver
> > +    maxItems: 1
> > +
> > +  enable-gpios:
> > +    description:
> > +      gpio node to toggle enable signal on transceiver
> > +    maxItems: 1
> > +
> > +  max-bitrate:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> > +    description:
> > +      max bit rate supported in bps

We already have 'max-speed' for serial devices, use that.

> > +    minimum: 1
> > +
> > +required:
> > +  - compatible
> > +  - '#phy-cells'
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    transceiver1: tcan104x-phy {
> > +      compatible = "ti,tcan1043";
> > +      #phy-cells = <0>;
> > +      max-bitrate = <5000000>;
> > +      standby-gpios = <&wakeup_gpio1 16 GPIO_ACTIVE_LOW>;
> > +      enable-gpios = <&main_gpio1 67 GPIO_ACTIVE_LOW>;
> > +    };
> > 
> 
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
> 



