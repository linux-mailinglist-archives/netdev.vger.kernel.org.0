Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AEA580579
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbiGYUYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiGYUYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:24:42 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F67E21E15
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:24:41 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id p11so14930427lfu.5
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TbcWMIxOgS2eY9LKbWN7Jh5YaS16I8ZOe/jkBgpK/pc=;
        b=xtQo5uH95PEf7n57pRRLiQb5kBjmQyJpg4Sngxr8ubmZim6bXxyig0k9B1xnXSX5/v
         AkTfTgl9FPPczL003j4tClh7RPkq89K8wDVMn0/+zKl73RCWD7lwXKCZ46Escj/FWHL9
         Uw8Q0yCtVupJjrtrW3cqWlwBFghJdKu4TyDDaDLDtN45hkIYPEoxXj+i1BUyfcjj4J5C
         0nsPgq14gwFjdLMslqbw7HljlxdMaT7pzvuZGa7Y9+VrI+RmSKaVQYGuTTwG01wBLvya
         TcHoSp5i9DsPqGuU3tMwvPU6srXR86HIMbgYc6Gj4S/QInQrmkD4oumCMvEecbudIcqK
         QYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TbcWMIxOgS2eY9LKbWN7Jh5YaS16I8ZOe/jkBgpK/pc=;
        b=Sf+CvybC5+4Ae/8G0HOXNNfE7RiaUdOmpgFtz2qqAaVe8D+tnMIgd71m7j7mM5ULpm
         ozMLQjjwH0K/z4qEIq1rAtEifXcs6MYJNxkYwcuOEYLA+04j4J7qIzU6i5i8+jcdr/gD
         bGzcxTHVahk9ZQX+1qxJa5G3IhB9bmy//xGC9K533ec0WuP8ee78rOHuXOU0UR2O6/wN
         eroFatdyP9d8833SaVdumEeT3j2e/1ZxPn7FnLiPmcXjL4OnTEzbkiamcf7DHRL4bnCb
         in85SpQZR7HBLrzfV0NBElmcpA5K6JFrrJQIht9HUhn/3Hc+kSpJRjoCOn3EEt0Os8z/
         5tmw==
X-Gm-Message-State: AJIora+GEkM/Q5VB6Txyq/qpduFhQD2cwXDkBE8502JX+TpXKwnZoSQk
        EeBBQKJfF7NL1QwVSv/2rewM4Q==
X-Google-Smtp-Source: AGRyM1tT4HN8CQZCaIz5ID8bu0HEGGk2g9UcEu9SnXxnK5ddIhwLhHuxim+rGUxe6JWcpcZ3L860WA==
X-Received: by 2002:a05:6512:1523:b0:48a:9ef0:6c17 with SMTP id bq35-20020a056512152300b0048a9ef06c17mr202991lfb.666.1658780679738;
        Mon, 25 Jul 2022 13:24:39 -0700 (PDT)
Received: from [192.168.3.197] (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id v15-20020a2e87cf000000b0025de6edd4a0sm1273226ljj.83.2022.07.25.13.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 13:24:39 -0700 (PDT)
Message-ID: <739dcb53-3859-e53f-2bbe-9099d5bd0052@linaro.org>
Date:   Mon, 25 Jul 2022 22:24:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [net-next v2 3/3] dt-bindings: net: adin1110: Add docs
Content-Language: en-US
To:     alexandru.tachici@analog.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        devicetree@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        gerhard@engleder-embedded.com, geert+renesas@glider.be,
        joel@jms.id.au, stefan.wahren@i2se.com, wellslutw@gmail.com,
        geert@linux-m68k.org, robh+dt@kernel.org,
        d.michailidis@fungible.com, stephen@networkplumber.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org
References: <20220725165312.59471-1-alexandru.tachici@analog.com>
 <20220725165312.59471-4-alexandru.tachici@analog.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220725165312.59471-4-alexandru.tachici@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/07/2022 18:53, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1110.yaml | 81 +++++++++++++++++++
>  1 file changed, 81 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/adi,adin1110.yaml b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
> new file mode 100644
> index 000000000000..cc83f08c0a55
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
> @@ -0,0 +1,81 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/adi,adin1110.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: ADI ADIN1110 MAC-PHY
> +
> +maintainers:
> +  - Alexandru Tachici <alexandru.tachici@analog.com>
> +
> +description: |
> +  The ADIN1110 is a low power single port 10BASE-T1L MAC-
> +  PHY designed for industrial Ethernet applications. It integrates
> +  an Ethernet PHY core with a MAC and all the associated analog
> +  circuitry, input and output clock buffering.
> +
> +  The ADIN2111 is a low power, low complexity, two-Ethernet ports
> +  switch with integrated 10BASE-T1L PHYs and one serial peripheral
> +  interface (SPI) port. The device is designed for industrial Ethernet
> +  applications using low power constrained nodes and is compliant
> +  with the IEEE 802.3cg-2019 Ethernet standard for long reach
> +  10 Mbps single pair Ethernet (SPE).
> +
> +  The device has a 4-wire SPI interface for communication
> +  between the MAC and host processor.
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - adi,adin1110
> +      - adi,adin2111
> +
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 0
> +
> +  reg:
> +    maxItems: 1
> +
> +  adi,spi-crc:
> +    description: |
> +      Enable CRC8 checks on SPI read/writes.
> +    type: boolean
> +
> +  interrupts:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    spi {
> +        ethernet@0 {
> +            compatible = "adi,adin2111";
> +            reg = <0>;
> +            spi-max-frequency = <24500000>;

Rob's bot complained about this. As a SPI slave device, this should also
reference spi-peripheral-props.yaml


Best regards,
Krzysztof
