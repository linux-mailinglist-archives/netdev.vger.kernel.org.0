Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104A044EBBD
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 18:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhKLRFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 12:05:02 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:44922 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbhKLRFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 12:05:00 -0500
Received: by mail-oi1-f180.google.com with SMTP id be32so18978179oib.11;
        Fri, 12 Nov 2021 09:02:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qdsBiO0OvPadce4G4EQFWEDt+EqmAslf5x4Pahu/XEU=;
        b=OhYkoZUsEowPK6bgY1Fx9bulO1wrVn+kT2oaLcsinYXgAz+78NYSUolhNEVhiIcpA3
         BGEe8uYMNpfqkj6+7+4Uoxk4FCM3lVv+cszJfbamGqogFkkvngPd0nqJkUVyy+cMCw4s
         3VoORRnDl81zsP+y2n5vD1Zll/qw0MzHxa2wniWKsKd2QVV7r4z/MAg9qxnEaxqSzj6B
         arTBQv6Fu3p+fQ+XJX/BmDNy2oRuMQrtjnbNYo7GHRO1ZdFbdXRkDOk4INTrP/y9xL+O
         6SaFCA2e8duoeNTOmEIOfuDtOAOVSXNSseapUlX4+ZDXbb+rtWlKoZOLNWX4bKZWt7gG
         Cd/A==
X-Gm-Message-State: AOAM533t6Chx3ylnGM89UAsSvSIsdacXZyQJIah6fRexwSphD05BsCvN
        l1Jow6jYwsXYfwV/qckYJg==
X-Google-Smtp-Source: ABdhPJydefifTQ+SBOXFlomA+xHAsz+GKvhJi4GL1HPrhn/YwYfEAyRA97AWg+ueH5gW7I/kODvcIQ==
X-Received: by 2002:a05:6808:11c9:: with SMTP id p9mr26902301oiv.169.1636736528788;
        Fri, 12 Nov 2021 09:02:08 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g2sm1364024oic.35.2021.11.12.09.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 09:02:08 -0800 (PST)
Received: (nullmailer pid 3010964 invoked by uid 1000);
        Fri, 12 Nov 2021 17:02:07 -0000
Date:   Fri, 12 Nov 2021 11:02:07 -0600
From:   Rob Herring <robh@kernel.org>
To:     Zijun Hu <zijuhu@codeaurora.org>
Cc:     davem@davemloft.net, rjliao@codeaurora.org, kuba@kernel.org,
        bgodavar@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        devicetree@vger.kernel.org, Zijun Hu <quic_zijuhu@quicinc.com>
Subject: Re: [PATCH v1 2/3] dt-bindings: net: bluetooth: Add device tree
 bindings for QTI bluetooth MAPLE
Message-ID: <YY6eD/r3ddU7PUxJ@robh.at.kernel.org>
References: <1635837069-1293-1-git-send-email-zijuhu@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1635837069-1293-1-git-send-email-zijuhu@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 03:11:09PM +0800, Zijun Hu wrote:
> From: Zijun Hu <quic_zijuhu@quicinc.com>

Subject space is valuable, don't say things twice:

dt-bindings: net: bluetooth: Add Qualcomm MAPLE

Is MAPLE an SoC? Everything else used part numbers, why not here?

> 
> Add device tree bindings for QTI bluetooth MAPLE.
> 
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
> index f93c6e7a1b59..9f0508c4dd16 100644
> --- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
> +++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
> @@ -23,6 +23,7 @@ properties:
>        - qcom,wcn3998-bt
>        - qcom,qca6390-bt
>        - qcom,wcn6750-bt
> +      - qcom,maple-bt
>  
>    enable-gpios:
>      maxItems: 1
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
> 
> 
