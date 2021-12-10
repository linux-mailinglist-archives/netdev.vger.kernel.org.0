Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FDB47025D
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239456AbhLJOGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:06:45 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:44802 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239405AbhLJOGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:06:44 -0500
Received: by mail-ot1-f45.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso9664412otj.11;
        Fri, 10 Dec 2021 06:03:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=k7EaRnob3zOEquu+wkUbm05857jqaStaszAJkkyFu8I=;
        b=j7nkdae4U5xqodaJfSWnsUJ6cIX9YjdrjK9GHEoFKfCJzQLN+1NFPTjJ1mSJ7Ug3TF
         fvEM/3th/Az2EnnnrYUxbk+e9Cuv4MFNwzPmOJ9tojz70nmQvWGTFKywtinUJSZqjBtM
         oUlbs69V/YQaCePK93tl6H5tIh2P2O0uXnp1GjkkjdV5nvxaht625di0ho+Ja5ZJ8+sl
         +KFX1sxTdxadBneJfq0h6tSSHbk0L/HLcnNMb7d7y6IY6jkVre/V3OVdpoSxPB9+kHmc
         QBNzs9Kppuu8cllyj6l3wS9O8pWQVoVmMcPZ+jhblZOAsATDNEtdRCVguKLa/uI212r2
         0Xrw==
X-Gm-Message-State: AOAM532Bly/SMGN857EdYq8t2qcP9UIVL8Phdb+CTjgxSlyMYwrIk/2m
        SEAkbc5CBE6/pEjrVolZYA==
X-Google-Smtp-Source: ABdhPJw8097NeWY7msvS0XSMdwLw1NEYFR27r4qN30zbTRskT35vsrks871Xs7VoBvqNOAmesE3DHQ==
X-Received: by 2002:a05:6830:18b:: with SMTP id q11mr11543396ota.113.1639144985532;
        Fri, 10 Dec 2021 06:03:05 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id t14sm554859oth.81.2021.12.10.06.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 06:03:04 -0800 (PST)
Received: (nullmailer pid 1252259 invoked by uid 1000);
        Fri, 10 Dec 2021 14:02:56 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, srv_heupstream@mediatek.com,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, davem@davemloft.net,
        angelogioacchino.delregno@collabora.com,
        devicetree@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        dkirjanov@suse.de, linux-mediatek@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        macpaul.lin@mediatek.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
In-Reply-To: <20211210013129.811-5-biao.huang@mediatek.com>
References: <20211210013129.811-1-biao.huang@mediatek.com> <20211210013129.811-5-biao.huang@mediatek.com>
Subject: Re: [PATCH net-next v8 4/6] net: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
Date:   Fri, 10 Dec 2021 08:02:56 -0600
Message-Id: <1639144976.227854.1252258.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 09:31:27 +0800, Biao Huang wrote:
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

Full log is available here: https://patchwork.ozlabs.org/patch/1566169


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

