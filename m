Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60AC662F60
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbjAISli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237229AbjAISlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:41:22 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB29B8FE7
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:41:18 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id az7so9168026wrb.5
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lcc+8lVbMYPsY9hr9mnuWPkOBuZt4DN6m8H6MCFQl9I=;
        b=YjDc9PqXhIZZk0bX7b8BB4evTX85CYzcPiWqlK81Bu/4k4LECqwb0hYWdsJkfkDdzF
         XBYREDtE8j8novHKhJ9sFt+z55dqSlk4SBcnglKQVImykO6BBJ7hsN4GRyYu5IF2WIE+
         cD5Mwb2Fb03e8OlC798Omfc82h33Tg4S200+QgHaJXlqTKSlv52ctBcZpWGYVvvCOaOs
         YVmpcuMlYvJw26IN75e8+XTuySv5EuV4I0dnkFw43XNpM7wHIa9g42CAt9e+KU1l0tQ1
         EzEyv/KoEveL+e0rWTHLGLARaMYJ7XJh2ENmpvMaWD78CADmt4AGnswZgC+2iLaJDXm5
         f0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lcc+8lVbMYPsY9hr9mnuWPkOBuZt4DN6m8H6MCFQl9I=;
        b=JftTtFra/KMFuO6IWkGaefyEma/3ith8Z8zli/B2A5PhcpiRkp5dKk0rDpckVrkiyk
         FTk7ZWPB9V+P3gq71rR3mZuAt+0x22NfCWPiLPeTboNK7dXV6mG357WWycutGXJzQmtH
         6wRUorJG+uV/G+/vtbGp3Kqdr1Aw/Z0smBAza67ZO6QBc/QVHBACtgrKr5+Q4zp7wKYR
         P88XOTjHFThztFNYo3qc2FXReKUXE2bTMZw1WM1RJ2bYpjlNsoCNOxfUWkOYplDO7NNh
         pcm9qOVoyy+HSiBO52ry2ieh8lRXAIWiirvttREpBUSG3qahnew4QYFPAjNwZ/Xblj3q
         tDyQ==
X-Gm-Message-State: AFqh2kp0NEA/G1gPatPSsCjbgNBJnP8mSXYNsFZMMAPajOhiTYnQQS7l
        nXzSdAYxPZFm5D/6aEkv1Yitrg==
X-Google-Smtp-Source: AMrXdXumJbNcUy9i1KX7PhYzq0uyUfiILub8pKYoeZhwSOhszfVhOxH+Aq3IU8EKBd2IxhZh2c/Tng==
X-Received: by 2002:a5d:5a15:0:b0:29b:9e07:24f with SMTP id bq21-20020a5d5a15000000b0029b9e07024fmr18983669wrb.0.1673289677303;
        Mon, 09 Jan 2023 10:41:17 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id d20-20020adfa354000000b002bc50ba3d06sm3503192wrb.9.2023.01.09.10.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 10:41:16 -0800 (PST)
Message-ID: <8ac52d50-168c-5c84-29fc-10219d97ff39@linaro.org>
Date:   Mon, 9 Jan 2023 19:41:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 16/18] iommu: arm-smmu: qcom: add support for sa8775p
Content-Language: en-US
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
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
 <863ca113-cf78-1844-d0be-e21915ef662f@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <863ca113-cf78-1844-d0be-e21915ef662f@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2023 19:10, Konrad Dybcio wrote:
> 
> 
> On 9.01.2023 18:45, Bartosz Golaszewski wrote:
>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>
>> Extend the driver to support the sa8775p platform.
>>
>> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>> ---
>>  drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
>> index 91d404deb115..5e12742fcfd9 100644
>> --- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
>> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
> /*
>  * Do not add any more qcom,SOC-smmu-500 entries to this list, unless they need
>  * special handling and can not be covered by the qcom,smmu-500 entry.
>  */

We should change the default -U argument for git format-patch :)

Best regards,
Krzysztof

