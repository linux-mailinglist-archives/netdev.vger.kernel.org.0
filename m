Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AF958047D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiGYTeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiGYTeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:34:00 -0400
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CDA1FCD3;
        Mon, 25 Jul 2022 12:33:59 -0700 (PDT)
Received: by mail-oo1-f51.google.com with SMTP id j8-20020a4ac548000000b00435a8dd31a2so2348210ooq.5;
        Mon, 25 Jul 2022 12:33:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KIw937KfRgtYEPX35WUaBoez2BdnKkRvpNFrhrEEgaE=;
        b=dD9MtLsulX2LksDLMQXrlNUHP7yLsa1OZH126qGyyVnR8DBpZX0PpSeRFtv/RLtfrG
         CnnyktGByUfD02WnXVSLMbXsDioPP6p06DDsdf9a8lpM2Hpol935iHw1PUh+gfH4UyOM
         qb5eEg5bIks0lakJvpg+emYsY4HlBJ+3NNdNqtzwbm89OmkFZM6dZ/Ye+jLhAwTybApK
         HNdAsOGa9Med45ssbbKx7kBItIDK0/i64Y7TXkoI5Kam8emFmtkrT9N5hplMi3ORVfcm
         TPXaBmR21I4ALj5zvdFawTkO69bhSxNtTyDlIoR3WDOc7YzsoxM71tI/5lBARm9zT/t1
         owIg==
X-Gm-Message-State: AJIora8viUvccAQkAupiFMUrYq0zAVPdCuYP/f6fke4t5dJPrjdqKfGl
        DVDeW4POdBe4jQnRt7z1QA==
X-Google-Smtp-Source: AGRyM1uTtx/J+WMQ8qtwru58sRJQF2353um12dhZAF81rpKXXTgUH9cVEJf0C4kEVleDBRmC7HIkdA==
X-Received: by 2002:a4a:d621:0:b0:435:d6cc:b2e1 with SMTP id n1-20020a4ad621000000b00435d6ccb2e1mr4704597oon.88.1658777638776;
        Mon, 25 Jul 2022 12:33:58 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id y3-20020a544d83000000b0032f7605d1a3sm5208627oix.31.2022.07.25.12.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 12:33:58 -0700 (PDT)
Received: (nullmailer pid 2565486 invoked by uid 1000);
        Mon, 25 Jul 2022 19:33:56 -0000
Date:   Mon, 25 Jul 2022 13:33:56 -0600
From:   Rob Herring <robh@kernel.org>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@amd.com, devicetree@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
Subject: Re: [PATCH v2 1/3] dt-bindings: net: cdns,macb: Add versal
 compatible string
Message-ID: <20220725193356.GA2561062-robh@kernel.org>
References: <20220722110330.13257-1-harini.katakam@xilinx.com>
 <20220722110330.13257-2-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722110330.13257-2-harini.katakam@xilinx.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 04:33:28PM +0530, Harini Katakam wrote:
> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> 
> Add versal compatible string.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> ---
> v2:
> Sort compatible string alphabetically.
> 
>  Documentation/devicetree/bindings/net/cdns,macb.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> index 9c92156869b2..762deccd3640 100644
> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> @@ -20,6 +20,7 @@ properties:
>  
>        - items:
>            - enum:
> +              - cdns,versal-gem       # Xilinx Versal
>                - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
>                - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC

Uh, how did we start this pattern? The vendor here is Xilinx, not 
Cadence. It should be xlnx,versal-gem instead.

>            - const: cdns,gem           # Generic
> -- 
> 2.17.1
> 
> 
