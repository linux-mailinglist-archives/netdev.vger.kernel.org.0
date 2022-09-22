Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510405E5C8E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiIVHhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiIVHhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:37:33 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D4ED12F9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:37:31 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id k10so13258248lfm.4
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 00:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=8BVSexZBc25zbrsl/l7cQOLYh/H9gnI+qVwKufcx9yk=;
        b=ENUvG4IvlLlpDT+Ei5lYUR13g4b/zaFM2hrm26L5653C8QXm1h/Lnp/+1cFn/OLIXt
         mSeR+y9113Oe3CPYDy1xbthb4LTb+1x+xR4lUdcaYU4djTeoHsaKHuIKDG5BviN5rOsN
         hZdLCF/7jX7y1Jy06XF+/5TIhOpxhpZK/oiHT5wLO9xfvBajfzoY3fszvKCPYPUXE8Lz
         nySlvUGE/nKncPsN/+AFSgimvrpceY/pJoKwMwnJO2hjGUClDZrGstnfIW57vHHAEee1
         T/pikliVPbAE4rQkpkuS7cNxiZSh5DxqYa+PTcDUoyF2LC6Y0xnMH1elFCxfuDK8hNIC
         dM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8BVSexZBc25zbrsl/l7cQOLYh/H9gnI+qVwKufcx9yk=;
        b=sO0BREmP91CmAzAVX5YZksNRgQa53bRrfXZ0hxm5k2rWE0ZvnNvbrjZY99AsrNUQT3
         +4Z2awQjJ5EmBWZh5JOXKn3LTvxxAstlvSNhCx18xaU/s739588cOfXvkbQjzLH7JYKo
         jifvcwDacgOc7BLrrh/Xv4VppBFsTKZKZm8ccjjRn8XGIb0+99M8DCjnJMPl7ki8jDPe
         Lubw/pBPuUjJEg/eyEdFLlS9lPSn5kKdK0u8W6nnW3+OlBTbeTB4QsOrCzPDOoL2mQ+P
         KEpmW33P8lcESq9HmJPYH2ur9gN8aVeWEJDChNz87TvDWYqr+w9JKiEZaRVb4bkTrq2H
         rc0w==
X-Gm-Message-State: ACrzQf1SIG4uiJ/WfC7UjDMSHVGYS82CifhzIHR+zuE0Zz/HvdGriD1q
        yBcXtSkZtf47rWQBanBKhL9YZw==
X-Google-Smtp-Source: AMsMyM4icsDLCQT6inm4QJfBmT99ZewPmbUn4YwLRftC6bjuLujDwNjk9aBvXqhfrUTBAPi115qcXw==
X-Received: by 2002:a05:6512:3047:b0:497:ab72:97f1 with SMTP id b7-20020a056512304700b00497ab7297f1mr672265lfb.624.1663832249776;
        Thu, 22 Sep 2022 00:37:29 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id f18-20020ac24992000000b0048b003c4bf7sm800651lfl.169.2022.09.22.00.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 00:37:29 -0700 (PDT)
Message-ID: <1aebd827-3ff4-8d13-ca85-acf4d3a82592@linaro.org>
Date:   Thu, 22 Sep 2022 09:37:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 4/8] dt-bindings: net: renesas: Document Renesas
 Ethernet Switch
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        kishon@ti.com, vkoul@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be
Cc:     andrew@lunn.ch, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
 <20220921084745.3355107-5-yoshihiro.shimoda.uh@renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220921084745.3355107-5-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/09/2022 10:47, Yoshihiro Shimoda wrote:
> Document Renesas Etherent Switch for R-Car S4-8 (r8a779f0).
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  .../bindings/net/renesas,etherswitch.yaml     | 286 ++++++++++++++++++
>  1 file changed, 286 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml
> new file mode 100644
> index 000000000000..988d14f5c54e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/renesas,etherswitch.yaml

Isn't dsa directory for this?

> @@ -0,0 +1,286 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/renesas,etherswitch.yaml#

Filename: renesas,r8a779f0-ether-switch.yaml

> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas Ethernet Switch
> +
> +maintainers:
> +  - Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> +
> +properties:
> +  compatible:
> +    const: renesas,r8a779f0-ether-switch
> +
> +  reg:
> +    maxItems: 2
> +
> +  reg-names:
> +    items:
> +      - const: base
> +      - const: secure_base
> +
> +  interrupts:
> +    maxItems: 47
> +
> +  interrupt-names:
> +    items:
> +      - const: mfwd_error
> +      - const: race_error
> +      - const: coma_error
> +      - const: gwca0_error
> +      - const: gwca1_error
> +      - const: etha0_error
> +      - const: etha1_error
> +      - const: etha2_error
> +      - const: gptp0_status
> +      - const: gptp1_status
> +      - const: mfwd_status
> +      - const: race_status
> +      - const: coma_status
> +      - const: gwca0_status
> +      - const: gwca1_status
> +      - const: etha0_status
> +      - const: etha1_status
> +      - const: etha2_status
> +      - const: rmac0_status
> +      - const: rmac1_status
> +      - const: rmac2_status
> +      - const: gwca0_rxtx0
> +      - const: gwca0_rxtx1
> +      - const: gwca0_rxtx2
> +      - const: gwca0_rxtx3
> +      - const: gwca0_rxtx4
> +      - const: gwca0_rxtx5
> +      - const: gwca0_rxtx6
> +      - const: gwca0_rxtx7
> +      - const: gwca1_rxtx0
> +      - const: gwca1_rxtx1
> +      - const: gwca1_rxtx2
> +      - const: gwca1_rxtx3
> +      - const: gwca1_rxtx4
> +      - const: gwca1_rxtx5
> +      - const: gwca1_rxtx6
> +      - const: gwca1_rxtx7
> +      - const: gwca0_rxts0
> +      - const: gwca0_rxts1
> +      - const: gwca1_rxts0
> +      - const: gwca1_rxts1
> +      - const: rmac0_mdio
> +      - const: rmac1_mdio
> +      - const: rmac2_mdio
> +      - const: rmac0_phy
> +      - const: rmac1_phy
> +      - const: rmac2_phy
> +
> +  clocks:
> +    maxItems: 2
> +
> +  clock-names:
> +    items:
> +      - const: fck
> +      - const: tsn
> +
> +  resets:
> +    maxItems: 2
> +
> +  reset-names:
> +    items:
> +      - const: rswitch2
> +      - const: tsn
> +
> +  iommus:
> +    maxItems: 16
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  ethernet-ports:
> +    type: object
> +
> +    properties:
> +      '#address-cells':
> +        description: Port number of ETHA (TSNA).
> +        const: 1

Blank line

> +      '#size-cells':
> +        const: 0
> +
> +    additionalProperties: false

Don't put it between properties. For nested object usually this is
before properties:

> +
> +    patternProperties:
> +      "^port@[0-9a-f]+$":
> +        type: object
> +

Skip blank line.

> +        $ref: "/schemas/net/ethernet-controller.yaml#"

No need for quotes.

> +        unevaluatedProperties: false
> +
> +        properties:
> +          reg:
> +            description:
> +              Port number of ETHA (TSNA).
> +
> +          phy-handle:
> +            description:
> +              Phandle of an Ethernet PHY.

Why do you need to mention this property? Isn't it coming from
ethernet-controller.yaml?

> +
> +          phy-mode:
> +            description:
> +              This specifies the interface used by the Ethernet PHY.
> +            enum:
> +              - mii
> +              - sgmii
> +              - usxgmii
> +
> +          phys:
> +            maxItems: 1
> +            description:
> +              Phandle of an Ethernet SERDES.

This is getting confusing. You have now:
- phy-handle
- phy
- phy-device
- phys
in one schema... although lan966x serdes seems to do the same. :/

> +
> +          mdio:
> +            $ref: "/schemas/net/mdio.yaml#"

No need for quotes. Are you sure this is property of each port? I don't
know the net/ethernet bindings that good, so I need to ask sometimes
basic questions. Other bindings seem to do it differently a bit.

> +            unevaluatedProperties: false
> +
> +        required:
> +          - phy-handle
> +          - phy-mode
> +          - phys
> +          - mdio
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +  - clocks
> +  - clock-names
> +  - resets
> +  - power-domains
> +  - ethernet-ports
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/r8a779f0-cpg-mssr.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/power/r8a779f0-sysc.h>
> +
> +    ethernet@e6880000 {
> +            compatible = "renesas,r8a779f0-ether-switch";

Wrong indentation. Use 4 spaces.

> +            reg = <0xe6880000 0x20000>, <0xe68c0000 0x20000>;
> +            reg-names = "base", "secure_base";
> +            interrupts = <GIC_SPI 256 IRQ_TYPE_LEVEL_HIGH>,
> +                         <GIC_SPI 257 IRQ_TYPE_LEVEL_HIGH>,
Best regards,
Krzysztof

