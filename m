Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59B54018E3
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbhIFJez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241506AbhIFJes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 05:34:48 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1DAC06179A
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 02:33:44 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u16so8859179wrn.5
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 02:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=i2+NvsBgnBTOZ+uAcUxvlIaM13WedkLbcL6bup+H1UM=;
        b=q9eDwDZxue+JjKYKIP+w/ygZ5RrOIy/6a/V0xWsuwzRdA+DY9pSefRgNpnnYpm5BQZ
         jcdsEFl+fmxv1rv5K31l4dvYsDgRRwrUDRSzPK+5TxnLrRKkeZrRIMX8t00nTTDrCsNi
         uf638hMv8OsnzcALsgDmG4mf5Gq7vuKLtqqOIWfbZSTBJC9+5AAZImMHCH6jbKGweNZY
         0rFAtFa8MeWkgidZTVKx5NAsJxCv7TwpC8fsiZdr5uQa0ixm8d4bVKAPP52HXRvZ99cf
         Q+yyT+iPmmajoU/79Hm6iTVhB2TuOulKMfd2QGm1q9pIns3NH7VucMIJue0cMY68rhls
         XvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=i2+NvsBgnBTOZ+uAcUxvlIaM13WedkLbcL6bup+H1UM=;
        b=JS4bqi42bobKNuAwbT6fXkVmsprQvQDvd/ELxJenINqxzGTV38m/SGVEOnCjA37Gge
         BkUony3teJEmaNgyPaC0r/Zbg6+MnZQ77BmqD5zw41g06RI0jduu2FCL3CcK6T6Ngl1o
         a8dSKdUnKfuADl13iNgPxcisy+/I4B6Yv76OtEe5xz7VEZOTs4//lHuFGpqfTDWkIycJ
         zQvqorXhYBZ9lFK+rJvTsErKvbtIS/jSBF+pKStCY05ppAi98T9DjrwmCNncXEwUDNyV
         FTq6SIAxoAjBp2KQhB/j5cFJIiPArIw9hwd2gv5Z4h/e2zIsXFjZLD5u//obnxxEMhnO
         eE2Q==
X-Gm-Message-State: AOAM531QHtySmPLi0r5JahqQhjjw0ZxgBwabrQiwp1YdXDTyk9uRmgc2
        6khU/89LPo1sjeb9vNTlJv2rzQ==
X-Google-Smtp-Source: ABdhPJzzIakAt8tQ+64AcWO9lDYlr4Dh32B1+kDEcgR0qe3zm7ry+opFn+4PQ93e0dV7eey6Ev0dkg==
X-Received: by 2002:adf:8006:: with SMTP id 6mr12342436wrk.38.1630920822630;
        Mon, 06 Sep 2021 02:33:42 -0700 (PDT)
Received: from google.com ([31.124.24.187])
        by smtp.gmail.com with ESMTPSA id i21sm7106080wrb.62.2021.09.06.02.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 02:33:42 -0700 (PDT)
Date:   Mon, 6 Sep 2021 10:33:39 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Vignesh R <vigneshr@ti.com>, Marc Zyngier <maz@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Use 'enum' instead of 'oneOf' plus 'const'
 entries
Message-ID: <YTXgc/GhZVKzJR9H@google.com>
References: <20210824202014.978922-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210824202014.978922-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021, Rob Herring wrote:

> 'enum' is equivalent to 'oneOf' with a list of 'const' entries, but 'enum'
> is more concise and yields better error messages.
> 
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Vignesh R <vigneshr@ti.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: dmaengine@vger.kernel.org
> Cc: linux-i2c@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Cc: linux-phy@lists.infradead.org
> Cc: linux-serial@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-spi@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/display/msm/dsi-phy-10nm.yaml           |  6 +++---
>  .../bindings/display/msm/dsi-phy-14nm.yaml           |  6 +++---
>  .../bindings/display/msm/dsi-phy-28nm.yaml           |  8 ++++----
>  .../bindings/dma/allwinner,sun6i-a31-dma.yaml        | 12 ++++++------
>  .../devicetree/bindings/firmware/arm,scpi.yaml       |  6 +++---
>  .../devicetree/bindings/i2c/ti,omap4-i2c.yaml        | 10 +++++-----
>  .../interrupt-controller/loongson,liointc.yaml       |  8 ++++----
>  .../devicetree/bindings/media/i2c/mipi-ccs.yaml      |  8 ++++----
>  .../devicetree/bindings/mfd/ti,lp87565-q1.yaml       |  6 +++---

Acked-by: Lee Jones <lee.jones@linaro.org>

>  .../devicetree/bindings/net/realtek-bluetooth.yaml   |  8 ++++----
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml          |  8 ++++----
>  .../devicetree/bindings/net/ti,k3-am654-cpts.yaml    |  6 +++---
>  Documentation/devicetree/bindings/pci/loongson.yaml  |  8 ++++----
>  .../devicetree/bindings/phy/intel,lgm-emmc-phy.yaml  |  6 +++---
>  .../devicetree/bindings/serial/8250_omap.yaml        |  9 +++++----
>  .../devicetree/bindings/sound/qcom,sm8250.yaml       |  6 +++---
>  .../devicetree/bindings/sound/tlv320adcx140.yaml     |  8 ++++----
>  .../devicetree/bindings/spi/realtek,rtl-spi.yaml     | 12 ++++++------
>  .../devicetree/bindings/timer/arm,sp804.yaml         |  6 +++---
>  19 files changed, 74 insertions(+), 73 deletions(-)

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
