Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898F76E9478
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbjDTMdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbjDTMdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:33:14 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267831FD2;
        Thu, 20 Apr 2023 05:32:57 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6a5febde157so325814a34.3;
        Thu, 20 Apr 2023 05:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681993976; x=1684585976;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tMwSPKQCjaI+s6rgmrEgsLCZjsqIZCT4Ezs2S+deB98=;
        b=AVzFbTxfXT6m+ICvWBNmzeWRlDjEKmeRAFm2huww9Dz8bJXs2ZTNqcaxKTMHxGlTdY
         CSUW4d7hVwQs41pZGQKVqY/nS3GZiCryK7WhpIkOACBw93fCqxjeHYG2wasbMrgNxgJS
         +CBPkRQd6hq/eUEK+88/G+jv4gfsLsTkP45YoYzKtpK0awqCglfA+ubvtqCjAwQQhZn5
         0ESdpeAMl17MqKZkQ4aTG+wsACDd1qj/DLIQvII9vq8I3xpeBRWMWQME0LOEsApjOI/m
         iBb2+N0e7dckCYVUCEKpaO/7v9jUWVBSEGQO56td0IPxRwpAP7P6I7deGtWSSZcwy1iz
         BeZw==
X-Gm-Message-State: AAQBX9cKD4L9FLI1dnyMBDE5r7pU+/VQSBRGVW/A195oevZIOczGkiqM
        XXNPcur2iWhLj46GxsKrVQ==
X-Google-Smtp-Source: AKy350YSGHZoEpx8/m/b2yMMUz7U5VCKfW6SofU/pYibL7OdS2HPNJjWi1oKmkk22+MMy/jv5K3amw==
X-Received: by 2002:a9d:65d0:0:b0:69c:8354:c5de with SMTP id z16-20020a9d65d0000000b0069c8354c5demr652098oth.2.1681993976169;
        Thu, 20 Apr 2023 05:32:56 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z13-20020a9d62cd000000b006a2cc609ddasm681829otk.2.2023.04.20.05.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 05:32:55 -0700 (PDT)
Received: (nullmailer pid 2632250 invoked by uid 1000);
        Thu, 20 Apr 2023 12:32:54 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc:     linux-gpio@vger.kernel.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org, andersson@kernel.org,
        linux-arm-msm@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, agross@kernel.org, netdev@vger.kernel.org
In-Reply-To: <1681966915-15720-2-git-send-email-quic_rohiagar@quicinc.com>
References: <1681966915-15720-1-git-send-email-quic_rohiagar@quicinc.com>
 <1681966915-15720-2-git-send-email-quic_rohiagar@quicinc.com>
Message-Id: <168199391964.2630980.4927574228536419171.robh@kernel.org>
Subject: Re: [PATCH 1/2] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl
 devicetree compatible
Date:   Thu, 20 Apr 2023 07:32:54 -0500
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


On Thu, 20 Apr 2023 10:31:54 +0530, Rohit Agarwal wrote:
> Add device tree binding Documentation details for Qualcomm SDX75
> pinctrl driver.
> 
> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
> ---
>  .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          | 195 +++++++++++++++++++++
>  1 file changed, 195 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml:50:13: [error] empty value in block mapping (empty-values)
./Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml:84:52: [warning] too few spaces after comma (commas)

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml: 'patternPropetries' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
./Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml: Unable to find schema file matching $id: http://devicetree.org/schemas/bindings/pinctrl/qcom,sdx75-tlmm.yaml
./Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml: $id: relative path/filename doesn't match actual path or filename
	expected: http://devicetree.org/schemas/pinctrl/qcom,sdx75-tlmm.yaml#
Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.example.dts:32.13-36: ERROR (duplicate_property_names): /example-0/pinctrl@03000000:#interrupt-cells: Duplicate property name
ERROR: Input tree has errors, aborting (use -f to force output)
make[1]: *** [scripts/Makefile.lib:419: Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.example.dtb] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1512: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/1681966915-15720-2-git-send-email-quic_rohiagar@quicinc.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

