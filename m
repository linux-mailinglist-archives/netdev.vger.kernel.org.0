Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D38233B1F4
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCOMAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhCOL75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:59:57 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F72BC061764
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:59:57 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id f12so8522278wrx.8
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SS1gct42nXEurrNmbvLMUHBfwY4gO5XhOVCF9euUF9s=;
        b=MUVhFOjYfQavUzABQXpLiEHlqUT3kzcdNXJk9R2s1IIzW53qoU76OIdvRjkVSRHwZG
         MtK28UTKXFQwGa0NHFvP98HaDgWRB/6+wenmYvSqtPKLU6ffJy2CLQwDffwSCztSNUOD
         wSVuTsNlrnhf73WyfMX0izOwHqfWsRmq8tC0o+Sb+XMIFqW9hjS+emFAP99ZWJFnUxRx
         GJTRzAVLk76O5LSSkeq23c6tjz8TSgW8xB8cCwVh8iCTg7i1xBDp5mw0lPeWCU2kMo9p
         mtKp/uZ0XetXYPSjXBIPJ/MXpZB5jZf/zfhV72tjHSxW0KDVboKgB/m3j0lpKL2nG296
         EnYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SS1gct42nXEurrNmbvLMUHBfwY4gO5XhOVCF9euUF9s=;
        b=XIQqQONd2wy3s8sdqIXquMsVWgQ+5ScxRoWXPrE4oeWN8VwShNQFuLr1QCI083/M4T
         hPJefu2xqxKSJm9PMWvuMtgQ+fU7tbMTisL76rfGxIN+2zZrPLi08YPNLKgLm16N+eE3
         dL3MjIWd4yhXoqIGRUJL3G9KQU9AD5Ez2F4kdmIfwyXRQNNZtXoX1UOlagEFqS4EYQOG
         myLPHc6K7MMSgv+lB8VMBIN+9IwAXl8CD/6fJEKmj5LOeXA2YCzFdQnwTKgBn3AaaOss
         Kh/ykdXlActuqEM7yVj3W6LIAF3Vuxzqh3UgGXOvz+q6nBzPjkc1zfLhbSrUv+8NvVMB
         l0vQ==
X-Gm-Message-State: AOAM531o4L8LZU/wSctzY1Hf9i2dfsGsbBL6+eSwaAamq7WapHJm0vdy
        rlXFWlWNLoZiox0m5/uNij1Qy3SCKcyfNhpV
X-Google-Smtp-Source: ABdhPJwLLHk3+2nVXdv1rSFL/CLcrBN5exMsKtZ/CKY/bRSQAaObXhf1VDwv6SBICLHZ+nQrVC8BYg==
X-Received: by 2002:a5d:6a4c:: with SMTP id t12mr26298747wrw.289.1615809595542;
        Mon, 15 Mar 2021 04:59:55 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id f22sm12048777wmc.33.2021.03.15.04.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 04:59:55 -0700 (PDT)
Subject: Re: [PATCH 5/5] arm64: dts: qcom: msm8916: Enable modem and WiFi
To:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
 <20210312003318.3273536-6-bjorn.andersson@linaro.org>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <f03b639f-f95a-a31a-6615-23cd6154182d@linaro.org>
Date:   Mon, 15 Mar 2021 12:01:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210312003318.3273536-6-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/03/2021 00:33, Bjorn Andersson wrote:
> Enable the modem and WiFi subsystems and specify msm8916 specific
> firmware path for these and the WCNSS control service.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>   arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi | 12 ++++++++++++
>   arch/arm64/boot/dts/qcom/msm8916.dtsi     |  2 +-
>   2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
> index 6aef0c2e4f0a..448e3561ef63 100644
> --- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
> +++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
> @@ -305,6 +305,12 @@ &mdss {
>   	status = "okay";
>   };
>   
> +&mpss {
> +	status = "okay";
> +
> +	firmware-name = "qcom/msm8916/mba.mbn", "qcom/msm8916/modem.mbn";
> +};
> +
>   &pm8916_resin {
>   	status = "okay";
>   	linux,code = <KEY_VOLUMEDOWN>;
> @@ -312,6 +318,8 @@ &pm8916_resin {
>   
>   &pronto {
>   	status = "okay";
> +
> +	firmware-name = "qcom/msm8916/wcnss.mbn";
>   };

On Debian I have to do this


index 2a6a23cb14ca..597cdc8f51cc 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -33,7 +33,7 @@
  #include "qcom_wcnss.h"

  #define WCNSS_CRASH_REASON_SMEM                422
-#define WCNSS_FIRMWARE_NAME            "wcnss.mdt"
+#define WCNSS_FIRMWARE_NAME            "qcom/msm8916/wcnss.mdt"

so I guess wcnss_probe() -> rproc_alloc() wants this fix too.

---
bod
