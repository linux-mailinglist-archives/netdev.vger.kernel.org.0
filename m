Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6B45BADCB
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiIPNHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiIPNHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:07:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728FF9DF9A
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:06:58 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so5323489wmq.1
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=2e3L0ED1BDpFLdmTFeqIIUKU3RqfHrrBxYTQB/sNCko=;
        b=WmiEwXzwWnQ7UhY4icQ+KagCVvewZf1BCWbBhzAwP1xnI7f2tTG51N/2zJzL1WOCaR
         9aiKuOvqAtqtWM2TmvB6sphGRbKpypjiXP2xf0Oguf5qD1YpKuPiehKdu/cx8lnE3gSu
         4Wm8hfai1x6u8g2wF2fwP63cTurPQ4AA1zOnW9KRXPLYl3lFwmci6Ry3V6aM+6HXqs0H
         NeNmCgewC1WV22suOCH3lAqR6oPUeqk4VFGIP9LHetVlUc3Dmj5McMfTD94JwuJiEtRW
         GZMbedYUVdldxNrRt7/dYsxbSVbFiV8iDzn7iKSJ5A6sJilWkEcgUZ+JybSqHWI2oiCe
         oRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=2e3L0ED1BDpFLdmTFeqIIUKU3RqfHrrBxYTQB/sNCko=;
        b=m8s2uzSecklV6UGlG4Rg6W1Lm7pD0V6Tn7s+avfPMhiDwRkFa5RfganiMx4XiXUFLd
         ys6HLazVglID5SoP/XXIBW9m3S5OT0ZV3B0ROuW48bLXz3R9luR30QOtE9of3MG3hg79
         26lUv74cKcCS8lXaXCPg0EYLAEywVXlNmznGX2z/haR3XVYaHR1sCrEu2IZhaiejVWFj
         RoUIpYfuhXjCzPlx3fPpKwrcH7nN/WhR60RtKNxHigkbrtynY6UrlDaZEJtkoteSzoyt
         3Rq7mcHEQABW4Ji1izP6u5gs3Cu4enLl9z8uHV5pFhbsgx5gEa/2dTMTD1EMF2TUKvAy
         oejg==
X-Gm-Message-State: ACgBeo2YEqh8x6pAxLEpkXCusmG6oZMJGTkU3uim6t0mcZAgC5wWOh8q
        MezdA1g+W8k36K+Ka5uGOaNx2w==
X-Google-Smtp-Source: AA6agR5UFLsDdB3qilLfFu+EUOFH0MP3U4bh23DIqC90LAY0sDX0eH8fz77Jqg/mU9Yy/mi+bZrsGQ==
X-Received: by 2002:a05:600c:2142:b0:3b4:92b6:73ba with SMTP id v2-20020a05600c214200b003b492b673bamr10433278wml.139.1663333616920;
        Fri, 16 Sep 2022 06:06:56 -0700 (PDT)
Received: from [192.168.86.238] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id y9-20020a05600c20c900b003a541d893desm2063106wmm.38.2022.09.16.06.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 06:06:56 -0700 (PDT)
Message-ID: <65f11ed1-f09f-e0a2-91f5-891394160c96@linaro.org>
Date:   Fri, 16 Sep 2022 14:06:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/4] slimbus: qcom-ngd-ctrl: Make QMI message rules const
Content-Language: en-US
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <20220912232526.27427-1-quic_jjohnson@quicinc.com>
 <20220912232526.27427-2-quic_jjohnson@quicinc.com>
 <20220912232526.27427-3-quic_jjohnson@quicinc.com>
 <20220912232526.27427-4-quic_jjohnson@quicinc.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220912232526.27427-4-quic_jjohnson@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/09/2022 00:25, Jeff Johnson wrote:
> Commit ff6d365898d ("soc: qcom: qmi: use con

SHA ID should be at least 12 chars long.

Same comment for all the patches in the series.


st for struct
> qmi_elem_info") allows QMI message encoding/decoding rules to be
> const, so do that for qcom-ngd-ctrl.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Other than that it LGTM,
Once fixed:

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>


--srini

> ---
>   drivers/slimbus/qcom-ngd-ctrl.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
> index 0aa8408464ad..931ab6317467 100644
> --- a/drivers/slimbus/qcom-ngd-ctrl.c
> +++ b/drivers/slimbus/qcom-ngd-ctrl.c
> @@ -220,7 +220,7 @@ struct slimbus_power_resp_msg_v01 {
>   	struct qmi_response_type_v01 resp;
>   };
>   
> -static struct qmi_elem_info slimbus_select_inst_req_msg_v01_ei[] = {
> +static const struct qmi_elem_info slimbus_select_inst_req_msg_v01_ei[] = {
>   	{
>   		.data_type  = QMI_UNSIGNED_4_BYTE,
>   		.elem_len   = 1,
> @@ -262,7 +262,7 @@ static struct qmi_elem_info slimbus_select_inst_req_msg_v01_ei[] = {
>   	},
>   };
>   
> -static struct qmi_elem_info slimbus_select_inst_resp_msg_v01_ei[] = {
> +static const struct qmi_elem_info slimbus_select_inst_resp_msg_v01_ei[] = {
>   	{
>   		.data_type  = QMI_STRUCT,
>   		.elem_len   = 1,
> @@ -284,7 +284,7 @@ static struct qmi_elem_info slimbus_select_inst_resp_msg_v01_ei[] = {
>   	},
>   };
>   
> -static struct qmi_elem_info slimbus_power_req_msg_v01_ei[] = {
> +static const struct qmi_elem_info slimbus_power_req_msg_v01_ei[] = {
>   	{
>   		.data_type  = QMI_UNSIGNED_4_BYTE,
>   		.elem_len   = 1,
> @@ -324,7 +324,7 @@ static struct qmi_elem_info slimbus_power_req_msg_v01_ei[] = {
>   	},
>   };
>   
> -static struct qmi_elem_info slimbus_power_resp_msg_v01_ei[] = {
> +static const struct qmi_elem_info slimbus_power_resp_msg_v01_ei[] = {
>   	{
>   		.data_type  = QMI_STRUCT,
>   		.elem_len   = 1,
