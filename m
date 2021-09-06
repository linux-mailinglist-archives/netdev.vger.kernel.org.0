Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7870D4019F7
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 12:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242143AbhIFKlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 06:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhIFKlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 06:41:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1920B60EBA;
        Mon,  6 Sep 2021 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630924818;
        bh=DDPfs7HWdQxUNn6g1tSkQLKbmCHfs6sAw/+UHBIdi/M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Th9BCpYBnVmKPtw+yozEi03DflXbpHZnsOAy4Jc0WTQbi+twSgb1XrzHHguyEtFuD
         unLwYfRWOgpMIlwzUdVta6PvLtBhb/hhKQ5qEENKV7U9Q2LFFvwWeMqWPPk6Ap99ke
         t2pEWUD6KxAncNF8dArN3EdFE4wFqS1pAblmOOdgP+5BvHtbm3NKW50g544B2Y1M7A
         0XwU7gfX6Z1zYK/ZPcefKlnE2u5JqlMtdYXMpq/QSt/s/+ZJTfO/4ugaIfwejhWnlB
         f5vXatWtRfzOn3a/PJ5ZMIbaUJ+VquKa0OnNdFXWmQbxRvwTPgstQShQxiAmi1QiQD
         A+2M66YfjlnIQ==
Date:   Mon, 6 Sep 2021 12:40:11 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Vignesh R <vigneshr@ti.com>, Marc Zyngier <maz@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
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
Message-ID: <20210906124011.66b8e9f3@coco.lan>
In-Reply-To: <20210824202014.978922-1-robh@kernel.org>
References: <20210824202014.978922-1-robh@kernel.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 24 Aug 2021 15:20:14 -0500
Rob Herring <robh@kernel.org> escreveu:

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

For media:

Acked-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Thanks,
Mauro
