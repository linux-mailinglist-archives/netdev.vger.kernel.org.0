Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DD52EEBB5
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbhAHDKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:10:21 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:32913 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbhAHDKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 22:10:21 -0500
Received: by mail-il1-f172.google.com with SMTP id n9so8978553ili.0;
        Thu, 07 Jan 2021 19:10:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LgCpZ89bhPoAzu1QaTKGtMiYIqqk0qB0oUZoQsv4bL8=;
        b=kZsGFX1Yqe8O6JxlP17V7D5MxfnSUPxPr94csWDNjQcugNkKrynVMUHscqr8AdXfXe
         o54Ss7lIsw4OqLocSHv4xFbUrpIkA9xW0ubIiScQDzJk3gkM+lC9c5/P1cEZ+125+WJp
         GP4WQ2qAS3gd4XdJ0WkgibfO1xonUQA/jjUCRTMbXRohNkjkU3FxQPyLKzFSjCyH2I5O
         wCUVmsqL5OfvCTl//NkJs9W3NJnByNrva+kntvxCjhR8e6UutU22PKAx7p93VrYzRJ8G
         CzA72+lIe3mB+tDEJd8ulr2dt8KDzmG5JZyZJKGcMPT4f0C+776xls37VWxavHBB3TD6
         bvRw==
X-Gm-Message-State: AOAM5308ibCZy5NlNLcw+82QiKQnTVnFGEd+3uGszDxZZlF154wKhh6T
        fqQgevst9E+OUUONCJ5N4g==
X-Google-Smtp-Source: ABdhPJyTo5xe6pis2HLmGkd2WeF1mOCMYefIn8WWRVKOqqhyq9PW9kuxdyo1JzxthAcVJl7U/Jigqw==
X-Received: by 2002:a05:6e02:1b8a:: with SMTP id h10mr1970185ili.141.1610075380095;
        Thu, 07 Jan 2021 19:09:40 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id x5sm5839653ilp.55.2021.01.07.19.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 19:09:38 -0800 (PST)
Received: (nullmailer pid 1805889 invoked by uid 1000);
        Fri, 08 Jan 2021 03:09:36 -0000
Date:   Thu, 7 Jan 2021 20:09:36 -0700
From:   Rob Herring <robh@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        David Airlie <airlied@linux.ie>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Min Guo <min.guo@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Stanley Chu <stanley.chu@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v5 10/11] dt-bindings: usb: convert mediatek, mtu3.txt to
 YAML schema
Message-ID: <20210108030936.GA1805818@robh.at.kernel.org>
References: <20201225075258.33352-1-chunfeng.yun@mediatek.com>
 <20201225075258.33352-10-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201225075258.33352-10-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Dec 2020 15:52:57 +0800, Chunfeng Yun wrote:
> Convert mediatek,mtu3.txt to YAML schema mediatek,mtu3.yaml
> 
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v5: changes suggested by Rob
>   1. remove unnecessary maxItems
>   2. define all phys supported
> 
> v4:
>   1. refer to usb-drd.yaml insstead of usb/generic.txt
>   the following ones suggested by Rob:
>   2. add the number of phys supported
>   3. fix indentation of wakeup
>   4. add examples for port and connector
> 
> v3:
>   1. fix yamllint warning
>   2. remove pinctrl* properties
>   3. remove unnecessary '|'
>   4. drop unused labels in example
> 
> v2: new patch
> ---
>  .../devicetree/bindings/usb/mediatek,mtu3.txt | 108 -------
>  .../bindings/usb/mediatek,mtu3.yaml           | 287 ++++++++++++++++++
>  2 files changed, 287 insertions(+), 108 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/usb/mediatek,mtu3.txt
>  create mode 100644 Documentation/devicetree/bindings/usb/mediatek,mtu3.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
