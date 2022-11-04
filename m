Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A4061A397
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 22:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiKDVvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 17:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKDVvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 17:51:45 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3194C27E;
        Fri,  4 Nov 2022 14:51:44 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-13ae8117023so6939695fac.9;
        Fri, 04 Nov 2022 14:51:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPm3fYpf8+soOo0ik2MiCLAEIDVsGz/gQA7QudomkhU=;
        b=P1bXBV2ZArxxOBt9iOeFXQoHxk0+vknI+sMlmJE81WtYEwZERVeYDdPx13+fJil/z7
         nW/y2lkj14LW0x8Oo0uUEXJJG/88eiZ3ND2IqptrQB+6WPIPglfMxNuhPqkdiPXdQc4f
         p6jjSO32SBdCxS4D/nL2lbZzRSqWJ80dH22x5fGGdf51ylTrmw6t0rRTNTokM3EOscjH
         /X3/IyWK/97OYEEW9LiLmHxDppYvKMbm+vdg0lQt9ILBceqpJlQWIsljICou7G8bYZxV
         lTnhUrnBbl3+tve2IL/gKmi/40ptbhNHd+Jq4nt+1SRJ6hZfgVPHSzcVxf0hFby+YRwh
         +Oeg==
X-Gm-Message-State: ACrzQf2yt1YuHI0eu0iYJODV0GGWoYdqQ8q4RBn3u/jy9aUk1efIpdBf
        E2Mr+Gkeo7HEYgNHtjLW8w==
X-Google-Smtp-Source: AMsMyM6q8K3CV2hmRdmQF4uARM5d4M9BjDS0fbsNu0HkSk3JP4EqSLzw1V3eqSmDsNL5fINc84rImQ==
X-Received: by 2002:a05:6870:4250:b0:13c:5a19:c451 with SMTP id v16-20020a056870425000b0013c5a19c451mr22702908oac.154.1667598703989;
        Fri, 04 Nov 2022 14:51:43 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d1-20020a9d5e01000000b0066c312b044dsm209464oti.27.2022.11.04.14.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 14:51:43 -0700 (PDT)
Received: (nullmailer pid 2890381 invoked by uid 1000);
        Fri, 04 Nov 2022 21:51:45 -0000
Date:   Fri, 4 Nov 2022 16:51:45 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: constrain number of 'reg' in
 ethernet ports
Message-ID: <166759870469.2890322.14150937576444600570.robh@kernel.org>
References: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102161512.53399-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 02 Nov 2022 12:15:11 -0400, Krzysztof Kozlowski wrote:
> 'reg' without any constraints allows multiple items which is not the
> intention for Ethernet controller's port number.
> 
> Constrain the 'reg' on AX88178 and LAN95xx USB Ethernet Controllers.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> ---
> 
> Changes since v2:
> 1. Drop changes to switches.
> 2. Add Rb tag.
> 
> Changes since v1:
> 1. Drop change to non-accepted renesas,r8a779f0-ether-switch.
> ---
>  Documentation/devicetree/bindings/net/asix,ax88178.yaml      | 4 +++-
>  Documentation/devicetree/bindings/net/microchip,lan95xx.yaml | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
