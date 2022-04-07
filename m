Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2CC4F80F9
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343693AbiDGNwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 09:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240547AbiDGNwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 09:52:33 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C51E1252;
        Thu,  7 Apr 2022 06:50:29 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-de3eda6b5dso6454650fac.0;
        Thu, 07 Apr 2022 06:50:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=6uOQ/kJvojqDkdfw1uMvPqM/fa5BMaYlPRD4ijDOV5Q=;
        b=STINaCYMGKVRvMkZc1Zqrk2U96dEwHC4ZSvdfmhMvRDUZAwZD70aFhIhKfI9kt3H2H
         3qVbr019iEJ72Fqp0UNhHrkBpkZlVNAGNX0zsr9cq/60GZ3EBLvDCCVdmTO9FZ9o+Py5
         15arxxUnCojonvBFleWfLMdOUZ8icdPpZLQF4LOJ6UAz2jUFDnl5GKNClTZ1aqCmxKEj
         ihuTZ9JiWVgu+gIjZxuRVk7htk9yhOF4E70wpRRc+wRACjj0GM0VQ8kUiZpzpW3+l+oN
         iNxo2L9i2lcNmriruBOT+qN/wb0sJZeZGZjsunY5zPvfWjIBPwDGa8dEW5A85YqVoN3J
         6e2Q==
X-Gm-Message-State: AOAM530aJlfkdbWyhi8axsEs597Ul7qodaGQe642ObU5rk5Do9IDoEvR
        8cNiq5EjepmvMwiywvtFdg==
X-Google-Smtp-Source: ABdhPJzHJQX/bwlqRnnc+CjMF09UNJp4+1PjBmsF22ov5JbijXywUe3we+ROhb9qm7aAFuR1xRv5Vw==
X-Received: by 2002:a05:6870:a106:b0:de:de08:4e3d with SMTP id m6-20020a056870a10600b000dede084e3dmr6559409oae.256.1649339429093;
        Thu, 07 Apr 2022 06:50:29 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k22-20020a056870959600b000d277c48d18sm8454241oao.3.2022.04.07.06.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 06:50:28 -0700 (PDT)
Received: (nullmailer pid 795405 invoked by uid 1000);
        Thu, 07 Apr 2022 13:50:27 -0000
From:   Rob Herring <robh@kernel.org>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     kishon@ti.com, nm@ti.com, linux-kernel@vger.kernel.org,
        kuba@kernel.org, s-anna@ti.com, vigneshr@ti.com,
        bjorn.andersson@linaro.org, linux-remoteproc@vger.kernel.org,
        ssantosh@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        mathieu.poirier@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
In-Reply-To: <20220406094358.7895-2-p-mohan@ti.com>
References: <20220406094358.7895-1-p-mohan@ti.com> <20220406094358.7895-2-p-mohan@ti.com>
Subject: Re: [RFC 01/13] dt-bindings: remoteproc: Add PRU consumer bindings
Date:   Thu, 07 Apr 2022 08:50:27 -0500
Message-Id: <1649339427.644388.795404.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 06 Apr 2022 15:13:46 +0530, Puranjay Mohan wrote:
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

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml:39:9: [warning] wrong indentation: expected 6 but found 8 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

