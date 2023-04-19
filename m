Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4ED6E7991
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbjDSMUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbjDSMU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:20:26 -0400
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E526A66;
        Wed, 19 Apr 2023 05:20:24 -0700 (PDT)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-1878f1ebf46so865897fac.1;
        Wed, 19 Apr 2023 05:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681906824; x=1684498824;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vDWn7LWX55rdAgK8lkZTjI/cl/gmcQIjVsQZmuaFPok=;
        b=S4OebHC6bPZWBCttDxrOlO33hLtezQgy1kZr5K65sj8zuJu/c85gJ53084t19Y5/r4
         Bh5x6ly3VyTl8CnZhOaW+kc1+tfvmjmrwKYhwq7T6EutbagKz90GDREXK2uOJJCtUNSh
         mvwtK5TmtZZBCHCQAt+cbapxWSRiOINqgPF0zUG7Wbu0UBUkfw1DcfrgxRMifMn/tJgz
         6tZXrjSxmul3ilK06n1SQGhv44NrlbMlcZgRE2TFhJyYIvZ7pplZl5QBrRZVyw0/m9V3
         ZZ9sPOq7LoWgLryii/Yxx+PXZFQZ9oOzAjdrKXH1Zs+eJLTY+2483fiitEGdDWusfJHg
         sXsg==
X-Gm-Message-State: AAQBX9cg75J4xmV5erjPb8OPUdJTTCICEkIvAsLZXHbF/QKH2rEbheNh
        aUz+ezwuQm1uKMID3d4qiw==
X-Google-Smtp-Source: AKy350achMGLsukLbt5lzLwN1OM7sY4Y18eDzdY5EhXFZgcfFGxbh3Xvp0buod3QAyAniCdmJL8Ycg==
X-Received: by 2002:a05:6870:f295:b0:17f:e768:60fb with SMTP id u21-20020a056870f29500b0017fe76860fbmr3024069oap.54.1681906823992;
        Wed, 19 Apr 2023 05:20:23 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 64-20020a4a0143000000b00529cc3986c8sm6920510oor.40.2023.04.19.05.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 05:20:23 -0700 (PDT)
Received: (nullmailer pid 3779626 invoked by uid 1000);
        Wed, 19 Apr 2023 12:20:22 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Justin Chen <justinpopo6@gmail.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        dri-devel@lists.freedesktop.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, opendmb@gmail.com,
        linaro-mm-sig@lists.linaro.org, pabeni@redhat.com,
        edumazet@google.com, robh+dt@kernel.org, sumit.semwal@linaro.org,
        christian.koenig@amd.com, andrew@lunn.ch, richardcochran@gmail.com,
        kuba@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        justin.chen@broadcom.com
In-Reply-To: <1681863018-28006-2-git-send-email-justinpopo6@gmail.com>
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
 <1681863018-28006-2-git-send-email-justinpopo6@gmail.com>
Message-Id: <168190678873.3778743.3635324500677416742.robh@kernel.org>
Subject: Re: [PATCH net-next 1/6] dt-bindings: net: Brcm ASP 2.0 Ethernet
 controller
Date:   Wed, 19 Apr 2023 07:20:22 -0500
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 18 Apr 2023 17:10:13 -0700, Justin Chen wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> Add a binding document for the Broadcom ASP 2.0 Ethernet
> controller.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 146 +++++++++++++++++++++
>  1 file changed, 146 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dtb: asp@9c00000: mdio@c614:compatible:0: 'brcm,asp-v2.0-mdio' is not one of ['brcm,genet-mdio-v1', 'brcm,genet-mdio-v2', 'brcm,genet-mdio-v3', 'brcm,genet-mdio-v4', 'brcm,genet-mdio-v5', 'brcm,unimac-mdio']
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dtb: asp@9c00000: mdio@c614: Unevaluated properties are not allowed ('compatible' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dtb: asp@9c00000: mdio@ce14:compatible:0: 'brcm,asp-v2.0-mdio' is not one of ['brcm,genet-mdio-v1', 'brcm,genet-mdio-v2', 'brcm,genet-mdio-v3', 'brcm,genet-mdio-v4', 'brcm,genet-mdio-v5', 'brcm,unimac-mdio']
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dtb: asp@9c00000: mdio@ce14: Unevaluated properties are not allowed ('compatible' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dtb: /example-0/asp@9c00000/mdio@c614: failed to match any schema with compatible: ['brcm,asp-v2.0-mdio']
Documentation/devicetree/bindings/net/brcm,asp-v2.0.example.dtb: /example-0/asp@9c00000/mdio@ce14: failed to match any schema with compatible: ['brcm,asp-v2.0-mdio']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/1681863018-28006-2-git-send-email-justinpopo6@gmail.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

