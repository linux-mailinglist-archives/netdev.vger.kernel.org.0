Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ED63DCAA2
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 09:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhHAHvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 03:51:35 -0400
Received: from smtp-32-i2.italiaonline.it ([213.209.12.32]:36661 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230195AbhHAHve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Aug 2021 03:51:34 -0400
Received: from oxapps-35-162.iol.local ([10.101.8.208])
        by smtp-32.iol.local with ESMTPA
        id A6Fomg0ajPvRTA6Fomr9FD; Sun, 01 Aug 2021 09:51:25 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1627804285; bh=Af2Rh5cNOtw4TvtwIlf9r+wU0IPj9hYsT1UE6aRFX14=;
        h=From;
        b=Zel5i8L/K1QuwdjRxjitp34na6e+QqUkQlT/9vh2n+MmXstSnCVRCszyoSXPcMaj9
         XDYh/QnmKZSD5yixbUvDLe7WI74cf6zUgf+aIVcJ9EuhCSap0OQq81Wo189wo3c35u
         CT0U0mRIbhTrNIaytXzkALwY+Z1HiWCTIcrgoKWF5S7gFVnB43sZK1lxEzLpzzhyHL
         rlTEyOVZ2os78iC051DyLpZxH44R0FekjKg1Yj9t60AXkQeckeTOwcJTNbyVvDDEAC
         b2cUgBzi1vZ/qvTzcuTSwURGW4sYLlW6gi9hBHRphn3K7++maoK0wikcqz8ok9ehcy
         CUtYq2iFjCRTQ==
X-CNFS-Analysis: v=2.4 cv=NqgUz+RJ c=1 sm=1 tr=0 ts=6106527d cx=a_exe
 a=OCAZjQWm+uh9gf1btJle/A==:117 a=J7go-RGC33AA:10 a=IkcTkHD0fZMA:10
 a=nep-EciQ0nEA:10 a=VwQbUJbxAAAA:8 a=gEfo2CItAAAA:8 a=UPI37tLYW5OaAxwkwrgA:9
 a=rHV0-jcvEoPftAnC:21 a=gTVJ0-qJTCAwcKrR:21 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=sptkURWiP4Gy88Gu7hUp:22
Date:   Sun, 1 Aug 2021 09:51:24 +0200 (CEST)
From:   Dario Binacchi <dariobin@libero.it>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Message-ID: <1297330344.65205.1627804284854@mail1.libero.it>
In-Reply-To: <CAL_JsqK0bVV7s3Pw5=_JSo171jnDrCTM5erKz5-dVWA0wR+b7g@mail.gmail.com>
References: <20210730171646.2406-1-dariobin@libero.it>
 <CAL_JsqK0bVV7s3Pw5=_JSo171jnDrCTM5erKz5-dVWA0wR+b7g@mail.gmail.com>
Subject: Re: [PATCH v3] dt-bindings: net: can: c_can: convert to json-schema
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev34
X-Originating-IP: 82.60.87.158
X-Originating-Client: open-xchange-appsuite
x-libjamsun: yYa3RqzAEVJx9REoKRYOt8ZjuwtwyGcs
x-libjamv: pgge6lMSBo0=
X-CMAE-Envelope: MS4xfFNsQEOefARsJANxJ9kQ7xUOKFy3YeIqjjv4AcxJTLVI38Cx55oHBUTimE3FpRwU026DVyY1krm8bSgKnsUTEOcivyv7hV3B6s33UKbuflcuF1/nhavt
 9VpdJWzrCa3l7+BCoi6H5mWFXLFsIxhIBb7SqL5+7f9DdsIsob0paD0OsWiUdJOkFa6YrZLgDSoufoa8oIsNwnmpq4LPalLGf+XHlXrIZBozboX8fgYSXly2
 XcO64AqCs7IhAFqW4dU6APShexf11r4RuhtE/8GIVbxP+Bip7hLf+Lv+x8VNI5SQloFrbb3alAxL9LD+YJIdvO6w58teXLTh1Bka+N8YbqyDmdAkHKGJthoN
 6g9gPX2/q+f/8TrSkKxptzWhVIljgJWG4uyJm3eO97taJ+i2h8cU4FqTFDsxbiIC9hQ1cuhoxEcOeb0/6htsty8Y/t0w6K90fG0lff87JZCtHJKIt7o=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

> Il 31/07/2021 02:55 Rob Herring <robh+dt@kernel.org> ha scritto:
> 
>  
> On Fri, Jul 30, 2021 at 11:16 AM Dario Binacchi <dariobin@libero.it> wrote:
> >
> > Convert the Bosch C_CAN/D_CAN controller device tree binding
> > documentation to json-schema.
> >
> > Document missing properties.
> > Remove "ti,hwmods" as it is no longer used in TI dts.
> > Make "clocks" required as it is used in all dts.
> > Correct nodename in the example.
> >
> > Signed-off-by: Dario Binacchi <dariobin@libero.it>
> >
> > ---
> >
> > Changes in v3:
> >  - Add type (phandle-array) and size (maxItems: 2) to syscon-raminit
> >    property.
> >
> > Changes in v2:
> >  - Drop Documentation references.
> >
> >  .../bindings/net/can/bosch,c_can.yaml         | 85 +++++++++++++++++++
> >  .../devicetree/bindings/net/can/c_can.txt     | 65 --------------
> >  2 files changed, 85 insertions(+), 65 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> >  delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt
> >
> > diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> > new file mode 100644
> > index 000000000000..416db97fbf9d
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> > @@ -0,0 +1,85 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/can/bosch,c_can.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Bosch C_CAN/D_CAN controller Device Tree Bindings
> > +
> > +description: Bosch C_CAN/D_CAN controller for CAN bus
> > +
> > +maintainers:
> > +  - Dario Binacchi <dariobin@libero.it>
> > +
> > +allOf:
> > +  - $ref: can-controller.yaml#
> > +
> > +properties:
> > +  compatible:
> > +    oneOf:
> > +      - enum:
> > +          - bosch,c_can
> > +          - bosch,d_can
> > +          - ti,dra7-d_can
> > +          - ti,am3352-d_can
> > +      - items:
> > +          - enum:
> > +              - ti,am4372-d_can
> > +          - const: ti,am3352-d_can
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  power-domains:
> > +    description: |
> > +      Should contain a phandle to a PM domain provider node and an args
> > +      specifier containing the DCAN device id value. It's mandatory for
> > +      Keystone 2 66AK2G SoCs only.
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    description: |
> > +      CAN functional clock phandle.
> > +    maxItems: 1
> > +
> > +  clock-names:
> > +    maxItems: 1
> > +
> > +  syscon-raminit:
> > +    description: |
> > +      Handle to system control region that contains the RAMINIT register,
> > +      register offset to the RAMINIT register and the CAN instance number (0
> > +      offset).
> > +    $ref: /schemas/types.yaml#/definitions/phandle-array
> > +    maxItems: 2
> 
> Sorry, I misread that and counted 2, not 3 items. But you should have
> run the checks.

Checks fail with both value 2 and value 3. Looking at other kernel bindings I think 
2 is correct. Looking through the kernel bindings I only saw examples of phandle-array 
type with maxItems: 1, which is not our case. For maxItems other than 1 I have not 
found examples. Is it possible that there is a bug in the checks on phandle-array 
with maxItems > 1?
Eventually I took inspiration from how the 'fsl,stop-mode' property is described in 
Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml to describe 'syscon-raminit'.

> 
> > +
> > +required:
> > + - compatible
> > + - reg
> > + - interrupts
> > + - clocks
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    can@481d0000 {
> > +        compatible = "bosch,d_can";
> > +        reg = <0x481d0000 0x2000>;
> > +        interrupts = <55>;
> > +        interrupt-parent = <&intc>;
> > +        status = "disabled";
> 
> Don't show 'status' in examples. Why would one want an example disabled?

I'll remove it in version 4.

Thanks and regards,
Dario

> 
> > +    };
> > +  - |
> > +    can@0 {
> > +        compatible = "ti,am3352-d_can";
> > +        reg = <0x0 0x2000>;
> > +        clocks = <&dcan1_fck>;
> > +        clock-names = "fck";
> > +        syscon-raminit = <&scm_conf 0x644 1>;
> > +        interrupts = <55>;
> > +        status = "disabled";
> > +    };
> > diff --git a/Documentation/devicetree/bindings/net/can/c_can.txt b/Documentation/devicetree/bindings/net/can/c_can.txt
> > deleted file mode 100644
> > index 366479806acb..000000000000
> > --- a/Documentation/devicetree/bindings/net/can/c_can.txt
> > +++ /dev/null
> > @@ -1,65 +0,0 @@
> > -Bosch C_CAN/D_CAN controller Device Tree Bindings
> > --------------------------------------------------
> > -
> > -Required properties:
> > -- compatible           : Should be "bosch,c_can" for C_CAN controllers and
> > -                         "bosch,d_can" for D_CAN controllers.
> > -                         Can be "ti,dra7-d_can", "ti,am3352-d_can" or
> > -                         "ti,am4372-d_can".
> > -- reg                  : physical base address and size of the C_CAN/D_CAN
> > -                         registers map
> > -- interrupts           : property with a value describing the interrupt
> > -                         number
> > -
> > -The following are mandatory properties for DRA7x, AM33xx and AM43xx SoCs only:
> > -- ti,hwmods            : Must be "d_can<n>" or "c_can<n>", n being the
> > -                         instance number
> > -
> > -The following are mandatory properties for Keystone 2 66AK2G SoCs only:
> > -- power-domains                : Should contain a phandle to a PM domain provider node
> > -                         and an args specifier containing the DCAN device id
> > -                         value. This property is as per the binding,
> > -                         Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
> > -- clocks               : CAN functional clock phandle. This property is as per the
> > -                         binding,
> > -                         Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
> > -
> > -Optional properties:
> > -- syscon-raminit       : Handle to system control region that contains the
> > -                         RAMINIT register, register offset to the RAMINIT
> > -                         register and the CAN instance number (0 offset).
> > -
> > -Note: "ti,hwmods" field is used to fetch the base address and irq
> > -resources from TI, omap hwmod data base during device registration.
> > -Future plan is to migrate hwmod data base contents into device tree
> > -blob so that, all the required data will be used from device tree dts
> > -file.
> > -
> > -Example:
> > -
> > -Step1: SoC common .dtsi file
> > -
> > -       dcan1: d_can@481d0000 {
> > -               compatible = "bosch,d_can";
> > -               reg = <0x481d0000 0x2000>;
> > -               interrupts = <55>;
> > -               interrupt-parent = <&intc>;
> > -               status = "disabled";
> > -       };
> > -
> > -(or)
> > -
> > -       dcan1: d_can@481d0000 {
> > -               compatible = "bosch,d_can";
> > -               ti,hwmods = "d_can1";
> > -               reg = <0x481d0000 0x2000>;
> > -               interrupts = <55>;
> > -               interrupt-parent = <&intc>;
> > -               status = "disabled";
> > -       };
> > -
> > -Step 2: board specific .dts file
> > -
> > -       &dcan1 {
> > -               status = "okay";
> > -       };
> > --
> > 2.17.1
> >
