Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CA951B67B
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbiEEDYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241063AbiEEDXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:23:50 -0400
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A134A914;
        Wed,  4 May 2022 20:20:12 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-e93bbb54f9so3099057fac.12;
        Wed, 04 May 2022 20:20:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CrA17Qkb0CGAcxobetRuqhXdLCc6EA43fw6FG/p5S1E=;
        b=k1Czu6bDWIUyNBtpfEEId28O54y6GifY5gkSM27lFHHfhUGn5f931N+UZ1kJNk6jFD
         O8ChRqqkWEl77ZtTp/UsGUy5Y60O0Iih+Znn+haVHdSxMkaXKu+8+9CEGQYjBZXcNnkk
         gJO2XyL4fEKmo5l/eqBepc1GfRoIhlx4ZbpV2aHzklR5smK/eQWUMcUnBUv5kUy+bxiL
         dcrfMfrrtXHbDozop4xYvCmZxbQBmkoqZ/t6YmhkbK14jJe0IF5hGSaHOQqY3OTudMnq
         Z2eiXDVcNJdySx4wkhuh5KKZEq/qZw6smo3V67PGpJXLtQbEVSy/8aVJAYhLhBtosj0+
         lDQA==
X-Gm-Message-State: AOAM532UtBGKvbgvSHaSUCcF8qQf1p1kJn+KKrjai19ht1UhpScOkEDk
        4tGtBICwplsuHskk0Vmv5Q==
X-Google-Smtp-Source: ABdhPJzZQHh5WERFjAKOY3FAKRrPmpzqMKJk92HlEORtCPCzwuVwho6/SAe7wJIjVr2bBIKTX1VSCQ==
X-Received: by 2002:a05:6870:f146:b0:db:c90:99bb with SMTP id l6-20020a056870f14600b000db0c9099bbmr1270130oac.55.1651720811913;
        Wed, 04 May 2022 20:20:11 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id l9-20020a056870204900b000e90b37d2f5sm157137oad.24.2022.05.04.20.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 20:20:11 -0700 (PDT)
Received: (nullmailer pid 2748967 invoked by uid 1000);
        Thu, 05 May 2022 03:20:10 -0000
Date:   Wed, 4 May 2022 22:20:10 -0500
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Jakub Kicinski <kuba@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] dt-bindings: net: lan966x: fix example
Message-ID: <YnNCalSon6Z7x38+@robh.at.kernel.org>
References: <20220503132038.2714128-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503132038.2714128-1-michael@walle.cc>
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

On Tue, 03 May 2022 15:20:38 +0200, Michael Walle wrote:
> In commit 4fdabd509df3 ("dt-bindings: net: lan966x: remove PHY reset")
> the PHY reset was removed, but I failed to remove it from the example.
> Fix it.
> 
> Fixes: 4fdabd509df3 ("dt-bindings: net: lan966x: remove PHY reset")
> Reported-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  .../devicetree/bindings/net/microchip,lan966x-switch.yaml     | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
