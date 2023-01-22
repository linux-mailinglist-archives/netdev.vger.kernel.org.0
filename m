Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDE7676D97
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 15:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjAVOTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 09:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjAVOTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 09:19:31 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04145144BA
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:19:30 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id e3so8609578wru.13
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6nP80yt4P2LkjTrQbSApnHJJEUxI5A3MtVuRUI18a3s=;
        b=dBCPnllzquDDUk+9Jg18anFzUDeoLloz26xrT7TaqiuwpuAwleMkzOfivLBXckeIrO
         k0bNfIggIMbd+JwuPaStVNt1bsNmGmvwxM3EAc4japN0UPT0gSC5gHyQRzqOJ91ODpAz
         eyafeA/P2Zymmyht7nTqT+PTmjnpZiD27bR3d9I/1RxPirk1Ax+NWKEJG9f2uP56FUfH
         svloR0GbSWGvZqO75pztznAjiKUj//p1a3q7O1LKJBGQmooStGU53RaRbGvSl6Pfb0WN
         riXvYdvdnlyA6jmMXZfiZr8y5vqWNWgHuNWdBoYOdTiI95sBuM1dfT5H95FPSCIX4Hig
         d3gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6nP80yt4P2LkjTrQbSApnHJJEUxI5A3MtVuRUI18a3s=;
        b=a1oqZpDa8lXre90SYyA6WDpkintK5yUxZLsNmuE7uMqy/fkfERYwj+1XRllAzts1WW
         PQFid6erk3deS9BSUeal0DfDTtMpkj+vKbD0to0xj1pbuiIh3LrN4IS8H3moHPsT+S26
         0UdWybE+t1Lu3SgaoVgF55c/cnpZus54FzfN/z+jJkkcN3i3CgcnLkX7xx2xlUOGBWU8
         xXs3xy2cEUpeZur/OpJ3i3Phmu6VUgdlgx2N4bOfUb3qHGQo18zs/sQXuJe/RWY3XPMy
         dVljBacJKwWMxY4OEXZz8vc79fH/Jk5Oaqstl9mxWocY+PQaEnbLrFt4KyYX1sgE+4JA
         Bxww==
X-Gm-Message-State: AFqh2krqR0ekEP8ENFRLg4JyR9UYIc0I6qANoJn3KCw2PJlI80UEgWZG
        CN9uzdRHFBkR2Bq6WZFLs6Zv3w==
X-Google-Smtp-Source: AMrXdXt35b+CmPQpFZihlqLeEU0wTQBsOlVJzU5chJmIhwORGBT/y9cFtSOaeQfQF/WddOUFzrntrA==
X-Received: by 2002:adf:f705:0:b0:2bd:d34e:534c with SMTP id r5-20020adff705000000b002bdd34e534cmr17454975wrp.36.1674397168563;
        Sun, 22 Jan 2023 06:19:28 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id n9-20020adf8b09000000b00241d21d4652sm2286368wra.21.2023.01.22.06.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 06:19:28 -0800 (PST)
Message-ID: <435018a3-80a1-2113-23bf-8645e8f6e4e4@linaro.org>
Date:   Sun, 22 Jan 2023 15:19:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH net-next 4/6] dt-bindings: net: renesas,rzn1-gmac:
 Document RZ/N1 GMAC support
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20230116103926.276869-1-clement.leger@bootlin.com>
 <20230116103926.276869-5-clement.leger@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230116103926.276869-5-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/01/2023 11:39, Clément Léger wrote:
> Add "renesas,rzn1-gmac" binding documention which is compatible which
> "snps,dwmac" compatible driver but uses a custom PCS to communicate
> with the phy.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/renesas,rzn1-gmac.yaml       | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> new file mode 100644
> index 000000000000..effb9a312832
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> @@ -0,0 +1,71 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/renesas,rzn1-gmac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas GMAC1 Device Tree Bindings

Drop Device Tree Bindings.

> +
> +maintainers:
> +  - Clément Léger <clement.leger@bootlin.com>
> +
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - renesas,r9a06g032-gmac
> +          - renesas,rzn1-gmac
> +  required:
> +    - compatible
> +
> +allOf:
> +  - $ref: "snps,dwmac.yaml#"

Drop quotes.

> +
> +properties:
> +  compatible:
> +    additionalItems: true

No. Drop.

> +    maxItems: 3

No.

> +    items:
> +      - enum:
> +          - renesas,r9a06g032-gmac
> +          - renesas,rzn1-gmac
> +    contains:
> +      enum:
> +        - snps,dwmac

No, please list possibilities

> +
> +  pcs-handle:
> +    description:
> +      phandle pointing to a PCS sub-node compatible with
> +      renesas,rzn1-miic.yaml#
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +
> +required:
> +  - compatible
> +
> +unevaluatedProperties: false
> +

Best regards,
Krzysztof

