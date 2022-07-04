Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80162565001
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiGDIsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiGDIsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:48:15 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B81BC37
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 01:48:13 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s14so10239565ljs.3
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 01:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=x6YrgXdgJuHk96zcSzLx5P4aQNGafp08HahAVfIDvNQ=;
        b=U0FVCyUbDjv6hJgDnDNGA6Y7OeR1Js9TKaIMudF2r2B0L7NoaBcQP5uIp+Y06Sw6hp
         Ej7EHr5wPEjxx3m8Pd9KFOrPDLo+8Des31+ApwZ5gjkfhTPCo2T31XXOeeXuWp2nf3Yj
         ftaM62EC6xJN8UJffIfIFTvPTtsAU701ed6OeSU5tlgCYXys4GlQI2x0YgBhGQsd8lA4
         kDgU8H+r4txu5xLAI7kRanu5ew4VNY3A38NkBiXr4+WTY4IfmIENVYD6kadQx2Z7gT9P
         q3cyx/2V0n2dh/sqnxx1dOR8BG6TcWqf/9qAKcMPiSBFjgYXQAYPgCA5FUc7FN9BOTM5
         8NJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x6YrgXdgJuHk96zcSzLx5P4aQNGafp08HahAVfIDvNQ=;
        b=BeJ5obZLho+Bnl17a9p9yPNIADF8bHPGllWehA5/agEC4HYpevyZ+XGiGDCZjrN0tD
         he8W0r73NsK/SXHRIwmtLZS2h0acAeEXYc+3MdArXRNC38hc5w53Ix0ovKwdeEUe6UXU
         U+AH8kfdfXP+/0RcXQrjV9z0+QcOh611sIqUAckFw0FX0Xz0aWdDGzGsa3cAJr6CruxA
         vn/PZbAbtXkGi9c3LO4SkK98mlhlrd7vbYEW7Zw6IuAUnu4IrjYv3q2h3E3r6RtoH8Xo
         sw3Hjz0jboPv1zJDQBWZLbBmT9HwPMxvu0EDaEkVmjBZOAiKi+2CUtuJfgcOr71+LVF7
         eUkQ==
X-Gm-Message-State: AJIora9IueK7UwOrLZ2nT/nkk47xRDRBssyzKoSnp9RVWM3DZOmig2rD
        /b8Yk9C2yhN76zjU3GfYY7aYpA==
X-Google-Smtp-Source: AGRyM1ugMP7vXlWpCyPYsCILvvEMOBppXRlOIsGBTBGpK5YsaS1Q7c7VXr62syPXM3cr/3QOlaCv/w==
X-Received: by 2002:a2e:bd13:0:b0:244:da2f:ff4d with SMTP id n19-20020a2ebd13000000b00244da2fff4dmr15361779ljq.213.1656924492053;
        Mon, 04 Jul 2022 01:48:12 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id 8-20020ac25f08000000b00478f1bd611csm5027189lfq.284.2022.07.04.01.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 01:48:11 -0700 (PDT)
Message-ID: <9124be7e-2512-da31-631f-e74ae8c3175c@linaro.org>
Date:   Mon, 4 Jul 2022 10:48:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 2/6] dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S}
 support
Content-Language: en-US
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
References: <20220704075032.383700-1-biju.das.jz@bp.renesas.com>
 <20220704075032.383700-3-biju.das.jz@bp.renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220704075032.383700-3-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/07/2022 09:50, Biju Das wrote:
> Add CAN binding documentation for Renesas RZ/N1 SoC.
> 
> The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
> to others like it has no clock divider register (CDR) support and it has
> no HW loopback (HW doesn't see tx messages on rx), so introduced a new
> compatible 'renesas,rzn1-sja1000' to handle these differences.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v2->v3:
>  * Added reg-io-width is required property for renesas,rzn1-sja1000.
> v1->v2:
>  * Updated commit description.
>  * Added an example for RZ/N1D SJA1000 usage
> ---
>  .../bindings/net/can/nxp,sja1000.yaml         | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> index d34060226e4e..16786475eae3 100644
> --- a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> +++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> @@ -19,6 +19,16 @@ allOf:
>      then:
>        required:
>          - reg-io-width
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: renesas,rzn1-sja1000
> +    then:
> +      required:
> +        - clocks
> +        - clock-names
> +        - reg-io-width
>  
>  properties:
>    compatible:
> @@ -27,6 +37,12 @@ properties:
>          const: nxp,sja1000
>        - description: Technologic Systems SJA1000 CAN Controller
>          const: technologic,sja1000
> +      - description: Renesas RZ/N1 SJA1000 CAN Controller
> +        items:
> +          - enum:
> +              - renesas,r9a06g032-sja1000 # RZ/N1D
> +              - renesas,r9a06g033-sja1000 # RZ/N1S
> +          - const: renesas,rzn1-sja1000 # RZ/N1

This explains usage of oneOf, but still earlier entries should be just
an enum.

>  
>    reg:
>      maxItems: 1
> @@ -34,6 +50,12 @@ properties:
>    interrupts:
>      maxItems: 1
>  
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    const: can_clk

Skip entire clock-names. Does not bring any information, especially that
name is obvious.

> +
>    reg-io-width:
>      $ref: /schemas/types.yaml#/definitions/uint32
>      description: I/O register width (in bytes) implemented by this device
> @@ -101,3 +123,16 @@ examples:
>              nxp,tx-output-config = <0x06>;
>              nxp,external-clock-frequency = <24000000>;
>      };
> +
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/r9a06g032-sysctrl.h>
> +
> +    can@52104000 {
> +            compatible = "renesas,r9a06g032-sja1000","renesas,rzn1-sja1000";

Missing space after ,

Wrong indentation.

> +            reg = <0x52104000 0x800>;
> +            reg-io-width = <4>;
> +            interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
> +            clocks = <&sysctrl R9A06G032_HCLK_CAN0>;
> +            clock-names = "can_clk";
> +    };


Best regards,
Krzysztof
