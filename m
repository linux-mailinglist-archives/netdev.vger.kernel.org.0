Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083325391B9
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 15:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344698AbiEaNVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 09:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344700AbiEaNV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 09:21:29 -0400
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7D4972A6;
        Tue, 31 May 2022 06:21:28 -0700 (PDT)
Received: by mail-oi1-f176.google.com with SMTP id m82so3421973oif.13;
        Tue, 31 May 2022 06:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=e5hEwdVyk0aAkl6eSBNPLNwTk/gtSZtsZFRN5GRZ6bA=;
        b=SLJnrAdPTX9gBHgCOIQUIvxYlWeUh/43uZIeHIbWXD6AgkZXfTsmVFN5/J1axleTgi
         W0Cv4Udy3xf4gfrDaQJ2zz6HRNdIo4oe8Has8kF5a35m8cB6mvSeB6hLgb2wmGZ5fQ/h
         MzL/WuStPns1a0DTMplSgAUK579dZESxCV+EFxyvFJ7Kco3zKrg3YmnHqJRJMUB2QrO7
         1zYv9b9aqzsRFxxH06dMe8IDa/Z+qpPoVXzaBmIGqdUSVMwm86Cc0lArGHpgWeDfU6Ix
         MUSRE+Vou+C6XSt13kYA72n4pHOWi49g/UKizwP2QyPexXgNkdJxd6X4vNc7m5Zhv1G+
         g9Sw==
X-Gm-Message-State: AOAM532+2SN84i6RIgO+cR5M+6d+3gCJf6AiuBP6cV46rMtmUPWGfRgB
        xYlYGi0twYXqHrcOlpyJyQ==
X-Google-Smtp-Source: ABdhPJwc9hEHIr4dNicEv2trxpFWfW7N9CStjs9nOb2xy+SSJhjlsZ6CBFELIq7Zjs0oQODGv2QlAg==
X-Received: by 2002:a05:6808:f8c:b0:32a:e67f:d20e with SMTP id o12-20020a0568080f8c00b0032ae67fd20emr11509012oiw.88.1654003287818;
        Tue, 31 May 2022 06:21:27 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s31-20020a056830439f00b0060613c844adsm6307651otv.10.2022.05.31.06.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 06:21:27 -0700 (PDT)
Received: (nullmailer pid 1610161 invoked by uid 1000);
        Tue, 31 May 2022 13:21:25 -0000
From:   Rob Herring <robh@kernel.org>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, edumazet@google.com, vigneshr@ti.com,
        kishon@ti.com, afd@ti.com, davem@davemloft.net,
        ssantosh@kernel.org, andrew@lunn.ch,
        krzysztof.kozlowski+dt@linaro.org, grygorii.strashko@ti.com,
        devicetree@vger.kernel.org, s-anna@ti.com, nm@ti.com,
        rogerq@kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20220531095108.21757-2-p-mohan@ti.com>
References: <20220531095108.21757-1-p-mohan@ti.com> <20220531095108.21757-2-p-mohan@ti.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add ICSSG Ethernet Driver bindings
Date:   Tue, 31 May 2022 08:21:25 -0500
Message-Id: <1654003285.283793.1610159.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 May 2022 15:21:07 +0530, Puranjay Mohan wrote:
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
> to interface the PRUs and load/run the firmware for supporting ethernet
> functionality.
> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
> v1: https://lore.kernel.org/all/20220506052433.28087-2-p-mohan@ti.com/
> v1 -> v2:
> * Addressed Rob's Comments
> * It includes indentation, formatting, and other minor changes.
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 181 ++++++++++++++++++
>  1 file changed, 181 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml: Unable to find schema file matching $id: http://devicetree.org/schemas/remoteproc/ti,pru-consumer.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,icssg-prueth.example.dtb: pruss2_eth: False schema does not allow {'compatible': ['ti,am654-icssg-prueth'], 'pinctrl-names': ['default'], 'pinctrl-0': [[4294967295]], 'sram': [[4294967295]], 'ti,prus': [[4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295]], 'firmware-name': ['ti-pruss/am65x-pru0-prueth-fw.elf', 'ti-pruss/am65x-rtu0-prueth-fw.elf', 'ti-pruss/am65x-txpru0-prueth-fw.elf', 'ti-pruss/am65x-pru1-prueth-fw.elf', 'ti-pruss/am65x-rtu1-prueth-fw.elf', 'ti-pruss/am65x-txpru1-prueth-fw.elf'], 'ti,pruss-gp-mux-sel': [[2, 2, 2, 2, 2, 2]], 'ti,mii-g-rt': [[4294967295]], 'dmas': [[4294967295, 49920], [4294967295, 49921], [4294967295, 49922], [4294967295, 49923], [4294967295, 49924], [4294967295, 49925], [4294967295, 49926], [4294967295, 49927], [4294967295, 17152], [4294967295, 17153]], 'dma-names': ['tx0-0', 'tx0-1', 'tx0-2', 'tx0-3', 'tx1-0', 'tx1-1', 'tx1-2', 'tx1-3', 'rx0', 'rx1'], 'i
 nterrupts': [[24, 0, 2], [25, 1, 3]], 'interrupt-names': ['tx_ts0', 'tx_ts1'], 'ethernet-ports': {'#address-cells': [[1]], '#size-cells': [[0]], 'port@0': {'reg': [[0]], 'phy-handle': [[4294967295]], 'phy-mode': ['rgmii-rxid'], 'interrupts-extended': [[4294967295, 24]], 'ti,syscon-rgmii-delay': [[4294967295, 16672]], 'local-mac-address': [[0, 0, 0, 0, 0, 0]]}, 'port@1': {'reg': [[1]], 'phy-handle': [[4294967295]], 'phy-mode': ['rgmii-rxid'], 'interrupts-extended': [[4294967295, 25]], 'ti,syscon-rgmii-delay': [[4294967295, 16676]], 'local-mac-address': [[0, 0, 0, 0, 0, 0]]}}, '$nodename': ['pruss2_eth']}
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,icssg-prueth.example.dtb: pruss2_eth: Unevaluated properties are not allowed ('firmware-name', 'ti,prus', 'ti,pruss-gp-mux-sel' were unexpected)
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

