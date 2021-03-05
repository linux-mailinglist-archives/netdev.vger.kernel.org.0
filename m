Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB49D32F3F1
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 20:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCETcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 14:32:41 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:44843 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhCETcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 14:32:21 -0500
Received: by mail-oi1-f169.google.com with SMTP id x20so3689283oie.11;
        Fri, 05 Mar 2021 11:32:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XaS2sNj3AaDvFNYBjMZ96z/1bD+wKa0y2e10rT1bRbo=;
        b=DBJ+dOmakxUa3Whvpz5LdGaiC5P7s5uAFWVqSy/fV4xPp6WWVxIp8FCPzfBqpVshrl
         HLkhU1QlDxrkZfgPAoOyKf/p8XGxpMtVEl57wRZqlfGEelXhzJ1CgwM3SL1kkr/y+UZ3
         fyXAuITl5mr86eUdlASReaYjav3A4gXdkKXtAOPboFHHAM3YhuiWJ8a6aIod6AXoCrJF
         aJrQPLYSBp4eiPOPDjSE4pRrk3HHinwzkD4m78vLCxt577Gnt0jyrvhkFxzAY9sc0QOY
         G+ghCS/OyHeSF9Ht7FrbQkGGmcul2vDrldYvEC+kLMOXclFkjRyQcpoTpWdoulE/ow3S
         yIiQ==
X-Gm-Message-State: AOAM533Qie9RwdJRzBx1UtrUWY2wqeYHyDYDQrDnt0XGK0dw0zkfqK9F
        ICIUMs5acGtKlS3R30Ditqgk9X4VXw==
X-Google-Smtp-Source: ABdhPJzeJ22aG7OHIMAzQMrvP4kx0nmrnZrAZfCRF/bSzz2qFHlNgD/X+8eCHp1qdTXD3YrzIsQb9A==
X-Received: by 2002:aca:da83:: with SMTP id r125mr8319982oig.127.1614972740680;
        Fri, 05 Mar 2021 11:32:20 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p66sm710872oib.53.2021.03.05.11.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 11:32:19 -0800 (PST)
Received: (nullmailer pid 518985 invoked by uid 1000);
        Fri, 05 Mar 2021 19:32:18 -0000
Date:   Fri, 5 Mar 2021 13:32:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Cc:     elder@kernel.org, bjorn.andersson@linaro.org, agross@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        konrad.dybcio@somainline.org, marijn.suijten@somainline.org,
        phone-devel@vger.kernel.org
Subject: Re: [PATCH v1 6/7] dt-bindings: net: qcom-ipa: Document
 qcom,sc7180-ipa compatible
Message-ID: <20210305193218.GA517246@robh.at.kernel.org>
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
 <20210211175015.200772-7-angelogioacchino.delregno@somainline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211175015.200772-7-angelogioacchino.delregno@somainline.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 06:50:14PM +0100, AngeloGioacchino Del Regno wrote:
> The driver supports SC7180, but the binding was not documented.
> Just add it.
> 
> Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 8a2d12644675..b063c6c1077a 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -43,7 +43,11 @@ description:
>  
>  properties:
>    compatible:
> -    const: "qcom,sdm845-ipa"
> +    oneOf:
> +      - items:
> +          - enum:

Just enum, you don't need oneOf when only 1. And items is implied when 
only 1 entry.

> +              - "qcom,sdm845-ipa"
> +              - "qcom,sc7180-ipa"
>  
>    reg:
>      items:
> -- 
> 2.30.0
> 
