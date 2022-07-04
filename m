Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684DB564FFA
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiGDIqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiGDIqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:46:14 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED657B7FC
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 01:46:11 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id l7so9472130ljj.4
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 01:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xJucMBBVgLFaDWx/IxVDD7JFEiYSXfSNtLyo4IJhtmw=;
        b=Jly84Hez17nHBBCyIwtgxEzZmasK3vuTBTvn17TPq/mEtvjIQVAfXkHZzNlUtB8CD6
         tO3v0QANG6qxyXhGc30vPx2Vptn8h1KDS2t+FKSEmdSG9FBpIw93KEOusq2Z01w5r+Q7
         iQB8dhdn/iqtqtq/AzyuGLAOyPagwed7qKXmZZDNuO6XPX0gq43iOVg75xW/T1Sbzm0D
         ii05EkckmpW9G3zYbnSSbMcturY1ccDz8oqRUZnzM0ieLXcEcsyaOKIMH8t3VlyGmE9K
         RlaJQ1O5djj1dmgfcGgVnhcGFJYgPL9zF12x3nTMEHspdvaQ3NLilNcIXznmYy0GNNeq
         kkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xJucMBBVgLFaDWx/IxVDD7JFEiYSXfSNtLyo4IJhtmw=;
        b=uo+qRPGWmyYQQSnXV6jGbl8Y2aJYYKZBFrTPJ9ff3WtHhhbxsCy8uJSU8nBfViB7UF
         YyfuiaV9AV/eDn19O7ZarLv9DvLUgVYQrVqw6pTji/c70r1ogfg8tNVrZEJJm0dvL/eS
         BQ0DVWJCdM/A/2qo8MbikPiS/b7GfVJruILJvhTT9M2L0To9YfmCzOYD3QcoDaA9oMd2
         Cl+f5v8HxC58cK/atNV+UU6ozdKhPaxUAm/Zm/hx3g5R74gwo/RQQyifElJiWMuD4N6T
         adsf+S07H48X04UCkitbpv4PgnDcc4vTYIjLLpONkMxpWKBhP+YVAvs2dex/CDSDn0bI
         urDw==
X-Gm-Message-State: AJIora80T6gw/AGJXq0/Q2OyY5sZfKDOidHfMrSPSy8+lUelt1qnsEGE
        Z/H8knuD7hDgKf5YrNEwsxNR7A==
X-Google-Smtp-Source: AGRyM1vMhMoNUqEc1UYrBjtEnTzvDBBi8UxHplKkyyv+BsID5o7X0JEB8oxggGxlwGfsDSBE47wD5Q==
X-Received: by 2002:a05:651c:4d0:b0:25b:b6f4:ae2d with SMTP id e16-20020a05651c04d000b0025bb6f4ae2dmr15906578lji.472.1656924370247;
        Mon, 04 Jul 2022 01:46:10 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id be37-20020a05651c172500b0025d19a2677asm970416ljb.76.2022.07.04.01.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 01:46:09 -0700 (PDT)
Message-ID: <ed032ae8-6a2b-b79f-d42a-6e96fe53a0d7@linaro.org>
Date:   Mon, 4 Jul 2022 10:46:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/6] dt-bindings: can: sja1000: Convert to json-schema
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
 <20220704075032.383700-2-biju.das.jz@bp.renesas.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220704075032.383700-2-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/07/2022 09:50, Biju Das wrote:
> Convert the NXP SJA1000 CAN Controller Device Tree binding
> documentation to json-schema.
> 
> Update the example to match reality.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v2->v3:
>  * Added reg-io-width is a required property for technologic,sja1000
>  * Removed enum type from nxp,tx-output-config and updated the description
>    for combination of TX0 and TX1.
>  * Updated the example
> v1->v2:
>  * Moved $ref: can-controller.yaml# to top along with if conditional to
>    avoid multiple mapping issues with the if conditional in the subsequent
>    patch.
> ---
>  .../bindings/net/can/nxp,sja1000.yaml         | 103 ++++++++++++++++++
>  .../devicetree/bindings/net/can/sja1000.txt   |  58 ----------
>  2 files changed, 103 insertions(+), 58 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/sja1000.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> new file mode 100644
> index 000000000000..d34060226e4e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
> @@ -0,0 +1,103 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/nxp,sja1000.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
> +
> +maintainers:
> +  - Wolfgang Grandegger <wg@grandegger.com>
> +
> +allOf:
> +  - $ref: can-controller.yaml#
> +  - if:

The advice of moving it up was not correct. The allOf containing ref and
if:then goes to place like in example-schema, so before
additional/unevaluatedProperties at the bottom.

Please do not introduce some inconsistent style.

> +      properties:
> +        compatible:
> +          contains:
> +            const: technologic,sja1000
> +    then:
> +      required:
> +        - reg-io-width
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - description: NXP SJA1000 CAN Controller
> +        const: nxp,sja1000
> +      - description: Technologic Systems SJA1000 CAN Controller
> +        const: technologic,sja1000

Entire entry should be just enum. Descriptions do not bring any
information - they copy compatible.

> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  reg-io-width:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: I/O register width (in bytes) implemented by this device
> +    default: 1
> +    enum: [ 1, 2, 4 ]
> +
> +  nxp,external-clock-frequency:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    default: 16000000
> +    description: |
> +      Frequency of the external oscillator clock in Hz.
> +      The internal clock frequency used by the SJA1000 is half of that value.
> +
> +  nxp,tx-output-mode:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [ 0, 1, 2, 3 ]
> +    default: 1
> +    description: |
> +      operation mode of the TX output control logic. Valid values are:
> +        <0x0> : bi-phase output mode
> +        <0x1> : normal output mode (default)
> +        <0x2> : test output mode
> +        <0x3> : clock output mode

Use decimal values, just like in enum.

> +
> +  nxp,tx-output-config:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    default: 0x02
> +    description: |
> +      TX output pin configuration. Valid values are any one of the below
> +      or combination of TX0 and TX1:
> +        <0x01> : TX0 invert
> +        <0x02> : TX0 pull-down (default)
> +        <0x04> : TX0 pull-up
> +        <0x06> : TX0 push-pull
> +        <0x08> : TX1 invert
> +        <0x10> : TX1 pull-down
> +        <0x20> : TX1 pull-up
> +        <0x30> : TX1 push-pull
> +
> +  nxp,clock-out-frequency:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: |
> +      clock frequency in Hz on the CLKOUT pin.
> +      If not specified or if the specified value is 0, the CLKOUT pin
> +      will be disabled.
> +
> +  nxp,no-comparator-bypass:
> +    type: boolean
> +    description: Allows to disable the CAN input comparator.
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
> +    can@1a000 {
> +            compatible = "technologic,sja1000";

Unusual indentation. Use 4 spaces for the DTS example.

> +            reg = <0x1a000 0x100>;
> +            interrupts = <1>;
> +            reg-io-width = <2>;
> +            nxp,tx-output-config = <0x06>;
> +            nxp,external-clock-frequency = <24000000>;
> +    };
> diff --git a/Documentation/devicetree/bindings/net/can/sja1000.txt b/Documentation/devicetree/bindings/net/can/sja1000.txt
> deleted file mode 100644
> index ac3160eca96a..000000000000
> --- a/Documentation/devicetree/bindings/net/can/sja1000.txt
> +++ /dev/null
> @@ -1,58 +0,0 @@
> -Memory mapped SJA1000 CAN controller from NXP (formerly Philips)
> -
> -Required properties:
> -
> -- compatible : should be one of "nxp,sja1000", "technologic,sja1000".
> -
> -- reg : should specify the chip select, address offset and size required
> -	to map the registers of the SJA1000. The size is usually 0x80.
> -
> -- interrupts: property with a value describing the interrupt source
> -	(number and sensitivity) required for the SJA1000.
> -
> -Optional properties:
> -
> -- reg-io-width : Specify the size (in bytes) of the IO accesses that
> -	should be performed on the device.  Valid value is 1, 2 or 4.
> -	This property is ignored for technologic version.
> -	Default to 1 (8 bits).
> -
> -- nxp,external-clock-frequency : Frequency of the external oscillator
> -	clock in Hz. Note that the internal clock frequency used by the
> -	SJA1000 is half of that value. If not specified, a default value
> -	of 16000000 (16 MHz) is used.
> -
> -- nxp,tx-output-mode : operation mode of the TX output control logic:
> -	<0x0> : bi-phase output mode
> -	<0x1> : normal output mode (default)
> -	<0x2> : test output mode
> -	<0x3> : clock output mode
> -
> -- nxp,tx-output-config : TX output pin configuration:
> -	<0x01> : TX0 invert
> -	<0x02> : TX0 pull-down (default)
> -	<0x04> : TX0 pull-up
> -	<0x06> : TX0 push-pull
> -	<0x08> : TX1 invert
> -	<0x10> : TX1 pull-down
> -	<0x20> : TX1 pull-up
> -	<0x30> : TX1 push-pull
> -
> -- nxp,clock-out-frequency : clock frequency in Hz on the CLKOUT pin.
> -	If not specified or if the specified value is 0, the CLKOUT pin
> -	will be disabled.
> -
> -- nxp,no-comparator-bypass : Allows to disable the CAN input comparator.
> -
> -For further information, please have a look to the SJA1000 data sheet.
> -
> -Examples:
> -
> -can@3,100 {
> -	compatible = "nxp,sja1000";
> -	reg = <3 0x100 0x80>;
> -	interrupts = <2 0>;
> -	interrupt-parent = <&mpic>;
> -	nxp,external-clock-frequency = <16000000>;
> -};
> -


Best regards,
Krzysztof
