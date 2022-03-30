Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59E84ECA0A
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349055AbiC3Qxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349048AbiC3Qxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:53:40 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075CE294A2B
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:51:54 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b24so25128762edu.10
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 09:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Im+A+HYFMnbbh7Mify3QJ5bCMuIFvSq16DgGjLn0sTo=;
        b=WzTa14WOM2lbKyeLdAzEMTp5kDmJwzYDMKH+S91N70oKmjkUdTaRBKCNGZquVALB9U
         kexgmSf1ebswIcIa0rfxliujpI08w/ZTN/OwUYZKFDtu/gHvSQap1TSmwnhUbNt6fgjn
         HKAuRQXKn+mSdjS5ZDKtwjQ7VyOB/wQbhACmcXVH8OwwfVOwX19XbizOmGL7F+rIWSki
         KE7aTp1v/r6TCZAolU09d5A+no6d1Pe22yATI8XeY4IsnNnCDZn6KDrfplh4t2iEDL0w
         YGPdJtjchQFai/IktaYvs4VrV557OnjvbDl5M7sXVN0C82PSlN3gZB0BhV655f9f3/Iv
         JI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Im+A+HYFMnbbh7Mify3QJ5bCMuIFvSq16DgGjLn0sTo=;
        b=VSVHoVqP2T1ojPMShgUbfTALPmaVW/tIoGlHmSAWwOMj4L/ePNtTB11yubaw390ACk
         iQzCbZX642K91uBNsadVQtXfvtRUTg4aib52NHT/akRnwZdPMsib8a4sis9owWZXwKr2
         +//QPebEjesqnGs+84R3nvxcfx+p0BZHQtvfKcshoVujzYatUfyCREct8WnEUQgDZbdO
         BjsC3bVvgqfztC6xpjfVhSgMO2lou+egI6/7LrtA+LZ0oW+2PvIOZGF+cfKGCULg4u/K
         y3PfhH2Hvw4mqL7aS9lW/Np1pJTaRBAECh/oefMjtm6qzI7CqwOlqI7VKlYa3PmA6PEL
         sIvg==
X-Gm-Message-State: AOAM5337YFC2jbOLV4vbnxMOS8SuA+VzG2ktmGpIUILmIu+NUlR20HZH
        0/b8o1bseHf6c5/VFLZjWLcM6w==
X-Google-Smtp-Source: ABdhPJwNMk4YmMoWVrCTM0khR+uH1H7lVK7VCQl2zmA3xYauqdZcAr6nqTHiFSRDTGgBvIQlQ54AGw==
X-Received: by 2002:a05:6402:d0b:b0:418:e53f:f19b with SMTP id eb11-20020a0564020d0b00b00418e53ff19bmr8873140edb.222.1648659113402;
        Wed, 30 Mar 2022 09:51:53 -0700 (PDT)
Received: from [192.168.0.164] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id gb29-20020a170907961d00b006e00c7b0f5asm8485361ejc.0.2022.03.30.09.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 09:51:52 -0700 (PDT)
Message-ID: <259ac0f4-50e9-291b-9ed3-91b52840fb9e@linaro.org>
Date:   Wed, 30 Mar 2022 18:51:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
 <YkR57poibmnvmkjk@shell.armlinux.org.uk>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YkR57poibmnvmkjk@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/2022 17:40, Russell King (Oracle) wrote:
> On Tue, Mar 15, 2022 at 07:21:59PM +0100, Krzysztof Kozlowski wrote:
>> On 15/03/2022 13:33, Ioana Ciornei wrote:
>>> Convert the sff,sfp.txt bindings to the DT schema format.
>>>
>>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>>> ---
>>>  .../devicetree/bindings/net/sff,sfp.txt       |  85 ------------
>>>  .../devicetree/bindings/net/sff,sfp.yaml      | 130 ++++++++++++++++++
>>>  MAINTAINERS                                   |   1 +
>>>  3 files changed, 131 insertions(+), 85 deletions(-)
>>>  delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
>>>  create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/sff,sfp.txt b/Documentation/devicetree/bindings/net/sff,sfp.txt
>>> deleted file mode 100644
>>> index 832139919f20..000000000000
>>> --- a/Documentation/devicetree/bindings/net/sff,sfp.txt
>>> +++ /dev/null
>>> @@ -1,85 +0,0 @@
>>> -Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
>>> -Transceiver
>>> -
>>> -Required properties:
>>> -
>>> -- compatible : must be one of
>>> -  "sff,sfp" for SFP modules
>>> -  "sff,sff" for soldered down SFF modules
>>> -
>>> -- i2c-bus : phandle of an I2C bus controller for the SFP two wire serial
>>> -  interface
>>> -
>>> -Optional Properties:
>>> -
>>> -- mod-def0-gpios : GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS)
>>> -  module presence input gpio signal, active (module absent) high. Must
>>> -  not be present for SFF modules
>>> -
>>> -- los-gpios : GPIO phandle and a specifier of the Receiver Loss of Signal
>>> -  Indication input gpio signal, active (signal lost) high
>>> -
>>> -- tx-fault-gpios : GPIO phandle and a specifier of the Module Transmitter
>>> -  Fault input gpio signal, active (fault condition) high
>>> -
>>> -- tx-disable-gpios : GPIO phandle and a specifier of the Transmitter Disable
>>> -  output gpio signal, active (Tx disable) high
>>> -
>>> -- rate-select0-gpios : GPIO phandle and a specifier of the Rx Signaling Rate
>>> -  Select (AKA RS0) output gpio signal, low: low Rx rate, high: high Rx rate
>>> -  Must not be present for SFF modules
>>> -
>>> -- rate-select1-gpios : GPIO phandle and a specifier of the Tx Signaling Rate
>>> -  Select (AKA RS1) output gpio signal (SFP+ only), low: low Tx rate, high:
>>> -  high Tx rate. Must not be present for SFF modules
>>> -
>>> -- maximum-power-milliwatt : Maximum module power consumption
>>> -  Specifies the maximum power consumption allowable by a module in the
>>> -  slot, in milli-Watts.  Presently, modules can be up to 1W, 1.5W or 2W.
>>> -
>>> -Example #1: Direct serdes to SFP connection
>>> -
>>> -sfp_eth3: sfp-eth3 {
>>> -	compatible = "sff,sfp";
>>> -	i2c-bus = <&sfp_1g_i2c>;
>>> -	los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
>>> -	mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
>>> -	maximum-power-milliwatt = <1000>;
>>> -	pinctrl-names = "default";
>>> -	pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
>>> -	tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
>>> -	tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
>>> -};
>>> -
>>> -&cps_emac3 {
>>> -	phy-names = "comphy";
>>> -	phys = <&cps_comphy5 0>;
>>> -	sfp = <&sfp_eth3>;
>>> -};
>>> -
>>> -Example #2: Serdes to PHY to SFP connection
>>> -
>>> -sfp_eth0: sfp-eth0 {
>>> -	compatible = "sff,sfp";
>>> -	i2c-bus = <&sfpp0_i2c>;
>>> -	los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
>>> -	mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
>>> -	pinctrl-names = "default";
>>> -	pinctrl-0 = <&cps_sfpp0_pins>;
>>> -	tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
>>> -	tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
>>> -};
>>> -
>>> -p0_phy: ethernet-phy@0 {
>>> -	compatible = "ethernet-phy-ieee802.3-c45";
>>> -	pinctrl-names = "default";
>>> -	pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
>>> -	reg = <0>;
>>> -	interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
>>> -	sfp = <&sfp_eth0>;
>>> -};
>>> -
>>> -&cpm_eth0 {
>>> -	phy = <&p0_phy>;
>>> -	phy-mode = "10gbase-kr";
>>> -};
>>> diff --git a/Documentation/devicetree/bindings/net/sff,sfp.yaml b/Documentation/devicetree/bindings/net/sff,sfp.yaml
>>> new file mode 100644
>>> index 000000000000..bceeff5ccedb
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
>>> @@ -0,0 +1,130 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: "http://devicetree.org/schemas/net/sff,sfp.yaml#"
>>> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>>> +
>>> +title: Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
>>> +  Transceiver
>>> +
>>> +maintainers:
>>> +  - Russell King <linux@armlinux.org.uk>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - sff,sfp  # for SFP modules
>>> +      - sff,sff  # for soldered down SFF modules
>>> +
>>> +  i2c-bus:
>>
>> Thanks for the conversion.
>>
>> You need here a type because this does not look like standard property.
>>
>>> +    description:
>>> +      phandle of an I2C bus controller for the SFP two wire serial
>>> +
>>> +  maximum-power-milliwatt:
>>> +    maxItems: 1
>>> +    description:
>>> +      Maximum module power consumption Specifies the maximum power consumption
>>> +      allowable by a module in the slot, in milli-Watts. Presently, modules can
>>> +      be up to 1W, 1.5W or 2W.
>>> +
>>> +patternProperties:
>>> +  "mod-def0-gpio(s)?":
>>
>> This should be just "mod-def0-gpios", no need for pattern. The same in
>> all other places.
>>
>>> +    maxItems: 1
>>> +    description:
>>> +      GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS) module
>>> +      presence input gpio signal, active (module absent) high. Must not be
>>> +      present for SFF modules
>>> +
>>> +  "los-gpio(s)?":
>>> +    maxItems: 1
>>> +    description:
>>> +      GPIO phandle and a specifier of the Receiver Loss of Signal Indication
>>> +      input gpio signal, active (signal lost) high
>>> +
>>> +  "tx-fault-gpio(s)?":
>>> +    maxItems: 1
>>> +    description:
>>> +      GPIO phandle and a specifier of the Module Transmitter Fault input gpio
>>> +      signal, active (fault condition) high
>>> +
>>> +  "tx-disable-gpio(s)?":
>>> +    maxItems: 1
>>> +    description:
>>> +      GPIO phandle and a specifier of the Transmitter Disable output gpio
>>> +      signal, active (Tx disable) high
>>> +
>>> +  "rate-select0-gpio(s)?":
>>> +    maxItems: 1
>>> +    description:
>>> +      GPIO phandle and a specifier of the Rx Signaling Rate Select (AKA RS0)
>>> +      output gpio signal, low - low Rx rate, high - high Rx rate Must not be
>>> +      present for SFF modules
>>> +
>>> +  "rate-select1-gpio(s)?":
>>> +    maxItems: 1
>>> +    description:
>>> +      GPIO phandle and a specifier of the Tx Signaling Rate Select (AKA RS1)
>>> +      output gpio signal (SFP+ only), low - low Tx rate, high - high Tx rate. Must
>>> +      not be present for SFF modules
>>
>> This and other cases should have a "allOf: if: ...." with a
>> "rate-select1-gpios: false", to disallow this property on SFF modules.
>>
>>> +
>>> +required:
>>> +  - compatible
>>> +  - i2c-bus
>>> +
>>> +additionalProperties: false
>>> +
>>> +examples:
>>> +  - | # Direct serdes to SFP connection
>>> +    #include <dt-bindings/gpio/gpio.h>
>>> +
>>> +    sfp_eth3: sfp-eth3 {
>>
>> Generic node name please, so maybe "transceiver"? or just "sfp"?
> 
> How does that work when you have several? If we have to have sfp@0,
> sfp@1 etc then we also need a reg property which will never be parsed
> and the number is meaningless.
> 
> In any case, this would be an _additional_ change over a pure conversion
> so arguably should be done in a separate patch.

First of all, there is no such case here. It's only one node.
Second, it works exactly the same like for all other cases - leds,
regulators etc. I already described it in other email (led-0, led-1).

> 
>>
>>> +      compatible = "sff,sfp";
>>> +      i2c-bus = <&sfp_1g_i2c>;
>>> +      los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
>>> +      mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
>>> +      maximum-power-milliwatt = <1000>;
>>> +      pinctrl-names = "default";
>>> +      pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
>>> +      tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
>>> +      tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
>>> +    };
>>> +
>>> +    cps_emac3 {
>>
>> This is not related, so please remove.
>>
>>> +      phy-names = "comphy";
>>> +      phys = <&cps_comphy5 0>;
>>> +      sfp = <&sfp_eth3>;
>>> +    };
> 
> Please explain why this is "not related" when it mentions the SFP.

Consumer, which it looks like, is not related to the binding. The same
as we do not put examples of clock consumers in clock providers.

I already explained in other mail to Ioana, so you can just refer there...

> 
>>> +
>>> +  - | # Serdes to PHY to SFP connection
>>> +    #include <dt-bindings/gpio/gpio.h>
>>
>> Are you sure it works fine? Double define?
> 
> Err what? Sorry, I don't understand what you're saying here, please
> explain what the issue is.

Including the same header twice causes duplicate defines, which should
be visible when testing the binding.

> 
>>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>>> +
>>> +    sfp_eth0: sfp-eth0 {
>>
>> Same node name - generic.
>>
>>> +      compatible = "sff,sfp";
>>> +      i2c-bus = <&sfpp0_i2c>;
>>> +      los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
>>> +      mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
>>> +      pinctrl-names = "default";
>>> +      pinctrl-0 = <&cps_sfpp0_pins>;
>>> +      tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
>>> +      tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
>>> +    };
>>> +
>>> +    mdio {
>>
>> Not related.
>>
>>> +      #address-cells = <1>;
>>> +      #size-cells = <0>;
>>> +
>>> +      p0_phy: ethernet-phy@0 {
>>> +        compatible = "ethernet-phy-ieee802.3-c45";
>>> +        pinctrl-names = "default";
>>> +        pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
>>> +        reg = <0>;
>>> +        interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
>>> +        sfp = <&sfp_eth0>;
>>> +      };
>>> +    };
>>> +
>>> +    cpm_eth0 {
>>
>> Also not related.
>>
>>> +      phy = <&p0_phy>;
>>> +      phy-mode = "10gbase-kr";
>>> +    };
> 
> These examples are showing how the SFP gets hooked up directly to a MAC
> or directly to a PHY. Would you prefer them to be in the ethernet-mac
> and ethernet-phy yaml files instead? It seems utterly perverse to split
> an example across several different yaml files.

Probably PHY or MAC is better place, because it defines the "sfp" property.

How is it different from other cases like this in bindings (clocks,
power domains, GPIOs)? IOW, why SFP is special? If it is, sure, let's
keep it here...

Best regards,
Krzysztof
