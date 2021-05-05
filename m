Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB72374B72
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 00:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhEEWoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 18:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbhEEWoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 18:44:03 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742CEC06138F
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 15:43:06 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z14so3102841ioc.12
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 15:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nC/IBifenONsVc9vMeQOv6acWNUTyGTY5GW7BiFudVU=;
        b=QTwl5lIsbomJ7O6sqqW0XuKaC294FKigV2q180wT8/EpZDQ5rcIHSvzKvJJ9pvv5uh
         z8U5ct8yLB3R1M0OSRpsKqceu4rkPpNu8pjcNWalCJJ+3ywEvO2XJWdSn8JGrlAPU0AZ
         0BR31oMd95JeJU0S52yIM+0UDTJLR3SW6tLKU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nC/IBifenONsVc9vMeQOv6acWNUTyGTY5GW7BiFudVU=;
        b=kPMU5D3+K4CFJ4Tm5qMruqCwhuZvBcKW/FLsRNgRQdKa2ESrZMhffWUSarEqs4uMs9
         MkJKEw9O3tknf/OEKtvKiXVawKdjDerLki4YphpG+ItowUTmTvhGetIwb4fqGXdzA0r8
         oVI71AXcXbZUIqvcw2HMwGgQ2yGNXlA5HERnwyxAAh5BOWyno5C7Cf53VozE2TplvSvM
         bPEevEfs3mSNjeC8BHIwKXIrNew2lAhvM4IMq5SU/T27xbp4iOiKcKEarCNvZoBipRDP
         efW9mClpxCi2d8lfWVhKgsGsd44174mHqtUYFhsXG0N9vzRnVW8W9N5mYxNUGK0E77Zv
         xRIQ==
X-Gm-Message-State: AOAM532i9XNXiqsXiGWxfQ3mLoQTRbV2+/s4e5QpbrhVp0uF9dXKvFDb
        f2lxqslpXOC72tuM/0VhIMqvQQ==
X-Google-Smtp-Source: ABdhPJwH1Saq8jX1rR1EHdxjdr3/FrPENkPRN4qLVDh1v0pgfyJvQqISlSS9gdsIEnnh9Nv1VLrBPw==
X-Received: by 2002:a05:6638:1390:: with SMTP id w16mr865314jad.83.1620254586009;
        Wed, 05 May 2021 15:43:06 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id k13sm256084iop.24.2021.05.05.15.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 15:43:05 -0700 (PDT)
Subject: Re: [PATCH v1 6/7] dt-bindings: net: qcom-ipa: Document
 qcom,sc7180-ipa compatible
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <20210211175015.200772-7-angelogioacchino.delregno@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <19151b65-5600-df8a-c25f-d46a096f068e@ieee.org>
Date:   Wed, 5 May 2021 17:43:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-7-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> The driver supports SC7180, but the binding was not documented.
> Just add it.

This has been fixed upstream now.
   c3264fee72e7 dt-bindings: net: qcom,ipa: add some compatible strings

					-Alex

> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> ---
>   Documentation/devicetree/bindings/net/qcom,ipa.yaml | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 8a2d12644675..b063c6c1077a 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -43,7 +43,11 @@ description:
>   
>   properties:
>     compatible:
> -    const: "qcom,sdm845-ipa"
> +    oneOf:
> +      - items:
> +          - enum:
> +              - "qcom,sdm845-ipa"
> +              - "qcom,sc7180-ipa"
>   
>     reg:
>       items:
> 

