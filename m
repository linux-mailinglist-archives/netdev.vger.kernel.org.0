Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9DB490B7A
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 16:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240504AbiAQPfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 10:35:52 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]:42957 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240489AbiAQPfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 10:35:48 -0500
Received: by mail-ot1-f41.google.com with SMTP id z25-20020a0568301db900b005946f536d85so11254080oti.9;
        Mon, 17 Jan 2022 07:35:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=uz9rWH9EExEde9e83L6Ci5xDXHmn67olZ/Bo1AaALIk=;
        b=mskP4pawIKONJuzpHhQk7qFFaJFpeY2odfRfUpBgrGO0kk4og6k4JuhtFtJXot18wo
         Zo0qbBM3noJLU7D+bXMop5aI5hWRMERNOwdu11BzWV/+pPzxI+4Vv85y8RIbrRDGQ2wD
         daYzfcIqNFXaTQuRk90/zIZLsJPNhpzafKR69eJgRAhZ9IUffBppzveQMuGPyAFXWdcI
         91A4pXPTpewzBFtntKwn9nv+3KOZahV/RHFJ17aACYs+EigfoZ7Ozxlb/ESW51OVD6OJ
         IkqU/oDqJ7RswTV/8fPiYFMDmNkN8OUSOOPZNC11SFHLN4GHR1SDEOxlVlbbj+Zxm+4+
         bwsA==
X-Gm-Message-State: AOAM531Vf6GiUPxGG/cmzcIrwSHzzgULZwyU46LVR+5ZUu71BD2nCL3r
        HJ32i6PCtnNTLXEARYycmA==
X-Google-Smtp-Source: ABdhPJzAopoamav84cvKKv308QfSUylWTMQX34XDs9D8wI7eeXkkB7i7iaF0ajflyRA76l5dpV6RKg==
X-Received: by 2002:a05:6830:1f56:: with SMTP id u22mr9420465oth.138.1642433746928;
        Mon, 17 Jan 2022 07:35:46 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bg17sm7015383oib.25.2022.01.17.07.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 07:35:45 -0800 (PST)
Received: (nullmailer pid 3923087 invoked by uid 1000);
        Mon, 17 Jan 2022 15:35:42 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     srv_heupstream@mediatek.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        angelogioacchino.delregno@collabora.com, macpaul.lin@mediatek.com,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        dkirjanov@suse.de, Maxime Coquelin <mcoquelin.stm32@gmail.com>
In-Reply-To: <20220117070706.17853-8-biao.huang@mediatek.com>
References: <20220117070706.17853-1-biao.huang@mediatek.com> <20220117070706.17853-8-biao.huang@mediatek.com>
Subject: Re: [PATCH net-next v12 7/7] net: dt-bindings: dwmac: add support for mt8195
Date:   Mon, 17 Jan 2022 09:35:42 -0600
Message-Id: <1642433742.934070.3923086.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jan 2022 15:07:06 +0800, Biao Huang wrote:
> Add binding document for the ethernet on mt8195.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.yaml          | 28 ++++++++++++++++---
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1580608


ethernet@1101c000: clock-names: ['axi', 'apb', 'mac_main', 'ptp_ref'] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: clocks: [[27, 34], [27, 37], [6, 154], [6, 155]] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: ['mediatek,mt2712-gmac'] does not contain items matching the given schema
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: 'oneOf' conditional failed, one must be fixed:
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: Unevaluated properties are not allowed ('compatible', 'reg', 'interrupts', 'interrupt-names', 'mac-address', 'clock-names', 'clocks', 'power-domains', 'snps,axi-config', 'snps,mtl-rx-config', 'snps,mtl-tx-config', 'snps,txpbl', 'snps,rxpbl', 'clk_csr', 'phy-mode', 'phy-handle', 'snps,reset-gpio', 'mdio' were unexpected)
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

