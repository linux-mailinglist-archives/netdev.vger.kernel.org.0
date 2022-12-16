Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7531B64EA0F
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 12:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiLPLPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 06:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiLPLPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:15:36 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FDA3723C
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:15:34 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id h10so1763768ljk.11
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XNmN8YSKMj8sewHmvzrRIH5jM9zSiZZ/kn+ymwWEngE=;
        b=EVpOLThGVmDOAFHwste+9mKNye5vUKeVIh74RNp6XeKz8XddVc9K2rx8ZGTx/WY8pe
         YfH29ku09sCGD8k37Cys5pS2COm6I7OU6/4ITJxHwSmdbkJDTUI8U5fbudaeCdh7Kl5p
         vdyr+VK+A9dFD1bvxjM1fEM3CavybkuqMf661K9AYpxQ1jHRdYJQFh3al0taLwCz52xU
         giW5qCP6GnolIVNwlDskg70vMgkAh9sfQW9yVDQxSLWwbpKzQd68I9vn1Fy2AQs1npi/
         ssvazCNj4uevDXF6qweG8bFgD7auqEWvXOo1TTriQSwQO4mLlaPat0JRh68uYLNOIcRL
         n/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNmN8YSKMj8sewHmvzrRIH5jM9zSiZZ/kn+ymwWEngE=;
        b=qjwSm5yveIz9+TkobT9LQ6XZl+mRxeHVQE5YEIVUIFQoTLwl+2iSsvzjkbnFzDMYuy
         2Z4MO7FNVG4v3zRYrEvYqYL1tz8tPvc/VdoBA2VWrcVaTnZ5kt4jMZ6Q9w+XcvljReak
         vjvUoZfuzN2umBWDPNgEeI8WzXG5osPptCzPlzDL760HGwowK1GOro8+RKvBmo2l1JbE
         qwkepF94O5b5geXUsFrVwIbrszB/n1/zKmcOr+5aZzLxIvLuJ716bbuZiBmoO/JkvL5j
         sy7Su4z+vU2+Y1g6Q/hfidyLpkN+PUcl9hL1G9MsFfSzyhjkQ5g+723jiyxRqI/2P+tJ
         KBxg==
X-Gm-Message-State: ANoB5plkmkXsVQuy25iEs2hutdR/zqxvZGozXe69jiwySD/QQCT/1ZXk
        COtwAxjROEB6NrVcft7rHzHzQw==
X-Google-Smtp-Source: AA0mqf5ZxNILozi/59eThvqaQDUVp7Rne/3dA+LV9B3+gi9zpnKCGbBvH4+liRRo6GkSgJCU7hemVA==
X-Received: by 2002:a2e:2a83:0:b0:279:c58a:817c with SMTP id q125-20020a2e2a83000000b00279c58a817cmr7758749ljq.39.1671189333181;
        Fri, 16 Dec 2022 03:15:33 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id i5-20020a2ea365000000b002771057e0e5sm127207ljn.76.2022.12.16.03.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 03:15:32 -0800 (PST)
Message-ID: <994718d8-f3ee-af5e-bda7-f913f66597ce@linaro.org>
Date:   Fri, 16 Dec 2022 12:15:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 5/9] dt-bindings: net: motorcomm: add support for
 Motorcomm YT8531
Content-Language: en-US
To:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-6-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221216070632.11444-6-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/12/2022 08:06, Yanhong Wang wrote:
> Add support for Motorcomm Technology YT8531 10/100/1000 Ethernet PHY.
> The document describe details of clock delay train configuration.
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>

Missing vendor prefix documentation. I don't think you tested this at
all with checkpatch and dt_binding_check.

> ---
>  .../bindings/net/motorcomm,yt8531.yaml        | 111 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 112 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
> new file mode 100644
> index 000000000000..c5b8a09a78bb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8531.yaml
> @@ -0,0 +1,111 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/motorcomm,yt8531.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Motorcomm YT8531 Gigabit Ethernet PHY
> +
> +maintainers:
> +  - Yanhong Wang <yanhong.wang@starfivetech.com>
> +

Why there is no reference to ethernet-phy.yaml?

> +select:
> +  properties:
> +    $nodename:
> +      pattern: "^ethernet-phy(@[a-f0-9]+)?$"

I don't think that's correct approach. You know affect all phys.

> +
> +  required:
> +    - $nodename
> +
> +properties:
> +  $nodename:
> +    pattern: "^ethernet-phy(@[a-f0-9]+)?$"

Just reference ethernet-phy.yaml.

> +
> +  reg:
> +    minimum: 0
> +    maximum: 31
> +    description:
> +      The ID number for the PHY.

Drop duplicated properties.

> +
> +  rxc_dly_en:

No underscores in node names. Missing vendor prefix. Both apply to all
your other custom properties, unless they are not custom but generic.

Missing ref.

> +    description: |
> +      RGMII Receive PHY Clock Delay defined with fixed 2ns.This is used for

After every full stop goes space.

> +      PHY that have configurable RX internal delays. If this property set
> +      to 1, then automatically add 2ns delay pad for Receive PHY clock.

Nope, this is wrong. You wrote now boolean property as enum.

> +    enum: [0, 1]
> +    default: 0
> +
> +  rx_delay_sel:
> +    description: |
> +      This is supplement to rxc_dly_en property,and it can
> +      be specified in 150ps(pico seconds) steps. The effective
> +      delay is: 150ps * N.

Nope. Use proper units and drop all this register stuff.

> +    minimum: 0
> +    maximum: 15
> +    default: 0
> +
> +  tx_delay_sel_fe:
> +    description: |
> +      RGMII Transmit PHY Clock Delay defined in pico seconds.This is used for
> +      PHY's that have configurable TX internal delays when speed is 100Mbps
> +      or 10Mbps. It can be specified in 150ps steps, the effective delay
> +      is: 150ps * N.

The binding is in very poor shape. Please look carefully in
example-schema. All my previous comments apply everywhere.

> +    minimum: 0
> +    maximum: 15
> +    default: 15
> +
> +  tx_delay_sel:
> +    description: |
> +      RGMII Transmit PHY Clock Delay defined in pico seconds.This is used for
> +      PHY's that have configurable TX internal delays when speed is 1000Mbps.
> +      It can be specified in 150ps steps, the effective delay is: 150ps * N.
> +    minimum: 0
> +    maximum: 15
> +    default: 1
> +
> +  tx_inverted_10:
> +    description: |
> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
> +      Transmit PHY Clock delay train configuration when speed is 10Mbps.
> +      0: original   1: inverted
> +    enum: [0, 1]
> +    default: 0
> +
> +  tx_inverted_100:
> +    description: |
> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
> +      Transmit PHY Clock delay train configuration when speed is 100Mbps.
> +      0: original   1: inverted
> +    enum: [0, 1]
> +    default: 0
> +
> +  tx_inverted_1000:
> +    description: |
> +      Use original or inverted RGMII Transmit PHY Clock to drive the RGMII
> +      Transmit PHY Clock delay train configuration when speed is 1000Mbps.
> +      0: original   1: inverted
> +    enum: [0, 1]
> +    default: 0
> +
> +required:
> +  - reg
> +
> +additionalProperties: true

This must be false. After referencing ethernet-phy this should be
unevaluatedProperties: false.


Best regards,
Krzysztof

