Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B7A694091
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjBMJQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBMJQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:16:09 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8026AD31
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:16:08 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id he5so389605wmb.3
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9xp1f1ClZNE5cUv+RX5qXmus2twTBsJN6syezVKx0s8=;
        b=gcbQXNr/KgUkr+MrCgtpoSl9reVna7vb/KY4TcMjsqFt/uWfsOL+8VIv2kZFKAXN3/
         ZlZlTHynJeVoKi68H0wu5ITc4AO/Svn+DI0Es9LPe2rscNPaP/gisgAKc8I+Y+u8yXjp
         Bspc3cmrubzquX7CXdLtwyJ36ToCCRha9jnQN/HgwLMD2rdvGoo76c4x/5fdIgdxzMVZ
         agjQizRF6fEz5wXSvW7YyH52Af9NHdREcYdF1yY9oetUI9EYS1DwuBeoHq6u096lZIuG
         uuk9dzCc/ScvyP0EZ3P42OtXomXJ+H9aqR9LQph/KmjT0mV12bWmrR5YaGgn2GT6PE4i
         QQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9xp1f1ClZNE5cUv+RX5qXmus2twTBsJN6syezVKx0s8=;
        b=eACSJjcMoYx/8MCRWTyd0RgxHb3AQB2JUcPkYwIX3DL/PEMDGaFIn02dOOQdPQ32et
         cexmWKbd15aSg542pXFhwtcokTKFvn39jHy4B2nmrpbg/NmeUtlTBccTNBBUN8xtqSxt
         uTczu1hdCuqfRJ+vGZMsR7Tos+qUWwqCOdaKwIGUfWLUHjnd4sqqgf+vmgbjKGD1pvTW
         QIzLKu6ITMYGTiPNtm8MPqw9333+kOL6FMxLntkB2eOjrlIMvI1NWnkM4epWHmG0n1RE
         B7Jt3z3YLvHcIamXOUCeItq4xS1SI3q/wp/hL7UYEoxZlfKFnDYRjjU5X7pD+BT80GIQ
         ie4Q==
X-Gm-Message-State: AO0yUKWt0whb0EXeq1zcf2R+iwUR4ivILqcH95IdviITth6hXVquSbLe
        zpYUbu7EZmat8VGytd3GzO5d6g==
X-Google-Smtp-Source: AK7set+GGl89xH8tiPOhMxaLDcaC7fVDbIk2ilrwvdd78yp4famGjU6z+o38lQ5t4v7j0eO3JvzD1w==
X-Received: by 2002:a05:600c:340a:b0:3dc:45a7:2b8a with SMTP id y10-20020a05600c340a00b003dc45a72b8amr18539198wmp.10.1676279767343;
        Mon, 13 Feb 2023 01:16:07 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id k7-20020a05600c080700b003daf672a616sm12678568wmp.22.2023.02.13.01.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 01:16:06 -0800 (PST)
Message-ID: <25572962-32ad-3175-e4b2-1d13eba45126@linaro.org>
Date:   Mon, 13 Feb 2023 10:16:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 03/12] dt-bindings: arm: mediatek: sgmiisys: Convert to
 DT schema
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <cover.1676128246.git.daniel@makrotopia.org>
 <6ea4483df9720a209462bd163d7f7e406d14053c.1676128246.git.daniel@makrotopia.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <6ea4483df9720a209462bd163d7f7e406d14053c.1676128246.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2023 17:02, Daniel Golle wrote:
> Convert mediatek,sgmiiisys bindings to DT schema format.
> Add maintainer Matthias Brugger, no maintainers were listed in the
> original documentation.
> As this node is also referenced by the Ethernet controller and used
> as SGMII PCS add this fact to the description.
> 
Thank you for your patch. There is something to discuss/improve.

> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
> new file mode 100644
> index 000000000000..99ceb08ad7c0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
> @@ -0,0 +1,53 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,sgmiisys.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"

Drop quotes from both.

> +
> +title: MediaTek SGMIISYS Controller
> +
> +maintainers:
> +  - Matthias Brugger <matthias.bgg@gmail.com>
> +
> +description:
> +  The MediaTek SGMIISYS controller provides SGMII related clocks to the system
> +  and is used by the Ethernet controller as SGMII PCS.
> +
> +properties:
> +  $nodename:
> +    pattern: "^syscon@[0-9a-f]+$"

Drop nodename, we do not require it per binding.

> +
> +  compatible:
> +    oneOf:

Drop oneOf, unless you plan to use it soon?

> +      - items:
> +          - enum:
> +              - mediatek,mt7622-sgmiisys
> +              - mediatek,mt7629-sgmiisys
> +              - mediatek,mt7986-sgmiisys_0
> +              - mediatek,mt7986-sgmiisys_1
> +          - const: syscon
> +


Best regards,
Krzysztof

