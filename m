Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C125BF914
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiIUIYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiIUIYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:24:11 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE37686FE8
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 01:24:08 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id q17so6015913lji.11
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 01:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=z2MCRZwnAPTEqYODMkj3+PTJcU+ncclCIozA5x11uMM=;
        b=BB35Aku2zGsCqnMGpK7NKQd1UICT5YpQwu7ZrKCddceP/5xfHPurL1Q69YMIhyIPV3
         21F4kSBCktfqX1gUFg9zlBxj4KdIPaUvjAM2SScf1baXqUD9KdA8lXcu4Dt5c6B6yjKR
         fkFgPLvX52svpOmU9DWoH8liK0fB4jhojs3RrOBP3I/QzX0s5Df5cBQlAtHyj02rkz35
         QvZcqpr+GSqJ23HKKrkaYLXtReanYgkneApheeoHjepuw+4IyRAIjZsHM+a439lPAJnG
         YM42xgEhu6fv9Ez9jizLriJeTLfG+TL0P7lWbeqp9gU8jx6ed+qqBToUCNVE+MQ2H37t
         gVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=z2MCRZwnAPTEqYODMkj3+PTJcU+ncclCIozA5x11uMM=;
        b=zcc32ODVBdMa6BBQZ7vdwRqoALpHPSg05QOIszNSy/uv420528nB9A/FC+LDSt0fLs
         qWbs6pv9U4t3Ksg8j3C0lTCiMEZMcXJ2vrbGEb1ekSU0CuOXYUq2MNJ6Ft/2PEedeCJZ
         EooYhkF+jM8TfRrUQLPHRq3QO3eXvKo/nDWp8L7Kj6JHsz4TT6sHKYLLCBEHul+H+uxQ
         IUAqxMXFzhRjg+f5etWTsi3+ChmJsIe5bt+ZWiOjg0uHAoc1ul1F+nZVdiCOqM5JlqVm
         n8nicBi/tjOZ9EcOK4djnr7jGUFIJpnaIloFi9KC70ZuDZJssr+lEtPgyJDJ6kVW9x84
         ksxg==
X-Gm-Message-State: ACrzQf0Arb6czxKS2gojrSuhbubEI5Imja47FRuVREQ7KhtQpLwpHOWh
        gLioUJEBnPx/LYJ7JXmMFWROIg==
X-Google-Smtp-Source: AMsMyM6Io3BmRoigc9CnsetOFpauZCLrMtETpU3n2CWPkIA90UfIJN1GhK1zG57LSt5VssYM+AN+vg==
X-Received: by 2002:a2e:2f07:0:b0:26c:59d3:4a26 with SMTP id v7-20020a2e2f07000000b0026c59d34a26mr3021933ljv.471.1663748646667;
        Wed, 21 Sep 2022 01:24:06 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id d25-20020ac25459000000b0048af4dc964asm337998lfn.73.2022.09.21.01.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 01:24:06 -0700 (PDT)
Message-ID: <bd460cfd-7114-b200-ab99-16fa3e2cff50@linaro.org>
Date:   Wed, 21 Sep 2022 10:24:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 2/2] dt-bindings: net: snps,dwmac: add clk_csr property
Content-Language: en-US
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220921070721.19516-1-jianguo.zhang@mediatek.com>
 <20220921070721.19516-3-jianguo.zhang@mediatek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220921070721.19516-3-jianguo.zhang@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/09/2022 09:07, Jianguo Zhang wrote:
> Add clk_csr property for snps,dwmac
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 491597c02edf..8cff30a8125d 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -288,6 +288,11 @@ properties:
>        is supported. For example, this is used in case of SGMII and
>        MAC2MAC connection.
>  
> +  clk_csr:

No underscores in node names. Missing vendor prefix.

> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      Frequency division factor for MDC clock.

Can't common clock framework do the job? What is the MDC clock?

Best regards,
Krzysztof
