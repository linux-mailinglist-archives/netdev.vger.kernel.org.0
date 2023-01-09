Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEECA662E71
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbjAISOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbjAISMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:12:54 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E41C6CFE1
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:10:28 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id bt23so14234598lfb.5
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z3JsIjoi2dFk770K4E7Cc6+bvqTHzQJvboduENfqJDY=;
        b=po91acebuAvy/xot5kHoF4OPolKB3textI1oiX6y8CDEHm3m7spk2rSBHSHP/wOzzx
         SaJ0a69VpJ+awHAM/0EyVUqdNhHg8DFCrfHoMoglseOH6lJxgJ2iOH8Ejm/TaJNlnUfh
         nV7aCd4vhT/R9xqno+syxGWrwXUlVfjxJGPmp7I5/hMsR8JV3X9xja4nqeMpSCrYXG7o
         4T7fExOMO3by+aAZ7jJc38p7Bz5EPtwIakfjYtOHl74nwzYhz+JiZirkqtKKLe46GRcf
         Z5Re4jSmxx+3nbNc8gXDgZmeDhyEzvjnGtbB1Q74pKZWBPPUAZMiXZIZRpIcQcXZo3P8
         pavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z3JsIjoi2dFk770K4E7Cc6+bvqTHzQJvboduENfqJDY=;
        b=ga1vZKxXSTF3jG+LXhu8voA38ezheLfEhHons+gdYIxTuFnuBbEwdCp0qARUecOmzy
         dA9uUb4hdlVH7qeltoHdIWN+H8qspsHkXnQ/pBbJ6JQH953kqke3BTeIdw3YKjlkhDs/
         rpPieXoPo5aeIdzwFX0/221frvu4dwSgDiDdKTBcKX0M+hZa/bxXtMwLkOOIDmkMhlVv
         2b3NOi7aFAJhzH9jnjG+Jw+QIzN8oCHz4avgniD/A330b4ab9E+N0xlUeupANGV+MTR9
         37AbYSdhWnKuBcjsC+vZLsgIY75hsQyL4P5Xay2kOHWLPMflTu+/Zvveq0/1O3kq+hlG
         2Jjg==
X-Gm-Message-State: AFqh2kprXx30Y/3Ypv44VatihPa+44GY8EftfHidFUXX39f5GWsahQCE
        MSDoZehxCp/pdTIkcb/x2BqRnA==
X-Google-Smtp-Source: AMrXdXva6mNB/kyj8xZBHoSj3xleh1LF7x+HCVy6uO5GijSB7MF6YlZ626gg7/Cu2pQeZV5Ni5We3A==
X-Received: by 2002:ac2:46d1:0:b0:4cb:1fa4:f68d with SMTP id p17-20020ac246d1000000b004cb1fa4f68dmr9302557lfo.18.1673287826433;
        Mon, 09 Jan 2023 10:10:26 -0800 (PST)
Received: from [192.168.1.101] (abxi45.neoplus.adsl.tpnet.pl. [83.9.2.45])
        by smtp.gmail.com with ESMTPSA id n11-20020a05651203eb00b004b58d457f2dsm1731581lfq.61.2023.01.09.10.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 10:10:24 -0800 (PST)
Message-ID: <863ca113-cf78-1844-d0be-e21915ef662f@linaro.org>
Date:   Mon, 9 Jan 2023 19:10:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 16/18] iommu: arm-smmu: qcom: add support for sa8775p
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
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
 <20230109174511.1740856-17-brgl@bgdev.pl>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230109174511.1740856-17-brgl@bgdev.pl>
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



On 9.01.2023 18:45, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Extend the driver to support the sa8775p platform.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
> index 91d404deb115..5e12742fcfd9 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
/*
 * Do not add any more qcom,SOC-smmu-500 entries to this list, unless they need
 * special handling and can not be covered by the qcom,smmu-500 entry.
 */
> @@ -500,6 +500,7 @@ static const struct of_device_id __maybe_unused qcom_smmu_impl_of_match[] = {
>  	{ .compatible = "qcom,msm8998-smmu-v2", .data = &qcom_smmu_v2_data },
>  	{ .compatible = "qcom,qcm2290-smmu-500", .data = &qcom_smmu_500_impl0_data },
>  	{ .compatible = "qcom,qdu1000-smmu-500", .data = &qcom_smmu_500_impl0_data  },
> +	{ .compatible = "qcom,sa8775p-smmu-500", .data = &qcom_smmu_500_impl0_data },
>  	{ .compatible = "qcom,sc7180-smmu-500", .data = &qcom_smmu_500_impl0_data },
>  	{ .compatible = "qcom,sc7280-smmu-500", .data = &qcom_smmu_500_impl0_data },
>  	{ .compatible = "qcom,sc8180x-smmu-500", .data = &qcom_smmu_500_impl0_data },

Document the property in bindings and follow it by "qcom,smmu-500", "arm,mmu-500"
instead.

Konrad
