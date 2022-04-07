Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C9B4F828B
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344490AbiDGPL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiDGPLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:11:55 -0400
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DB82BB18;
        Thu,  7 Apr 2022 08:09:55 -0700 (PDT)
Received: by mail-ot1-f46.google.com with SMTP id 88-20020a9d0ee1000000b005d0ae4e126fso4087110otj.5;
        Thu, 07 Apr 2022 08:09:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mvsoNOk9u8RV2yVCZLMb/29uYaw0/4/Qw5+UfuDkMks=;
        b=ec2YPQw+MOwqh33IbQ6jfO5ewzH9X6jl14iOKTglcII8F3l0PuXw++gXCgaNN8FfKO
         lDBEr6GwssmRWJV9YxgwvieXOwyKSLhXUIVtWMiSFcNg/k2HQWAIhHIadKjQb9U3MzmK
         kyLa3oMqSmEGXay2bgXNHr6nKHHQcB85MICWNJw7EkbXrQQQyIZIQYkDXa7rd8QCnUTX
         ZliN5vGinAHWQxxalsIviBrhwSemnl5svIbNimC+7i0/HWKTrb7CU2/Ppwr4wv0HrKEn
         93ZsAIm5vkQ+j9fOm4WSfKInzy2MaGpMhKM18Se0190HbtItgpfoHGuazFvjmaETYVZf
         q4xA==
X-Gm-Message-State: AOAM532R/aQn279nKLoaTcasdUgIglW1MG489F1/pr0Q1Hahr1FdjChC
        ncrtggWy/Edw51/YzIDI8/6P8aZTXw==
X-Google-Smtp-Source: ABdhPJzdNp+SArorak1XGGcOGrCQUd+SwHej8ANssNSIJv2Vtew9hsSojZk7jiFJDg5SzFN4KY51PA==
X-Received: by 2002:a9d:136:0:b0:5cd:9e9b:4872 with SMTP id 51-20020a9d0136000000b005cd9e9b4872mr5150803otu.192.1649344194343;
        Thu, 07 Apr 2022 08:09:54 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q39-20020a4a88ea000000b0032165eb3af8sm7531169ooh.42.2022.04.07.08.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 08:09:54 -0700 (PDT)
Received: (nullmailer pid 1105330 invoked by uid 1000);
        Thu, 07 Apr 2022 15:09:53 -0000
Date:   Thu, 7 Apr 2022 10:09:53 -0500
From:   Rob Herring <robh@kernel.org>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        mathieu.poirier@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        nm@ti.com, ssantosh@kernel.org, s-anna@ti.com,
        linux-arm-kernel@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, vigneshr@ti.com,
        kishon@ti.com
Subject: Re: [RFC 01/13] dt-bindings: remoteproc: Add PRU consumer bindings
Message-ID: <Yk7+wXwDHrtjFo9s@robh.at.kernel.org>
References: <20220406094358.7895-1-p-mohan@ti.com>
 <20220406094358.7895-2-p-mohan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406094358.7895-2-p-mohan@ti.com>
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

On Wed, Apr 06, 2022 at 03:13:46PM +0530, Puranjay Mohan wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> Add a YAML binding document for PRU consumers. The binding includes
> all the common properties that can be used by different PRU consumer
> or application nodes and supported by the PRU remoteproc driver.
> These are used to configure the PRU hardware for specific user
> applications.
> 
> The application nodes themselves should define their own bindings.
> 
> Co-developed-by: Tero Kristo <t-kristo@ti.com>
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
>  .../bindings/remoteproc/ti,pru-consumer.yaml  | 66 +++++++++++++++++++
>  1 file changed, 66 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml
> 
> diff --git a/Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml b/Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml
> new file mode 100644
> index 000000000000..c245fe1de656
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml
> @@ -0,0 +1,66 @@
> +# SPDX-License-Identifier: (GPL-2.0-only or BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/remoteproc/ti,pru-consumer.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Common TI PRU Consumer Binding
> +
> +maintainers:
> +  - Suman Anna <s-anna@ti.com>
> +
> +description: |
> +  A PRU application/consumer/user node typically uses one or more PRU device
> +  nodes to implement a PRU application/functionality. Each application/client
> +  node would need a reference to at least a PRU node, and optionally define
> +  some properties needed for hardware/firmware configuration. The below
> +  properties are a list of common properties supported by the PRU remoteproc
> +  infrastructure.
> +
> +  The application nodes shall define their own bindings like regular platform
> +  devices, so below are in addition to each node's bindings.
> +
> +properties:
> +  ti,prus:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array

Needs contraints. A phandle-array is really a matrix of phandles and 
args. If no args, something like this:

minItems: ??
maxItems: ??
items:
  maxItems: 1

> +    description: phandles to the PRU, RTU or Tx_PRU nodes used
> +
> +  firmware-name:
> +    $ref: /schemas/types.yaml#/definitions/string-array
> +    description: |
> +      firmwares for the PRU cores, the default firmware for the core from
> +      the PRU node will be used if not provided. The firmware names should
> +      correspond to the PRU cores listed in the 'ti,prus' property
> +
> +  ti,pruss-gp-mux-sel:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    maxItems: 6
> +    items:
> +        enum: [0, 1, 2, 3, 4]
> +    description: |
> +      array of values for the GP_MUX_SEL under PRUSS_GPCFG register for a PRU.
> +      This selects the internal muxing scheme for the PRU instance. Values
> +      should correspond to the PRU cores listed in the 'ti,prus' property. The
> +      GP_MUX_SEL setting is a per-slice setting (one setting for PRU0, RTU0,
> +      and Tx_PRU0 on K3 SoCs). Use the same value for all cores within the
> +      same slice in the associative array. If the array size is smaller than
> +      the size of 'ti,prus' property, the default out-of-reset value (0) for the
> +      PRU core is used.
> +
> +required:
> +  - ti,prus
> +
> +dependencies:
> +  firmware-name: [ 'ti,prus' ]
> +  ti,pruss-gp-mux-sel: [ 'ti,prus' ]
> +
> +additionalProperties: true

This must be false unless it is a common, shared schema.

> +
> +examples:
> +  - |
> +    /* PRU application node example */
> +    pru-app {
> +        ti,prus = <&pru0>, <&pru1>;
> +        firmware-name = "pruss-app-fw0", "pruss-app-fw1";
> +        ti,pruss-gp-mux-sel = <2>, <1>;
> +    };
> -- 
> 2.17.1
> 
> 
