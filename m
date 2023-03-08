Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9016B149C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 22:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjCHV5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 16:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCHV5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 16:57:15 -0500
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66536D4612;
        Wed,  8 Mar 2023 13:57:12 -0800 (PST)
Received: by mail-oi1-f177.google.com with SMTP id bi17so206562oib.3;
        Wed, 08 Mar 2023 13:57:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678312631;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YAS1xYRXj3cdPKcvjDZ+t7RtqFJmt8ftiUP9NIi5BhI=;
        b=P1HTNeHRUBXI1ZVgptGhOCNrE5ICnLbKPDvi9SrOPBXkgMgbofmmOWvVwW2wWJtwq/
         XPw770xZ//6IFtwwZgUAiF2aaS6+iJP0P7nErzZny4bjZIKDWaiLF/7paJusUnySX+i3
         GBBN6GupsC2h4KqxEtqtU970YqvMX3H3cikZyuTtWjQEn/pQk+LismnDHH7o0rgj7JT/
         1nsJU24Pr3NfCYo5nAALE0c5SNYEJjBSfyDis8qVCzhnbZRmDsdQD+ogqR9+XM41IptB
         kVR6psewl7yJiGxcb41Dk063dTYtVmBTDCehI7MojL9jdyO2rKQwMKDVYHtgbmdQ+iIg
         Ldpw==
X-Gm-Message-State: AO0yUKVuPxLZm4uOJpTEwmrwOd08URfc9B5X2+lC6z4QayUBsvqgx85w
        zL9B6vY1d+jBWLPry9Uvzg==
X-Google-Smtp-Source: AK7set/wO6Hud4S7hIzFW35ljRId+eCmpPInzcvs2Ch8cPaIh2UOWciajGcHOgTRjHsb09N5i4I6pQ==
X-Received: by 2002:aca:1c03:0:b0:378:3a54:4418 with SMTP id c3-20020aca1c03000000b003783a544418mr7812947oic.49.1678312631513;
        Wed, 08 Mar 2023 13:57:11 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y64-20020aca3243000000b00383eaea5e88sm6820737oiy.38.2023.03.08.13.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 13:57:10 -0800 (PST)
Received: (nullmailer pid 3911485 invoked by uid 1000);
        Wed, 08 Mar 2023 21:57:09 -0000
Date:   Wed, 8 Mar 2023 15:57:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Samin Guo <samin.guo@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v5 03/12] dt-bindings: net: snps,dwmac: Add an optional
 resets single 'ahb'
Message-ID: <20230308215709.GA3904341-robh@kernel.org>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-4-samin.guo@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303085928.4535-4-samin.guo@starfivetech.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 04:59:19PM +0800, Samin Guo wrote:
> According to:
> stmmac_platform.c: stmmac_probe_config_dt
> stmmac_main.c: stmmac_dvr_probe

That's not really a reason on its own. Maybe the driver is wrong. Do we 
know what hardware needs this?

> dwmac controller may require one (stmmaceth) or two (stmmaceth+ahb)
> reset signals, and the maxItems of resets/reset-names is going to be 2.
> 
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml        | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index b4135d5297b4..89099a888f0b 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -133,12 +133,18 @@ properties:
>          - ptp_ref
>  
>    resets:
> -    maxItems: 1
> -    description:
> -      MAC Reset signal.
> +    minItems: 1
> +    items:
> +      - description: GMAC stmmaceth reset
> +      - description: AHB reset
>  
>    reset-names:
> -    const: stmmaceth
> +    minItems: 1
> +    maxItems: 2
> +    contains:

This means 'reset-names = "foo", "ahb";' is valid. You want 'items' 
instead. However, that still allows the below string in any order. Do we 
really need that? If not, then you want:

items:
  - const: stmmaceth
  - const: ahb

> +      enum:
> +        - stmmaceth
> +        - ahb
>  
>    power-domains:
>      maxItems: 1
> -- 
> 2.17.1
> 
