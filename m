Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD88608070
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 23:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJUVAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 17:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJUVA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 17:00:29 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5569210B794;
        Fri, 21 Oct 2022 14:00:26 -0700 (PDT)
Received: by mail-oi1-f180.google.com with SMTP id u15so4614932oie.2;
        Fri, 21 Oct 2022 14:00:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ERb3pe6StZzna5ZtQJPnW7VI4odfFihYwdZmHNbXwgU=;
        b=s+PVe2cK+OS1guMVq2EqxzuHeuycfOvZeEtDcKL4uhLELdTLJrWP+YAJP//XVkSwU6
         4rS2ToQALV2GLkTbBCN66ZkSs048WTxNrzZfIkUoej/Gxl9sdu5KsH7TB1xDBgIfTVcN
         Mt2wXsrcsxE1opB0HmT4V5JS/zK8YNkX0FCtJSDRvw+GdsUPVNfq2gNHPi/0FbOY/aoX
         KBNFNWh+Zdp4/s8xMnimorqMcX7CMUN0mc5Xk5mlwRtG/3zQEZdrH6LySF9K5Dfam3FM
         ESQ3tCPTnwUekITe055LbrYDqsTUHatWR/jMlCF5NzV2Tjv1O5iCMslKcutYPwOGmU+L
         XTwA==
X-Gm-Message-State: ACrzQf3Y3teQDrzTf9F7Qnv4m2H6TAy4uwIvNY7n6DuqXRpQbdUzHvtY
        +M1ClugODa6LozJdatolyg==
X-Google-Smtp-Source: AMsMyM6XN8ugoSJwidUv7yRrhtQPQwwfy5a7UUCAQlFXGKyN6/phH0Kv14z497vMFEWBIZsWfDdO1g==
X-Received: by 2002:a54:4798:0:b0:355:d27:ca7a with SMTP id o24-20020a544798000000b003550d27ca7amr21174579oic.54.1666386025107;
        Fri, 21 Oct 2022 14:00:25 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x7-20020a056870e38700b0013297705e5dsm10533445oad.28.2022.10.21.14.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 14:00:24 -0700 (PDT)
Received: (nullmailer pid 314786 invoked by uid 1000);
        Fri, 21 Oct 2022 21:00:25 -0000
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     lorenzo.bianconi@redhat.com, devicetree@vger.kernel.org,
        nbd@nbd.name, sujuan.chen@mediatek.com, Mark-MC.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, daniel@makrotopia.org, kuba@kernel.org,
        sean.wang@mediatek.com, netdev@vger.kernel.org,
        Bo.Jiao@mediatek.com, ryder.Lee@mediatek.com,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        john@phrozen.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com
In-Reply-To: <7a454984f0001a71964114b71f353cb47af95ee6.1666368566.git.lorenzo@kernel.org>
References: <cover.1666368566.git.lorenzo@kernel.org> <7a454984f0001a71964114b71f353cb47af95ee6.1666368566.git.lorenzo@kernel.org>
Message-Id: <166638584121.307593.16292067214114795446.robh@kernel.org>
Subject: Re: [PATCH net-next 2/6] dt-bindings: net: mediatek: add WED RX binding for MT7986 eth driver
Date:   Fri, 21 Oct 2022 16:00:25 -0500
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 18:18:32 +0200, Lorenzo Bianconi wrote:
> Document the binding for the RX Wireless Ethernet Dispatch core on the
> MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> forwarded to LAN/WAN one.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 126 ++++++++++++++++++
>  .../arm/mediatek/mediatek,mt7986-wo-boot.yaml |  45 +++++++
>  .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml |  49 +++++++
>  .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  |  66 +++++++++
>  4 files changed, 286 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml: properties:mediatek,wocpu_boot:maxItems: False schema does not allow 1
	hint: Scalar properties should not have array keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml: properties:mediatek,wocpu_ilm:maxItems: False schema does not allow 1
	hint: Scalar properties should not have array keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml: properties:mediatek,ap2woccif:maxItems: False schema does not allow 1
	hint: Scalar properties should not have array keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml: properties:mediatek,wocpu_dlm:maxItems: False schema does not allow 1
	hint: Scalar properties should not have array keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml: properties:mediatek,wocpu_data:maxItems: False schema does not allow 1
	hint: Scalar properties should not have array keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml: properties:mediatek,wocpu_emi:maxItems: False schema does not allow 1
	hint: Scalar properties should not have array keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.example.dtb:0:0: /example-1/soc/syscon@15000000: failed to match any schema with compatible: ['mediatek,mt7986-ethsys', 'syscon']
Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.example.dtb:0:0: /example-1/soc/syscon@15000000/reset-controller: failed to match any schema with compatible: ['ti,syscon-reset']
Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.example.dtb:0:0: /example-1/soc/wocpu0_ilm@151e0000: failed to match any schema with compatible: ['mediatek,wocpu0_ilm']
Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.example.dtb:0:0: /example-0/soc/syscon@15000000: failed to match any schema with compatible: ['mediatek,mt7986-ethsys', 'syscon']
Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.example.dtb:0:0: /example-0/soc/syscon@15000000/reset-controller: failed to match any schema with compatible: ['ti,syscon-reset']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

