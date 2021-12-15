Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4221475A31
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhLOOBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:01:10 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:43556 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhLOOBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:01:10 -0500
Received: by mail-oi1-f175.google.com with SMTP id o4so31777776oia.10;
        Wed, 15 Dec 2021 06:01:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=v2N2/2aRl0uDViM7Eo18ZEycm6qiJCN1cJkIyTdCyMk=;
        b=7kLoa8v4csmCqQezHcwUlNB2BDTigIYGynImdVvway3FvvWXQijx+7C2N0QqKLjhPq
         DSaT46+Sk0BAd8fTTFOtSGsRastP7djj+bj6WEVv2YlrtAJnHarH+m2SRiz5nBrX5jaK
         7pnIg3WbiHQNfMIClTrjS+bEdnhoDRSuPp81qcUIvqGlCSqVChEmJyZZSKQg3j1cwdvB
         nv94MUYhLBOuJROpLR0WiCbl1BwDZbkSK7TYHou03ejcQZMS/gcOed81CocqIbG1cRqN
         PY2XnORJSH4y9bvDsF5OYfrp2vONtGHPGOxTfr00IzukxLfvB9716mUpADjHxIDS3Srd
         rnsw==
X-Gm-Message-State: AOAM532S/tb5Y+3S7CoM5hfDwpjqO1yVWLqUqjxkVYEFZkYsr63wbDlr
        b3lGxAnWID72tdV3mj3XeA==
X-Google-Smtp-Source: ABdhPJyLHls0NqIbXlFT86l7QPNmz2Nu39/Akl9ZcQh7M1EkHj/vb600jTYN0BNbCBgWUtj6wv4pJQ==
X-Received: by 2002:aca:2319:: with SMTP id e25mr38548861oie.164.1639576869775;
        Wed, 15 Dec 2021 06:01:09 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id b1sm447272otj.5.2021.12.15.06.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 06:01:09 -0800 (PST)
Received: (nullmailer pid 1207416 invoked by uid 1000);
        Wed, 15 Dec 2021 14:01:07 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        davem@davemloft.net,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        devicetree@vger.kernel.org, srv_heupstream@mediatek.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        macpaul.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        angelogioacchino.delregno@collabora.com, dkirjanov@suse.de,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20211215021652.7270-5-biao.huang@mediatek.com>
References: <20211215021652.7270-1-biao.huang@mediatek.com> <20211215021652.7270-5-biao.huang@mediatek.com>
Subject: Re: [PATCH net-next v9 4/6] net: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
Date:   Wed, 15 Dec 2021 08:01:07 -0600
Message-Id: <1639576867.892685.1207415.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 10:16:50 +0800, Biao Huang wrote:
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
>  .../bindings/net/mediatek-dwmac.yaml          | 155 ++++++++++++++++++
>  2 files changed, 155 insertions(+), 91 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1567987


ethernet@1101c000: clock-names: ['axi', 'apb', 'mac_main', 'ptp_ref'] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: clocks: [[27, 34], [27, 37], [6, 154], [6, 155]] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: ['mediatek,mt2712-gmac'] does not contain items matching the given schema
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: ['mediatek,mt2712-gmac'] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: Unevaluated properties are not allowed ('compatible', 'reg', 'interrupts', 'interrupt-names', 'mac-address', 'clock-names', 'clocks', 'power-domains', 'snps,axi-config', 'snps,mtl-rx-config', 'snps,mtl-tx-config', 'snps,txpbl', 'snps,rxpbl', 'clk_csr', 'phy-mode', 'phy-handle', 'snps,reset-gpio', 'mdio' were unexpected)
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

