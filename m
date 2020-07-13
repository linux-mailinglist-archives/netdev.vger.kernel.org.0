Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1323721D8D5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729875AbgGMOoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:44:24 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:37599 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729703AbgGMOoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:44:23 -0400
Received: by mail-il1-f195.google.com with SMTP id r12so11375053ilh.4;
        Mon, 13 Jul 2020 07:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NGaGy7e/QItRe31Endu4HioF7kLqOnN7iiPvP2SlYbo=;
        b=jd0OK1FCp3v+0mxHLt+lgHtBH9z43TeqBIwh8LMlD4OqJ02W3O9MSQcwf6vboJ2XAw
         v59/Qp00iHy/esNneb9gUtNqlRptpdmKKzmFP7Z3O9Z6e24BEkPh9k5Nzm47F22sJy6i
         Pui540cr3+L7jGkTEu1nsYpvDxin1qrMZy63fg51I1G3OcuDH9g7PtwnGXcM0r279SQ0
         5XfIDIrun2RS4j7L1vlxUd35c8mO/hVpaicCp6mrILs+fq3jE3ZDROXzgicxWBkOXtXV
         rcRcsiQTZbi3BOICm947dv/405nsUs+1xTxat8FNXwtt9ZBmYl13kDLNR94QtLaCJ9wR
         N96g==
X-Gm-Message-State: AOAM533gyCkZHbGI+sJvrLwv1O5Vp/NizwcDgqtdzZBCx1s+9YUnQK2Z
        iC21SLbUMl14KipTWMjpmU5yjgJdMw==
X-Google-Smtp-Source: ABdhPJzT2ulZfmlrepEO40ag1dive2U1RS4bZA9xVjwFKHFnaBsgmAphymT1KzkyOOn0eSeOk+7lkA==
X-Received: by 2002:a92:5bdd:: with SMTP id c90mr30613ilg.154.1594651462800;
        Mon, 13 Jul 2020 07:44:22 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id o16sm8210750ilt.59.2020.07.13.07.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:44:22 -0700 (PDT)
Received: (nullmailer pid 154124 invoked by uid 1000);
        Mon, 13 Jul 2020 14:44:21 -0000
Date:   Mon, 13 Jul 2020 08:44:21 -0600
From:   Rob Herring <robh@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 8/8] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
Message-ID: <20200713144421.GA149051@bogus>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-9-kurt@linutronix.de>
 <92b7dca3-f56d-ecb1-59c2-0981c2b99dad@gmail.com>
 <87mu43ncaa.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mu43ncaa.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 08:45:33AM +0200, Kurt Kanzenbach wrote:
> On Sat Jul 11 2020, Florian Fainelli wrote:
> > On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
> >> Add basic documentation and example.
> >> 
> >> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> >> ---
> >>  .../bindings/net/dsa/hellcreek.yaml           | 132 ++++++++++++++++++
> >>  1 file changed, 132 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> >> 
> >> diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> >> new file mode 100644
> >> index 000000000000..bb8ccc1762c8
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> >> @@ -0,0 +1,132 @@
> >> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >> +%YAML 1.2
> >> +---
> >> +$id: http://devicetree.org/schemas/net/dsa/hellcreek.yaml#
> >> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >> +
> >> +title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
> >> +
> >> +allOf:
> >> +  - $ref: dsa.yaml#
> >> +
> >> +maintainers:
> >> +  - Andrew Lunn <andrew@lunn.ch>
> >> +  - Florian Fainelli <f.fainelli@gmail.com>
> >> +  - Vivien Didelot <vivien.didelot@gmail.com>
> >
> > Don't you want to add yourself here as well?
> 
> Sure.
> 
> >
> >> +
> >> +description:
> >> +  The Hellcreek TSN Switch IP is a 802.1Q Ethernet compliant switch. It supports
> >> +  the Pricision Time Protocol, Hardware Timestamping as well the Time Aware
> 
> s/Pricision/Precision/g;
> 
> >> +  Shaper.
> >> +
> >> +properties:
> >> +  compatible:
> >> +    oneOf:
> >> +      - const: hirschmann,hellcreek
> >> +
> >> +  reg:
> >> +    description:
> >> +      The physical base address and size of TSN and PTP memory base
> >
> > You need to indicate how many of these cells are required.
> 
> Yes.
> 
> >
> >> +
> >> +  reg-names:
> >> +    description:
> >> +      Names of the physical base addresses
> >
> > Likewise.
> >
> >> +
> >> +  '#address-cells':
> >> +    const: 1
> >> +
> >> +  '#size-cells':
> >> +    const: 1
> >
> > Humm, not sure about those, you do not expose a memory mapped interface
> > bus from this switch to another sub node.
> 
> True. That might be even different for other SoCs.
> 
> >
> >> +
> >> +  leds:
> >> +    type: object
> >> +    properties:
> >> +      '#address-cells':
> >> +        const: 1
> >> +      '#size-cells':
> >> +        const: 0
> >> +
> >> +    patternProperties:
> >> +      "^led@[0-9]+$":
> >> +          type: object
> >> +          description: Hellcreek leds
> >> +
> >> +          properties:
> >> +            reg:
> >> +              items:
> >> +                - enum: [0, 1]
> >> +              description: Led number
> >> +
> >> +            label:
> >> +              description: Label associated with this led
> >> +              $ref: /schemas/types.yaml#/definitions/string
> >> +
> >> +            default-state:
> >> +              items:
> >> +                enum: ["on", "off", "keep"]
> >> +              description: Default state for the led
> >> +              $ref: /schemas/types.yaml#/definitions/string
> >> +
> >> +          required:
> >> +            - reg
> >
> > Can you reference an existing LED binding by any chance?
> 
> Yes, we should reference leds/common.yaml somehow. Looking at
> leds-gpio.yaml for example, it should be possible like this:
> 
> patternProperties:
>   "^led@[0-9]+$":
>       type: object
>       description: Hellcreek leds
> 
>       $ref: ../../leds/common.yaml#
> 
>       [...]
> 
> But, how to express that only label and default-state should be used?

properties:
  label: true
  default-state: true

additionalProperties: false
