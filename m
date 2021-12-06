Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CC54691D4
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhLFI66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbhLFI65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:58:57 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DF6C061354
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 00:55:29 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id d24so21001024wra.0
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 00:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=STO5Jj3dQ1sXzYML+OEYKU3DftiKlpT/Vhi6uTR5tsw=;
        b=WKb8gZZdVZzkeKXGZzLPX/fdigN1/PCfTTSLLiS672hWdi3ikas1tsV2H8JiVrUtpI
         +PyZVZhzame2RZd280yDUJruRvVjzucgK4Cd6Imv3YCa0w1r7new7nepF6aiS6PK9K39
         uYE5FXUzRmXkWdDkSnY045KmcgvFbyla5ve6ufYhN5mWPCRq5spBuTm1KYul275RV8kq
         yqpHdyY0q6esFpDBt7A2fUmLb1byJVRlTuf/TWHeSYYIO/lj/gbxa1BlgDTQHgbsZhab
         8oEziyGN8FeCilzG2/jGnUk+/H9dVz9GzjBHHfnyUs5On+n17AC72qG5/FYMpMK2xd5V
         I+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=STO5Jj3dQ1sXzYML+OEYKU3DftiKlpT/Vhi6uTR5tsw=;
        b=Ttk5CkE3XTSUjcrzEvKSok4EGaHerIYngtJ4OTzikNI1GQXQaKBM3uu6ufL0/kMi/2
         ADXURq1iohjvqv2nTUsVVVigNh89HKW4p1bRDbTvpaw8VmwZYZ58jTc6SDl+yya9oBWM
         hT4ErPBQj7fKu76UOsKMbPgyu4yFdQsk1xYKmx0mgsVRFm4z2Vdaw+O8WeQC20PmbGof
         QM4WWYTKeDS7nABY8xmGQ5YSkSra3zbR43vgI3zlkX5g7tj5H3MvBqdWQvF9nxAXyIjj
         ZKIArkHa+qqeG2IRid7vB+xLYJCsTX0OHR5LqVkqQ+3gX+v+RIHOA8OeURlMpf6PhGOH
         bLaQ==
X-Gm-Message-State: AOAM5339Xh5BJmGJPAcxmowJhRuIw9k35mNTmbLo9QH+Oacm4teG085h
        vF2Jprvv7FrDIk7DxPcayg6Fj00L1Q1lUA==
X-Google-Smtp-Source: ABdhPJwaIiJ3n8JFLStZ486JkHxVBTxr9uvbdyc+8Pot1eFpl+prjMp40JwvJBR3lMR8RxIWcl+NTQ==
X-Received: by 2002:a5d:5588:: with SMTP id i8mr41456170wrv.552.1638780927546;
        Mon, 06 Dec 2021 00:55:27 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id g13sm14342509wrd.57.2021.12.06.00.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 00:55:27 -0800 (PST)
Date:   Mon, 6 Dec 2021 08:55:25 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        katie.morris@in-advantage.com
Subject: Re: [RFC v1] mfd: pinctrl: RFC only: add and utilze mfd option in
 pinctrl-ocelot
Message-ID: <Ya3P/Z3jbMpV1Fso@google.com>
References: <20211203211611.946658-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211203211611.946658-1-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Dec 2021, Colin Foster wrote:

> This is a psuedo-commit, but one that tells the complete story of what I'm
> looking at. During an actual submission this'll be broken up into two
> commits, but I'd like to get some feedback on whether this is the correct
> path for me to be going down.
> 
> Background:
> 
> Microchip has a family of chips - the VSC7511, 7512, 7513, and 7514. The
> last two have an internal MIPS processor, which are supported by
> drivers/net/ethernet/mscc/ocelot_*. The former two lack this processor.
> 
> All four chips can be configured externally via a number of interfaces:
> SPI, I2C, PCIe... This is currently not supported and is my end goal.
> 
> The networking portion of these chips have been reused in other products as
> well. These utilize the common code by way of mscc_ocelot_switch_lib and
> net/dsa/ocelot/*. Specifically the "Felix" driver.
> 
> Current status:
> 
> I've put out a few RFCs on the "ocelot_spi" driver. It utilizes Felix and
> invokes much of the network portion of the hardware (VSC7512). It works
> great! Thanks community :)
> 
> There's more hardware that needs to get configured, however. Currently that
> includes general pin configuration, and an optional serial GPIO expander.
> The former is supported by drivers/pinctrl/pinctrl-ocelot.c and the latter
> by drivers/pinctrl/pinctrl-microchip-sgpio.c.
> 
> These drivers have been updated to use regmap instead of iomem, but that
> isn't the complete story. There are two options I know about, and maybe
> others I don't.
> 
> Option 1 - directly hook into the driver:
> 
> This was the path that was done in
> commit b99658452355 ("net: dsa: ocelot: felix: utilize shared mscc-miim
> driver for indirect MDIO access").
> This is in the net-next tree. In this case the Seville driver passes in its
> regmap to the mscc_miim_setup function, which bypasses mscc_miim_probe but
> allows the same driver to be used.
> 
> This was my initial implementation to hook into pinctrl-ocelot and
> pinctrl-microchip-sgpio. The good thing about this implementation is I have
> direct control over the order of things happening. For instance, pinctrl
> might need to be configured before the MDIO bus gets probed.
> 
> The bad thing about this implementation is... it doesn't work yet. My
> memory is fuzzy on this, but I recall noticing that the application of a
> devicetree pinctrl function happens in the driver probe. I ventured down
> this path of walking the devicetree, applying pincfg, etc. That was a path
> to darkness that I have abandoned.
> 
> What is functioning is I have debugfs / sysfs control, so I do have the
> ability to do some runtime testing and verification.
> 
> Option 2 - MFD (this "patch")
> 
> It really seems like anything in drivers/net/dsa/ should avoid
> drivers/pinctl, and that MFD is the answer. This adds some complexity to
> pinctrl-ocelot, and I'm not sure whether that breaks the concept of MFD. So
> it seems like I'm either doing something unique, or I'm doing something
> wrong.
> 
> I err on the assumption that I'm doing something wrong.
> 
> pinctrl-ocelot gets its resources the device tree by way of
> platform_get_and_ioremap_resource. This driver has been updated to support
> regmap in the pinctrl tree:
> commit 076d9e71bcf8 ("pinctrl: ocelot: convert pinctrl to regmap")
> 
> The problem comes about when this driver is probed by way of
> "mfd_add_devices". In an ideal world it seems like this would be handled by
> resources. MFD adds resources to the device before it gets probed. The
> probe happens and the driver is happy because platform_get_resource
> succeeds.
> 
> In this scenario the device gets probed, but needs to know how to get its
> regmap... not its resource. In the "I'm running from an internal chip"
> scenario, the existing process of "devm_regmap_init_mmio" will suffice. But
> in the "I'm running from an externally controlled setup via {SPI,I2C,PCIe}"
> the process needs to be "get me this regmap from my parent". It seems like
> dev_get_regmap is a perfect candidate for this.
> 
> Perhaps there is something I'm missing in the concept of resources /
> regmaps. But it seems like pinctrl-ocelot needs to know whether it is in an
> MFD scenario, and that concept didn't exist. Hence the addition of
> device_is_mfd as part of this patch. Since "device_is_mfd" didn't exist, it
> feels like I might be breaking the concept of MFD.
> 
> I think this would lend itself to a pretty elegant architecture for the
> VSC751X externally controlled chips. In a manner similar to
> drivers/mfd/madera* there would be small drivers handling the prococol
> layers for SPI, I2C... A core driver would handle the register mappings,
> and could be gotten by dev_get_regmap. Every sub-device (DSA, pinctrl,
> other pinctrl, other things I haven't considered yet) could either rely on
> dev->parent directly, or in this case adjust. I can't imagine a scenario
> where someone would want pinctrl for the VSC7512 without the DSA side of
> things... but that would be possible in this architecture that would
> otherwise not.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/mfd/mfd-core.c           | 6 ++++++
>  drivers/pinctrl/pinctrl-ocelot.c | 7 ++++++-
>  include/linux/mfd/core.h         | 2 ++
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 684a011a6396..2ba6a692499b 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -33,6 +33,12 @@ static struct device_type mfd_dev_type = {
>  	.name	= "mfd_device",
>  };
>  
> +int device_is_mfd(struct platform_device *pdev)
> +{
> +	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
> +}
> +EXPORT_SYMBOL(device_is_mfd);
> +
>  int mfd_cell_enable(struct platform_device *pdev)
>  {
>  	const struct mfd_cell *cell = mfd_get_cell(pdev);
> diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> index 0a36ec8775a3..758fbc225244 100644
> --- a/drivers/pinctrl/pinctrl-ocelot.c
> +++ b/drivers/pinctrl/pinctrl-ocelot.c
> @@ -10,6 +10,7 @@
>  #include <linux/gpio/driver.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> +#include <linux/mfd/core.h>
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
> @@ -1368,7 +1369,11 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
>  
>  	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
>  
> -	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
> +	if (device_is_mfd(pdev))
> +		info->map = dev_get_regmap(dev->parent, "GCB");
> +	else
> +		info->map = devm_regmap_init_mmio(dev, base, &regmap_config);

What happens if you were to call the wrong API in either scenario?

If the answer is 'the call would fail', then why not call one and if
it fails, call the other?  With provided commits describing the
reason for the stacked calls of course.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
