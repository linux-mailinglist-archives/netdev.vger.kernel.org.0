Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13154692058
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbjBJN6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjBJN6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:58:36 -0500
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B746A707;
        Fri, 10 Feb 2023 05:58:35 -0800 (PST)
Received: by mail-ot1-f51.google.com with SMTP id d21-20020a056830005500b0068bd2e0b25bso1546283otp.1;
        Fri, 10 Feb 2023 05:58:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x6ZAgwWF/VUwU4zZqfR/sTQryZXeoKEBbQY/zLmHl1c=;
        b=J7q260AXfsiNVcxf6cHUnICf+I1gCec4u3prLL0oBJ91f+QfD/raQjnsq5xulMEjVM
         ctzc4LZibTDfPU9rUiqc1EHkRG0G/uZHW2lUzpMF7YqSLX/64KGidgSD1am1xNGSd+N7
         8kuN9597fMOVmap7HhMkH8McT+tD7+K48sXDaqMXzK74UNP91fRpSt2tIv+GYvu7Kr06
         JoJISrluuqT8JvBHN/PQfKEOhoKz43qdn2TtBZvAY664uo4Z7p0cH88d1aIpJ+TVM0xy
         DB+4Awb7Vb2pwkUZYk6/qTdORSvE1FLjbRV0dyBtqD5slNUtbn0n7fxl9e0AC7s429a/
         T5cQ==
X-Gm-Message-State: AO0yUKVmT+iNK374V1nLwHfdH93rjORc1xxULBKzuG/RkCm3W8bhvW7A
        eMLkeu4oTqUyzH+crRTSNQ==
X-Google-Smtp-Source: AK7set+u6KQcX0GiHN1DnJNApQ90AmwZcuRPf7A4yG3G1e8Xrs7q6Pbo37r993MC4QCznDKyzDJ61A==
X-Received: by 2002:a9d:1b6e:0:b0:68b:d220:b280 with SMTP id l101-20020a9d1b6e000000b0068bd220b280mr9873155otl.27.1676037514571;
        Fri, 10 Feb 2023 05:58:34 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j11-20020a9d738b000000b00684cbd8dd49sm1962404otk.79.2023.02.10.05.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 05:58:34 -0800 (PST)
Received: (nullmailer pid 2493637 invoked by uid 1000);
        Fri, 10 Feb 2023 13:58:31 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Paolo Abeni <pabeni@redhat.com>,
        srk@ti.com, andrew@lunn.ch, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, ssantosh@kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        nm@ti.com, "David S. Miller" <davem@davemloft.net>,
        Vignesh Raghavendra <vigneshr@ti.com>, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Suman Anna <s-anna@ti.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230210114957.2667963-2-danishanwar@ti.com>
References: <20230210114957.2667963-1-danishanwar@ti.com>
 <20230210114957.2667963-2-danishanwar@ti.com>
Message-Id: <167603709479.2486232.8105868847286398852.robh@kernel.org>
Subject: Re: [PATCH v5 1/2] dt-bindings: net: Add ICSSG Ethernet
Date:   Fri, 10 Feb 2023 07:58:31 -0600
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


On Fri, 10 Feb 2023 17:19:56 +0530, MD Danish Anwar wrote:
> From: Puranjay Mohan <p-mohan@ti.com>
> 
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet hardware. The ICSSG driver uses the PRU and PRUSS consumer
> APIs to interface the PRUs and load/run the firmware for supporting
> ethernet functionality.
> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 184 ++++++++++++++++++
>  1 file changed, 184 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml: Unable to find schema file matching $id: http://devicetree.org/schemas/remoteproc/ti,pru-consumer.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ti,icssg-prueth.example.dtb: ethernet: False schema does not allow {'compatible': ['ti,am654-icssg-prueth'], 'pinctrl-names': ['default'], 'pinctrl-0': [[4294967295]], 'ti,sram': [[4294967295]], 'ti,prus': [[4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295]], 'firmware-name': ['ti-pruss/am65x-pru0-prueth-fw.elf', 'ti-pruss/am65x-rtu0-prueth-fw.elf', 'ti-pruss/am65x-txpru0-prueth-fw.elf', 'ti-pruss/am65x-pru1-prueth-fw.elf', 'ti-pruss/am65x-rtu1-prueth-fw.elf', 'ti-pruss/am65x-txpru1-prueth-fw.elf'], 'ti,pruss-gp-mux-sel': [[2, 2, 2, 2, 2, 2]], 'dmas': [[4294967295, 49920], [4294967295, 49921], [4294967295, 49922], [4294967295, 49923], [4294967295, 49924], [4294967295, 49925], [4294967295, 49926], [4294967295, 49927], [4294967295, 17152], [4294967295, 17153]], 'dma-names': ['tx0-0', 'tx0-1', 'tx0-2', 'tx0-3', 'tx1-0', 'tx1-1', 'tx1-2', 'tx1-3', 'rx0', 'rx1'], 'ti,mii-g-rt': [[4294967295]]
 , 'interrupts': [[24, 0, 2], [25, 1, 3]], 'interrupt-names': ['tx_ts0', 'tx_ts1'], 'ethernet-ports': {'#address-cells': [[1]], '#size-cells': [[0]], 'port@0': {'reg': [[0]], 'phy-handle': [[4294967295]], 'phy-mode': ['rgmii-id'], 'interrupts-extended': [[4294967295, 24]], 'ti,syscon-rgmii-delay': [[4294967295, 16672]], 'local-mac-address': [[0, 0, 0, 0, 0, 0]]}, 'port@1': {'reg': [[1]], 'phy-handle': [[4294967295]], 'phy-mode': ['rgmii-id'], 'interrupts-extended': [[4294967295, 25]], 'ti,syscon-rgmii-delay': [[4294967295, 16676]], 'local-mac-address': [[0, 0, 0, 0, 0, 0]]}}, '$nodename': ['ethernet']}
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ti,icssg-prueth.example.dtb: ethernet: Unevaluated properties are not allowed ('firmware-name', 'ti,prus', 'ti,pruss-gp-mux-sel' were unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230210114957.2667963-2-danishanwar@ti.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

