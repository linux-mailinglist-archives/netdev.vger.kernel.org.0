Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD83E44E7E1
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 14:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhKLNvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 08:51:49 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:43567 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbhKLNvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 08:51:40 -0500
Received: by mail-ot1-f48.google.com with SMTP id h16-20020a9d7990000000b0055c7ae44dd2so13860378otm.10;
        Fri, 12 Nov 2021 05:48:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=6pHca0PIi6BrRjpQqaAzxuZW0QOl0VIRadxfTfhPAkQ=;
        b=q3568mjKFwtzqhYJVdKnXwAddZBtLDRsUstfbVF3CektfsZW6Vs5MkTm5qfj/6M+Rs
         aI//ST4C9Yoo63EjudsrjSxRx4AeytsPpAQN9leooueWW09gF8SeelH6ZM/HkcbBMUKD
         Mstnsuhy3SSZFLrO2urNQiqTpiUihkrQYt1rSLukoiT7z3/N9RrXWS0U0Cfo8azzUY68
         QhjLjazGOgJfd/jHYR8N3y9ss6OJ6/ntZSgRRr26W6I9aFr3Rt7NnE+vCcikRQwrApYg
         acf3FG8BpvkwY5yWZ/C9lFycm9ypLwPjBS7cGDRjRRpk9wZaru6+F0R9f54xCK4kz6KE
         TDPg==
X-Gm-Message-State: AOAM530A3zt8tcEwBI8XX7/wz7/ACl2KlMEyqjR81DhoYIhGT3kdMLHD
        6de5nQLpxONYYM0BukduIA==
X-Google-Smtp-Source: ABdhPJwly26891iEK8vtNTXyQVNzHORW9lkbyk3RQPIGYIxK3HMgQYC5n3VkFR/ORX4G7j567JV10A==
X-Received: by 2002:a05:6830:1e57:: with SMTP id e23mr12025731otj.16.1636724928903;
        Fri, 12 Nov 2021 05:48:48 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a23sm1053194ool.3.2021.11.12.05.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 05:48:48 -0800 (PST)
Received: (nullmailer pid 2463375 invoked by uid 1000);
        Fri, 12 Nov 2021 13:48:37 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     linux-kernel@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        davem@davemloft.net, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>, macpaul.lin@mediatek.com,
        linux-mediatek@lists.infradead.org,
        angelogioacchino.delregno@collabora.com,
        srv_heupstream@mediatek.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Rob Herring <robh+dt@kernel.org>, dkirjanov@suse.de,
        devicetree@vger.kernel.org
In-Reply-To: <20211112093918.11061-5-biao.huang@mediatek.com>
References: <20211112093918.11061-1-biao.huang@mediatek.com> <20211112093918.11061-5-biao.huang@mediatek.com>
Subject: Re: [PATCH v3 4/7] net-next: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
Date:   Fri, 12 Nov 2021 07:48:37 -0600
Message-Id: <1636724917.159298.2463374.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Nov 2021 17:39:15 +0800, Biao Huang wrote:
> Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.txt           |  91 ----------
>  .../bindings/net/mediatek-dwmac.yaml          | 157 ++++++++++++++++++
>  2 files changed, 157 insertions(+), 91 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1554228


ethernet@1101c000: clock-names: ['axi', 'apb', 'mac_main', 'ptp_ref'] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: clocks: [[27, 34], [27, 37], [6, 154], [6, 155]] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: ['mediatek,mt2712-gmac'] does not contain items matching the given schema
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: 'oneOf' conditional failed, one must be fixed:
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

