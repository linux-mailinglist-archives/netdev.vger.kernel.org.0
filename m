Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F1A692575
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbjBJShw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Feb 2023 13:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjBJShu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:37:50 -0500
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A284475F46;
        Fri, 10 Feb 2023 10:37:47 -0800 (PST)
Received: by mail-oo1-f53.google.com with SMTP id x15-20020a4ab90f000000b004e64a0a967fso617346ooo.2;
        Fri, 10 Feb 2023 10:37:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j7h/WebataPPaEa1u0vdSZ4RcwWXCSihrRS9Y13n00s=;
        b=MCk+IEoY1bMnkVFM1ciZG+EaTzzzIkMkut8w2pQHWC8j6IzzpXbn3TSyzMfqnmGj20
         NxIigeHvkAK54w13H02gljyg9IR12F4IMKUqFpfyxVtBp5T/VZHHaQFeKIzNsIdFz+t8
         HLuaV5K5RuIK6YjubZCS6dLSNtRQSZHMaHFecnvea6KZHkLvnm6rP/kPdYMiDw94TyWj
         wjSvIB/2ecigX/hmjhKONqVd2bJdT/zxHVfiTiKHPb2N8LuMJl95h9ytFWMoMuoQuh3J
         4JuqVHMiWPYmFSpnDjwAqZQQb+CkqfC2hzSXc+o+0TgIiDAkXbXKBWxPs2MWJHPlSYdE
         cASg==
X-Gm-Message-State: AO0yUKUXV4KeD2pgZ2EaBU5Q1EaCTu34bC7SvFDeDb4f+7jTnLF4MNb1
        RVOHCJa47K/9TJuKw7wFmw==
X-Google-Smtp-Source: AK7set830zF5ycsji4Hw2LbzEHyGO0HXDM7rD8uyVm2n3BwbUfUR1WJMnLdu6EWioWTCmNi77JlAxA==
X-Received: by 2002:a05:6820:449:b0:51a:7a15:9758 with SMTP id p9-20020a056820044900b0051a7a159758mr7198969oou.5.1676054266872;
        Fri, 10 Feb 2023 10:37:46 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t5-20020a4adbc5000000b00511e01623bbsm2286985oou.7.2023.02.10.10.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 10:37:46 -0800 (PST)
Received: (nullmailer pid 2925630 invoked by uid 1000);
        Fri, 10 Feb 2023 18:37:45 -0000
Date:   Fri, 10 Feb 2023 12:37:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Md Danish Anwar <a0501179@ti.com>
Cc:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Paolo Abeni <pabeni@redhat.com>,
        srk@ti.com, andrew@lunn.ch, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        ssantosh@kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        nm@ti.com, "David S. Miller" <davem@davemloft.net>,
        Vignesh Raghavendra <vigneshr@ti.com>, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Suman Anna <s-anna@ti.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Roger Quadros <rogerq@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH v5 1/2] dt-bindings: net: Add ICSSG
 Ethernet
Message-ID: <20230210183745.GA2923614-robh@kernel.org>
References: <20230210114957.2667963-1-danishanwar@ti.com>
 <20230210114957.2667963-2-danishanwar@ti.com>
 <167603709479.2486232.8105868847286398852.robh@kernel.org>
 <69f54246-5541-7899-f4ed-76d0a600e1b0@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <69f54246-5541-7899-f4ed-76d0a600e1b0@ti.com>
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

On Fri, Feb 10, 2023 at 09:00:59PM +0530, Md Danish Anwar wrote:
> 
> 
> On 10/02/23 19:28, Rob Herring wrote:
> > 
> > On Fri, 10 Feb 2023 17:19:56 +0530, MD Danish Anwar wrote:
> >> From: Puranjay Mohan <p-mohan@ti.com>
> >>
> >> Add a YAML binding document for the ICSSG Programmable real time unit
> >> based Ethernet hardware. The ICSSG driver uses the PRU and PRUSS consumer
> >> APIs to interface the PRUs and load/run the firmware for supporting
> >> ethernet functionality.
> >>
> >> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> >> Signed-off-by: Md Danish Anwar <danishanwar@ti.com>
> >> ---
> >>  .../bindings/net/ti,icssg-prueth.yaml         | 184 ++++++++++++++++++
> >>  1 file changed, 184 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> >>
> > 
> > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > 
> > yamllint warnings/errors:
> > 
> > dtschema/dtc warnings/errors:
> > ./Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml: Unable to find schema file matching $id: http://devicetree.org/schemas/remoteproc/ti,pru-consumer.yaml
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ti,icssg-prueth.example.dtb: ethernet: False schema does not allow {'compatible': ['ti,am654-icssg-prueth'], 'pinctrl-names': ['default'], 'pinctrl-0': [[4294967295]], 'ti,sram': [[4294967295]], 'ti,prus': [[4294967295, 4294967295, 4294967295, 4294967295, 4294967295, 4294967295]], 'firmware-name': ['ti-pruss/am65x-pru0-prueth-fw.elf', 'ti-pruss/am65x-rtu0-prueth-fw.elf', 'ti-pruss/am65x-txpru0-prueth-fw.elf', 'ti-pruss/am65x-pru1-prueth-fw.elf', 'ti-pruss/am65x-rtu1-prueth-fw.elf', 'ti-pruss/am65x-txpru1-prueth-fw.elf'], 'ti,pruss-gp-mux-sel': [[2, 2, 2, 2, 2, 2]], 'dmas': [[4294967295, 49920], [4294967295, 49921], [4294967295, 49922], [4294967295, 49923], [4294967295, 49924], [4294967295, 49925], [4294967295, 49926], [4294967295, 49927], [4294967295, 17152], [4294967295, 17153]], 'dma-names': ['tx0-0', 'tx0-1', 'tx0-2', 'tx0-3', 'tx1-0', 'tx1-1', 'tx1-2', 'tx1-3', 'rx0', 'rx1'], 'ti,mii-g-rt': [[429!
> >  4967295]], 'interrupts': [[24, 0, 2], [25, 1, 3]], 'interrupt-names': ['tx_ts0', 'tx_ts1'], 'ethernet-ports': {'#address-cells': [[1]], '#size-cells': [[0]], 'port@0': {'reg': [[0]], 'phy-handle': [[4294967295]], 'phy-mode': ['rgmii-id'], 'interrupts-extended': [[4294967295, 24]], 'ti,syscon-rgmii-delay': [[4294967295, 16672]], 'local-mac-address': [[0, 0, 0, 0, 0, 0]]}, 'port@1': {'reg': [[1]], 'phy-handle': [[4294967295]], 'phy-mode': ['rgmii-id'], 'interrupts-extended': [[4294967295, 25]], 'ti,syscon-rgmii-delay': [[4294967295, 16676]], 'local-mac-address': [[0, 0, 0, 0, 0, 0]]}}, '$nodename': ['ethernet']}
> > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> > /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ti,icssg-prueth.example.dtb: ethernet: Unevaluated properties are not allowed ('firmware-name', 'ti,prus', 'ti,pruss-gp-mux-sel' were unexpected)
> > 	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> > 
> > doc reference errors (make refcheckdocs):
> > 
> > See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230210114957.2667963-2-danishanwar@ti.com
> 
> Hi Rob,
> This patch depends on the patch [1] which is posted through series [2]. Patch
> [1] is currently approved, reviewed and will soon be merged to mainline Linux.
> Once it is merged this patch won't throw the above error.
> 
> In the meantime I have posted this patch to get it reviewed so that once patch
> [1] gets merged, this will be ready to be merged.
> 
> [1] https://lore.kernel.org/all/20230106121046.886863-2-danishanwar@ti.com/
> [2] https://lore.kernel.org/all/20230106121046.886863-1-danishanwar@ti.com/

State that in *this* patch if you don't want to get the report.

Rob
