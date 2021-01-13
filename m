Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A392F41ED
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbhAMCmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:42:40 -0500
Received: from mail-oi1-f172.google.com ([209.85.167.172]:43683 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728351AbhAMCmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 21:42:40 -0500
Received: by mail-oi1-f172.google.com with SMTP id q25so570641oij.10;
        Tue, 12 Jan 2021 18:42:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TnILk4VpEu/oT+IpVAchf2EyrzoqdWoNiHXReeRtRvc=;
        b=hKE5bEYea+0W8blz3vcb5n+twDamVVL0sVg0aT2XoiFrzyORLTZIkpTqrCvCrDR5NT
         1irMOnUdmL476Y0WA8VPF7AZg/XPD5LYO0uvkQ+hELGFn7lwfpncAQez4yP8BoOrBoST
         z9tRTd5apnJqzObtbS2ytltn7Tv2xezF6fT0qj7NsNl5Qu5M5RlpLQz5jVb5d+eS4c8F
         iRuPSE1rqtbWAeZdMycLL13Iz1VVk5Z7YySsM5HGSzN0lI4HDELzcJ4Pajjlp2wEYQZd
         yPmDEfdIKmjFjLWCK+4XbbKOC/GSugbuQs/XFzRbDwKYaVCEpqt1Te6sgvrOfOEMCFeC
         PIAA==
X-Gm-Message-State: AOAM531ZwM9lqlXbRnDqmq6X9mtpyE1DrQfzHiZukGyO8+NulH/9/It/
        KZKiNOfa+/DU9GK5CdMeqw==
X-Google-Smtp-Source: ABdhPJyKqKNiiMd2rkfNqcoZKbYp0KoUwskIJsniu87UfydYYo6KiDbZye7UjaGc55Mxhjh2WSAO8g==
X-Received: by 2002:aca:f594:: with SMTP id t142mr50034oih.162.1610505713172;
        Tue, 12 Jan 2021 18:41:53 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id b19sm158465oib.6.2021.01.12.18.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 18:41:52 -0800 (PST)
Received: (nullmailer pid 1409182 invoked by uid 1000);
        Wed, 13 Jan 2021 02:41:51 -0000
Date:   Tue, 12 Jan 2021 20:41:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, rdunlap@infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] dt-bindings: net: remove modem-remoteproc
 property
Message-ID: <20210113024151.GA1408606@robh.at.kernel.org>
References: <20210112192831.686-1-elder@linaro.org>
 <20210112192831.686-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112192831.686-3-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 01:28:29PM -0600, Alex Elder wrote:
> The IPA driver uses the remoteproc SSR notifier now, rather than the
> temporary IPA notification system used initially.  As a result it no
> longer needs a property identifying the modem subsystem DT node.
> 
> Use GIC_SPI rather than 0 in the example interrupt definition.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 8a2d12644675b..a8cff214ee11f 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -113,13 +113,6 @@ properties:
>        performing early IPA initialization, including loading and
>        validating firwmare used by the GSI.
>  
> -  modem-remoteproc:
> -    $ref: /schemas/types.yaml#/definitions/phandle
> -    description:
> -      This defines the phandle to the remoteproc node representing
> -      the modem subsystem.  This is requied so the IPA driver can
> -      receive and act on notifications of modem up/down events.
> -
>    memory-region:
>      maxItems: 1
>      description:
> @@ -135,7 +128,6 @@ required:
>    - interrupts
>    - interconnects
>    - qcom,smem-states
> -  - modem-remoteproc
>  
>  oneOf:
>    - required:
> @@ -168,7 +160,6 @@ examples:
>                  compatible = "qcom,sdm845-ipa";
>  
>                  modem-init;
> -                modem-remoteproc = <&mss_pil>;
>  
>                  iommus = <&apps_smmu 0x720 0x3>;
>                  reg = <0x1e40000 0x7000>,
> @@ -178,8 +169,8 @@ examples:
>                              "ipa-shared",
>                              "gsi";
>  
> -                interrupts-extended = <&intc 0 311 IRQ_TYPE_EDGE_RISING>,
> -                                      <&intc 0 432 IRQ_TYPE_LEVEL_HIGH>,
> +                interrupts-extended = <&intc GIC_SPI 311 IRQ_TYPE_EDGE_RISING>,
> +                                      <&intc GIC_SPI 432 IRQ_TYPE_LEVEL_HIGH>,

You need the include file.

>                                        <&ipa_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,
>                                        <&ipa_smp2p_in 1 IRQ_TYPE_EDGE_RISING>;
>                  interrupt-names = "ipa",
> -- 
> 2.20.1
> 
