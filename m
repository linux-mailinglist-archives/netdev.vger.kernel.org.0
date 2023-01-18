Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B62672235
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjARP4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjARPyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:54:53 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0007456ECE
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:51:19 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k16so4376624wms.2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cXztzz9eQE5yAeZKGMUMFg/Zj91bDlHuOhYcwUvF18o=;
        b=GdYhmLDVzU5PawleUjy7HzJQlHRp0xzQEUubtVRgF2UOPS3DWbci8yK2YWVJHZNZXm
         ss2vqx1iLlF7UivFNF/DEiz/B0eBf7jqxPlcF7RF6APAFktd4XDKr/ppuhS/OUz0YI8v
         B9xJyVUyJrQlU/J1P2rESSuXHZOqmafSwSqWmOjF9XuYO8z5Oh1zHWNXrGmtRrwBFPRr
         JZ4Ya68B5bnCZG/DyxF2QZInee68Ju5Ft0SAj285r8eJv46ovDyWDku52pZMkJOq7Wlw
         rnG6GnLO0Qzmxpp2pf2WVS7cryB7T97mfWIIw4L+H7PKTVzYOctj1ZrvBIHTJ5Qa79Ia
         Fo1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cXztzz9eQE5yAeZKGMUMFg/Zj91bDlHuOhYcwUvF18o=;
        b=WW77FjwfqyPKoiMHneltEc8ralJIZXjoXkTyAfMJ2q/8NX+k07Lwk8EnPKL1jnROZ9
         uvmilcKD/3/U4dLPIF0tJR4JtxweADuv30l9VfkdkOUD5OUGXuh/pKB2x031QMJBzGXF
         jhOzkOEDZwF+i5HkX7eYRwfbDf6QKewZJubUGBq9ww6fXap5taPB1AkuBxWiS0txTSmj
         8aaHXfKdVlK3Edc+HuCKp0q1Zj56FTm2ucj9FL1vUh1Lol3zw/5OWv0eSfUecaz/RBVa
         8InJxEPaMTUcz6N+KSLzglwa48TcGvrcDEQLYyiq87NxtA3rXdyWSwsZ2zL8BUug2CFu
         v2TQ==
X-Gm-Message-State: AFqh2kqF7L+ZdFiRqTjzpzIdrfs+tG1skmgHDQFYJx5duX2jPYgz1Bi0
        f7zHlVbV1Am+qHt5lF96QL0WYw==
X-Google-Smtp-Source: AMrXdXsTZcClQl9bxcwiEKjoRnzSJ2yCZmooCIKBSadeADdTTA6+M/TsGtBVZ7NPee6iuUewrbzdtQ==
X-Received: by 2002:a05:600c:5405:b0:3d3:5709:68e8 with SMTP id he5-20020a05600c540500b003d3570968e8mr6990822wmb.36.1674057078592;
        Wed, 18 Jan 2023 07:51:18 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id w1-20020a1cf601000000b003daf681d05dsm2330254wmc.26.2023.01.18.07.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 07:51:18 -0800 (PST)
Message-ID: <55f020de-6058-67d2-ea68-6006186daee3@linaro.org>
Date:   Wed, 18 Jan 2023 16:51:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v4 6/7] riscv: dts: starfive: jh7110: Add ethernet device
 node
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
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <20230118061701.30047-7-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230118061701.30047-7-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2023 07:17, Yanhong Wang wrote:
> Add JH7110 ethernet device node to support gmac driver for the JH7110
> RISC-V SoC.
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  arch/riscv/boot/dts/starfive/jh7110.dtsi | 93 ++++++++++++++++++++++++
>  1 file changed, 93 insertions(+)
> 
> diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> index c22e8f1d2640..c6de6e3b1a25 100644
> --- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
> @@ -433,5 +433,98 @@
>  			reg-shift = <2>;
>  			status = "disabled";
>  		};
> +
> +		stmmac_axi_setup: stmmac-axi-config {

Why your bindings example is different?

Were the bindings tested? Ahh, no they were not... Can you send only
tested patches?

Was this tested?

> +			snps,lpi_en;
> +			snps,wr_osr_lmt = <4>;
> +			snps,rd_osr_lmt = <4>;
> +			snps,blen = <256 128 64 32 0 0 0>;
> +		};
> +

Best regards,
Krzysztof

