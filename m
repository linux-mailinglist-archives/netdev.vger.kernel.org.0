Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898FB6F0A79
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244227AbjD0RD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243917AbjD0RD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:03:57 -0400
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A7C1FF2;
        Thu, 27 Apr 2023 10:03:56 -0700 (PDT)
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6a5f9c1200eso3427429a34.1;
        Thu, 27 Apr 2023 10:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682615036; x=1685207036;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wC46zsAOw/V5ESWPegZro4CMY5VowLiZF8XH9gcabPY=;
        b=C6NSaQcFRiGDqUw649yFc8ryoiYzWAtDLHuGrMHLCiKgNLEhYpmpxhi2789xeGyu6V
         F15ykKcWLpQe2GGNE7MK8QDNyPu9c0a2aZ1nBk19aT3k+lXrzxWmgaJmaMOiiO+pOMLo
         22YFgM3YkF2W2bqKkJaankQqs4PACWisOY1eI/h8Gitl54WdBBkJMsU6rF/L6PbYoxRv
         2/uwvvP76bwpVtDcI5T+4jY7aD3izUsQHppS9TRpGwXC4YZ7GhlYuGYQNgil0MG6p7S6
         eoAADRqYCJ9mFlmngCRavz6ioAh/t9n3IYV0DFAXc0E0iJUR5JC8IDOwMzUzmKVGRLLv
         TEnw==
X-Gm-Message-State: AC+VfDzH0BS0P+OKML1XkUMrNw12rLJF7LhlEqdrSsvUZQsSZMnog/Ra
        OqzC6O9cGxv+5HueuP2O1A==
X-Google-Smtp-Source: ACHHUZ5RUnCi8AoKLltmFAY7/AL0bgmWCcoCXJSj7xdDUJSp8Fc/76bbUfA6n5sACT4lLkIB91rAcg==
X-Received: by 2002:a05:6830:1d62:b0:6a5:dd6c:1daa with SMTP id l2-20020a0568301d6200b006a5dd6c1daamr1015264oti.22.1682615035560;
        Thu, 27 Apr 2023 10:03:55 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d17-20020a056830045100b006a63283a9e5sm7205176otc.75.2023.04.27.10.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 10:03:54 -0700 (PDT)
Received: (nullmailer pid 3172049 invoked by uid 1000);
        Thu, 27 Apr 2023 17:03:54 -0000
Date:   Thu, 27 Apr 2023 12:03:54 -0500
From:   Rob Herring <robh@kernel.org>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: Re: [PATCH v2 net-next 1/6] dt-bindings: net: brcm,unimac-mdio: Add
 asp-v2.0
Message-ID: <20230427170354.GA3163369-robh@kernel.org>
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
 <1682535272-32249-2-git-send-email-justinpopo6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682535272-32249-2-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 11:54:27AM -0700, Justin Chen wrote:
> The ASP 2.0 Ethernet controller uses a brcm unimac.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> index 0be426ee1e44..6684810fcbf0 100644
> --- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> @@ -22,6 +22,8 @@ properties:
>        - brcm,genet-mdio-v3
>        - brcm,genet-mdio-v4
>        - brcm,genet-mdio-v5
> +      - brcm,asp-v2.0-mdio
> +      - brcm,asp-v2.1-mdio

How many SoCs does each of these correspond to? SoC specific compatibles 
are preferred to version numbers (because few vendors are disciplined 
at versioning and also not changing versions with every Soc). 

>        - brcm,unimac-mdio
>  
>    reg:
> -- 
> 2.7.4
> 
