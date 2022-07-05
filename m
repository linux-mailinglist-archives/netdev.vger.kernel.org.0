Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84B7567958
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiGEV3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGEV3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:29:07 -0400
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487CF29B;
        Tue,  5 Jul 2022 14:29:06 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id m13so12435920ioj.0;
        Tue, 05 Jul 2022 14:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Aoqbj22+xs7AUQGHqy5zfV9GowBwHzmJWZ84qZsDpf8=;
        b=tuLy2Jnww5jrc3UriDSsw5ePsX2N6M28hGuO2BJ0YjSo5PtDtaMLOeUJ51+QUKPL1J
         pPP5XhwuA7rFhA2HX9uJHyPQE2kpwyNLsqVSGgGvAbngfl0lzAJ7BuLhRR/yC8z2LWO/
         fZuJTauWSHxHqHnGO+hZlHEpUewr/FHfyPzFCvmuwpCB0FdFZNA+r7zOW/5TrwbVnc7U
         6SWKY4c6MNLpcJ7lOFGxeYr4h+GE966YpyNkc2lLJmWlUkJURwH5uSUJY4Rgo7nBCSPC
         sTzryHW8NapyjxK2vdHU9jvMcjChNMpnl8WymN6XUVstXd5xlvYU5/uRnJCN6QS+97Oh
         jzzQ==
X-Gm-Message-State: AJIora9G3iDX8D9bIK/U4aHZh4GabQA+Ldg9fKs4Opa+uSbWUM0Z2G0Z
        +SvHRFct7cyy54gBD7jeDw==
X-Google-Smtp-Source: AGRyM1u2XZuJnEKOkHS2uIY7FeVZztuxUPhB9mogeLXsxZ2prRn10birHWShP1M7I6+ormEQY+ZweQ==
X-Received: by 2002:a6b:dd17:0:b0:675:1774:3c4 with SMTP id f23-20020a6bdd17000000b00675177403c4mr19631915ioc.213.1657056545469;
        Tue, 05 Jul 2022 14:29:05 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id y25-20020a027319000000b00339e42c3e2fsm15276939jab.80.2022.07.05.14.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 14:29:05 -0700 (PDT)
Received: (nullmailer pid 2672817 invoked by uid 1000);
        Tue, 05 Jul 2022 21:29:03 -0000
Date:   Tue, 5 Jul 2022 15:29:03 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, linux@armlinux.org.uk,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] dt-bindings: net: convert sff,sfp to
 dtschema
Message-ID: <20220705212903.GA2615438-robh@kernel.org>
References: <20220704134604.13626-1-ioana.ciornei@nxp.com>
 <20220704134604.13626-2-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704134604.13626-2-ioana.ciornei@nxp.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 04:46:01PM +0300, Ioana Ciornei wrote:
> Convert the sff,sfp.txt bindings to the DT schema format.
> Also add the new path to the list of maintained files.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - used the -gpios suffix
>  - restricted the use of some gpios if the compatible is sff,sff
> 
>  .../devicetree/bindings/net/sff,sfp.txt       |  85 -----------
>  .../devicetree/bindings/net/sff,sfp.yaml      | 143 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  3 files changed, 144 insertions(+), 85 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
>  create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/sff,sfp.txt b/Documentation/devicetree/bindings/net/sff,sfp.txt
> deleted file mode 100644
> index 832139919f20..000000000000
> --- a/Documentation/devicetree/bindings/net/sff,sfp.txt
> +++ /dev/null
> @@ -1,85 +0,0 @@
> -Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
> -Transceiver
> -
> -Required properties:
> -
> -- compatible : must be one of
> -  "sff,sfp" for SFP modules
> -  "sff,sff" for soldered down SFF modules
> -
> -- i2c-bus : phandle of an I2C bus controller for the SFP two wire serial
> -  interface
> -
> -Optional Properties:
> -
> -- mod-def0-gpios : GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS)
> -  module presence input gpio signal, active (module absent) high. Must
> -  not be present for SFF modules
> -
> -- los-gpios : GPIO phandle and a specifier of the Receiver Loss of Signal
> -  Indication input gpio signal, active (signal lost) high
> -
> -- tx-fault-gpios : GPIO phandle and a specifier of the Module Transmitter
> -  Fault input gpio signal, active (fault condition) high
> -
> -- tx-disable-gpios : GPIO phandle and a specifier of the Transmitter Disable
> -  output gpio signal, active (Tx disable) high
> -
> -- rate-select0-gpios : GPIO phandle and a specifier of the Rx Signaling Rate
> -  Select (AKA RS0) output gpio signal, low: low Rx rate, high: high Rx rate
> -  Must not be present for SFF modules
> -
> -- rate-select1-gpios : GPIO phandle and a specifier of the Tx Signaling Rate
> -  Select (AKA RS1) output gpio signal (SFP+ only), low: low Tx rate, high:
> -  high Tx rate. Must not be present for SFF modules
> -
> -- maximum-power-milliwatt : Maximum module power consumption
> -  Specifies the maximum power consumption allowable by a module in the
> -  slot, in milli-Watts.  Presently, modules can be up to 1W, 1.5W or 2W.
> -
> -Example #1: Direct serdes to SFP connection
> -
> -sfp_eth3: sfp-eth3 {
> -	compatible = "sff,sfp";
> -	i2c-bus = <&sfp_1g_i2c>;
> -	los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
> -	mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
> -	maximum-power-milliwatt = <1000>;
> -	pinctrl-names = "default";
> -	pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
> -	tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
> -	tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
> -};
> -
> -&cps_emac3 {
> -	phy-names = "comphy";
> -	phys = <&cps_comphy5 0>;
> -	sfp = <&sfp_eth3>;
> -};
> -
> -Example #2: Serdes to PHY to SFP connection
> -
> -sfp_eth0: sfp-eth0 {
> -	compatible = "sff,sfp";
> -	i2c-bus = <&sfpp0_i2c>;
> -	los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
> -	mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
> -	pinctrl-names = "default";
> -	pinctrl-0 = <&cps_sfpp0_pins>;
> -	tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
> -	tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
> -};
> -
> -p0_phy: ethernet-phy@0 {
> -	compatible = "ethernet-phy-ieee802.3-c45";
> -	pinctrl-names = "default";
> -	pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
> -	reg = <0>;
> -	interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
> -	sfp = <&sfp_eth0>;
> -};
> -
> -&cpm_eth0 {
> -	phy = <&p0_phy>;
> -	phy-mode = "10gbase-kr";
> -};
> diff --git a/Documentation/devicetree/bindings/net/sff,sfp.yaml b/Documentation/devicetree/bindings/net/sff,sfp.yaml
> new file mode 100644
> index 000000000000..86f3ed2546d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/sff,sfp.yaml
> @@ -0,0 +1,143 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/sff,sfp.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: Small Form Factor (SFF) Committee Small Form-factor Pluggable (SFP)
> +  Transceiver
> +
> +maintainers:
> +  - Russell King <linux@armlinux.org.uk>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - sff,sfp  # for SFP modules
> +      - sff,sff  # for soldered down SFF modules
> +
> +  i2c-bus:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      phandle of an I2C bus controller for the SFP two wire serial
> +
> +  maximum-power-milliwatt:
> +    maxItems: 1
> +    description:
> +      Maximum module power consumption Specifies the maximum power consumption
> +      allowable by a module in the slot, in milli-Watts. Presently, modules can
> +      be up to 1W, 1.5W or 2W.

       enum: [ 1000, 1500, 2000 ]

Or is it not just those values? Maybe 'maximum: 2000' instead.

> +
> +patternProperties:
> +  "mod-def0-gpios":

These aren't patterns. Move to 'properties'.

> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the MOD-DEF0 (AKA Mod_ABS) module
> +      presence input gpio signal, active (module absent) high. Must not be
> +      present for SFF modules
> +
> +  "los-gpios":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Receiver Loss of Signal Indication
> +      input gpio signal, active (signal lost) high
> +
> +  "tx-fault-gpios":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Module Transmitter Fault input gpio
> +      signal, active (fault condition) high
> +
> +  "tx-disable-gpios":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Transmitter Disable output gpio
> +      signal, active (Tx disable) high
> +
> +  "rate-select0-gpios":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Rx Signaling Rate Select (AKA RS0)
> +      output gpio signal, low - low Rx rate, high - high Rx rate Must not be
> +      present for SFF modules
> +
> +  "rate-select1-gpios":
> +    maxItems: 1
> +    description:
> +      GPIO phandle and a specifier of the Tx Signaling Rate Select (AKA RS1)
> +      output gpio signal (SFP+ only), low - low Tx rate, high - high Tx rate. Must
> +      not be present for SFF modules
> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: sff,sff
> +    then:
> +      properties:
> +        mod-def0-gpios: false
> +        rate-select0-gpios: false
> +        rate-select1-gpios: false
> +
> +required:
> +  - compatible
> +  - i2c-bus
> +
> +additionalProperties: false
> +
> +examples:
> +  - | # Direct serdes to SFP connection
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    sfp_eth3: sfp-eth3 {
> +      compatible = "sff,sfp";
> +      i2c-bus = <&sfp_1g_i2c>;
> +      los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
> +      mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
> +      maximum-power-milliwatt = <1000>;
> +      pinctrl-names = "default";
> +      pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
> +      tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
> +      tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
> +    };
> +
> +    cps_emac3 {
> +      phy-names = "comphy";
> +      phys = <&cps_comphy5 0>;
> +      sfp = <&sfp_eth3>;
> +    };
> +
> +  - | # Serdes to PHY to SFP connection
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    sfp_eth0: sfp-eth0 {
> +      compatible = "sff,sfp";
> +      i2c-bus = <&sfpp0_i2c>;
> +      los-gpios = <&cps_gpio1 28 GPIO_ACTIVE_HIGH>;
> +      mod-def0-gpios = <&cps_gpio1 27 GPIO_ACTIVE_LOW>;
> +      pinctrl-names = "default";
> +      pinctrl-0 = <&cps_sfpp0_pins>;
> +      tx-disable-gpios = <&cps_gpio1 29 GPIO_ACTIVE_HIGH>;
> +      tx-fault-gpios  = <&cps_gpio1 26 GPIO_ACTIVE_HIGH>;
> +    };
> +
> +    mdio {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      p0_phy: ethernet-phy@0 {
> +        compatible = "ethernet-phy-ieee802.3-c45";
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&cpm_phy0_pins &cps_phy0_pins>;
> +        reg = <0>;
> +        interrupt = <&cpm_gpio2 18 IRQ_TYPE_EDGE_FALLING>;
> +        sfp = <&sfp_eth0>;
> +      };
> +    };
> +
> +    cpm_eth0 {
> +      phy = <&p0_phy>;
> +      phy-mode = "10gbase-kr";
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 28108e4fdb8f..8677878603fe 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18110,6 +18110,7 @@ SFF/SFP/SFP+ MODULE SUPPORT
>  M:	Russell King <linux@armlinux.org.uk>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/net/sff,sfp.yaml
>  F:	drivers/net/phy/phylink.c
>  F:	drivers/net/phy/sfp*
>  F:	include/linux/mdio/mdio-i2c.h
> -- 
> 2.17.1
> 
> 
