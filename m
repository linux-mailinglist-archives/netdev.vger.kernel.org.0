Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A1C55ACB2
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 22:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiFYU7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 16:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbiFYU7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 16:59:38 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F4F12AD7
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 13:59:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id eo8so8001943edb.0
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 13:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8DfPB+6+v8MPZjnhRqnPJ95rq7IbN6JaoTlReGsTtZw=;
        b=J1Y9airSGKm4W7Ntehp1NBPUtCHFAsGVCmPiLsw4GI8HIpoML+FgByP9iG2S0A9b85
         dvac41Ml0vNUDWuyyje4WZ/buNkqUi7buep79Rv5+UMFwHoKlrHl6otkBjf2bhnjfPhQ
         iZiwzxC9IkBC+mhJ+ef7vpBe2zQaQTkqLVApmDYudVZVcxlvcZCI2dE+fGtfJicQAt+0
         GXWFSEclRoyQhImU3H4mY1VtsqoQ8W1JbU7qefb1Jznc+vLRA436+2qJ4xQlVzam8WSM
         eCXATZxTwl5LLJlXW+l4xcNBRjEo1pbmMl2pUoUpFlKDZZfxb0yVjefS9BIGOpwqjenv
         OrHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8DfPB+6+v8MPZjnhRqnPJ95rq7IbN6JaoTlReGsTtZw=;
        b=PDYOQ6tQmjvQZ0TieCd/b3/t7Zi99ZlHbAQ1DIdAYuSumj128ZpmhsrMuhftsH96+j
         JctasJBfYXEYo7qTutDs+7qYKdy/J1Xo9fwEhvzsb55f7WE8SAxi80kCbGPV3caVzXpL
         7hR6hYAF2tcGel3GNd8QOggksMSIn0HJocZTJzsqVuwSll09I09barieKrrKjmrBJhTN
         1L6JOv7teOOnkUl87O/QKwqARumgkleE8akstFCqmVFvVvnRbNv+F83sCSvRfiVZbgCM
         lP3LF6aFt048jenambcgECgzWGHmixKRHnk6fFxLZc+iE3jb73qNWT9p70IDG11eNWAT
         g6yA==
X-Gm-Message-State: AJIora9QqKJ/MhP1Lk5IanXCasEhORzkPIki5VE5OGcq6jIHkIpAuI0N
        Px5ic/urQQKcGEl0beaM/IxtNQ==
X-Google-Smtp-Source: AGRyM1tRJB/iLbCtlrDGd9h3fOaIgHK7o7Kfgt52jMoZJEqIJ0+P5rwgbJa9NFoitReQKaqnlDEzow==
X-Received: by 2002:a05:6402:4244:b0:437:726c:e1a with SMTP id g4-20020a056402424400b00437726c0e1amr4502166edb.107.1656190775076;
        Sat, 25 Jun 2022 13:59:35 -0700 (PDT)
Received: from [192.168.0.239] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id g3-20020a1709061c8300b0070759e37183sm3007655ejh.59.2022.06.25.13.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jun 2022 13:59:34 -0700 (PDT)
Message-ID: <f14c4deb-6430-5f9e-1607-81e661b6d5e2@linaro.org>
Date:   Sat, 25 Jun 2022 22:59:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [net-next 2/2] dt-bindings: net: adin1110: Add docs
Content-Language: en-US
To:     alexandru.tachici@analog.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        devicetree@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        gerhard@engleder-embedded.com, geert+renesas@glider.be,
        joel@jms.id.au, stefan.wahren@i2se.com, wellslutw@gmail.com,
        geert@linux-m68k.org, robh+dt@kernel.org,
        d.michailidis@fungible.com, stephen@networkplumber.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org
References: <20220624200628.77047-1-alexandru.tachici@analog.com>
 <20220624200628.77047-3-alexandru.tachici@analog.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220624200628.77047-3-alexandru.tachici@analog.com>
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

On 24/06/2022 22:06, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1110.yaml | 127 ++++++++++++++++++
>  1 file changed, 127 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/adi,adin1110.yaml b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
> new file mode 100644
> index 000000000000..0ac18dd62e5a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
> @@ -0,0 +1,127 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/adi,adin1110.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"

No quotes in both of above.

> +
> +title: ADI ADIN1110 MAC-PHY
> +
> +allOf:

allOf goes after description.

> +  - $ref: ethernet-controller.yaml#
> +  - $ref: spi-controller.yaml#

From the description it looks it is SPI device, not a controller.

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
> +patternProperties:
> +  "^phy@[0-1]$":

[01] is shorter

"phy" child node is deprecated, so phy@0 and phy@1, I think, as well.
Look how other ethernet controllers are doing it.

> +    description: |
> +      ADIN1100 PHY that is present on the same chip as the MAC.
> +    type: object
> +
> +    properties:
> +      reg:

maxItems:1

> +        items:
> +          maximum: 1
> +
> +    allOf:
> +      - if:
> +          properties:
> +            compatible:

I am not sure this works correctly... You reference here parent
properties but then change them to some other compatible?

Did you actually test that this works as it should?

> +              contains:
> +                const: adi,adin1110
> +        then:
> +          properties:
> +            compatible:
> +              const: ethernet-phy-id0283.bc91
> +        else:
> +          properties:
> +            compatible:
> +              const: ethernet-phy-id0283.bca1
> +
> +    required:
> +      - compatible
> +      - reg
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - phy@0
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +        spi0 {

1. spi, not spi0
2. Wrong indentation. Use 4 spaces for DTS example.


> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                status = "okay";

This is not needed.

> +
> +                ethernet@0 {
> +                        compatible = "adi,adin2111";
> +                        reg = <0>;
> +                        spi-max-frequency = <24500000>;
> +
> +                        adi,spi-crc;
> +
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        interrupt-parent = <&gpio>;
> +                        interrupts = <25 2>;

"2" looks like interrupt flag, so use it.

> +
> +                        mac-address = [ ca 2f b7 10 23 63 ];

This should be rather some 00 11 22 type of MAC, or you expect to encode
same MAC in several devices?

> +
> +                        phy@0 {
> +                                #phy-cells = <0>;
> +                                compatible = "ethernet-phy-id0283.bca1";
> +                                reg = <0>;
> +                        };
> +
> +                        phy@1 {
> +                                #phy-cells = <0>;
> +                                compatible = "ethernet-phy-id0283.bca1";
> +                                reg = <1>;
> +                        };
> +                };
> +        };


Best regards,
Krzysztof
