Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1974E64EA
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350783AbiCXOTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiCXOTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:19:43 -0400
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C3811C08;
        Thu, 24 Mar 2022 07:18:11 -0700 (PDT)
Received: by mail-oo1-f46.google.com with SMTP id p34-20020a4a95e5000000b003248d73d460so797045ooi.1;
        Thu, 24 Mar 2022 07:18:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=Jna4fyumBD0bsBuDM2E70JQUhEhnD+mfetOCaVsAbQk=;
        b=O4RWvPRW2mD8lSrZTwaOIPxR9pbT32C7WmkJDMs3RRcMbQ8rNnZZEqdQmqBGGgLbM5
         v5SUnjO1TdWOCI8Aw+nZlzMTMfBzj3ZTrxrFLB+p5NoR+4+Y03NUsqUdU4rivjZ7F2r2
         ce4HHYmSoURabB8tuSdDgq0wHzVG33IRGvND8tk+lnr/V8Mt/pJzBU79SdWqeRnYFyq1
         aUjQ6SqDQsPETwUAPqDLDXIEUv3abkxfELBiULGnIWyNjRsvp12FMx6q6VmcglG5DYUb
         NVQ3uDcrCKTNxy67IOJzX8UZIhr0yW0Z+sKdfSnM0uv951PnKsP59HpMRbc+eYmX/7gG
         Y3dg==
X-Gm-Message-State: AOAM532smXqEuOKOuze2sEg1XYX8L9RAtGwDwRAcijCBqDQFtjZ28Do8
        owXfNWsZacEXXdheOsd8Hg==
X-Google-Smtp-Source: ABdhPJzJuf8Db7RwHK6W2v9lHlH2Uobl2lgItPUE3wBiHzc1/e/y0yGslIGw8IsCKFJahe0bJkm/iA==
X-Received: by 2002:a4a:de52:0:b0:320:d6a0:cf7f with SMTP id z18-20020a4ade52000000b00320d6a0cf7fmr2025395oot.83.1648131490312;
        Thu, 24 Mar 2022 07:18:10 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id x65-20020a9d20c7000000b005cdaeec68d5sm1349219ota.37.2022.03.24.07.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 07:18:09 -0700 (PDT)
Received: (nullmailer pid 1995382 invoked by uid 1000);
        Thu, 24 Mar 2022 14:18:08 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, macpaul.lin@mediatek.com,
        linux-kernel@vger.kernel.org, srv_heupstream@mediatek.com,
        Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-mediatek@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20220324012112.7016-2-biao.huang@mediatek.com>
References: <20220324012112.7016-1-biao.huang@mediatek.com> <20220324012112.7016-2-biao.huang@mediatek.com>
Subject: Re: [PATCH net-next] dt-bindings: net: snps,dwmac: modify available values of PBL
Date:   Thu, 24 Mar 2022 09:18:08 -0500
Message-Id: <1648131488.593520.1995381.nullmailer@robh.at.kernel.org>
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

On Thu, 24 Mar 2022 09:21:12 +0800, Biao Huang wrote:
> PBL can be any of the following values: 1, 2, 4, 8, 16 or 32
> according to the datasheet, so modify available values of PBL in
> snps,dwmac.yaml.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1608860


dwmac@9630000: $nodename:0: 'dwmac@9630000' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/stih407-b2120.dt.yaml
	arch/arm/boot/dts/stih410-b2120.dt.yaml
	arch/arm/boot/dts/stih410-b2260.dt.yaml
	arch/arm/boot/dts/stih418-b2199.dt.yaml
	arch/arm/boot/dts/stih418-b2264.dt.yaml

eth@5c400000: $nodename:0: 'eth@5c400000' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/spear1310-evb.dt.yaml

eth@5c400000: compatible: ['st,spear600-gmac'] does not contain items matching the given schema
	arch/arm/boot/dts/spear1310-evb.dt.yaml

eth@5c500000: $nodename:0: 'eth@5c500000' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/spear1310-evb.dt.yaml

eth@5c500000: compatible: ['st,spear600-gmac'] does not contain items matching the given schema
	arch/arm/boot/dts/spear1310-evb.dt.yaml

eth@5c600000: $nodename:0: 'eth@5c600000' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/spear1310-evb.dt.yaml

eth@5c600000: compatible: ['st,spear600-gmac'] does not contain items matching the given schema
	arch/arm/boot/dts/spear1310-evb.dt.yaml

eth@5c700000: $nodename:0: 'eth@5c700000' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/spear1310-evb.dt.yaml

eth@5c700000: compatible: ['st,spear600-gmac'] does not contain items matching the given schema
	arch/arm/boot/dts/spear1310-evb.dt.yaml

eth@e0800000: $nodename:0: 'eth@e0800000' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/spear300-evb.dt.yaml
	arch/arm/boot/dts/spear310-evb.dt.yaml
	arch/arm/boot/dts/spear320-evb.dt.yaml
	arch/arm/boot/dts/spear320-hmi.dt.yaml

eth@e2000000: $nodename:0: 'eth@e2000000' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/spear1310-evb.dt.yaml
	arch/arm/boot/dts/spear1340-evb.dt.yaml

eth@e2000000: compatible: ['st,spear600-gmac'] does not contain items matching the given schema
	arch/arm/boot/dts/spear1310-evb.dt.yaml
	arch/arm/boot/dts/spear1340-evb.dt.yaml

ethernet@c9410000: 'phy-mode' is a required property
	arch/arm/boot/dts/meson6-atv1200.dt.yaml
	arch/arm/boot/dts/meson8-minix-neo-x8.dt.yaml

ethernet@e0800000: compatible: ['st,spear600-gmac'] does not contain items matching the given schema
	arch/arm/boot/dts/spear600-evb.dt.yaml

ethernet@f8010000: interrupt-names:1: 'eth_wake_irq' was expected
	arch/arm/boot/dts/artpec6-devboard.dt.yaml

ethernet@fe2a0000: clock-names: ['stmmaceth', 'mac_clk_rx', 'mac_clk_tx', 'clk_mac_refout', 'aclk_mac', 'pclk_mac', 'clk_mac_speed', 'ptp_ref', 'pclk_xpcs'] is too long
	arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dt.yaml

ethernet@fe2a0000: clocks: [[15, 386], [15, 389], [15, 389], [15, 184], [15, 180], [15, 181], [15, 389], [15, 185], [15, 172]] is too long
	arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dt.yaml

ethernet@ff800000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dt.yaml
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_n5x_socdk.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_mercury_aa1.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml

ethernet@ff800000: resets: [[6, 32], [6, 40]] is too long
	arch/arm/boot/dts/socfpga_arria10_mercury_aa1.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml

ethernet@ff800000: resets: [[7, 32], [7, 40]] is too long
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dt.yaml
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_n5x_socdk.dt.yaml

ethernet@ff802000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dt.yaml
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_n5x_socdk.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_mercury_aa1.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml

ethernet@ff802000: resets: [[6, 33], [6, 41]] is too long
	arch/arm/boot/dts/socfpga_arria10_mercury_aa1.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml

ethernet@ff802000: resets: [[7, 33], [7, 41]] is too long
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dt.yaml
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_n5x_socdk.dt.yaml

ethernet@ff804000: reset-names: ['stmmaceth', 'stmmaceth-ocp'] is too long
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dt.yaml
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_n5x_socdk.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_mercury_aa1.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml

ethernet@ff804000: resets: [[6, 34], [6, 42]] is too long
	arch/arm/boot/dts/socfpga_arria10_mercury_aa1.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_nand.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dt.yaml
	arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dt.yaml

ethernet@ff804000: resets: [[7, 34], [7, 42]] is too long
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dt.yaml
	arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_agilex_socdk_nand.dt.yaml
	arch/arm64/boot/dts/intel/socfpga_n5x_socdk.dt.yaml

eth@f0802000: $nodename:0: 'eth@f0802000' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/nuvoton-npcm730-gbs.dt.yaml
	arch/arm/boot/dts/nuvoton-npcm730-gsj.dt.yaml
	arch/arm/boot/dts/nuvoton-npcm730-kudo.dt.yaml
	arch/arm/boot/dts/nuvoton-npcm750-evb.dt.yaml
	arch/arm/boot/dts/nuvoton-npcm750-runbmc-olympus.dt.yaml

eth@f0804000: $nodename:0: 'eth@f0804000' does not match '^ethernet(@.*)?$'
	arch/arm/boot/dts/nuvoton-npcm750-evb.dt.yaml
	arch/arm/boot/dts/nuvoton-npcm750-runbmc-olympus.dt.yaml

