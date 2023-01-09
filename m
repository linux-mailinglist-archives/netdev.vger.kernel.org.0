Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54DD662F38
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbjAISe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbjAIS2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:28:08 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30C777AC2
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:24:55 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o15so6918856wmr.4
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GR/8pvxe2f4pohEZXkyoXtetxOTq5sWV3atP5vyJM74=;
        b=a++QxVPD+vd0RqUAy+qbLCg3roHmEcf9/SFtidz6KaTCo5uuI/J9PRtxvoVfcZDFFv
         fgdbWTJ7M8LPdEXTuc9FTs749FXA/+NXPXBi92JrHjzigG0yoxl41hRVfG2hRV1uU65F
         NnYtLPkTcRW+IAJr19OZSJquVpxrSRTj0LzcS5BuWk/lr6/ywimKTzGI1rfZnjqad3qu
         p/NLmUQjgdLSiJJ5Aed4uBZ9ns5kXuBKlQ2sYYbSso7F4obFnaJJRMou90y/qpjrvadl
         HN360Mw9/TKTP+QPFQA8nEBcc8IYOBTTEyuFJQL172kuQv6hy2tJaQ65bOVL8GkMChLP
         E8wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GR/8pvxe2f4pohEZXkyoXtetxOTq5sWV3atP5vyJM74=;
        b=1wvaG5J+Yv+JaZH/MsvFF8sZmnXRCXIz8ZtHAB0Qr2tay+2Bpf6rLeclfBJKR/4Zci
         osChcnd/1kzlAsXHoDQHjyLFn60HqJisZGanjgjHTUPwUUcLnzjdfVEKTJ22JVcHnN9B
         cXT60IBQJD9MLrtjqqSd6G7Xc3/3JaKcK+f5ZappP8RC3CPAJ3dQ6oFIHaPih3eBT84+
         ERaWihjExKNB9BQeSKUq+S0SK9l+fu7R7Y16JQ4Gtf9uJ5uEO1I2Y2p3i/9rZZ9aYndo
         gW2whEi/eTROYSC73/fxAo30c7v+/yyygUhBFgRnMVTooQzkIrR5rgrRlEiIFQ7wCD83
         ITfg==
X-Gm-Message-State: AFqh2koOgTcnshzLtLhjiv99Iwvu302WU3k9fkVg+I05sGmL0TthAY3w
        pJgxdBoUcweF9SqLq+UU5X2rrg==
X-Google-Smtp-Source: AMrXdXuJCY8YyrI9RTQ0ufjgVapPWyphfUr254moXi6Kk5eoylipwpcFE2FpxXiWaZIJ9yZ2VeNS8Q==
X-Received: by 2002:a05:600c:2318:b0:3c6:e63e:23e9 with SMTP id 24-20020a05600c231800b003c6e63e23e9mr49980736wmo.24.1673288694404;
        Mon, 09 Jan 2023 10:24:54 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id u16-20020a05600c00d000b003cf4eac8e80sm14642238wmm.23.2023.01.09.10.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 10:24:53 -0800 (PST)
Message-ID: <95282b7b-c02c-ff1c-e306-89a7be2d7d1c@linaro.org>
Date:   Mon, 9 Jan 2023 19:24:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 15/18] dt-bindings: arm-smmu: document the smmu on
 Qualcomm SA8775P
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-16-brgl@bgdev.pl>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230109174511.1740856-16-brgl@bgdev.pl>
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

On 09/01/2023 18:45, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Document the qcom,smmu-500 SMMU on SA8775P platforms.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  Documentation/devicetree/bindings/iommu/arm,smmu.yaml | 1 +
>  1 file changed, 1 insertion(+)

This and SM8550 ARM SMMU should be rebased on top of:
https://lore.kernel.org/all/20221222092355.74586-1-krzysztof.kozlowski@linaro.org/
and include relevant change as well.

Best regards,
Krzysztof

