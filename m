Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1B668F85E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 20:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjBHTvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 14:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjBHTvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 14:51:07 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165251C7E6
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 11:51:05 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id j23so2756245wra.0
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 11:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cY1HwE63r9UqyW6Gdx6yhcFxmTguDnqyz+SAe6KoqOQ=;
        b=Hn2pHT7CPTC3o8c4Wpog/hsIQx7uvafsHgvOxeofLCyAJV9L7gPsNScf3TeLdqqPnr
         LUzNnDUuUwSEk4aAlXxfEaM0zrMXnNq/Cz9jO8mHY2YrfNr8ZSfgFLz3JafNViK1B0bT
         53rAEhyJo2OFPoJrvYYNaSFu+AOUT2z3hE6WS4W+99iNSs+K++NUxAAHsqs+vnQswru7
         g2c2FQ5Zbky3mbyXl60E6JmICG07hRBCes7yafGv0Boq39tw4NTKpnaCMM8GPAJALkiJ
         IzP9WQ7KcVyZ+MritmxJAz+n/lPp2+TSmLh2MLkT3IRzrHIZ1barAg2zteWvZOip25aT
         bkXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cY1HwE63r9UqyW6Gdx6yhcFxmTguDnqyz+SAe6KoqOQ=;
        b=dAn85xUlm0smcdoQAbZMEtLCFJAv2uGn7gongzailYD+i80NVEUoXPVlvYUNopA8uX
         LSIP5zmay6QWiY0UI5XNpxrruiOA9+Bgg0D/ZwG/bfb5TY+gXiktuVLp25xkXWZ7TP4Z
         LnVYJHQy5Es5r4S/df7zk4fMGtI++o3enZ2SJHzvudd4I44tPjck2BCXSh94qEtA87SB
         jrYM5U74Qn0W9EeSyxaIv8YcSdJPDFpU0N1JGJInbc1Ag1l0dCehdW8+9TqUjQsLiaqB
         GgaNT/KykN+LcCWwV+G97RE423mkm7OElZFgGWchRjxHEcuIqzqQfAd9Fu/QN57hRUCE
         tPjw==
X-Gm-Message-State: AO0yUKUfOyMX8xGzK4SF987ZR+NqzxRJcNbCJQVtOXdiCO1RUCicvS6p
        jB+UCRS7SFT5hqRFvFsfq1cH0Q==
X-Google-Smtp-Source: AK7set9dhkugBafQNUYIvCX0R36B8oLdf4eHcflcqRkwcR7SGvh653bV+4HiKahZLc+dRe/stewv5A==
X-Received: by 2002:adf:ef0d:0:b0:2c4:645:da36 with SMTP id e13-20020adfef0d000000b002c40645da36mr2643620wro.24.1675885863619;
        Wed, 08 Feb 2023 11:51:03 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id f9-20020adff989000000b002c3e6b39512sm8933760wrr.53.2023.02.08.11.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 11:51:03 -0800 (PST)
Message-ID: <55f02cd9-d191-8454-ef67-613bc8373f9f@linaro.org>
Date:   Wed, 8 Feb 2023 20:51:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 4/6] dt-bindings: net: renesas,rzn1-gmac:
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
References: <20230208164203.378153-1-clement.leger@bootlin.com>
 <20230208164203.378153-5-clement.leger@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230208164203.378153-5-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2023 17:42, Clément Léger wrote:
> Add "renesas,rzn1-gmac" binding documentation which is compatible with
> "snps,dwmac" compatible driver but uses a custom PCS to communicate
> with the phy.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/renesas,rzn1-gmac.yaml       | 67 +++++++++++++++++++
>  1 file changed, 67 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> new file mode 100644
> index 000000000000..944fd0d97d79
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/renesas,rzn1-gmac.yaml
> @@ -0,0 +1,67 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/renesas,rzn1-gmac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Renesas GMAC
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
> +  - $ref: snps,dwmac.yaml#
> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - renesas,r9a06g032-gmac
> +          - renesas,rzn1-gmac
> +          - snps,dwmac

This is still not correct and does not make any sense.

What do you want to say here with such binding? That you describe
"snps,dwmac" here? Then it's duplicated with snps,dwmac.yaml... Drop
that enum and make it a proper list.

Best regards,
Krzysztof

