Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC72747025B
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbhLJOGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:06:43 -0500
Received: from mail-ot1-f49.google.com ([209.85.210.49]:35636 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239289AbhLJOGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:06:41 -0500
Received: by mail-ot1-f49.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso9727720otr.2;
        Fri, 10 Dec 2021 06:03:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=qFj8K3WFpcuS6IdcgSs6T2eGLRNYj7TpTJrIpVhra44=;
        b=t9qrPmKVNBPUFFzRZnxuT5Ns2+7PeQSjQ/EqrycRjGN7V/ATokYbPwSt6ko2h/x5nv
         a89zw00Quvvk2kZiM7FFzjnVmTatpSNxW+smlI/uE/gcyQyuFApgMoc4mfQGDz3yGkmP
         VrYHL1Nlre5PbhccicRkDpmmZXxw6FqJGM6vECUufHVtkRqRrlxT059e8A6qa7tgQzzv
         BsmM6bNYyxl5WoNq9udleW31JzfJ/TRclIERkr//MYqIKLytqOC/+NaSxKLorzuNRRIv
         3YynmPb8TWM8sVufwVV1+hwOjcHvglsXZxuPkMWf9cy6DcTzDSs70dE+W9CtQdFoy7RA
         zpmg==
X-Gm-Message-State: AOAM531z4WjYrjN13qxIbWEjEEtU7Rt6gMriXGZDmWXY2bWoffb9ccu8
        f1OobPnNfmzprmpcR8SCQg==
X-Google-Smtp-Source: ABdhPJxGA9LwgjCGvSQm44Ms90YQCfR3aM+imwu+hZ7RRERaZQjBVA7pPuzIZen5MPrjMTwZuS9PoA==
X-Received: by 2002:a9d:1b0f:: with SMTP id l15mr10945246otl.38.1639144983324;
        Fri, 10 Dec 2021 06:03:03 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id y192sm673672oie.21.2021.12.10.06.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 06:03:00 -0800 (PST)
Received: (nullmailer pid 1252262 invoked by uid 1000);
        Fri, 10 Dec 2021 14:02:56 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        angelogioacchino.delregno@collabora.com,
        linux-kernel@vger.kernel.org, dkirjanov@suse.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        devicetree@vger.kernel.org
In-Reply-To: <20211210013129.811-7-biao.huang@mediatek.com>
References: <20211210013129.811-1-biao.huang@mediatek.com> <20211210013129.811-7-biao.huang@mediatek.com>
Subject: Re: [PATCH net-next v8 6/6] net: dt-bindings: dwmac: add support for mt8195
Date:   Fri, 10 Dec 2021 08:02:56 -0600
Message-Id: <1639144976.235371.1252261.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 09:31:29 +0800, Biao Huang wrote:
> Add binding document for the ethernet on mt8195.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.yaml          | 86 +++++++++++++++----
>  1 file changed, 70 insertions(+), 16 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1566168


ethernet@1101c000: clock-names: ['axi', 'apb', 'mac_main', 'ptp_ref'] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: clocks: [[27, 34], [27, 37], [6, 154], [6, 155]] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: ['mediatek,mt2712-gmac'] does not contain items matching the given schema
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: 'oneOf' conditional failed, one must be fixed:
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: Unevaluated properties are not allowed ('compatible', 'reg', 'interrupts', 'interrupt-names', 'mac-address', 'clock-names', 'clocks', 'assigned-clocks', 'assigned-clock-parents', 'power-domains', 'snps,axi-config', 'snps,mtl-rx-config', 'snps,mtl-tx-config', 'snps,txpbl', 'snps,rxpbl', 'clk_csr', 'phy-mode', 'phy-handle', 'snps,reset-gpio', 'mdio' were unexpected)
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

