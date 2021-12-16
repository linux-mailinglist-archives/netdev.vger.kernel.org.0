Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985D04773A8
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237036AbhLPNxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:53:09 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:45777 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhLPNxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 08:53:07 -0500
Received: by mail-oi1-f169.google.com with SMTP id 7so36515154oip.12;
        Thu, 16 Dec 2021 05:53:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=6fkUBesEK+ljm2rlPJZWtYPxz7Qh1jlpFH5iXSMcGv8=;
        b=UVf6FCLqJBxFQFiqz41n97REGIYbL6r/AXZv2jRg7zV0RcaPQ+IKZW2VTNRZNM3It1
         nS/yVTnTY9m2vLqoorvl16A3PdPzs1hewHYHeerv8LUzpZ4CcLiu581V8zWML7dPvwNZ
         cS+ZKEUv2++iUNKS7yduZPI0fNPFy/oel/bjvBhyVo7j0xPrQPQ7WUKsH40cQbC/i6Vu
         7u9IPNlTyAwrBUv8pNBHRmkL0zXgRJdeJMC1su87l3lGbwGg6VRODrdjbcfrgSCn3EAZ
         Esll5yFmDrnqeRrvCC7cRAIkns2Op5pfva7qidbo3ebp1Us6zt3B26WLvJMkbjID67Q2
         k31Q==
X-Gm-Message-State: AOAM531Bk2vu34PeSeSETCm9WLoPqC+g1KW3LXLi6b13Zq/QS8VB1m82
        EmEGzyhuTRIhFOu+pbb7W4O+W9evnQ==
X-Google-Smtp-Source: ABdhPJw5upVfoScoQm9JMcGvL7W6litpwZZt9iGYREg40ouAGdsEx1RNm5o/nQz8hQBdqefWZlPU/w==
X-Received: by 2002:aca:c650:: with SMTP id w77mr4205603oif.8.1639662787205;
        Thu, 16 Dec 2021 05:53:07 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id i3sm1041907ooq.39.2021.12.16.05.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 05:53:06 -0800 (PST)
Received: (nullmailer pid 4004891 invoked by uid 1000);
        Thu, 16 Dec 2021 13:53:03 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, srv_heupstream@mediatek.com,
        macpaul.lin@mediatek.com, davem@davemloft.net,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        Jose Abreu <joabreu@synopsys.com>,
        linux-mediatek@lists.infradead.org, dkirjanov@suse.de,
        Matthias Brugger <matthias.bgg@gmail.com>,
        angelogioacchino.delregno@collabora.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
In-Reply-To: <20211216055328.15953-5-biao.huang@mediatek.com>
References: <20211216055328.15953-1-biao.huang@mediatek.com> <20211216055328.15953-5-biao.huang@mediatek.com>
Subject: Re: [PATCH net-next v10 4/6] net: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
Date:   Thu, 16 Dec 2021 07:53:03 -0600
Message-Id: <1639662783.037495.4004890.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 13:53:26 +0800, Biao Huang wrote:
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

Full log is available here: https://patchwork.ozlabs.org/patch/1568901


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

