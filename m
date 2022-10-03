Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EBB5F34D6
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 19:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJCRtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 13:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJCRtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 13:49:23 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C885F3C8E3
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 10:48:59 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bu25so17676369lfb.3
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 10:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=6ipOceJJFj+HqQfrKHGaIq1ts4QULB2eTqa5pJ5AnGQ=;
        b=Pb6u00JY40ihS6lWhfk/8psqfFcrlLbyTM/67KyV5kttLM7RrD9ABhM8bgO6Y+82fW
         o++6jBccSvlcyn7dtnthJEhrgj3tGxEos3d6Rr464yNqf4l+ToeDY8OsJQLshB5LdsNw
         SiafljJe0dTksArzYypzHGqVehjBcYRFpZhKvq8azF38Vm/iwVYXQ4rfefk7MpaS9/fP
         3O/k45mUMWaaluWL/TLIEC75WiOxhevhXPmUATvp0eccltZYD47iWKZzKUsdf/65vX1Z
         gO3O0zJhUtPHUSOsU/Q34YDuVGE++QkSNob7FNppTV5sUXw5kku0zuPP2MOvvtPtcc64
         vHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6ipOceJJFj+HqQfrKHGaIq1ts4QULB2eTqa5pJ5AnGQ=;
        b=vFgbhasVw338hv5ArYekD/9+xlWl+syysF1uZO0Y5eh1R2Fs0W8N5F59U9dNuOk3kJ
         j9YEbdqrJ9LwZ4OyihPk3rKPfdNwVns9XEzpzmArqdayMU9qD1AoRh2Cl/FDkZVSvz8x
         awNXVHfzVhRoIi4tOjGOV/IheUHuN8biQjK2a2F3tqsgm20VU/KD74xiVBC+dj0fv6U8
         zwtNqGLEdiMIFEDc2AYbM44g8DLUrf/+k5MDBWPOZJilLdUBd3WWmJmF5Hc1RJ54xZy/
         iADms8yeWI2dFxmRex9TCiunvypXNqqkjm9+bY1iX/qXu83GTVYvJLA1W5h0cezmHgMh
         0zCg==
X-Gm-Message-State: ACrzQf1Qm/dFNORO1qxqnQg2Sf3vkyfAohjmuLWlCUoLMfi1joLZQL+Y
        f5LKGEfFhEsFMfQkYAbKrx82dg==
X-Google-Smtp-Source: AMsMyM7EWpJ7gFlCh3Jln+/dYe1qMlIoeM2gUsYwbQztUdBfRAFaIXRtE/eAHqbh+hehWvK5O+F+xQ==
X-Received: by 2002:a05:6512:22cf:b0:49e:860d:8f4e with SMTP id g15-20020a05651222cf00b0049e860d8f4emr7370759lfu.584.1664819337829;
        Mon, 03 Oct 2022 10:48:57 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id g14-20020a056512118e00b0049e9122bd1bsm1543958lfr.164.2022.10.03.10.48.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 10:48:57 -0700 (PDT)
Message-ID: <c1b64758-219b-9251-cea8-d5301f01ee7f@linaro.org>
Date:   Mon, 3 Oct 2022 19:48:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Content-Language: en-US
To:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221003164624.4823-1-jerry.ray@microchip.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221003164624.4823-1-jerry.ray@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/10/2022 18:46, Jerry Ray wrote:
> Adding the dt binding yaml for the lan9303 3-port ethernet switch.
> The microchip lan9354 3-port ethernet switch will also use the
> same binding.
> 
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
> v3->v4:
>  - Addressed v3 community feedback
> v2->v3:
>  - removed cpu labels
>  - now patching against latest net-next
> v1->v2:
>  - fixed dt_binding_check warning
>  - added max-speed setting on the switches 10/100 ports.
> ---
>  .../devicetree/bindings/net/dsa/lan9303.txt   | 100 -------------
>  .../bindings/net/dsa/microchip,lan9303.yaml   | 134 ++++++++++++++++++
>  MAINTAINERS                                   |   8 ++
>  3 files changed, 142 insertions(+), 100 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/lan9303.txt
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/lan9303.txt b/Documentation/devicetree/bindings/net/dsa/lan9303.txt
> deleted file mode 100644
> index 46a732087f5c..000000000000
> --- a/Documentation/devicetree/bindings/net/dsa/lan9303.txt
> +++ /dev/null
> @@ -1,100 +0,0 @@
> -SMSC/MicroChip LAN9303 three port ethernet switch
> --------------------------------------------------
> -
> -Required properties:
> -
> -- compatible: should be
> -  - "smsc,lan9303-i2c" for I2C managed mode
> -    or
> -  - "smsc,lan9303-mdio" for mdio managed mode
> -
> -Optional properties:
> -
> -- reset-gpios: GPIO to be used to reset the whole device
> -- reset-duration: reset duration in milliseconds, defaults to 200 ms
> -
> -Subnodes:
> -
> -The integrated switch subnode should be specified according to the binding
> -described in dsa/dsa.txt. The CPU port of this switch is always port 0.
> -
> -Note: always use 'reg = <0/1/2>;' for the three DSA ports, even if the device is
> -configured to use 1/2/3 instead. This hardware configuration will be
> -auto-detected and mapped accordingly.
> -
> -Example:
> -
> -I2C managed mode:
> -
> -	master: masterdevice@X {
> -
> -		fixed-link { /* RMII fixed link to LAN9303 */
> -			speed = <100>;
> -			full-duplex;
> -		};
> -	};
> -
> -	switch: switch@a {
> -		compatible = "smsc,lan9303-i2c";
> -		reg = <0xa>;
> -		reset-gpios = <&gpio7 6 GPIO_ACTIVE_LOW>;
> -		reset-duration = <200>;
> -
> -		ports {
> -			#address-cells = <1>;
> -			#size-cells = <0>;
> -
> -			port@0 { /* RMII fixed link to master */
> -				reg = <0>;
> -				ethernet = <&master>;
> -			};
> -
> -			port@1 { /* external port 1 */
> -				reg = <1>;
> -				label = "lan1";
> -			};
> -
> -			port@2 { /* external port 2 */
> -				reg = <2>;
> -				label = "lan2";
> -			};
> -		};
> -	};
> -
> -MDIO managed mode:
> -
> -	master: masterdevice@X {
> -		phy-handle = <&switch>;
> -
> -		mdio {
> -			#address-cells = <1>;
> -			#size-cells = <0>;
> -
> -			switch: switch-phy@0 {
> -				compatible = "smsc,lan9303-mdio";
> -				reg = <0>;
> -				reset-gpios = <&gpio7 6 GPIO_ACTIVE_LOW>;
> -				reset-duration = <100>;
> -
> -				ports {
> -					#address-cells = <1>;
> -					#size-cells = <0>;
> -
> -					port@0 {
> -						reg = <0>;
> -						ethernet = <&master>;
> -					};
> -
> -					port@1 { /* external port 1 */
> -						reg = <1>;
> -						label = "lan1";
> -					};
> -
> -					port@2 { /* external port 2 */
> -						reg = <2>;
> -						label = "lan2";
> -					};
> -				};
> -			};
> -		};
> -	};
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
> new file mode 100644
> index 000000000000..ca6cbe83ba75
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
> @@ -0,0 +1,134 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/microchip,lan9303.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LAN9303 Ethernet Switch Series
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +maintainers:
> +  - UNGLinuxDriver@microchip.com
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - enum:
> +          - smsc,lan9303-mdio
> +          - microchip,lan9354-mdio
> +      - enum:
> +          - smsc,lan9303-i2c
> +          - microchip,lan9354-i2c

This still does not make sense. It is one enum. Drop oneOf.

> +
> +  reg:
> +    maxItems: 1
> +
> +  reset-gpios:
> +    description: Optional reset line
> +    maxItems: 1
> +
> +  reset-duration:
> +    description: Reset duration in milliseconds
> +    default: 200

This is a friendly reminder during the review process.

It seems my previous comments were not fully addressed. Maybe my
feedback got lost between the quotes, maybe you just forgot to apply it.
Please go back to the previous discussion and either implement all
requested changes or keep discussing them.

Thank you.

> +
> +required:
> +  - compatible
> +  - reg
> +
Best regards,
Krzysztof

