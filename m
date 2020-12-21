Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8482E00CB
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgLUTLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:11:55 -0500
Received: from mail-oi1-f176.google.com ([209.85.167.176]:38995 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgLUTLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 14:11:54 -0500
Received: by mail-oi1-f176.google.com with SMTP id w124so12332328oia.6;
        Mon, 21 Dec 2020 11:11:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f9rsH3MI3HmxoU3YRSFq+GPxbgSUzkM76uH8mgO+QJ0=;
        b=LHaHonXz/x3h47Ew9od3e938uE+OuKsuX+6UF3RpmUKIjVxSR3JzM/60SHRYmkIC2A
         MFrnbcd7zS6M6yzaLHpTjkZy6qPdlx6+PyGDoaN7vXfk7IdOzz/tsF8Bw/q/eXebdkhl
         H0VzESCXYFrLi6mANkmGzRkAmAbad3RTPsrdMBwQDwcFL8B19C70rWTTVwBpROOuJJ42
         XZ2KgaLqaj2XrWc/Cad4h6Lna8drD40UEBClohmfLtNtdYMcBV0LfqODFP9BOTvPggY0
         y8jxvOqG8vf7eEGuWdnwGDXUPh43K86kzAkJ3wnTdnN/GrluuaCbQ+u4G/vqEu89pgi4
         3JZA==
X-Gm-Message-State: AOAM533OujfRoHbBS+xyFTiHktDXYOl7Gi9wAcRaVVmgs9b2jM6qYjz4
        GBeSGMoYlYPubZ0Alduzzg==
X-Google-Smtp-Source: ABdhPJykTihmx7a1AWZTQnLaeKbOndEBk8EAvOatAGL9pTLPvCEAQBmw9IQc3TLr1f+WzJECt5AmDA==
X-Received: by 2002:aca:3a02:: with SMTP id h2mr11827243oia.65.1608577873045;
        Mon, 21 Dec 2020 11:11:13 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id r15sm3731437oie.33.2020.12.21.11.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:11:12 -0800 (PST)
Received: (nullmailer pid 382296 invoked by uid 1000);
        Mon, 21 Dec 2020 19:11:07 -0000
Date:   Mon, 21 Dec 2020 12:11:07 -0700
From:   Rob Herring <robh@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Min Guo <min.guo@mediatek.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vinod Koul <vkoul@kernel.org>, netdev@vger.kernel.org,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        linux-mediatek@lists.infradead.org, linux-usb@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 07/11] dt-bindings: phy: convert MIPI DSI PHY binding
 to YAML schema
Message-ID: <20201221191107.GA382240@robh.at.kernel.org>
References: <20201216093012.24406-1-chunfeng.yun@mediatek.com>
 <20201216093012.24406-7-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216093012.24406-7-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 17:30:08 +0800, Chunfeng Yun wrote:
> Convert MIPI DSI PHY binding to YAML schema mediatek,dsi-phy.yaml
> 
> Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v4:
>   1. add maintainer Philipp add support mt8183 suggested by Chun-Kuang
>   2. use keyword multipleOf suggested by Rob
>   3. fix typo of 'MIPI' in title
> 
> v3: new patch
> ---
>  .../display/mediatek/mediatek,dsi.txt         | 18 +---
>  .../bindings/phy/mediatek,dsi-phy.yaml        | 85 +++++++++++++++++++
>  2 files changed, 86 insertions(+), 17 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
