Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E850F672207
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjARPuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjARPtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:49:32 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EA34F34A
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:47:13 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id f25-20020a1c6a19000000b003da221fbf48so1843555wmc.1
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S2/UQrgOGDC4yyfTe65BG0yHQo36ScKkbVDK3v1/MZo=;
        b=mrVJV+kB5VAmsLR0HzGPNRZVEDyPQUkOac7by1QPdbs4IP2edcljWRjDfnCLbugduL
         iEf0CxU9MtxEkMnKTOZ+0ZF4Q6wr3LXEqwN5tvvJFP/cRITqrXSS2mYSFy6X/uxUCj7m
         47cE1fGF/T4wagcylEKWyNbuv4EWLb6mfDftIxQWRZGf0C6aG0ZqAtQ1a1AUM8BLUNI1
         Q2mBUa8iCSIzuehqs/S34L8y6rcjvdkP60SxzgqJD/Mw5v+qgwJtLyn7qg87zZTSx5pF
         7qellwUyrkUpUfY3TL1CAKLO07tcaqNoddT5K3Q8ovdsjETTmJ92bD8m45cpGlHhbYBq
         KJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S2/UQrgOGDC4yyfTe65BG0yHQo36ScKkbVDK3v1/MZo=;
        b=d6rEVIWDgQdC4NOm6FtihUBO8jr92JaH+Nr5m54JVYBjAgGDRyWXdSVzl4IY7UxWJr
         HfTemMYrocrBDFnIesTNy+J9uWmQE2TW04H5C+W3M1ymmZQE+wlro++vYgKmu0HVmCFt
         hpWUt3gIlYVtM/XeBPsXsKug4EowqBi9zv76qIhWkt5tDibfOx8iJQnLzyXksYeN8uVl
         QiOGRpPqjLtTgJeSPxbJWZjLD1LiNpV9xv9XyIVkHFQnu+5vdegEI3aLCCHiIP5uawOm
         coEsICKfq93LwjUYch4//FobsJU419xgq9ApMQnahgPUJvWixZNWZrLKzfU6FlVJGZUn
         R5rQ==
X-Gm-Message-State: AFqh2krS4m2xq6nB2uMcU1y9IEZU52tG/lPLqDobP36tIgnwm1Swo6nD
        SU1sJRQD4iTg6C55hY//aVODGA==
X-Google-Smtp-Source: AMrXdXsDMnxhFvV+nCjEhypB+Fmw+62+IqPHnHN/TbzV9By1tMAd/W+ZxVs1DheIWw4fUU/IKRLGHQ==
X-Received: by 2002:a05:600c:5252:b0:3da:2500:e702 with SMTP id fc18-20020a05600c525200b003da2500e702mr3163123wmb.32.1674056831854;
        Wed, 18 Jan 2023 07:47:11 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id z2-20020a05600c220200b003d9a86a13bfsm2218870wml.28.2023.01.18.07.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 07:47:11 -0800 (PST)
Message-ID: <15a87640-d8c7-d7aa-bdfb-608fa2e497cb@linaro.org>
Date:   Wed, 18 Jan 2023 16:47:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v4 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
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
 <20230118061701.30047-3-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230118061701.30047-3-yanhong.wang@starfivetech.com>
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

On 18/01/2023 07:16, Yanhong Wang wrote:
> Some boards(such as StarFive VisionFive v2) require more than one value
> which defined by resets property, so the original definition can not
> meet the requirements. In order to adapt to different requirements,
> adjust the maxitems number definition.
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index e26c3e76ebb7..baf2c5b9e92d 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -133,12 +133,9 @@ properties:
>          - ptp_ref
>  
>    resets:
> -    maxItems: 1

Also, this does not make sense on its own and messes constraints for all
other users. So another no for entire patch.

Best regards,
Krzysztof

