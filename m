Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8D851D946
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 15:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392598AbiEFNlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 09:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347079AbiEFNlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 09:41:21 -0400
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DB15D651;
        Fri,  6 May 2022 06:37:38 -0700 (PDT)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-edf3b6b0f2so6804417fac.9;
        Fri, 06 May 2022 06:37:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=bXouDNTd1mqqNaROQPaX+ROWqeN12vTnYsJ6b+irPxI=;
        b=cVrC9mIpiWqzmazl7ggZQH+dm8ubcrDShdFTSgQ+6rrYZQIO14fWR+KySAIZkRc3be
         ALA4+i8ZmEc8txrojWsQqbNtAgdMv8tfNx4Jx974jQvmjVwPKgpqp1OkMR6IDSfT3vld
         fuP2ZQsV7+sc80ansctZt5FShN6wEjvZgpqKSFIh8QpfQ/u27ZTGQow/aRI/vGMMCsoA
         3kM5/Ly2AYcLluiKEKzylCN4Q175501NGP5d7YZHFgn/wGeU39RowDOkotYjd3mF1v+F
         z2atbEjSFxsxLR846xdRekwHn9Be2QuRVyqQMPLh43WnKSddt9tUetMvP9RPhcQSkVOh
         1J4g==
X-Gm-Message-State: AOAM530mlCfpaHZOp4QL7606y7B4RSzeJ9IJWHbQUiMOkFzCtdRwxpzz
        alDhtltPltqNc+ZqXITxDQ==
X-Google-Smtp-Source: ABdhPJzQXmIFc8ZStq1x1BfkSPjisZIu0znwFW1uSwTfb2zHq8RvF9wBmTnTmAyyhFOh/bU7lnM35w==
X-Received: by 2002:a05:6870:9615:b0:e7:c74:e993 with SMTP id d21-20020a056870961500b000e70c74e993mr4582519oaq.87.1651844257675;
        Fri, 06 May 2022 06:37:37 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x23-20020a9d6297000000b0060603221256sm1585798otk.38.2022.05.06.06.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 06:37:37 -0700 (PDT)
Received: (nullmailer pid 1590046 invoked by uid 1000);
        Fri, 06 May 2022 13:37:36 -0000
From:   Rob Herring <robh@kernel.org>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     kishon@ti.com, krzysztof.kozlowski+dt@linaro.org,
        davem@davemloft.net, netdev@vger.kernel.org, s-anna@ti.com,
        rogerq@kernel.org, vigneshr@ti.com, afd@ti.com, andrew@lunn.ch,
        devicetree@vger.kernel.org, ssantosh@kernel.org, nm@ti.com,
        grygorii.strashko@ti.com, edumazet@google.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20220506052433.28087-2-p-mohan@ti.com>
References: <20220506052433.28087-1-p-mohan@ti.com> <20220506052433.28087-2-p-mohan@ti.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: Add ICSSG Ethernet Driver bindings
Date:   Fri, 06 May 2022 08:37:36 -0500
Message-Id: <1651844256.314860.1590045.nullmailer@robh.at.kernel.org>
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

On Fri, 06 May 2022 10:54:32 +0530, Puranjay Mohan wrote:
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
> to interface the PRUs and load/run the firmware for supporting ethernet
> functionality.
> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 174 ++++++++++++++++++
>  1 file changed, 174 insertions(+)
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

