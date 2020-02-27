Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1190172AB0
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 23:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgB0WB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 17:01:58 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39115 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbgB0WB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 17:01:58 -0500
Received: by mail-wm1-f67.google.com with SMTP id c84so1092188wme.4;
        Thu, 27 Feb 2020 14:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=DZXI7uvvOw0fNdSg04a7D3gbzl4O/eHHrwdgk0aaqJE=;
        b=qcTMvEgnxEKV4piO6AHz5L7oRN0JLeSuOXxP106XCYDKH09gIrroqn7rSfi287p0Wi
         D4FnP5B3QV+mcghGyJNUbZXS1rbfCkppw2DtmlnQTCC2eAufS+i8q/1hFKOKlqGzKGOW
         1IVKGWdjTZfSHTDMGqqTaIPqcpwa2bTTy0zU3gQoTPZuffAmZEToLTVFl8ivGLL7B+Jh
         3MSUc/c6EAC8wJXc2B8Z/AB/aVwj36MrkGh7J0FrjMAh277nOhpy5ZupXbCTBq1/NhRf
         WN6mKmsR5Tsl335zKCvdVL4llYeh7rdgyI4bhhjG+XE6eBv1Klc6GEw4F+l5aqRsRwXB
         NSDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:in-reply-to:subject:date
         :message-id:mime-version:content-transfer-encoding:content-language
         :thread-index;
        bh=DZXI7uvvOw0fNdSg04a7D3gbzl4O/eHHrwdgk0aaqJE=;
        b=Hr7mZ035tS76RLMQ0TXU9xtSB8Mnj1TgpmSQ6WWeCPCMBqJLu0HFVoigB49WAZuHUv
         q+pNIV3yn4gMW01Vs+SALCKwOO22bDq/2yNTvfJh3eCwqgAngRe+P/Wy893Pw21As+dG
         dVb8rGoDFArGzJRMi2L3/1rsIg/LkQR6MqdkV6vFSV736atk52Dxltud+f25Rz534Yws
         TP8rilKhQejv4BYW/QN1HGNt3LxnX8tSZ8ZgTIzFnqU5JSj9ochC7sC28gKq/jpt38Et
         h1EV+fUayKcJikqx/rdsnb0mXBohYUWqr9y9eC9J+VvFMagckp3bFxdueAnKWTccIwbA
         2Hxw==
X-Gm-Message-State: APjAAAUV4obIQ6XRidc0GVGJK4t4IklcfukkxbdZDsy+utMXGmgeF08h
        b37KYJHLJWiF3wBi00nWDwY=
X-Google-Smtp-Source: APXvYqxOIbpdZLQdoCOz/7kFY829F0PDjAgwYtPnuzYix4T1+T8HFSPqEhciJa4khjnAvg8dEheDFg==
X-Received: by 2002:a1c:4805:: with SMTP id v5mr884862wma.80.1582840915478;
        Thu, 27 Feb 2020 14:01:55 -0800 (PST)
Received: from AnsuelXPS (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.gmail.com with ESMTPSA id z2sm3443814wrq.95.2020.02.27.14.01.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Feb 2020 14:01:54 -0800 (PST)
From:   <ansuelsmth@gmail.com>
To:     "'Rob Herring'" <robh@kernel.org>
Cc:     "'Andy Gross'" <agross@kernel.org>,
        "'Bjorn Andersson'" <bjorn.andersson@linaro.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Florian Fainelli'" <f.fainelli@gmail.com>,
        "'Heiner Kallweit'" <hkallweit1@gmail.com>,
        "'Russell King'" <linux@armlinux.org.uk>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <andrew@lunn.ch> <20200227011050.11106-1-ansuelsmth@gmail.com> <20200227011050.11106-2-ansuelsmth@gmail.com> <20200227172340.GA19136@bogus>
In-Reply-To: <20200227172340.GA19136@bogus>
Subject: R: [PATCH v8 2/2] dt-bindings: net: Add ipq806x mdio bindings
Date:   Thu, 27 Feb 2020 23:01:51 +0100
Message-ID: <005401d5edb9$84fd8ec0$8ef8ac40$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: it
Thread-Index: AQK3MMxYfxrxN4e01t227dGot2VmuAEzaQ9BAnacW3QBIS/lwaZGtj5w
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Feb 27, 2020 at 02:10:46AM +0100, Ansuel Smith wrote:
> > Add documentations for ipq806x mdio driver.
> >
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > ---
> > Changes in v8:
> > - Fix error in dtb check
> > - Remove not needed reset definition from example
> > - Add include header for ipq806x clocks
> > - Fix wrong License type
> >
> > Changes in v7:
> > - Fix dt_binding_check problem
> >
> >  .../bindings/net/qcom,ipq8064-mdio.yaml       | 61
> +++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >  create mode 100644
> Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-
> mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-
> mdio.yaml
> > new file mode 100644
> > index 000000000000..4334a415f23c
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-
> mdio.yaml
> > @@ -0,0 +1,61 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
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
> > +description:
> > +  The ipq806x soc have a MDIO dedicated controller that is
> > +  used to comunicate with the gmac phy conntected.
> 
> 2 typos
> 
> > +  Child nodes of this MDIO bus controller node are standard
> > +  Ethernet PHY device nodes as described in
> > +  Documentation/devicetree/bindings/net/phy.txt
> 
> You might want to read what that file says now.
> 
> > +
> > +allOf:
> > +  - $ref: "mdio.yaml#"
> > +
> > +properties:
> > +  compatible:
> > +    items:
> > +        - const: qcom,ipq8064-mdio
> > +        - const: syscon
> 
> Why is this a 'syscon'? Does it have more than 1 function?
>
 
Since the code use syscon_node_to_regmap, the syscon compatible
is need or the driver fails to load. (since the reg is used also for the 
gmac node) 

Again sorry for the mess as I misread the email... Will fix all in v9 

> > +
> > +  reg:
> > +    description: address and length of the register set for the device
> 
> Drop this and you need to state how many (maxItems).
> 
> > +
> > +  clocks:
> > +    description: A reference to the clock supplying the MDIO bus
> controller
> 
> Same here.
> 
> > +
> > +  clock-names:
> > +    const: master
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
> > +    #include <dt-bindings/clock/qcom,gcc-ipq806x.h>
> > +
> > +    mdio0: mdio@37000000 {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +
> > +        compatible = "qcom,ipq8064-mdio", "syscon";
> > +        reg = <0x37000000 0x200000>;
> > +
> > +        clocks = <&gcc GMAC_CORE1_CLK>;
> > +
> > +        switch@10 {
> > +            compatible = "qca,qca8337";
> > +            /* ... */
> > +        };
> > +    };
> > --
> > 2.25.0
> >

