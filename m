Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B31565FCB2
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 09:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjAFI0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 03:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbjAFI0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 03:26:09 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E57C6953B
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 00:26:05 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m8-20020a05600c3b0800b003d96f801c48so3048103wms.0
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 00:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L0n/DIgDTfYifomNRqJzUTabMZYhQa7BFKwTKwm66yQ=;
        b=qiRLqYUBA2u2o8wp63XaQ1VC8fn2Tiftp14ohCTvWdoi2JqSvKwHcGcTRvloLjI6tB
         Cye4uonPkFK0xu5bB0aRg+d0beK5vTG7ubVHCQTQeRPDkGjz7LhzULFpZPbGyiAEz+/I
         TZhbECeetpmSogDFh+t93fTk/vRYiFdT2+C1bYxpddDFMWzBhbMHINnNdWGUnIr8nEy/
         BkX3x22vJHs2iANB4Hcz2zb8Rc40LStrfhrDBfRL6oOmdvdL4lM8TIDtidspddMnnhL9
         3oM+d+ploOFa6/yD5zaAkwjpNOZwqHzQpflnASbpucCWsI5b7mQdUF84ioHBUQYWYuK2
         V/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L0n/DIgDTfYifomNRqJzUTabMZYhQa7BFKwTKwm66yQ=;
        b=GhIePTrju3Coj0VN4HKvn6bR+4u4N+Y1JRcUsP4ysx0HD67bCdeq2LW66Gg1ADpyYA
         MSXMFmnBzjPGCKQCpBusLCOThJsiM3POWJE5JOTldulZVO0D32U1g0UJSHSgK0bsG616
         VcZU8mYmdapTsNfKi6Ia6ihbfi0P4DlZU3cK+/N0fuX8RZhB5Eyqbtb7dZOPoOMuIC60
         /jrsWMr9C7CN3y41eREDMzlFZskwV1kt5KO30mvg93D0pPvq72ycNVVgFxEDfL1zY6C6
         PgEoRHvdsiq+/uotnkTFY4CRFE39B/niRx7ENmVNNPUzQgChoLxtdr4J2BpdHWxWK3gt
         jOPw==
X-Gm-Message-State: AFqh2koXb+1PkXR1AhRl5GXUqUvNdYSK/yT5qxKR3vU/7AgZkqPwOsEg
        QgufhY4GHzExCYfNav+QsfOEBw==
X-Google-Smtp-Source: AMrXdXuX4rDk5SLD2+Tq3xdf8miNpN3ODoaCpth4Y3JrZB56qa6ivt8EASjBYJGcf1JMrsCqcPcdwQ==
X-Received: by 2002:a05:600c:3ba7:b0:3d3:4dac:aa69 with SMTP id n39-20020a05600c3ba700b003d34dacaa69mr38293045wms.36.1672993563943;
        Fri, 06 Jan 2023 00:26:03 -0800 (PST)
Received: from [192.168.1.102] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id z14-20020a05600c220e00b003d99fad7511sm821735wml.22.2023.01.06.00.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 00:26:03 -0800 (PST)
Message-ID: <b74baadf-37a4-c9a2-c821-3c3e0143fa4a@linaro.org>
Date:   Fri, 6 Jan 2023 09:26:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
Content-Language: en-US
To:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230105073024.8390-2-Frank.Sae@motor-comm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2023 08:30, Frank wrote:
> Add a YAML binding document for the Motorcom yt8xxx Ethernet phy driver.
> 

Subject: drop second, redundant "Driver bindings".

> Signed-off-by: Frank <Frank.Sae@motor-comm.com>

Use full first and last name. Your email suggests something more than
only "Frank".

> ---
>  .../bindings/net/motorcomm,yt8xxx.yaml        | 180 ++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  MAINTAINERS                                   |   1 +
>  3 files changed, 183 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> new file mode 100644
> index 000000000000..337a562d864c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
> @@ -0,0 +1,180 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/motorcomm,yt8xxx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MotorComm yt8xxx Ethernet PHY
> +
> +maintainers:
> +  - frank <frank.sae@motor-comm.com>
> +
> +description: |
> +  Bindings for MotorComm yt8xxx PHYs.

Instead describe the hardware. No need to state the obvious that these
are bindings.

> +  yt8511 will be supported later.

Bindings should be complete. Your driver support is not relevant here.

> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +properties:
> +  motorcomm,clk-out-frequency:

Use property suffixes matching the type.

> +    description: clock output in Hertz on clock output pin.

Drop "Hertz". It should be obvious from the suffix.

> +    $ref: /schemas/types.yaml#/definitions/uint32

Drop.

Anyway, does it fit standard clock-frequency property?

> +    enum: [0, 25000000, 125000000]
> +    default: 0
> +
> +  motorcomm,rx-delay-basic:
> +    description: |
> +      Tristate, setup the basic RGMII RX Clock delay of PHY.
> +      This basic delay is fixed at 2ns (1000Mbps) or 8ns (100Mbps、10Mbps).
> +      This basic delay usually auto set by hardware according to the voltage
> +      of RXD0 pin (low = 0, turn off;   high = 1, turn on).
> +      If not exist, this delay is controlled by hardware.

I don't understand that at all. What "not exist"? There is no verb and
no subject.

The type and description are really unclear.

> +      0: turn off;   1: turn on.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [0, 1]

So this is bool?

> +
> +  motorcomm,rx-delay-additional-ps:
> +    description: |
> +      Setup the additional RGMII RX Clock delay of PHY defined in pico seconds.
> +      RGMII RX Clock Delay = rx-delay-basic + rx-delay-additional-ps.
> +    enum:

Best regards,
Krzysztof

