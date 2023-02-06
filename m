Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A2668BEA7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjBFNsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjBFNsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:48:16 -0500
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8A1EFA5;
        Mon,  6 Feb 2023 05:47:53 -0800 (PST)
Received: by mail-oo1-f48.google.com with SMTP id y17-20020a4ade11000000b0051762fdf955so1105859oot.3;
        Mon, 06 Feb 2023 05:47:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=92apLSSkuYwWJFfhBYJuWlfSYvlCP6TR/Ko63PLydtg=;
        b=LF4yuSWrJRtcWyRvecEQjN+evx/aZLZWWMAb5K67lOg0D88eDhAGjihh+10462+aSc
         o6t40xBdWbHDiXfXMbPiK6TmTf3eQ5ssKNAiWZ+lmInrVTSAALmIZcSWndbWAex5n5Dr
         hlK7zPfxn4OVhvOjZhji3qb0E1VKR+1/q2Mrz+lotBT/P7kUeyBhXj6drbr0nqgL0KBx
         qmK4GfEjQlF21Mulz1vHs8zk9gvaflypQ8Tm6FG79c/UuBDeA96uPFP30EezyVx1Q98y
         lLileKJMXZhXf1q8ndSatAlf6SZo3sKnQYoxnARJskGPqlRvXO8PucWz3QnpOZsnvFtN
         oorA==
X-Gm-Message-State: AO0yUKVG3hjjYHcDJxrC1cX0LrCA7+3DvHI1vyUq3KLfc1ks5SXCVoal
        58ft1NZHfKUL+tQ0ugC2CA==
X-Google-Smtp-Source: AK7set9wq+r1TUMDsYbZNPyPYD5ICQnr4N/fs2ZLVZ0nK/+C6JFqH6uY9HPieDqeosEgV9M9TYL0pw==
X-Received: by 2002:a4a:c898:0:b0:4a3:aa96:23c7 with SMTP id t24-20020a4ac898000000b004a3aa9623c7mr9000017ooq.6.1675691210179;
        Mon, 06 Feb 2023 05:46:50 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id g17-20020a4adc91000000b00517bfd71ce1sm4590668oou.9.2023.02.06.05.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 05:46:49 -0800 (PST)
Received: (nullmailer pid 1490133 invoked by uid 1000);
        Mon, 06 Feb 2023 13:46:48 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        ssantosh@kernel.org, Rob Herring <robh+dt@kernel.org>,
        "Andrew F. Davis" <afd@ti.com>, andrew@lunn.ch,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Suman Anna <s-anna@ti.com>,
        srk@ti.com, "David S. Miller" <davem@davemloft.net>, nm@ti.com,
        netdev@vger.kernel.org, Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
In-Reply-To: <20230206060708.3574472-2-danishanwar@ti.com>
References: <20230206060708.3574472-1-danishanwar@ti.com>
 <20230206060708.3574472-2-danishanwar@ti.com>
Message-Id: <167569095956.1485300.151990392599002247.robh@kernel.org>
Subject: Re: [PATCH v4 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Date:   Mon, 06 Feb 2023 07:46:48 -0600
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


On Mon, 06 Feb 2023 11:37:07 +0530, MD Danish Anwar wrote:
> From: Puranjay Mohan <p-mohan@ti.com>
> 
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
> to interface the PRUs and load/run the firmware for supporting ethernet
> functionality.
> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 179 ++++++++++++++++++
>  1 file changed, 179 insertions(+)
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

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230206060708.3574472-2-danishanwar@ti.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

