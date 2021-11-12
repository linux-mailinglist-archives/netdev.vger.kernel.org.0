Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC23B44E7DC
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 14:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhKLNvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 08:51:42 -0500
Received: from mail-oi1-f177.google.com ([209.85.167.177]:33422 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbhKLNvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 08:51:36 -0500
Received: by mail-oi1-f177.google.com with SMTP id q25so12412410oiw.0;
        Fri, 12 Nov 2021 05:48:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=lfnFk0Vk2nlPX6zE3Xuo6uqEuasd9Rkq/bqEgF/SFTA=;
        b=zePNQAHqjeVvBXlkIBVgG+dLi0h6dnxadR3Z588HJf0gwM56IlZl7jjVAw8pXQZL01
         wuTK5OxMiWsjqYMqt61owCnJKSJL0PD0BAzf9hRg5sum1aIJLqQi4eLR1977H6BdaSX1
         F2VZfgccWWDKxpdOvquzPFvil7yDDOFFK0s71tYxcuLb70RpxRm/4o9eR1DJFDKAdHDe
         rbfNjGanaGKoNFssi/hpYJq4Eqj5vOt/q9B0fylDwGo+JqUdIA73LWg8rMl5pEkc/frJ
         d/Nvy/1hgkZD/puDsHXbfDduoy15+nmJO/1Gx/YfrDyEpxhZT93BdiRdNCBRbvaVWbPe
         W0+Q==
X-Gm-Message-State: AOAM532NaFN1BKvNB/71m8ds7hHspwQsmvm47qVhv44qY36t+48X98nh
        x4P8awFf9oASvkG0bt/zDA==
X-Google-Smtp-Source: ABdhPJwYvgxWt2U6crFb5cYgShEcV2k6Ksx10uPU+Y41+QNrwmhXTQw/q/at2PcM13hNbmCaEt2ZHA==
X-Received: by 2002:a05:6808:14e:: with SMTP id h14mr23166380oie.28.1636724925287;
        Fri, 12 Nov 2021 05:48:45 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id h3sm11658ooe.13.2021.11.12.05.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 05:48:44 -0800 (PST)
Received: (nullmailer pid 2463377 invoked by uid 1000);
        Fri, 12 Nov 2021 13:48:37 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        angelogioacchino.delregno@collabora.com, davem@davemloft.net,
        Jose Abreu <joabreu@synopsys.com>, srv_heupstream@mediatek.com,
        Jakub Kicinski <kuba@kernel.org>, dkirjanov@suse.de,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        macpaul.lin@mediatek.com, linux-arm-kernel@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-stm32@st-md-mailman.stormreply.com
In-Reply-To: <20211112093918.11061-8-biao.huang@mediatek.com>
References: <20211112093918.11061-1-biao.huang@mediatek.com> <20211112093918.11061-8-biao.huang@mediatek.com>
Subject: Re: [PATCH v3 7/7] net-next: dt-bindings: dwmac: add support for mt8195
Date:   Fri, 12 Nov 2021 07:48:37 -0600
Message-Id: <1636724917.173620.2463376.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Nov 2021 17:39:18 +0800, Biao Huang wrote:
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

Full log is available here: https://patchwork.ozlabs.org/patch/1554230


ethernet@1101c000: clock-names: ['axi', 'apb', 'mac_main', 'ptp_ref'] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: clocks: [[27, 34], [27, 37], [6, 154], [6, 155]] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: ['mediatek,mt2712-gmac'] does not contain items matching the given schema
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: 'oneOf' conditional failed, one must be fixed:
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

