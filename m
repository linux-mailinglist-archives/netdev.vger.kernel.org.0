Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4AD602D07
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 15:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiJRNcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 09:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiJRNcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 09:32:05 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2D5CA8A3;
        Tue, 18 Oct 2022 06:32:04 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-132fb4fd495so16762930fac.12;
        Tue, 18 Oct 2022 06:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9LPS7Ui1ifKCQGZJtIESYlvh40jFVqHRbTJAbgwh0jA=;
        b=oT4dfEBswTP2TPhphK9xVWeBuXWJb9hnTvsIStXNfjTXMvxku2ixkyP9gPqrK9pVES
         sdGrqzcbs/0BYeFcFMhv69AhhQzFgOCp7DAuNwCVGlHVt8x86pzsaMsTkn42A0cQK1zR
         pq7LnUtQc7wvsRuZdTc97luKl26NJS0nvGekdkYi8LS9enOgl54AwDHDdu7UAr9xKCD6
         E7blLbI4yW8n5uL3KMH9iLmyAnrRJGGZP59hK0DWcdo3jaNcpXhGD05cSNr0BCC0KdOz
         geqyjauVMbzz/vRAsvhleRDD0DpAhJqKlbwfEQeFySC/Od/ATW4Q3xzsHaqWVkHedOEy
         RoSw==
X-Gm-Message-State: ACrzQf21fO3u09KUYIFmOIXV3UJEFrFI/iSNLVYK4AhCUf6TxDUeCzaE
        EHc36OkhytEWl/WgEaYv1Q==
X-Google-Smtp-Source: AMsMyM5Z+V662wMKC+ZWGOfybHUQM4CBjcqbEfQ060Ke1a/Yt2qr9c2zZMlcyonm0B9BZHC4O0QcAg==
X-Received: by 2002:a05:6870:c214:b0:131:c125:bcb2 with SMTP id z20-20020a056870c21400b00131c125bcb2mr18579957oae.292.1666099923460;
        Tue, 18 Oct 2022 06:32:03 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q1-20020a9d6301000000b006618f8e44e5sm5804446otk.57.2022.10.18.06.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 06:32:03 -0700 (PDT)
Received: (nullmailer pid 180829 invoked by uid 1000);
        Tue, 18 Oct 2022 13:32:01 -0000
From:   Rob Herring <robh@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vigneshr@ti.com, nsekhar@ti.com,
        pabeni@redhat.com, linux@armlinux.org.uk, vladimir.oltean@nxp.com,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski@linaro.org
In-Reply-To: <20221018085810.151327-2-s-vadapalli@ti.com>
References: <20221018085810.151327-1-s-vadapalli@ti.com> <20221018085810.151327-2-s-vadapalli@ti.com>
Message-Id: <166609952162.171762.3639347443256680406.robh@kernel.org>
Subject: Re: [PATCH v2 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J721e CPSW9G
Date:   Tue, 18 Oct 2022 08:32:01 -0500
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

On Tue, 18 Oct 2022 14:28:08 +0530, Siddharth Vadapalli wrote:
> Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
> ports) CPSW9G module and add compatible for it.
> 
> Changes made:
>     - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
>     - Extend pattern properties for new compatible.
>     - Change maximum number of CPSW ports to 8 for new compatible.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 23 +++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml:196:25: [error] syntax error: mapping values are not allowed here (syntax)

dtschema/dtc warnings/errors:
make[1]: *** Deleting file 'Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dts'
Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml:196:25: mapping values are not allowed in this context
make[1]: *** [Documentation/devicetree/bindings/Makefile:26: Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.example.dts] Error 1
make[1]: *** Waiting for unfinished jobs....
./Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml:196:25: mapping values are not allowed in this context
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml: ignoring, error parsing file
make: *** [Makefile:1492: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

