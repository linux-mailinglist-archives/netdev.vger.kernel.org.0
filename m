Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3F744D8BB
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbhKKPAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:00:37 -0500
Received: from mail-oi1-f181.google.com ([209.85.167.181]:41640 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbhKKPAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:00:25 -0500
Received: by mail-oi1-f181.google.com with SMTP id u74so12003358oie.8;
        Thu, 11 Nov 2021 06:57:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=eOq5ir+TFZBL5cj7XaOZPw0GldpRN8fcVtMKUZ8KDPc=;
        b=SMY2FKgbDJZoMRFWODsXCP3a5xnsRNrW/LHfFYnEZcyMtMU/AewOQf/Sb0zj78L8wb
         04rdXvKzB2RHRYGnY7EAWWbdDHhxf7hxguX4nnmUQ5rtZX3l/xYBagSWM2YwsTibO7gV
         uB2flJPMTHS0H2j/8HeNrilNSxGMy/FeO65hcIJkdHGs7q7Zg/xqEKXM5cqeZvOJ97C4
         GhkVB7Yfa/6w6Sxz9PR4uURLEXbPq8taOSOYk+emwEkWv9kt+esyE/ZB3YXJSR8wXdFn
         ElxFTDcgJmLTqqMyeuZnD9vqtb1yV6baIQ03djiIAPv/UDlo1bT92yvTXCaFvO7eeg2n
         4lbA==
X-Gm-Message-State: AOAM5316OSKNuYSKpj2gyQ9MZsD+oCT219up2Gf+2HKieLUiG3BjJwik
        ToRqmvIAvfhzW08xmLJQUQ==
X-Google-Smtp-Source: ABdhPJylUnRgVbfCJwWY8YapTYWcyJT8PtHaBGyigns+dkTO2lU8gHUIpbJagVcgphNPxro1ePlm2w==
X-Received: by 2002:a05:6808:159a:: with SMTP id t26mr20008829oiw.106.1636642655301;
        Thu, 11 Nov 2021 06:57:35 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id ay42sm769577oib.22.2021.11.11.06.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 06:57:34 -0800 (PST)
Received: (nullmailer pid 3774089 invoked by uid 1000);
        Thu, 11 Nov 2021 14:57:26 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Jose Abreu <joabreu@synopsys.com>, srv_heupstream@mediatek.com,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        macpaul.lin@mediatek.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
In-Reply-To: <20211111071214.21027-5-biao.huang@mediatek.com>
References: <20211111071214.21027-1-biao.huang@mediatek.com> <20211111071214.21027-5-biao.huang@mediatek.com>
Subject: Re: [PATCH v2 4/5] dt-bindings: net: dwmac: Convert mediatek-dwmac to DT schema
Date:   Thu, 11 Nov 2021 08:57:26 -0600
Message-Id: <1636642646.918741.3774088.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 15:12:13 +0800, Biao Huang wrote:
> Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.txt           |  91 --------
>  .../bindings/net/mediatek-dwmac.yaml          | 211 ++++++++++++++++++
>  2 files changed, 211 insertions(+), 91 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1553803


ethernet@1101c000: clock-names: ['axi', 'apb', 'mac_main', 'ptp_ref'] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: clocks: [[27, 34], [27, 37], [6, 154], [6, 155]] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: ['mediatek,mt2712-gmac'] does not contain items matching the given schema
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: 'oneOf' conditional failed, one must be fixed:
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

