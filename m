Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095A01C45B8
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbgEDSXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730696AbgEDSXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:23:18 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4239C061A10
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:23:18 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w4so13380960ioc.6
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 11:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g00MXxVdtztL4qBMS1aNPPa+lbPn+NJIpTHVHqlFdp4=;
        b=YXOeQUUayM6/ouFtGCsISVJxSpaOEQJ4jSyQ8BSyXptcIlItLECymk2zqbRE+z8BeA
         UzxwHHZpnbYkXMQDviMSGeIK+cTw9DXrZtbjMZxLAX8ZsP2lDNKaZoD1FLP4XFBtLIqN
         K/H5/dVM9JPfTuuczRP0juET3D1IhxXabFd4X4nYxcrmR/BO9A9jZWLJvI3AfFXDWcsP
         bB1UKpqXRlBv4AUsMxnNUrs7tjoNgQo7ge9pYVwGbD8gk8uvgb1ToQlwdpLDcFGHhHFF
         2lr22WkBR+95902NkqrDrVSE/+Ykn6r7eOlO8Ao2XwkJQqQD+mX1ObF3xY6hqbMSLWxe
         q9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g00MXxVdtztL4qBMS1aNPPa+lbPn+NJIpTHVHqlFdp4=;
        b=AjI1oQtc6TOT+PyqGs1RSkd5cASZDcnWBqeNZ5JEj1t8ZyfP+KR1HkhE4sXWqPVCfu
         tY7Kc4JeSXwZiRz/CcbSoVkdthnpsfIMlSvPo5oQta9jxd1ECfL+i861QD0rdMpW3Eud
         jOuGEXyxDMnmbO/QXMc1BehqSYAps2fjWqneAOGI7+wjO76STp4f2Ketxt1udiPmaGmg
         sWZPPa+k00JWJU/9ip62fWL8d0zTpbabMTAbNR8Ni7p0fjjVQLeI/sx5znjHm7wssGdi
         ztPO0dtwjiDFCugH9MKJThirmblSpi7BSN5je/fycYBW+Ryc+h+MoIM0/GEX/gjyprKd
         O/tQ==
X-Gm-Message-State: AGi0PuaS91L+8QgO/gthiV8TuyOCz7MToVK/EqnoXM2q0Hi3wBrxeAO4
        jrPozxawk3mEcschYg9UrWU7Dw==
X-Google-Smtp-Source: APiQypKXOR9T8IP7JnAqSvoxNt2MP63A/IWQcSz212xzt/Zjxn35i0MjKM6muvk2wEXRTm5fSj0L8w==
X-Received: by 2002:a5e:c008:: with SMTP id u8mr16636889iol.4.1588616597871;
        Mon, 04 May 2020 11:23:17 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id v9sm4487809iol.28.2020.05.04.11.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 11:23:16 -0700 (PDT)
Subject: Re: [PATCH] dt-bindings: net: add IPA iommus property
From:   Alex Elder <elder@linaro.org>
To:     robh+dt@kernel.org, bjorn.andersson@linaro.org, agross@kernel.org
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, davem@davemloft.net,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200501214500.31433-1-elder@linaro.org>
Message-ID: <040dbe54-1a64-6d32-076e-189963f10036@linaro.org>
Date:   Mon, 4 May 2020 13:23:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501214500.31433-1-elder@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/20 4:45 PM, Alex Elder wrote:
> The IPA accesses "IMEM" and main system memory through an SMMU, so
> its DT node requires an iommus property to define range of stream IDs
> it uses.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Please ignore this patch.  I have reposted it as the first
patch in a new series:
   https://lore.kernel.org/netdev/20200504175859.22606-1-elder@linaro.org/

					-Alex

> ---
>   Documentation/devicetree/bindings/net/qcom,ipa.yaml | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 140f15245654..7b749fc04c32 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -20,7 +20,10 @@ description:
>     The GSI is an integral part of the IPA, but it is logically isolated
>     and has a distinct interrupt and a separately-defined address space.
>   
> -  See also soc/qcom/qcom,smp2p.txt and interconnect/interconnect.txt.
> +  See also soc/qcom/qcom,smp2p.txt and interconnect/interconnect.txt.  See
> +  iommu/iommu.txt and iommu/arm,smmu.yaml for more information about SMMU
> +  bindings.
> +
>   
>     - |
>       --------             ---------
> @@ -54,6 +57,9 @@ properties:
>         - const: ipa-shared
>         - const: gsi
>   
> +  iommus:
> +    maxItems: 1
> +
>     clocks:
>       maxItems: 1
>   
> @@ -126,6 +132,7 @@ properties:
>   
>   required:
>     - compatible
> +  - iommus
>     - reg
>     - clocks
>     - interrupts
> @@ -164,6 +171,7 @@ examples:
>                   modem-init;
>                   modem-remoteproc = <&mss_pil>;
>   
> +                iommus = <&apps_smmu 0x720 0x3>;
>                   reg = <0 0x1e40000 0 0x7000>,
>                           <0 0x1e47000 0 0x2000>,
>                           <0 0x1e04000 0 0x2c000>;
> 

