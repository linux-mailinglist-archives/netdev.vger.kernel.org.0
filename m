Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C89F24A972
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgHSWgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:36:31 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35088 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSWga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:36:30 -0400
Received: by mail-io1-f65.google.com with SMTP id s2so413972ioo.2;
        Wed, 19 Aug 2020 15:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bC6aASYEgsmqX0lrYUMvyzWqmXHNI5bk9/vbQX0AirY=;
        b=SWTs008CEnelWbAez7PJeCHAIGaPzw12nSXnkigcyRglTdj+2qTPIpfbZTB44q3qrP
         1HUJXJiPEIvKB/RABIWEfsqZHOfxmoX9HmhvgJRHkpvZDRXZcVsdr9MXf1QUDXzOM+UT
         3ih7/fiAL+le0Nqu6HbHoFGiFQbOe12IFANNzQw/ly8PT9oQ3/j08oUfQF+aYMETyoGc
         OkQPXAIaUw3OE0EXirbTGsj8WgxV/lpBBruL8lpDG34Se6nLa56Fkm8vQJ6YJbJeKvbq
         I4DJ6Ma5tvPM8qY3gsVfRtzpf9nsM2MrCFKhcce32Zx31oH/LQ22a0V3gFJZ8es+YRND
         oFiQ==
X-Gm-Message-State: AOAM533OPoAraIbyMe+b3nZEUtW9eDpAUW/Z/2qSXESqyIKyBycX76B7
        aZyNAhhomC6lDdHnp5holQ==
X-Google-Smtp-Source: ABdhPJyExfthK/G2i9U35sdrsHpH6q4ydgO7dbM/7WUr+hI2m5whIMc2HLDa2NliEenlvW3c4ys8/A==
X-Received: by 2002:a6b:591a:: with SMTP id n26mr147084iob.122.1597876589103;
        Wed, 19 Aug 2020 15:36:29 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id p21sm49152ioj.10.2020.08.19.15.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 15:36:28 -0700 (PDT)
Received: (nullmailer pid 2087313 invoked by uid 1000);
        Wed, 19 Aug 2020 22:36:25 -0000
Date:   Wed, 19 Aug 2020 16:36:25 -0600
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, linuxarm@huawei.com,
        David Airlie <airlied@linux.ie>, Wei Xu <xuwei5@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mauro.chehab@huawei.com, Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 49/49] dt: display: Add binds for the DPE and DSI
 controller for Kirin 960/970
Message-ID: <20200819223625.GA2086431@bogus>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
 <6471642f74779fecfc9d5e990d90f9475d8b32d4.1597833138.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6471642f74779fecfc9d5e990d90f9475d8b32d4.1597833138.git.mchehab+huawei@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 13:46:17 +0200, Mauro Carvalho Chehab wrote:
> Add a description of the bindings used by Kirin 960/970 Display
> Serial Interface (DSI) controller and by its Display Engine (DPE).
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  .../display/hisilicon,hi3660-dpe.yaml         |  99 +++++++++++++++++
>  .../display/hisilicon,hi3660-dsi.yaml         | 102 ++++++++++++++++++
>  .../boot/dts/hisilicon/hikey970-drm.dtsi      |   4 +-
>  3 files changed, 203 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/display/hisilicon,hi3660-dpe.yaml
>  create mode 100644 Documentation/devicetree/bindings/display/hisilicon,hi3660-dsi.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

Error: Documentation/devicetree/bindings/display/hisilicon,hi3660-dsi.example.dts:25.31-32 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:342: Documentation/devicetree/bindings/display/hisilicon,hi3660-dsi.example.dt.yaml] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1367: dt_binding_check] Error 2


See https://patchwork.ozlabs.org/patch/1347736

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

