Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABDD6C0FC7
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjCTKyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjCTKy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:54:27 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E8729402
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 03:51:02 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t11so14331628lfr.1
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 03:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679309432;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8UwMGbH95BaLLx6VzjXlU8ubTmlqMITzsi02SYgcbvI=;
        b=iKPOVPKk07dfNQ2nsalEOt9QMeZSoUSarM2PQvDxFzOElRqUlet00WA/9AjIttRUCg
         Ihuc/KDXndazNFyzkC1KbmSo3cVyAK05rH7S5QthpBztPjUipW0XfOBYVHzcidB9hBtZ
         HMkfFV6bdu+dBryLA16HZVb0y1Lf7Jp/5sROGYyTXf/FDE5lKuymwM5/XT8s5pYwIRxY
         Ounrmn/XAgiUNJnNzVnU1HzPYH/BLfmN4CW5m4GADoE+J2tzZFxlaumlPtMTVMQtqyjj
         nuzjPx825LmD5m7p4tkCacDq6x7haUWOTfbSnb9G5oPNAHGkXGSTXNrsxzc3CD+8THsN
         YASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679309432;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8UwMGbH95BaLLx6VzjXlU8ubTmlqMITzsi02SYgcbvI=;
        b=qf+BENZwlcWFpWhCZ1tc5m5ORdVYJvRgICjh2dEWbl/UtgLDVLlftpeqQMEyt6hwAV
         ZGXFWJNiWu0VeiF4eDAnd3tF9tEAr1KnRvPOJd6qt5ON8UDfpqoaIdzZGHM/CNa1XlJo
         m/nmZvECby/NbpoTqua/KuYrDAid+tWb+lqqzr8r7NLXHiRtB6TUDwmVftKqNw61kB8G
         kKEsegz/MnfoeKdpqe8IKPY6WX6dUXOVEkCbygcbUwiLi8jeEcbJR8mrDj1VwpewDpQo
         /jJU1YACPCVlVDg2uhQN0GlrS5NIh0QABiDGVzkD49kLdVkUvAI+PsUyqJkNTsDnq3OA
         7zvQ==
X-Gm-Message-State: AO0yUKW/y/7uQO4J6UuBlf/HWSEKSkiqMDf9bMROIrceDAGui7N+FltO
        G1fiDh3jllk9qAawT2X5fFJC4NqYIizm8B+1TqM=
X-Google-Smtp-Source: AK7set9cug+D2wErAAJApwApv/p51maqym3vipkKYV792xKcSZHwzylSgwAaCKLLoU7iYea0159e3Q==
X-Received: by 2002:ac2:4341:0:b0:4dd:a633:2ae4 with SMTP id o1-20020ac24341000000b004dda6332ae4mr6148017lfl.39.1679309432265;
        Mon, 20 Mar 2023 03:50:32 -0700 (PDT)
Received: from [192.168.1.101] (abym238.neoplus.adsl.tpnet.pl. [83.9.32.238])
        by smtp.gmail.com with ESMTPSA id o9-20020ac24349000000b004d19e442d53sm1635969lfl.249.2023.03.20.03.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 03:50:31 -0700 (PDT)
Message-ID: <244a59c6-2dc0-83c7-07d2-6bae04022605@linaro.org>
Date:   Mon, 20 Mar 2023 11:50:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/3] arm64: dts: qcom: sc8280xp-crd: add wifi calibration
 variant
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230320104658.22186-1-johan+linaro@kernel.org>
 <20230320104658.22186-4-johan+linaro@kernel.org>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230320104658.22186-4-johan+linaro@kernel.org>
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



On 20.03.2023 11:46, Johan Hovold wrote:
> Describe the bus topology for PCIe domain 6 and add the ath11k
> calibration variant so that the board file (calibration data) can be
> loaded.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216036
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  arch/arm64/boot/dts/qcom/sc8280xp-crd.dts | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
> index 90a5df9c7a24..5dfda12f669b 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts


Was mixing
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts

this /\

[...]

and this \/
> +			qcom,ath11k-calibration-variant = "LE_X13S";
Intentional? Especially given Kalle's comment on bugzilla?

Konrad
> +		};
> +	};
>  };
>  
>  &pcie4_phy {
