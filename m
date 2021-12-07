Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3DC46BE61
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238343AbhLGPBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:01:48 -0500
Received: from mail-ot1-f52.google.com ([209.85.210.52]:35822 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238310AbhLGPBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:01:45 -0500
Received: by mail-ot1-f52.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso18409426otr.2;
        Tue, 07 Dec 2021 06:58:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=ISwB/Cqr0g2fR9Rv1ZPSZGA/iwpQtfwdBswG+ia19pY=;
        b=gfnfWPUM61NcILbw+nBDwkoPkHatfY9B7MidFAhE4r3zvq8itm/tlsegbnxNHjwS51
         U7xNNJ8P37Ur9Xzz3F4SkNbCweSnfMhjxIm8mvn1l9QaJm5sXUankOuzJ72QNNOAdzWY
         +LykeUpkLEvmrA6Dl2BXh+N736fWjd8LohvLjfj56EzncDeDwPBXKAIbbZ1fcaouOFiS
         PeY9y/KVDMbZMgmImgN6LV8TRk87GBShZYVJHXe14aMoBCEGnhYwAMTrJL7Pjs+D02Ir
         iOzFNSxGUIh2ztZmIfe+TRf3qcW4i4ijy9fuz6g51elQ3222jStGt569xEi4coaK7bl1
         Uzsw==
X-Gm-Message-State: AOAM532KDc+a/Dv4n4cMvEU/2/0tfE8gNngimVILWp6CMYxgOltD19mq
        y0cWQCjpDT43D1s+A/JwJw==
X-Google-Smtp-Source: ABdhPJzWbIjQ5ndnddb4GSl+z61bTtoUDb/1KYBoxAMiY033kVvOuMdyLuS3XWH3MrvukZoClyRG5g==
X-Received: by 2002:a05:6830:2643:: with SMTP id f3mr35971443otu.187.1638889094869;
        Tue, 07 Dec 2021 06:58:14 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g4sm2719201oof.40.2021.12.07.06.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:58:13 -0800 (PST)
Received: (nullmailer pid 5806 invoked by uid 1000);
        Tue, 07 Dec 2021 14:58:10 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com, davem@davemloft.net,
        netdev@vger.kernel.org, dkirjanov@suse.de,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        srv_heupstream@mediatek.com, linux-mediatek@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        angelogioacchino.delregno@collabora.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        macpaul.lin@mediatek.com
In-Reply-To: <20211207015505.16746-5-biao.huang@mediatek.com>
References: <20211207015505.16746-1-biao.huang@mediatek.com> <20211207015505.16746-5-biao.huang@mediatek.com>
Subject: Re: [PATCH v5 4/7] net-next: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
Date:   Tue, 07 Dec 2021 08:58:10 -0600
Message-Id: <1638889090.734543.5805.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Dec 2021 09:55:02 +0800, Biao Huang wrote:
> Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
> And there are some changes in .yaml than .txt, others almost keep the same:
>   1. compatible "const: snps,dwmac-4.20".
>   2. delete "snps,reset-active-low;" in example, since driver remove this
>      property long ago.
>   3. add "snps,reset-delay-us = <0 10000 10000>" in example.
>   4. the example is for rgmii interface, keep related properties only.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.txt           |  91 ----------
>  .../bindings/net/mediatek-dwmac.yaml          | 156 ++++++++++++++++++
>  2 files changed, 156 insertions(+), 91 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1564459


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

