Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC181C45E6
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgEDS3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730606AbgEDS32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:29:28 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9A1C061A41
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:29:27 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 207so163755pgc.6
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 11:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3mcb3hEms/g2cRqXnF9mYGpTlaunEURjVZJCsIzGh9k=;
        b=Zh/W+EiE3lvTwm+HWpVVsbuUMLNuAdreiZ2ZqOc+C3Ch5E1CjUraKKj4/BATTkl0SQ
         nvB715f5f1/i8/QqCGuaBQQmLrIX/rGOkI7uCqvJgOziqNe4wpbCZDC64EOO8tEneDC8
         5xZC438qx9k6dBvlrMI4JqvZbGDHXCci/LtIt8oaHR8w9sxBUtyE8LE/Fr77j5ASvaT5
         EE5davlIM9hmPW7dbjVYycDHUjQYDbcrNLIGZv+yOb/kyKoUtTcWkcdTkEJE4O00VAUF
         teOcH6GUEH+lU+8sdTOS1kCwvq4f5hoc7ZzEmJ4rFkPmkhdOHR+KOlMuGINjD/FbCU9L
         D3NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3mcb3hEms/g2cRqXnF9mYGpTlaunEURjVZJCsIzGh9k=;
        b=LgFyFuWmrWDppBuZ2i+R/JaBOz144HJ2gAp/Z7h8wVqN2v7Gzp0qdG1J50on/C67xN
         LJb/CyUHswcH9UQkd9N+bxOIYPTajxYnHhR8T3E7MnMfd4LwRWnAZ09EMjXAaPhv4NLj
         x4EWaWryoIj9W0a7829R00E3bipMaUxICiJXZkgplc02XmlYKxFwoE5XejrGDRxiAZF1
         YRaEmOhSdEMxgj2l8rtlH/W23nkonKCSLCQWAaeDV+8TrJ4UJyYE04SF5m1FSQko+zHD
         4WxlJ2pUfaBVqMvJy3idV1YIX+moGbpIbI1Kpq04sOvWoQxgTmgWC4Gg1p9ifXlRCW5f
         uWMQ==
X-Gm-Message-State: AGi0PuY+u06WcI4/ljY4Z0dlk0NIW1ZRgpS444KH1/OiWyUCcENV6hGm
        nMUqREgcT2SE4vsNfH8G/7/E4A==
X-Google-Smtp-Source: APiQypJw2QOIf2XJfvZVcM8veojbbFcmiYFYAB5w4F2DRway3GD/F2mtQmG2UymA9Nd+umrDiTMePw==
X-Received: by 2002:aa7:82d7:: with SMTP id f23mr19851746pfn.198.1588616966991;
        Mon, 04 May 2020 11:29:26 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id 13sm9402013pfv.95.2020.05.04.11.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 11:29:26 -0700 (PDT)
Date:   Mon, 4 May 2020 11:30:10 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     robh+dt@kernel.org, davem@davemloft.net, evgreen@chromium.org,
        subashab@codeaurora.org, cpratapa@codeaurora.org,
        agross@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] dt-bindings: net: add IPA iommus property
Message-ID: <20200504183010.GD20625@builder.lan>
References: <20200504175859.22606-1-elder@linaro.org>
 <20200504175859.22606-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504175859.22606-2-elder@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 04 May 10:58 PDT 2020, Alex Elder wrote:

> The IPA accesses "IMEM" and main system memory through an SMMU, so
> its DT node requires an iommus property to define range of stream IDs
> it uses.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 140f15245654..7b749fc04c32 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -20,7 +20,10 @@ description:
>    The GSI is an integral part of the IPA, but it is logically isolated
>    and has a distinct interrupt and a separately-defined address space.
>  
> -  See also soc/qcom/qcom,smp2p.txt and interconnect/interconnect.txt.
> +  See also soc/qcom/qcom,smp2p.txt and interconnect/interconnect.txt.  See
> +  iommu/iommu.txt and iommu/arm,smmu.yaml for more information about SMMU
> +  bindings.
> +
>  
>    - |
>      --------             ---------
> @@ -54,6 +57,9 @@ properties:
>        - const: ipa-shared
>        - const: gsi
>  
> +  iommus:
> +    maxItems: 1
> +
>    clocks:
>      maxItems: 1
>  
> @@ -126,6 +132,7 @@ properties:
>  
>  required:
>    - compatible
> +  - iommus

This technically "breaks" backwards compatibility, but the binding is
rather new and in limited use, so I think we should do this.


Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

>    - reg
>    - clocks
>    - interrupts
> @@ -164,6 +171,7 @@ examples:
>                  modem-init;
>                  modem-remoteproc = <&mss_pil>;
>  
> +                iommus = <&apps_smmu 0x720 0x3>;
>                  reg = <0 0x1e40000 0 0x7000>,
>                          <0 0x1e47000 0 0x2000>,
>                          <0 0x1e04000 0 0x2c000>;
> -- 
> 2.20.1
> 
