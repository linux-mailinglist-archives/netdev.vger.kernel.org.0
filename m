Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC360671E3F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjARNmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjARNlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:41:55 -0500
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C86E4FC23;
        Wed, 18 Jan 2023 05:10:55 -0800 (PST)
Received: by mail-oo1-f50.google.com with SMTP id c145-20020a4a4f97000000b004f505540a20so2038170oob.1;
        Wed, 18 Jan 2023 05:10:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LPXKE4fWh08xIviaGRGhwlFYvgu/9wGipKwIrtn3ERY=;
        b=uNf3VSqr6i/H/SFMqfg1Ekznu9B/ttX4LFx53AFBpqLvuRaridi0WoisuONJP0DI4E
         CIUhqtFUp6R+RNR6VJCP8NDjg58H+rdOZfJQPC9vlvebCB5sesyodyWm5o7J4kRB5bK8
         FlsSCHDREO7eqRMtYablV+9VSpswViPdcjzTMAgR4V1HQqx6niJC4wDya5utoSGmmvo4
         ILwmFU9G0Nd6K4msTzxf4NuVrhbFU1q7FMNfjrtzhhBLOZ6rYjhIjMt9gIBAoNRA1vgA
         4Oj30UkrEwUsrvnmgJ/JG07esO4aKfD5QG96d5/qSqV9XAma9ViK0ss8eCBFM5Y6EsBW
         idIA==
X-Gm-Message-State: AFqh2kroRSLQMRqx6qoc8sJdRuewxx8spJfWYtUx8DLS0N1iPOaTQE2y
        CYNd4YbzeWbrER5Xu3vlKQ==
X-Google-Smtp-Source: AMrXdXuaVkiDYUFtNuNfPCSPfjF3RtDj8mtkMncMjSfU5aOhhpiJCxGNF68RjD5jl+wYaaUCe+TGSw==
X-Received: by 2002:a4a:1ac4:0:b0:4f2:21f7:cd93 with SMTP id 187-20020a4a1ac4000000b004f221f7cd93mr3356508oof.0.1674047449990;
        Wed, 18 Jan 2023 05:10:49 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s23-20020a4ae557000000b0049f5ce88583sm16470775oot.7.2023.01.18.05.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 05:10:48 -0800 (PST)
Received: (nullmailer pid 1459876 invoked by uid 1000);
        Wed, 18 Jan 2023 13:10:47 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        Peter Geis <pgwipeout@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <20230118061701.30047-3-yanhong.wang@starfivetech.com>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <20230118061701.30047-3-yanhong.wang@starfivetech.com>
Message-Id: <167404705359.1390391.205840489556921087.robh@kernel.org>
Subject: Re: [PATCH v4 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
Date:   Wed, 18 Jan 2023 07:10:47 -0600
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


On Wed, 18 Jan 2023 14:16:56 +0800, Yanhong Wang wrote:
> Some boards(such as StarFive VisionFive v2) require more than one value
> which defined by resets property, so the original definition can not
> meet the requirements. In order to adapt to different requirements,
> adjust the maxitems number definition.
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.example.dtb: ethernet@1c0b000: Unevaluated properties are not allowed ('reset-names' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.example.dtb: ethernet@1c0b000: Unevaluated properties are not allowed ('reset-names' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.example.dtb: ethernet@1c0b000: Unevaluated properties are not allowed ('reset-names' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230118061701.30047-3-yanhong.wang@starfivetech.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

