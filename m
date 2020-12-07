Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603BF2D1BE5
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgLGVR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:17:57 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35707 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgLGVR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:17:56 -0500
Received: by mail-ot1-f68.google.com with SMTP id i6so7820374otr.2;
        Mon, 07 Dec 2020 13:17:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G1G6ObvJgDI0E7m4Cl1U1Ro4MDrbTLhzH3K0T2+ZbBs=;
        b=LXphHGOpjCqUv2Tt+M521S8Pu2IaqZG9/tIYqED4G/shP7is5W3Rwp1B87r5bfiINM
         fy3xVi4eDJdw04KpV1Nc0z4trs0aryYqUZ6djJPfIg2esj3wG19OlPeUyXx4zMZOy+bb
         +WnWCkqjxWdP/gVyQSusS+GdhJv5y7S1dku5lDYL/3Joy48Wqg/6pEu1PL1AGmtEGvM5
         ECnCqlfRgXWAHxdx16nnItjA1TBIeHz5IHrEwN7x4OQK3dWYP/JviBkgdU4qqVouz8y6
         x5AvRvvSXUXR2iVUA83HLj67DpKt7wGcdmcmB/AKVAgAtlMa1Lq3VcqDYb/2VVnUH5zO
         59MA==
X-Gm-Message-State: AOAM5338vu9wM+kGxzV0+vvfiE/6UFBYZ2Jn1Kd+Pex0OrsbItE+LGWB
        6tnAS2aF3TLMG0ClSyKmgw==
X-Google-Smtp-Source: ABdhPJy/chd0MSu5WIDA3RVAbdxX9aM4h7hyWLwu1dkVGQ1ZVEXEos5cdWB3ekvdjyNJmXERqp4QUg==
X-Received: by 2002:a05:6830:4036:: with SMTP id i22mr2933425ots.127.1607375835756;
        Mon, 07 Dec 2020 13:17:15 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id k134sm3203551oib.51.2020.12.07.13.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 13:17:14 -0800 (PST)
Received: (nullmailer pid 840904 invoked by uid 1000);
        Mon, 07 Dec 2020 21:17:13 -0000
Date:   Mon, 7 Dec 2020 15:17:13 -0600
From:   Rob Herring <robh@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vkoul@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 04/11] dt-bindings: phy: convert phy-mtk-tphy.txt to
 YAML schema
Message-ID: <20201207211713.GA840844@robh.at.kernel.org>
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
 <20201118082126.42701-4-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118082126.42701-4-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 16:21:19 +0800, Chunfeng Yun wrote:
> Convert phy-mtk-tphy.txt to YAML schema mediatek,tphy.yaml
> 
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v3:
>   1. fix dt_binding_check error in example after add mtu3.yaml
>   Changes suggested by Rob:
>   2. fix wrong indentation
>   3. remove '|' due to no formatting to preserve
>   4. add a space after '#'
>   5. drop unused labels and status in examples
>   6. modify file mode
> 
> v2:
>   1. modify description and compatible
> ---
>  .../bindings/phy/mediatek,tphy.yaml           | 260 ++++++++++++++++++
>  .../devicetree/bindings/phy/phy-mtk-tphy.txt  | 162 -----------
>  2 files changed, 260 insertions(+), 162 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/mediatek,tphy.yaml
>  delete mode 100644 Documentation/devicetree/bindings/phy/phy-mtk-tphy.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
