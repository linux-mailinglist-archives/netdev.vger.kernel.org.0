Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854D72D1BDF
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgLGVQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:16:36 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35882 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgLGVQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:16:35 -0500
Received: by mail-ot1-f66.google.com with SMTP id y24so13931857otk.3;
        Mon, 07 Dec 2020 13:16:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rSAFkhpNJQAuz9y5dju0W7uXjODyDSx6iiAnGJorzFE=;
        b=LabFy7kUaJOrTWpn/CBHBFDaeDjB4dsNcUXA8Qcf1E4f/qFJ/Ai6GA2hazlu+uZytJ
         GHMswHc7dj6B3XmIWCehObD7ldrgL2/GJDBuEIsgSYGAMnAX/VsH/+aZbZfJDW2BQySb
         TOQ9ZMpv/NVJdNi8T1IwoDe/6iXUK3zJ8pwW+InL085rp81rS9MfmHhu9jmHPu6eHP7f
         oMze/1BkFrN80ebN/S+X/h7zKt9MsV/rfUwNFiHp3GsWkxkC49R+9/FUi1DuX8PV5iUw
         yqefHQZku8SAcjCGtXHC/CoSjY5V44Qhjhb7XRJzeOl4owq9nPi7OLPWNgR2yoOEu0f/
         bZGA==
X-Gm-Message-State: AOAM530i1PHfomfi4j+KqYQzIzTz2pHPOPEbJZt7r+z6RZd7gVukMqhq
        7sVIIAyXfJtne2WH7gbdwA==
X-Google-Smtp-Source: ABdhPJxQpESfvNGlJAqwTMytNEER2nkmsXBzu8vhDgGPWF4PCnXOQyEU6ub0eGzupCQoCYrmNFRMlQ==
X-Received: by 2002:a05:6830:128a:: with SMTP id z10mr14708659otp.3.1607375754577;
        Mon, 07 Dec 2020 13:15:54 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id b28sm2878493oob.22.2020.12.07.13.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 13:15:53 -0800 (PST)
Received: (nullmailer pid 838684 invoked by uid 1000);
        Mon, 07 Dec 2020 21:15:52 -0000
Date:   Mon, 7 Dec 2020 15:15:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Min Guo <min.guo@mediatek.com>, devicetree@vger.kernel.org,
        David Airlie <airlied@linux.ie>, linux-usb@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 03/11] dt-bindings: phy: convert phy-mtk-xsphy.txt to
 YAML schema
Message-ID: <20201207211552.GA838655@robh.at.kernel.org>
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com>
 <20201118082126.42701-3-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118082126.42701-3-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 16:21:18 +0800, Chunfeng Yun wrote:
> Convert phy-mtk-xsphy.txt to YAML schema mediatek,xsphy.yaml
> 
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v3:
>   1. remove type for property with standard unit suffix suggested by Rob
>   2. remove '|' for descritpion
>   3. fix yamllint warning
> 
> v2:
>   1. modify description and compatible definition suggested by Rob
> ---
>  .../bindings/phy/mediatek,xsphy.yaml          | 199 ++++++++++++++++++
>  .../devicetree/bindings/phy/phy-mtk-xsphy.txt | 109 ----------
>  2 files changed, 199 insertions(+), 109 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/mediatek,xsphy.yaml
>  delete mode 100644 Documentation/devicetree/bindings/phy/phy-mtk-xsphy.txt
> 

Reviewed-by: Rob Herring <robh@kernel.org>
