Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56682EEBAF
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbhAHDHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:07:44 -0500
Received: from mail-io1-f46.google.com ([209.85.166.46]:44348 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbhAHDHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 22:07:43 -0500
Received: by mail-io1-f46.google.com with SMTP id z5so8363127iob.11;
        Thu, 07 Jan 2021 19:07:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8KcxnzAs3ni/01L1eWgKza5Z0B+3uDNHSn0G445YVHg=;
        b=e7lJrlcX4xVkQoGVesqM0RGAcmD22bcmvVi2vOW7YU+yZG7PpnCynNiogB08yahZAS
         NJklLLudiTXhUm6+UUuA9dk4KJ/HxUFg7DmmKdhmPzgNrlVdoyVJO1cvBqmzbj+/OLHc
         02hN5Mouv9wQ4ggB1Dk+6jOu3cQVuXQMT6r125mmw9k3ghqAvKW65GYrl7I2wbJghXyq
         YjpOwPGEt9LgffA24obYVimPlGTgt52N5Q77+agScRxFgE9f/pvSI2QTtHPuTHzugj++
         5PcAjB5T6qcYLBDHByLOtZ6skcJ3lk0eoPW3+xurdEaDCjO4sYIFZo49E7hpepM5SDsq
         Dytw==
X-Gm-Message-State: AOAM5319w5QXYXsmclbE1XupwrknP6KUojZRTR0OI756KTx57aE6u1yb
        TGrHRSDdJ6wcK8Z4uBtFqA==
X-Google-Smtp-Source: ABdhPJxfKaoaAn2T5WBaPEv5PLxKzEgHV8iS3F793MOnICO4dRtjruSucVwbpui6WwUnMMVGHMmVLw==
X-Received: by 2002:a5d:9c91:: with SMTP id p17mr3801573iop.36.1610075222485;
        Thu, 07 Jan 2021 19:07:02 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id x5sm5939782ilm.22.2021.01.07.19.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 19:07:01 -0800 (PST)
Received: (nullmailer pid 1802363 invoked by uid 1000);
        Fri, 08 Jan 2021 03:06:57 -0000
Date:   Thu, 7 Jan 2021 20:06:57 -0700
From:   Rob Herring <robh@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Vinod Koul <vkoul@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Min Guo <min.guo@mediatek.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-usb@vger.kernel.org, David Airlie <airlied@linux.ie>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        dri-devel@lists.freedesktop.org, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v5 09/11] dt-bindings: usb: convert mediatek,
 mtk-xhci.txt to YAML schema
Message-ID: <20210108030657.GA1802097@robh.at.kernel.org>
References: <20201225075258.33352-1-chunfeng.yun@mediatek.com>
 <20201225075258.33352-9-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225075258.33352-9-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Dec 2020 15:52:56 +0800, Chunfeng Yun wrote:
> Convert mediatek,mtk-xhci.txt to YAML schema mediatek,mtk-xhci.yaml
> 
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v5: changes suggested by Rob
>   1. refer to usb-xhci.yaml instead of usb-hcd.yaml
>   2. remove unnecessary maxItems
>   3. add items for all phys may be supported
>   4. change pattern, and limit pattern length of patternProperties
> 
> v4: update it according to Rob's suggestion
>   1. modify dictionary of phys
>   2. fix endentation in "mediatek,syscon-wakeup" items
>   3. remove reference to usb-hcd.yaml
> 
> v3:
>   1. fix yamllint warning
>   2. remove pinctrl* properties supported by default suggested by Rob
>   3. drop unused labels
>   4. modify description of mediatek,syscon-wakeup
>   5. remove type of imod-interval-ns
> 
> v2: new patch
> ---
>  .../bindings/usb/mediatek,mtk-xhci.txt        | 121 ------------
>  .../bindings/usb/mediatek,mtk-xhci.yaml       | 178 ++++++++++++++++++
>  2 files changed, 178 insertions(+), 121 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.txt
>  create mode 100644 Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
