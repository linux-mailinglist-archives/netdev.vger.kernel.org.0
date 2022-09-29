Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53265EFFE6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 00:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiI2WIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 18:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiI2WIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 18:08:19 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B43DB654A;
        Thu, 29 Sep 2022 15:08:16 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id q10so3009666oib.5;
        Thu, 29 Sep 2022 15:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=6O8Jjng3iyin8rOht5eSYjzFn9Bme9u5OQK0LkD2pu8=;
        b=afFAa1bBvksKz6COSVbXYnb7pUt6qzXpToTUPMF8v+70SBL7B0fOZSCAcN0Ri/9Pj8
         0b4T2wbO8kHyxRsrF/qCn5bsIfysH7Ss+JWTWElT6gt/dTEusUfUOmTz7jbBzalyBLAT
         VnUMW99LW3ma0ESU5Ln6SDy4EXtIHEPiJACDD1vRY3PdcpBTv8aIZmoFEqB8dVTLkxBD
         KbNJypqpLIaG/t0Govcyj4gZFMx491dwdbZ8F1g6aqKWHI5EVF/SP0J1g8YBNrBL0rLz
         5nevo7tS8rZfnuGdhT57sfgabEdHBPWhlKnn4+M0jEPG9Rf+EOETMvr9Fs1Jp2x06PuW
         uzOw==
X-Gm-Message-State: ACrzQf3AZAmkEgQ/8SBkQDaeJRRLHWfYILLjhMffNjjL85yriAF8yXpu
        RlFUxFLzxPq6RX4QmClBy4E/Erjnmw==
X-Google-Smtp-Source: AMsMyM6BAUAzcU5iHjhtArwxDH4lLKHBTagWqW15z6CnS+PiBi2+/SsRCLz0KEtcFaae12p9OiVr+Q==
X-Received: by 2002:aca:1018:0:b0:34d:8f7a:27e1 with SMTP id 24-20020aca1018000000b0034d8f7a27e1mr8214159oiq.284.1664489295603;
        Thu, 29 Sep 2022 15:08:15 -0700 (PDT)
Received: from macbook.herring.priv (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id l13-20020a056870218d00b0010bf07976c9sm239823oae.41.2022.09.29.15.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:08:14 -0700 (PDT)
Received: (nullmailer pid 2832554 invoked by uid 1000);
        Thu, 29 Sep 2022 22:08:13 -0000
Date:   Thu, 29 Sep 2022 17:08:13 -0500
From:   Rob Herring <robh@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     Jose Abreu <joabreu@synopsys.com>, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] dt-bindings: net: snps,dwmac: Document stmmac-axi-config
 subnode
Message-ID: <166448929263.2832109.15881411107607706980.robh@kernel.org>
References: <20220927012449.698915-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927012449.698915-1-marex@denx.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 03:24:49 +0200, Marek Vasut wrote:
> The stmmac-axi-config subnode is present in multiple dwmac instance DTs,
> document its content per snps,axi-config property description which is
> a phandle to this subnode.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: devicetree@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: netdev@vger.kernel.org
> To: linux-arm-kernel@lists.infradead.org
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 54 +++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
