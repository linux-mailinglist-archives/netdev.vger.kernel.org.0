Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927846CF18F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjC2R71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjC2R7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:59:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F844201
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:59:22 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id m2so16630351wrh.6
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 10:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680112760;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OJ9nha7AgNmpmpnP4RutaTZzBRrwel6kV4lGuwfHlf8=;
        b=aLjxdVe/40YaHJHwB6i2tMNnpYc9l4e81zyuv2IPGWApYcCl/erSxKBA2of1bZBHSZ
         UXzeAjnb1qRkpNRTSjcO0qJ1SrrLsImL1FV2ltdJA66H0R9FFrnTOlufw5jfVbbWj4ls
         AahADSqGwloxFoHk+PS66/3/6lM0SD9rW8QvEuMILlXm3F8tanC8E2ZjxUCFFanEpa7r
         YEfVQbaqrqtzv7TfZbLbHdIpq/9Q4+QCC2q5QqBrZXEyPISFLZoBYpL5SzNUlScgqutK
         F4OpjyeZCMugC0eWcNDcDKMkzY4EXZP0Fshf/4PPBcbQ1PkXLJXg8EIFw4hOJBeVgRjh
         BX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680112760;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OJ9nha7AgNmpmpnP4RutaTZzBRrwel6kV4lGuwfHlf8=;
        b=vfl/8xuGlKibKbG6dwX+NXsaSSGOo2uoSVDprvTeMDV9bhPe+dop1sOYE5sF0XjpXY
         rxP8OCIYbpVsbXulFwGxOIThor5FlJrUaP1+2IagSsfQLyRhq262xicqqUOZJ4JdTuCm
         jTpnuYnziYm5KA9CTQDu3UQtiMY57mpkHrxCQHTojpBJ0/Xuo3Soza8+wRqkRJMlM83c
         cI4xwvFFS3MXBJg7k50yeKRUFEsayRkea8GpPseebL1XYzyCzMEZJwpnzVtQTN6JdLiE
         nQh3c13p9gfBPHXfnH0+L1d5sEkoi/GdnMEUbwiuyBRb8fscrvXrm0LFPdAZEiuA1uDE
         6/Jw==
X-Gm-Message-State: AAQBX9ca1hUtLjUrQeJKMlG1WkkzXLnnSfHuiW5vnT2w7T0w3aFaTJZa
        Rk2OnjBDVj7sngICpl5wTyGi3jZKpkqsFzmHWP8GcA==
X-Google-Smtp-Source: AKy350akP4/NQIx5w9BQvswFfGlbVMz6q4mb9WlohNsWv2IEhZG0HeS9p9EvXUCf7t0U8BCXIWGxBfe111LBZrdT+R0=
X-Received: by 2002:adf:ec82:0:b0:2d4:167e:854d with SMTP id
 z2-20020adfec82000000b002d4167e854dmr4219882wrn.2.1680112760643; Wed, 29 Mar
 2023 10:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230323062451.2925996-1-danishanwar@ti.com> <20230323062451.2925996-2-danishanwar@ti.com>
 <20230327205841.GA3158115@p14s> <9d4c7762-615b-0fbd-76d2-87156e691928@ti.com>
In-Reply-To: <9d4c7762-615b-0fbd-76d2-87156e691928@ti.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Wed, 29 Mar 2023 11:59:09 -0600
Message-ID: <CANLsYkx6Nkrc_qSVWe53bhm9GjTDzXydiaxCB=_nL2R7ppu-qw@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: [PATCH v5 1/5] soc: ti: pruss: Add
 pruss_get()/put() API
To:     Md Danish Anwar <a0501179@ti.com>
Cc:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Mar 2023 at 23:42, Md Danish Anwar <a0501179@ti.com> wrote:
>
> Hi Mathieu,
>
> On 28/03/23 02:28, Mathieu Poirier wrote:
> > Hi Danish
> >
> > On Thu, Mar 23, 2023 at 11:54:47AM +0530, MD Danish Anwar wrote:
> >> From: Tero Kristo <t-kristo@ti.com>
> >>
> >> Add two new get and put API, pruss_get() and pruss_put() to the
> >> PRUSS platform driver to allow client drivers to request a handle
> >> to a PRUSS device. This handle will be used by client drivers to
> >> request various operations of the PRUSS platform driver through
> >> additional API that will be added in the following patches.
> >>
> >> The pruss_get() function returns the pruss handle corresponding
> >> to a PRUSS device referenced by a PRU remoteproc instance. The
> >> pruss_put() is the complimentary function to pruss_get().
> >>
> >> Co-developed-by: Suman Anna <s-anna@ti.com>
> >> Signed-off-by: Suman Anna <s-anna@ti.com>
> >> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> >> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> >> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> >> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> >> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> >> Reviewed-by: Roger Quadros <rogerq@kernel.org>
> >> ---
> >>  drivers/remoteproc/pru_rproc.c                |  2 +-
> >>  drivers/soc/ti/pruss.c                        | 60 ++++++++++++++++++-
> >>  .../{pruss_driver.h => pruss_internal.h}      |  7 ++-
> >>  include/linux/remoteproc/pruss.h              | 19 ++++++
> >>  4 files changed, 83 insertions(+), 5 deletions(-)
> >>  rename include/linux/{pruss_driver.h => pruss_internal.h} (90%)
> >>
> >> diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
> >> index b76db7fa693d..4ddd5854d56e 100644
> >> --- a/drivers/remoteproc/pru_rproc.c
> >> +++ b/drivers/remoteproc/pru_rproc.c
> >> @@ -19,7 +19,7 @@
> >>  #include <linux/of_device.h>
> >>  #include <linux/of_irq.h>
> >>  #include <linux/remoteproc/pruss.h>
> >> -#include <linux/pruss_driver.h>
> >> +#include <linux/pruss_internal.h>
> >>  #include <linux/remoteproc.h>
> >>
> >>  #include "remoteproc_internal.h"
> >> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> >> index 6882c86b3ce5..6c2bb02a521d 100644
> >> --- a/drivers/soc/ti/pruss.c
> >> +++ b/drivers/soc/ti/pruss.c
> >> @@ -6,6 +6,7 @@
> >>   * Author(s):
> >>   *  Suman Anna <s-anna@ti.com>
> >>   *  Andrew F. Davis <afd@ti.com>
> >> + *  Tero Kristo <t-kristo@ti.com>
> >>   */
> >>
> >>  #include <linux/clk-provider.h>
> >> @@ -16,8 +17,9 @@
> >>  #include <linux/of_address.h>
> >>  #include <linux/of_device.h>
> >>  #include <linux/pm_runtime.h>
> >> -#include <linux/pruss_driver.h>
> >> +#include <linux/pruss_internal.h>
> >>  #include <linux/regmap.h>
> >> +#include <linux/remoteproc.h>
> >>  #include <linux/slab.h>
> >>
> >>  /**
> >> @@ -30,6 +32,62 @@ struct pruss_private_data {
> >>      bool has_core_mux_clock;
> >>  };
> >>
> >> +/**
> >> + * pruss_get() - get the pruss for a given PRU remoteproc
> >> + * @rproc: remoteproc handle of a PRU instance
> >> + *
> >> + * Finds the parent pruss device for a PRU given the @rproc handle of the
> >> + * PRU remote processor. This function increments the pruss device's refcount,
> >> + * so always use pruss_put() to decrement it back once pruss isn't needed
> >> + * anymore.
> >> + *
> >> + * Return: pruss handle on success, and an ERR_PTR on failure using one
> >> + * of the following error values
> >> + *    -EINVAL if invalid parameter
> >> + *    -ENODEV if PRU device or PRUSS device is not found
> >> + */
> >> +struct pruss *pruss_get(struct rproc *rproc)
> >> +{
> >> +    struct pruss *pruss;
> >> +    struct device *dev;
> >> +    struct platform_device *ppdev;
> >> +
> >> +    if (IS_ERR_OR_NULL(rproc))
> >> +            return ERR_PTR(-EINVAL);
> >> +
> >
> > There is no guarantee that @rproc is valid without calling rproc_get_by_handle()
> > or pru_rproc_get().
> >
>
> Here in this API, we are checking if rproc is NULL or not. Also we are checking
> is_pru_rproc() to make sure this rproc is pru-rproc only and not some other rproc.
>
> This API will be called from driver (icssg_prueth.c) which I'll post once this
> series is merged.
>
> In the driver we are doing,
>
>         prueth->pru[slice] = pru_rproc_get(np, pru, &pruss_id);
>
>         pruss = pruss_get(prueth->pru[slice]);
>
> So, before calling pruss_get() we are in fact calling pru_rproc_get() to make
> sure it's a valid rproc.
>

You are doing the right thing but because pruss_get() is exported
globally, other people eventually using the interface may not be so
rigorous.  Add a comment to the pruss_get() function documentation
clearly mentioning it is expected the caller will have done a
pru_rproc_get() on @rproc.

> I think in this API, these two checks (NULL check and is_pru_rproc) should be
> OK as the driver is already calling pru_rproc_get() before this API.
>
> The only way to get a "pru-rproc" is by calling pru_rproc_get(), now the check
> is_pru_rproc() will only be true if it is a "pru-rproc" implying
> pru_rproc_get() was called before calling this API.
>
> Please let me know if this is OK or if any change is required.
>
> >> +    dev = &rproc->dev;
> >> +
> >> +    /* make sure it is PRU rproc */
> >> +    if (!dev->parent || !is_pru_rproc(dev->parent))
> >> +            return ERR_PTR(-ENODEV);
> >> +
> >> +    ppdev = to_platform_device(dev->parent->parent);
> >> +    pruss = platform_get_drvdata(ppdev);
> >> +    if (!pruss)
> >> +            return ERR_PTR(-ENODEV);
> >> +
> >> +    get_device(pruss->dev);
> >> +
> >> +    return pruss;
> >> +}
> >> +EXPORT_SYMBOL_GPL(pruss_get);
> >> +
> >> +/**
> >> + * pruss_put() - decrement pruss device's usecount
> >> + * @pruss: pruss handle
> >> + *
> >> + * Complimentary function for pruss_get(). Needs to be called
> >> + * after the PRUSS is used, and only if the pruss_get() succeeds.
> >> + */
> >> +void pruss_put(struct pruss *pruss)
> >> +{
> >> +    if (IS_ERR_OR_NULL(pruss))
> >> +            return;
> >> +
> >> +    put_device(pruss->dev);
> >> +}
> >> +EXPORT_SYMBOL_GPL(pruss_put);
> >> +
> >>  static void pruss_of_free_clk_provider(void *data)
> >>  {
> >>      struct device_node *clk_mux_np = data;
> >> diff --git a/include/linux/pruss_driver.h b/include/linux/pruss_internal.h
> >> similarity index 90%
> >> rename from include/linux/pruss_driver.h
> >> rename to include/linux/pruss_internal.h
> >> index ecfded30ed05..8f91cb164054 100644
> >> --- a/include/linux/pruss_driver.h
> >> +++ b/include/linux/pruss_internal.h
> >> @@ -6,9 +6,10 @@
> >>   *  Suman Anna <s-anna@ti.com>
> >>   */
> >>
> >> -#ifndef _PRUSS_DRIVER_H_
> >> -#define _PRUSS_DRIVER_H_
> >> +#ifndef _PRUSS_INTERNAL_H_
> >> +#define _PRUSS_INTERNAL_H_
> >>
> >> +#include <linux/remoteproc/pruss.h>
> >>  #include <linux/types.h>
> >>
> >>  /*
> >> @@ -51,4 +52,4 @@ struct pruss {
> >>      struct clk *iep_clk_mux;
> >>  };
> >>
> >> -#endif      /* _PRUSS_DRIVER_H_ */
> >> +#endif      /* _PRUSS_INTERNAL_H_ */
> >> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> >> index 039b50d58df2..93a98cac7829 100644
> >> --- a/include/linux/remoteproc/pruss.h
> >> +++ b/include/linux/remoteproc/pruss.h
> >> @@ -4,12 +4,14 @@
> >>   *
> >>   * Copyright (C) 2015-2022 Texas Instruments Incorporated - http://www.ti.com
> >>   *  Suman Anna <s-anna@ti.com>
> >> + *  Tero Kristo <t-kristo@ti.com>
> >>   */
> >>
> >>  #ifndef __LINUX_PRUSS_H
> >>  #define __LINUX_PRUSS_H
> >>
> >>  #include <linux/device.h>
> >> +#include <linux/err.h>
> >>  #include <linux/types.h>
> >>
> >>  #define PRU_RPROC_DRVNAME "pru-rproc"
> >> @@ -44,6 +46,23 @@ enum pru_ctable_idx {
> >>
> >>  struct device_node;
> >>  struct rproc;
> >> +struct pruss;
> >> +
> >> +#if IS_ENABLED(CONFIG_TI_PRUSS)
> >> +
> >> +struct pruss *pruss_get(struct rproc *rproc);
> >> +void pruss_put(struct pruss *pruss);
> >> +
> >> +#else
> >> +
> >> +static inline struct pruss *pruss_get(struct rproc *rproc)
> >> +{
> >> +    return ERR_PTR(-EOPNOTSUPP);
> >> +}
> >> +
> >> +static inline void pruss_put(struct pruss *pruss) { }
> >> +
> >> +#endif /* CONFIG_TI_PRUSS */
> >>
> >>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)
> >>
> >> --
> >> 2.25.1
> >>
>
> --
> Thanks and Regards,
> Danish.
