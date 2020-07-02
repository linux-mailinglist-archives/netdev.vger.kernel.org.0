Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999ED212F7D
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgGBW3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbgGBW3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 18:29:42 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1CFC08C5C1;
        Thu,  2 Jul 2020 15:29:41 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h22so27101620lji.9;
        Thu, 02 Jul 2020 15:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xxQFr1BqDEffTMIbjj2nr78urbKnKQfjZ+rNpfgSt08=;
        b=H5Eg11Z9hn0nAlgWO7xYNhfv0JqaLDjFb6T3TNFC4HAhEYM+NAykFGb40mVhLCEyP8
         89J6eu0fEwy/nisaUDezq6zLhobof7rGWCcDy5p0cCVTOXcIu91LT30adquKyk1RDcpo
         R5Za4WEURUdOtucQnivvJbaFYfMj1p1AiBdGYkZobOlKsMz4CJb9Ka5vqgX3hio6nEU4
         LApjtLJ4mIuzgwD1Y67rCWqyTi0T9ViqnT9MwX/X1hWv+OdjGDDvjuKJNvyfqdALZyHz
         0mSG7VtcmsjqA6JIA87D7xXr4IJ1fsqhQNS3ljpAHMYqKSLCfPIHnHNt2Yc6kXHAekRe
         UYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xxQFr1BqDEffTMIbjj2nr78urbKnKQfjZ+rNpfgSt08=;
        b=CSibwBh/B0WsD7+B82rXM6+1vIXOLEhiI2gh5BrIOX1NRaPN87smcsBiA7oaIaK5KV
         XeaUkL8flzwozIPN0oyDlz7q79aCFiGEwX8hjqoReYJ4BZEey5mHI7PvTuomkoay5Ahq
         l6anU8UtU9LWyob9V00++5CfXGDqfX9+Ib/k2ZWFMmBe/AQbQccFuBbCQ1Qtrn9fFqDx
         cWifNg/TzxJo4ly4oFISCoX5YwhZ48tYvMnEYN8C+gIpTO30YBvxXxyX6BKbH2ZkmAdO
         LgL01WHbtkfAwH0qiacnm2NHXCE3R+VAMkDw+CsoC6rfsPKmKUN6s8M6Fa06McyKqCHO
         82lg==
X-Gm-Message-State: AOAM530smaHNs+5c0HEGujinBLUCOsoMgvL1xaihhLU/Q5gBtXJpbC7w
        +VtW/QG37zujmIwL5LzEIYFatjCO4eA2nKCQtLU=
X-Google-Smtp-Source: ABdhPJw63DHFOW+2oJ387eLmT45jEZ5gsdDYBXDveJ+O6iDUw8rDJqoTS4F60kuHr07mYRB3M3UDRSi7vwC3QvZSNpQ=
X-Received: by 2002:a2e:9e87:: with SMTP id f7mr18422139ljk.44.1593728980418;
 Thu, 02 Jul 2020 15:29:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200702175352.19223-1-TheSven73@gmail.com> <20200702175352.19223-3-TheSven73@gmail.com>
In-Reply-To: <20200702175352.19223-3-TheSven73@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 2 Jul 2020 19:29:29 -0300
Message-ID: <CAOMZO5DxUeXH8ZYxmKynA7xO3uF6SP_Kt-g=8MPgsF7tqkRvAA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] ARM: imx6plus: optionally enable internal routing
 of clk_enet_ref
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Shawn Guo <shawnguo@kernel.org>, Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sven,

On Thu, Jul 2, 2020 at 2:53 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:

> +       /*
> +        * On imx6 plus, enet_ref from ANATOP/CCM can be internally routed to
> +        * be the PTP clock source, instead of having to be routed through
> +        * pads.
> +        */
> +       if (of_machine_is_compatible("fsl,imx6qp")) {
> +               clksel = of_property_read_bool(np, "fsl,ptpclk-bypass-pad") ?
> +                               IMX6Q_GPR5_ENET_TXCLK_SEL_PLL :
> +                               IMX6Q_GPR5_ENET_TXCLK_SEL_PAD;
> +               regmap_update_bits(gpr, IOMUXC_GPR5,
> +                                  IMX6Q_GPR5_ENET_TXCLK_SEL_MASK, clksel);
> +       }

With the device tree approach, I think that a better place to touch
GPR5 would be inside the fec driver.

You can refer to drivers/pci/controller/dwc/pci-imx6.c and follow the
same approach for accessing the GPR register:
...
/* Grab GPR config register range */
imx6_pcie->iomuxc_gpr =
syscon_regmap_lookup_by_compatible("fsl,imx6q-iomuxc-gpr")

For the property name, what about fsl,txclk-from-pll?
