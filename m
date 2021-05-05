Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5294374B76
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 00:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhEEWoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 18:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbhEEWoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 18:44:11 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2969C06134D
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 15:43:11 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id b17so3122910ilh.6
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 15:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AMvqVLaQgP9SZ02av5Xb9uNNcb2canxCwjD7q3lTwm4=;
        b=DItsHr6eNdQb25/vXeyH9zREbIvrZUZd2DmN0nwXlUBvYvueQJUH5vo2AUb36lBv2L
         fodxXzHol4XTKMES5Q+nABfGcDNUS0hedJ8QE3IkoLltrPODrQ4Io901OdQbyQGpI9TW
         4QcNyUgzSmtnvfkD5gdYrVdq1C9GxbOOpshKo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AMvqVLaQgP9SZ02av5Xb9uNNcb2canxCwjD7q3lTwm4=;
        b=EbW0Zr9Dey/oHyjLr2Y3l0tva6swwWCJMlOiwjfNLsWBtkvs8Ed5PPh7IgssEUmis6
         GGMQMamsEtRwd26I+SPSPkM4OdQKrgqMkmLpOVdtPAKa9ADzkQ/aVKoy+89vMCgavOmw
         a54yk8uxHi6uzQXV7S/38A1oRbSyokhuYSSLxoOyybAS3p18TsBr4Bz4s963Cvik4Zu9
         kckyk8yMDUusHBwDmsFHcfiC/F4aYklVW2sgyxlhqUlU9ljMrridgcTZeqtjjN/yrrws
         LqvURMhACmug237LIOw6xq6H9cs7vHiLYTUK0GFY/p2n7LSC95RDEGTCHFsx+4dq5hx+
         m+Kw==
X-Gm-Message-State: AOAM532TVFeGYw/iFmH1ewR/dLAsS83jGgbA6YW1HQ5PtGnxKfzP4P0M
        WfoyOOBA5ltrqiIWJaCxXBYt9Q==
X-Google-Smtp-Source: ABdhPJw4+aModkOR1CL4tGwxKVaInDrJMi+2xFdAf4BJf3oqi/3HhawuE8nuXEZmg5LgtQDbSH/z6g==
X-Received: by 2002:a92:c566:: with SMTP id b6mr1201152ilj.162.1620254591251;
        Wed, 05 May 2021 15:43:11 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id q1sm374703ilj.4.2021.05.05.15.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 15:43:10 -0700 (PDT)
Subject: Re: [PATCH v1 7/7] dt-bindings: net: qcom-ipa: Document
 qcom,msm8998-ipa compatible
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>, elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <20210211175015.200772-8-angelogioacchino.delregno@somainline.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <9998f8ed-b656-4496-b70d-83a0ee43d646@ieee.org>
Date:   Wed, 5 May 2021 17:43:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211175015.200772-8-angelogioacchino.delregno@somainline.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 11:50 AM, AngeloGioacchino Del Regno wrote:
> MSM8998 support has been added: document the new compatible.
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

The upstream file affected here now has a slightly different
format.  I will implement this change, credit you for having
first proposed it, and will include a link to your original
message.

					-Alex

> ---
>   Documentation/devicetree/bindings/net/qcom,ipa.yaml | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index b063c6c1077a..9dacd224b606 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -46,6 +46,7 @@ properties:
>       oneOf:
>         - items:
>             - enum:
> +              - "qcom,msm8998-ipa"
>                 - "qcom,sdm845-ipa"
>                 - "qcom,sc7180-ipa"
>   
> 

