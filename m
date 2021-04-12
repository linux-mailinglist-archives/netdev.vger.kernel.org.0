Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B5C35D068
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245032AbhDLSck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:32:40 -0400
Received: from mail-oo1-f50.google.com ([209.85.161.50]:40828 "EHLO
        mail-oo1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhDLScj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 14:32:39 -0400
Received: by mail-oo1-f50.google.com with SMTP id j20-20020a4ad6d40000b02901b66fe8acd6so3256194oot.7;
        Mon, 12 Apr 2021 11:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N9ov6B/qlym070JXQJqFslQDmbhzPAQYMb1x8KwEf44=;
        b=J5xvNmpq+fCfCWHEhQ+KGKPdptID/FrZ/0gM0srYN0d1OKJ3nLieW3HOgPtDu8/Q9x
         lkJeG/BFGT/ZwBc435SLG/Sb/WDLv+uonhDMXie/agHwRuaOn6uSB5JqlL3F1m1CORlO
         mapMd7xGIv7gTqxdYZjtyc4MxFAUYNgIf1+fdIF3KMRo8Rk5nmFIUHNX5lVRLYk8H4dd
         xa1dhDlO4gW6CIepyWxZ3OiepfJdzj3uj4SapODYTnSDTYhAVUzsCtShLE2bJos3th3E
         HeUuLrl7Ne4vWI0SY9DdWzenXyLSgZQNbkAaFgnY70FHAQ/NhPniGUMOS4qEwQR8c177
         kU5w==
X-Gm-Message-State: AOAM530FJHx2ZQh42tybTnNfZbcvOh1tuXJE4z5dAGKHHW5tPi6IKey7
        6nk7XLmrMVJHFpw2AUSYqA==
X-Google-Smtp-Source: ABdhPJzrGdBff893Ewe8x+/WsgzTuF7LSm695wZKwiVU6D/tezehMuM4zN2lkVgdXRQ57nezF27xVg==
X-Received: by 2002:a4a:bd82:: with SMTP id k2mr5586783oop.5.1618252340408;
        Mon, 12 Apr 2021 11:32:20 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 38sm2805835oth.14.2021.04.12.11.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 11:32:19 -0700 (PDT)
Received: (nullmailer pid 4165053 invoked by uid 1000);
        Mon, 12 Apr 2021 18:32:18 -0000
Date:   Mon, 12 Apr 2021 13:32:18 -0500
From:   Rob Herring <robh@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] dt-bindings: net: qcom,ipa: add some
 compatible strings
Message-ID: <20210412183218.GA4164081@robh.at.kernel.org>
References: <20210409204024.1255938-1-elder@linaro.org>
 <20210409204024.1255938-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409204024.1255938-2-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 03:40:21PM -0500, Alex Elder wrote:
> Add existing supported platform "qcom,sc7180-ipa" to the set of IPA
> compatible strings.  Also add newly-supported "qcom,sdx55-ipa",
> "qcom,sc7280-ipa".
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 8f86084bf12e9..2645a02cf19bf 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -43,7 +43,11 @@ description:
>  
>  properties:
>    compatible:
> -    const: "qcom,sdm845-ipa"
> +    oneOf:
> +      - const: "qcom,sc7180-ipa"
> +      - const: "qcom,sc7280-ipa"
> +      - const: "qcom,sdm845-ipa"
> +      - const: "qcom,sdx55-ipa"

Use enum instead of oneOf + const. And drop the quotes.

>  
>    reg:
>      items:
> -- 
> 2.27.0
> 
