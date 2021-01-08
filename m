Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E33B2EEBA4
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbhAHDGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:06:08 -0500
Received: from mail-il1-f181.google.com ([209.85.166.181]:47055 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbhAHDGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 22:06:07 -0500
Received: by mail-il1-f181.google.com with SMTP id 75so8891404ilv.13;
        Thu, 07 Jan 2021 19:05:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=arkq3vtpRQtU5z3eGsmG2DhJUAWYG7qKz2FVaRgjOOo=;
        b=lLHPf8YcbBb+SlT+D3j1W+nvtR2qGNL2wi0jr+2NdkwcdJ+BOjSA7C2WbvhYepmQjQ
         Q3/s7T+3dBkdLIOxKn0PMsKEOjbIont4K3mlkx1SURuJ854Gn0mcowOWACxJ3q5B7mhN
         0UI1W+27oJA0mUl1FBIVO8WrfpVGtv5rXgT9Mv3bgh+dSv9QMw3kA9U5QaKbXIJc0K1p
         8+d3Eu9BZIoJ1o1Mu8+O6teK7Q6IjZwmm4mfS5DBsU7ATleaJBX+2NUTBfGz47n8XsUa
         WcTxAx8CRZlKd1rri1oZBRH2FYLCr5p/FkLSnWVhOdXfCZi50TowYE2BL0Du4iYNZOoS
         x+/w==
X-Gm-Message-State: AOAM5306n+TLaqthPrz7JZYPYT/gFuKMh3+brh3SuSCmzKM5Lw+JBGdf
        2dwzJEFDelnUSQRe2eL0Dg==
X-Google-Smtp-Source: ABdhPJyKWrLxcGC66HT5wGIZ8PKEuzgHS2mskcXZJtvK358qOBYcpO8cr50U2hVSdiPnd8PJiw10gA==
X-Received: by 2002:a92:cdac:: with SMTP id g12mr1885522ild.145.1610075126513;
        Thu, 07 Jan 2021 19:05:26 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id o195sm6066850ila.38.2021.01.07.19.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 19:05:25 -0800 (PST)
Received: (nullmailer pid 1800216 invoked by uid 1000);
        Fri, 08 Jan 2021 03:05:23 -0000
Date:   Thu, 7 Jan 2021 20:05:23 -0700
From:   Rob Herring <robh@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, Min Guo <min.guo@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v5 01/11] dt-bindings: usb: convert usb-device.txt to
 YAML schema
Message-ID: <20210108030523.GA1800134@robh.at.kernel.org>
References: <20201225075258.33352-1-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225075258.33352-1-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Dec 2020 15:52:48 +0800, Chunfeng Yun wrote:
> Convert usb-device.txt to YAML schema usb-device.yaml
> 
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v5: changes suggested by Rob:
>   1. limit the pattern length
>   2. remove properties description for hard wired USB devices in usb-hcd.yaml
> 
>     depends on series:
>     https://patchwork.kernel.org/project/linux-usb/list/?series=399561
>     [v6,00/19] dt-bindings: usb: Add generic USB HCD, xHCI, DWC USB3 DT schema
> 
> v4: no changes, update dependent series:
>     https://patchwork.kernel.org/project/linux-usb/list/?series=399561
>     [v6,00/19] dt-bindings: usb: Add generic USB HCD, xHCI, DWC USB3 DT schema
> 
> v3:
>   1. remove $nodenmae and items key word for compatilbe;
>   2. add additionalProperties;
> 
>   The followings are suggested by Rob:
>   3. merge the following patch
>     [v2,1/4] dt-bindings: usb: convert usb-device.txt to YAML schema
>     [v2,2/4] dt-bindings: usb: add properties for hard wired devices
>   4. define the unit-address for hard-wired device in usb-hcd.yaml,
>      also define its 'reg' and 'compatible';
>   5. This series is base on Serge's series:
>     https://patchwork.kernel.org/project/linux-usb/cover/20201111090853.14112-1-Sergey.Semin@baikalelectronics.ru/
>     [v4,00/18] dt-bindings: usb: Add generic USB HCD, xHCI, DWC USB3 DT schema
> 
> v2 changes suggested by Rob:
>   1. modify pattern to support any USB class
>   2. convert usb-device.txt into usb-device.yaml
> ---
>  .../devicetree/bindings/usb/usb-device.txt    | 102 --------------
>  .../devicetree/bindings/usb/usb-device.yaml   | 124 ++++++++++++++++++
>  .../devicetree/bindings/usb/usb-hcd.yaml      |  19 +++
>  3 files changed, 143 insertions(+), 102 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/usb/usb-device.txt
>  create mode 100644 Documentation/devicetree/bindings/usb/usb-device.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
