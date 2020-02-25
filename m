Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3942216EE2C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 19:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgBYSkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 13:40:04 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35123 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731502AbgBYSkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 13:40:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id m3so264080wmi.0;
        Tue, 25 Feb 2020 10:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=feAL21K5KyQooD4Dct/J2LgVGWzU4vdAa6CeFCmcjfo=;
        b=eyHv0N8X4mYVdB/JLOAbKaWUiTwdA1GhsnRxkfBZnYkw7AtaMhL7rqrajCubVKn7ny
         3BDX09hTwlqazgI7AUtjqmj09Pn9IoohJaA+GYE3iYx3FwCt66bsHOPxM+ag9/fAEOwi
         BDe3exw4DenI7EmRulnRSmeCWHZT4zdgMD4Hui18X1nlLRsBZVXaTNSr3U22p4Nrsl6/
         WjeF56LmWzh62DKceeMyGjZDUcfHQaVSt8LQscuJeVXOxywOX8yPaLZpNywrocUyeiKP
         AhCoLqHrndHV8RK6ajFPOnRnWBkfO/ynztO6nCEayUxA1vJDtN0OPm/uyUmgkypbyLjI
         UB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=feAL21K5KyQooD4Dct/J2LgVGWzU4vdAa6CeFCmcjfo=;
        b=hQ9bduo8w1T82ToMHjKcVDqEgm0LEt5DakFaLHsBBrOord7tNNOWO//dhSDNnGRadp
         IyGsFuGGEzuaZMHzsD/jobCG5+g+6soT9sIoirwCdGntA5acNTC+fu+50hmM/xmU+pcQ
         Ap1dA4sW8gAmN/0ZLetDV5zho6/SQB1hzkSnbmec5x4MXVvjvUF4Aq3Wyb3dP0JBH6b5
         ZdrqnCtBEYcghZdaetj5cbiSO5NMVjtX993dNHTj+MZwWGwtXWgYmLxfQ6+z6j8NIAPx
         aaXdbMRAAEv8rzQmZPoTDyJ6xSOr5k+9bMAb3kXFpqhNv2lWLVXj6/2CLwWyyU72L/z8
         6thw==
X-Gm-Message-State: APjAAAWuzDP0eMOKYKcvkZRO1hcj2f9+O5wPhAzF5ADT3Cvu7DsZlmVN
        G2pWiX5FT9MxDCrv0iafc8E=
X-Google-Smtp-Source: APXvYqxkUbC3nFV7VQ8Rme8IvHtqfkWKRCuZgFFg5eoAcloLZmRp5cJ0Askhj8hpJax4US6yo8+V/Q==
X-Received: by 2002:a1c:3803:: with SMTP id f3mr587833wma.134.1582656000717;
        Tue, 25 Feb 2020 10:40:00 -0800 (PST)
Received: from AnsuelXPS (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.gmail.com with ESMTPSA id x7sm24416640wrq.41.2020.02.25.10.39.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 10:39:59 -0800 (PST)
From:   <ansuelsmth@gmail.com>
To:     "'Rob Herring'" <robh+dt@kernel.org>
Cc:     "'Andy Gross'" <agross@kernel.org>,
        "'Bjorn Andersson'" <bjorn.andersson@linaro.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Florian Fainelli'" <f.fainelli@gmail.com>,
        "'Heiner Kallweit'" <hkallweit1@gmail.com>,
        "'Russell King'" <linux@armlinux.org.uk>,
        "'linux-arm-msm'" <linux-arm-msm@vger.kernel.org>,
        "'netdev'" <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200224211035.16897-1-ansuelsmth@gmail.com> <20200224211035.16897-2-ansuelsmth@gmail.com> <CAL_JsqL7hAX81hDg8L24n-xpJGzZLEu+kAvJfw=g2pzEo_LPOw@mail.gmail.com>
In-Reply-To: <CAL_JsqL7hAX81hDg8L24n-xpJGzZLEu+kAvJfw=g2pzEo_LPOw@mail.gmail.com>
Subject: R: [PATCH v7 2/2] Documentation: devictree: Add ipq806x mdio bindings
Date:   Tue, 25 Feb 2020 19:39:59 +0100
Message-ID: <007601d5ec0a$fc80df70$f5829e50$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: it
Thread-Index: AQMEm6ZQ0XHBfC/w6iKFBoKEX66FxAGLDSBGAdvCRiqls6b/QA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Feb 24, 2020 at 3:10 PM Ansuel Smith <ansuelsmth@gmail.com>
> wrote:
> >
> 
> typo in the subject. Use 'dt-bindings: net: ...' for the subject prefix.
> 
> > Add documentations for ipq806x mdio driver.
> >
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> > Changes in v7:
> > - Fix dt_binding_check problem
> 
> Um, no you didn't...
> 

Does make dt_check_binding still gives errors? 
If yes can you give me some advice on how to test only this since it gives me
errors on checking other upstream Documentation ? 
I will fix the other problem in v8. Sorry for the mess and thanks.

> >
> >  .../bindings/net/qcom,ipq8064-mdio.yaml       | 55
> +++++++++++++++++++
> >  1 file changed, 55 insertions(+)
> >  create mode 100644
> Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-
> mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-
> mdio.yaml
> > new file mode 100644
> > index 000000000000..3178cbfdc661
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-
> mdio.yaml
> > @@ -0,0 +1,55 @@
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> 
> Dual license new bindings please:
> 
> (GPL-2.0-only OR BSD-2-Clause)
> 
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/qcom,ipq8064-mdio.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Qualcomm ipq806x MDIO bus controller
> > +
> > +maintainers:
> > +  - Ansuel Smith <ansuelsmth@gmail.com>
> > +
> > +description: |+
> 
> Don't need '|+' unless you need specific formatting.
> 
> > +  The ipq806x soc have a MDIO dedicated controller that is
> > +  used to comunicate with the gmac phy conntected.
> > +  Child nodes of this MDIO bus controller node are standard
> > +  Ethernet PHY device nodes as described in
> > +  Documentation/devicetree/bindings/net/phy.txt
> > +
> > +allOf:
> > +  - $ref: "mdio.yaml#"
> > +
> > +properties:
> > +  compatible:
> > +    const: qcom,ipq8064-mdio
> 
> blank line between properties please.
> 
> > +  reg:
> > +    maxItems: 1
> > +    description: address and length of the register set for the device
> 
> That's every 'reg', you can drop this.
> 
> > +  clocks:
> > +    maxItems: 1
> > +    description: A reference to the clock supplying the MDIO bus
> controller
> 
> That's every 'clocks', you can drop this.
> 
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - clocks
> > +  - "#address-cells"
> > +  - "#size-cells"
> > +
> > +examples:
> > +  - |
> > +    mdio0: mdio@37000000 {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        compatible = "qcom,ipq8064-mdio", "syscon";
> 
> 'syscon' doesn't match the schema and is wrong.
> 
> > +        reg = <0x37000000 0x200000>;
> 
> > +        resets = <&gcc GMAC_CORE1_RESET>;
> > +        reset-names = "stmmaceth";
> 
> Not documented.
> 
> > +        clocks = <&gcc GMAC_CORE1_CLK>;
> 
> You need to include the header for these defines.
> 
> > +
> > +        switch@10 {
> > +            compatible = "qca,qca8337";
> > +            /* ... */
> > +        };
> > +    };
> > --
> > 2.25.0
> >

