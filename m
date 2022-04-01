Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF104EE942
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 09:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343964AbiDAHuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 03:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243493AbiDAHuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 03:50:16 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA8A6415
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 00:48:25 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id yy13so4138957ejb.2
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 00:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jKLQBlqIFr/iG8CIwjuu4g6Q7RGdVgPWfVQ84Mi3Szw=;
        b=KzeZfGo9KEvF7K0FINsb2Zw+lDMpJcEXVQB/RHtbXUlJlwYpbs4L7Yeda1a6F/OFAQ
         j6V5g9qh5PCVqg0b266UGaWdDa/xAh5DDNBKUYHi2TOJqW4eZBp+tqv+MHS+dUXrM527
         J7wfoZM8BfcEFhnVOKmH6AUtEnqhxuubqs9JyXAGB3XH4UjNW+HBxyrLA0Vp6u5wlvnu
         OGE86RrHHoq4EFlBlyNvmiIdszD4dD79P5SBrwuuF5JRu/KtBi8/DP1SkX0Lnvr/+bOs
         udplW3iJ7/CTJqzhIkJMy9URRFZZAMSzNJASwgXKEpGYfbv6KkWF25kwBWxNCCxh0dd0
         cy5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jKLQBlqIFr/iG8CIwjuu4g6Q7RGdVgPWfVQ84Mi3Szw=;
        b=zpWQ4YdBHNM1ZytETKVf3FdM+bFKpnlcRFj7wmCYnk8dBCnXyA8iBCV7GxDaBa5HhZ
         PLnlQZYjz/yWWLiqdRQ/O5ObA8I6qPCy4MFAlQCUoGEb/iBaiEj/5VPmeGusc3FvgWlS
         E/8S/YLGjbJPCnW7f2I2O+DP9ct7UtJMjTlpbC+JUEJ8hrEkakHa5Et2LX3D5G4kNsOA
         Ou4DdZJKPOBGZCjl7SuUyp5JlYY4j9pbZQ2WlWEfDNVXKDbXU+ZrCaPxNuoJRMNWm5Ok
         sg5J0+wwIJoEwXy8oPZuffKhshQXkCF9qTOZxl4iaXuLOLIIgs2EjbEaklDwRia1I1Mu
         QP8A==
X-Gm-Message-State: AOAM530am3SABDBdqKl8qdIODT42G7ihboPqC6bFuOz3IjrtnQns9YHQ
        Gjgd47k8N9VJ1wTwSAXuhdmNQ3D54pDd2Irn
X-Google-Smtp-Source: ABdhPJx9cuTp/HJczdd8HHheza6l+fRGghaWPC5zP6OhOX6OjwVsHgut0xVX9BrZq/DnM7xxD2Sdww==
X-Received: by 2002:a17:906:4cd8:b0:6db:372:c4ba with SMTP id q24-20020a1709064cd800b006db0372c4bamr8216694ejt.57.1648799304275;
        Fri, 01 Apr 2022 00:48:24 -0700 (PDT)
Received: from [192.168.0.169] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id b11-20020a170906728b00b006df8494d384sm738545ejl.122.2022.04.01.00.48.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 00:48:23 -0700 (PDT)
Message-ID: <8f02c5fc-5ded-b589-19ca-2b419c4664ab@linaro.org>
Date:   Fri, 1 Apr 2022 09:48:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] dt-bindings: net: snps: remove duplicate name
Content-Language: en-US
To:     dj76.yang@samsung.com, "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?7KCE66y46riw?= <moonki.jun@samsung.com>
References: <CGME20220401030847epcms1p8cf7a8e1d8cd7d325dacf30f78da36328@epcms1p8>
 <20220401030847epcms1p8cf7a8e1d8cd7d325dacf30f78da36328@epcms1p8>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220401030847epcms1p8cf7a8e1d8cd7d325dacf30f78da36328@epcms1p8>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/04/2022 05:08, 양동진 wrote:
> snps,dwmac has duplicated name for loongson,ls2k-dwmac and
> loongson,ls7a-dwmac.

Your "From" name seems to be different than Signed-off-by. These should
be the same, so can you fix the commit author to be the same as SoB?

> 
> Signed-off-by: Dongjin Yang <dj76.yang@samsung.com>

Fixes: 68277749a013 ("dt-bindings: dwmac: Add bindings for new Loongson
SoC and bridge chip")


> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 2d5248f..36c85eb 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -53,20 +53,18 @@ properties:
>          - allwinner,sun8i-r40-gmac
>          - allwinner,sun8i-v3s-emac
>          - allwinner,sun50i-a64-emac
> -        - loongson,ls2k-dwmac
> -        - loongson,ls7a-dwmac
>          - amlogic,meson6-dwmac
>          - amlogic,meson8b-dwmac
>          - amlogic,meson8m2-dwmac
>          - amlogic,meson-gxbb-dwmac
>          - amlogic,meson-axg-dwmac
> -        - loongson,ls2k-dwmac
> -        - loongson,ls7a-dwmac
>          - ingenic,jz4775-mac
>          - ingenic,x1000-mac
>          - ingenic,x1600-mac
>          - ingenic,x1830-mac
>          - ingenic,x2000-mac
> +        - loongson,ls2k-dwmac
> +        - loongson,ls7a-dwmac
>          - rockchip,px30-gmac
>          - rockchip,rk3128-gmac
>          - rockchip,rk3228-gmac


Best regards,
Krzysztof
