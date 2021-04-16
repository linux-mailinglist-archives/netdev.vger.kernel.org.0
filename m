Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE7C36285F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242426AbhDPTLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:11:34 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:46878 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbhDPTLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 15:11:33 -0400
Received: by mail-ot1-f45.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso24763465otb.13;
        Fri, 16 Apr 2021 12:11:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7kkTDXKovXIYC5vNheXczRDZhYQJOa8QXII+sZNZW1U=;
        b=BA+0EKkJYIIL1l5o/3rZVQoL8tiRg/3+6PiGrjosPrhBfcolMaFcoxpxeaFVNh1wyy
         4mjWjJw5NvVRS5g5JtRCpT0BKMCVqHSLWDP5lYchm45+sZ6W8CnxpISJoSz39Xfg51O0
         iNcBMbjQE/DnqDSgblUTEOtsrQ7iSm8mwns6PFRnNBqRlLvw36HeVdfJJDeO5cJcQ5ud
         4+k/wHmKLMp3fwYsQUS4ZbQHOs8mKUwFlDSdYmMrS246j5ntGxw6osOyF0LgZTzAo9id
         dkh0LmFmdkM1OrrqIQZRJa+uUqq7Ghq45x18umh+Bs2ag07oyp7gefTVhh9XQG3Axm9s
         NIhA==
X-Gm-Message-State: AOAM5332KN9BunCH6xclUbSVRk/8RQjWqNmg2LshrHC1TXsCjKUsGZRN
        Raobhar8YQEnnKnZvMaZbg==
X-Google-Smtp-Source: ABdhPJyXHTioo0D1PWDv8uhr84Ecya6KUrH26PwVEjr9f3PEJkrt8iUeVlzVy7Zf8FxASveORI8/Gg==
X-Received: by 2002:a05:6830:10:: with SMTP id c16mr4809791otp.48.1618600267611;
        Fri, 16 Apr 2021 12:11:07 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id t4sm246593oie.27.2021.04.16.12.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 12:11:05 -0700 (PDT)
Received: (nullmailer pid 3776346 invoked by uid 1000);
        Fri, 16 Apr 2021 19:11:04 -0000
Date:   Fri, 16 Apr 2021 14:11:04 -0500
From:   Rob Herring <robh@kernel.org>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v5 net-next 10/10] dt-bindings: net: korina: Add DT
 bindings for IDT 79RC3243x SoCs
Message-ID: <20210416191104.GB3770043@robh.at.kernel.org>
References: <20210416085207.63181-1-tsbogend@alpha.franken.de>
 <20210416085207.63181-11-tsbogend@alpha.franken.de>
 <ca4d9975-c153-94c9-dec8-bf9416c76b45@gmail.com>
 <20210416133536.GA10451@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416133536.GA10451@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 03:35:36PM +0200, Thomas Bogendoerfer wrote:
> On Fri, Apr 16, 2021 at 12:29:46PM +0300, Sergei Shtylyov wrote:
> > On 16.04.2021 11:52, Thomas Bogendoerfer wrote:
> > 
> > > Add device tree bindings for ethernet controller integrated into
> > > IDT 79RC3243x SoCs.
> > > 
> > > Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > > ---
> > >   .../bindings/net/idt,3243x-emac.yaml          | 74 +++++++++++++++++++
> > >   1 file changed, 74 insertions(+)
> > >   create mode 100644 Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> > > new file mode 100644
> > > index 000000000000..3697af5cb66f
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> > > @@ -0,0 +1,74 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/idt,3243x-emac.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: IDT 79rc3243x Ethernet controller
> > > +
> > > +description: Ethernet controller integrated into IDT 79RC3243x family SoCs
> > > +
> > > +maintainers:
> > > +  - Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > > +
> > > +allOf:
> > > +  - $ref: ethernet-controller.yaml#
> > > +
> > > +properties:
> > > +  compatible:
> > > +    const: idt,3243x-emac
> > > +
> > > +  reg:
> > > +    maxItems: 3
> > > +
> > > +  reg-names:
> > > +    items:
> > > +      - const: korina_regs
> > > +      - const: korina_dma_rx
> > > +      - const: korina_dma_tx
> > > +
> > > +  interrupts:
> > > +    items:
> > > +      - description: RX interrupt
> > > +      - description: TX interrupt
> > > +
> > > +  interrupt-names:
> > > +    items:
> > > +      - const: korina_rx
> > > +      - const: korina_tx
> > > +
> > > +  clocks:
> > > +    maxItems: 1
> > > +
> > > +  clock-names:
> > > +    items:
> > > +      - const: mdioclk
> > > +
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +  - reg-names
> > > +  - interrupts
> > > +  - interrupt-names
> > > +
> > > +additionalProperties: false
> > > +
> > > +examples:
> > > +  - |
> > > +
> > > +    ethernet@60000 {
> > > +        compatible = "idt,3243x-emac";
> > > +
> > > +        reg = <0x60000 0x10000>,
> > > +              <0x40000 0x14>,
> > > +              <0x40014 0x14>;
> > > +        reg-names = "korina_regs",
> > > +                    "korina_dma_rx",
> > > +                    "korina_dma_tx";
> > > +
> > > +        interrupts-extended = <&rcpic3 0>, <&rcpic3 1>;
> > 
> >    You use this prop, yet don't describe it?
> 
> that's just interrupt-parent and interrupts in one statement. And since
> make dt_binding_check didn't complained I thought that's good this way.
> Rob, do I need to describe interrupts-extended as well ?

No, the tooling handles both cases. What the parent is is outside the 
scope of a binding.

> I could change that to interrupt-parent/interrupts as the driver no
> longer uses dma under/overrun interrupts, which have a different
> interrupt-parent.

Humm, you should be describing the interrupt connections the h/w block 
has, not what the driver uses (today) or not.

Rob
