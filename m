Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6674EC87D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348329AbiC3Pma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240274AbiC3Pm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:42:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5B933E84;
        Wed, 30 Mar 2022 08:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Xyd+3OFiEvBjX5Y966CY1Vv00DKxAJjprbbdw8ESbMs=; b=1dF96IeEeuW/7uflx5uUCRn1ma
        zgvkwD/B3rlfZbqoDYxS+bao207KfuFkwZmog6ps4ym1L0bMUdryVeDgf1A9t+mNK876PFrXCRof+
        xoY9h5DyUcYNwifpXxfQ7byEXFk8f+Q5HGym9g8jiYBlajUdLHy3q+PeBmrtatGzOsJPMHsm0s+tC
        JLm7X8TIAi7x+/CF8mQmE2YszFTEzod1hMQ3zHCwnGmIdha9wPRdnQ5OLpByxISDAngv3EvJZpqvK
        p3B2eZZI2L2UGbfuUSpT3Zpg1VL2x3ZRpMfYrWxcjn2chUw8rpNdQg2Y1LXbKCDOCIBhM+lihlMcZ
        FJ4QzRIQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58002)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nZaQz-0003MK-5V; Wed, 30 Mar 2022 16:40:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nZaQw-0006j0-SC; Wed, 30 Mar 2022 16:40:30 +0100
Date:   Wed, 30 Mar 2022 16:40:30 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Message-ID: <YkR57poibmnvmkjk@shell.armlinux.org.uk>
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 07:21:59PM +0100, Krzysztof Kozlowski wrote:
> On 15/03/2022 13:33, Ioana Ciornei wrote:
> > Convert the sff,sfp.txt bindings to the DT schema format.
> > 
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  .../devicetree/bindings/net/sff,sfp.txt       |  85 ------------
> >  .../devicetree/bindings/net/sff,sfp.yaml      | 130 ++++++++++++++++++
> >  MAINTAINERS                                   |   1 +
> >  3 files changed, 131 insertions(+), 85 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
> >  create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/sff,sfp.txt b/Documentation/devicetree/bindings/net/sff,sfp.txt
> > deleted file mode 100644
> > index 832139919f20..000000000000
> > --- a/Documentation/devicetree/bindings/net/sff,sfp.txt
> > +++ /dev/null
> > @@ -1,85 +0,0 @@
> > -Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
> > -Transceiver
> > -
> > -Required properties:
> > -
> > -- compatible : must be one of
> > -  "sff,sfp" for SFP modules
> > -  "sff,sff" for soldered down SFF modules
> > -
> > -- i2c-bus : phandle of an I2C bus controller for the SFP two wire serial
> > -  interface
> > -
> > -Optional Properties:
> > -
> > -- mod-def0-gpios : GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS)
> > -  module presence input gpio signal, active (module absent) high. Must
> > -  not be present for SFF modules
> > -
> > -- los-gpios : GPIO phandle and a specifier of the Receiver Loss of Signal
> > -  Indication input gpio signal, active (signal lost) high
> > -
> > -- tx-fault-gpios : GPIO phandle and a specifier of the Module Transmitter
> > -  Fault input gpio signal, active (fault condition) high
> > -
> > -- tx-disable-gpios : GPIO phandle and a specifier of the Transmitter Disable
> > -  output gpio signal, active (Tx disable) high
> > -
> > -- rate-select0-gpios : GPIO phandle and a specifier of the Rx Signaling Rate
> > -  Select (AKA RS0) output gpio signal, low: low Rx rate, high: high Rx rate
> > -  Must not be present for SFF modules
> > -
> > -- rate-select1-gpios : GPIO phandle and a specifier of the Tx Signaling Rate
> > -  Select (AKA RS1) output gpio signal (SFP+ only), low: low Tx rate, high:
> > -  high Tx rate. Must not be present for SFF modules
> > -
> > -- maximum-power-milliwatt : Maximum module power consumption
> > -  Specifies the maximum power consumption allowable by a module in the
> > -  slot, in milli-Watts.  Presently, modules can be up to 1W, 1.5W or 2W.
> > -
> > -Example #1: Direct serdes to SFP connection
> > -
> > -sfp_eth3: sfp-eth3 {
> > -	compatible = "sff,sfp";
> > -	i2c-bus = <&sfp_1g_i2c>;
> > -	los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
> > -	mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
> > -	maximum-power-milliwatt = <1000>;
> > -	pinctrl-names = "default";
> > -	pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
> > -	tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
> > -	tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
> > -};
> > -
> > -&cps_emac3 {
> > -	phy-names = "comphy";
> > -	phys = <&cps_comphy5 0>;
> > -	sfp = <&sfp_eth3>;
> > -};
> > -
> > -Example #2: Serdes to PHY to SFP connection
> > -
> > -sfp_eth0: sfp-eth0 {
> > -	compatible = "sff,sfp";
> > -	i2c-bus = <&sfpp0_i2c>;
> > -	los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
> > -	mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
> > -	pinctrl-names = "default";
> > -	pinctrl-0 = <&cps_sfpp0_pins>;
> > -	tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
> > -	tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
> > -};
> > -
> > -p0_phy: ethernet-phy@0 {
> > -	compatible = "ethernet-phy-ieee802.3-c45";
> > -	pinctrl-names = "default";
> > -	pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
> > -	reg = <0>;
> > -	interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
> > -	sfp = <&sfp_eth0>;
> > -};
> > -
> > -&cpm_eth0 {
> > -	phy = <&p0_phy>;
> > -	phy-mode = "10gbase-kr";
> > -};
> > diff --git a/Documentation/devicetree/bindings/net/sff,sfp.yaml b/Documentation/devicetree/bindings/net/sff,sfp.yaml
> > new file mode 100644
> > index 000000000000..bceeff5ccedb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
> > @@ -0,0 +1,130 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/net/sff,sfp.yaml#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > +
> > +title: Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
> > +  Transceiver
> > +
> > +maintainers:
> > +  - Russell King <linux@armlinux.org.uk>
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - sff,sfp  # for SFP modules
> > +      - sff,sff  # for soldered down SFF modules
> > +
> > +  i2c-bus:
> 
> Thanks for the conversion.
> 
> You need here a type because this does not look like standard property.
> 
> > +    description:
> > +      phandle of an I2C bus controller for the SFP two wire serial
> > +
> > +  maximum-power-milliwatt:
> > +    maxItems: 1
> > +    description:
> > +      Maximum module power consumption Specifies the maximum power consumption
> > +      allowable by a module in the slot, in milli-Watts. Presently, modules can
> > +      be up to 1W, 1.5W or 2W.
> > +
> > +patternProperties:
> > +  "mod-def0-gpio(s)?":
> 
> This should be just "mod-def0-gpios", no need for pattern. The same in
> all other places.
> 
> > +    maxItems: 1
> > +    description:
> > +      GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS) module
> > +      presence input gpio signal, active (module absent) high. Must not be
> > +      present for SFF modules
> > +
> > +  "los-gpio(s)?":
> > +    maxItems: 1
> > +    description:
> > +      GPIO phandle and a specifier of the Receiver Loss of Signal Indication
> > +      input gpio signal, active (signal lost) high
> > +
> > +  "tx-fault-gpio(s)?":
> > +    maxItems: 1
> > +    description:
> > +      GPIO phandle and a specifier of the Module Transmitter Fault input gpio
> > +      signal, active (fault condition) high
> > +
> > +  "tx-disable-gpio(s)?":
> > +    maxItems: 1
> > +    description:
> > +      GPIO phandle and a specifier of the Transmitter Disable output gpio
> > +      signal, active (Tx disable) high
> > +
> > +  "rate-select0-gpio(s)?":
> > +    maxItems: 1
> > +    description:
> > +      GPIO phandle and a specifier of the Rx Signaling Rate Select (AKA RS0)
> > +      output gpio signal, low - low Rx rate, high - high Rx rate Must not be
> > +      present for SFF modules
> > +
> > +  "rate-select1-gpio(s)?":
> > +    maxItems: 1
> > +    description:
> > +      GPIO phandle and a specifier of the Tx Signaling Rate Select (AKA RS1)
> > +      output gpio signal (SFP+ only), low - low Tx rate, high - high Tx rate. Must
> > +      not be present for SFF modules
> 
> This and other cases should have a "allOf: if: ...." with a
> "rate-select1-gpios: false", to disallow this property on SFF modules.
> 
> > +
> > +required:
> > +  - compatible
> > +  - i2c-bus
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - | # Direct serdes to SFP connection
> > +    #include <dt-bindings/gpio/gpio.h>
> > +
> > +    sfp_eth3: sfp-eth3 {
> 
> Generic node name please, so maybe "transceiver"? or just "sfp"?

How does that work when you have several? If we have to have sfp@0,
sfp@1 etc then we also need a reg property which will never be parsed
and the number is meaningless.

In any case, this would be an _additional_ change over a pure conversion
so arguably should be done in a separate patch.

> 
> > +      compatible = "sff,sfp";
> > +      i2c-bus = <&sfp_1g_i2c>;
> > +      los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
> > +      mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
> > +      maximum-power-milliwatt = <1000>;
> > +      pinctrl-names = "default";
> > +      pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
> > +      tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
> > +      tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
> > +    };
> > +
> > +    cps_emac3 {
> 
> This is not related, so please remove.
> 
> > +      phy-names = "comphy";
> > +      phys = <&cps_comphy5 0>;
> > +      sfp = <&sfp_eth3>;
> > +    };

Please explain why this is "not related" when it mentions the SFP.

> > +
> > +  - | # Serdes to PHY to SFP connection
> > +    #include <dt-bindings/gpio/gpio.h>
> 
> Are you sure it works fine? Double define?

Err what? Sorry, I don't understand what you're saying here, please
explain what the issue is.

> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +
> > +    sfp_eth0: sfp-eth0 {
> 
> Same node name - generic.
> 
> > +      compatible = "sff,sfp";
> > +      i2c-bus = <&sfpp0_i2c>;
> > +      los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
> > +      mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
> > +      pinctrl-names = "default";
> > +      pinctrl-0 = <&cps_sfpp0_pins>;
> > +      tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
> > +      tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
> > +    };
> > +
> > +    mdio {
> 
> Not related.
> 
> > +      #address-cells = <1>;
> > +      #size-cells = <0>;
> > +
> > +      p0_phy: ethernet-phy@0 {
> > +        compatible = "ethernet-phy-ieee802.3-c45";
> > +        pinctrl-names = "default";
> > +        pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
> > +        reg = <0>;
> > +        interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
> > +        sfp = <&sfp_eth0>;
> > +      };
> > +    };
> > +
> > +    cpm_eth0 {
> 
> Also not related.
> 
> > +      phy = <&p0_phy>;
> > +      phy-mode = "10gbase-kr";
> > +    };

These examples are showing how the SFP gets hooked up directly to a MAC
or directly to a PHY. Would you prefer them to be in the ethernet-mac
and ethernet-phy yaml files instead? It seems utterly perverse to split
an example across several different yaml files.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
