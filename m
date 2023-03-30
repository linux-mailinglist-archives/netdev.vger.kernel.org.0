Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855586D080F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjC3OVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjC3OVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:21:37 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CF7C64F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 07:21:15 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id y14so19281516wrq.4
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 07:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680186071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfjgn2sklT68/0BLeF+AeFT45mcxXZf7FXc0FH6Wl20=;
        b=GwQkyFczagEwSP/T4r+ynsFphEKSQTfFKzBBpMV3x/6tlPBpBId0PDVaCRQMseg8sA
         8aTHCb07YgMglNdMTNBcdmkd4B0b8ZE9OQFHG8xwLaiivqxbESFdX29IqrHJbruo1niC
         dgPT4cmJaXJv35HiEBYb43nXki+IvPyrkox615l/A6abnjFKmYtuJwmn8wVI+KwxFbJp
         QCXMqp0uhu07kiKfqQGsIlQXlOTMyrx6ZnPCfIDRquePY3zxql2/9xAUwa+CHmgcA6uY
         VHBRo4nTeVm0WYSFTJLNtVPLMsBKAefnYQ6Y4BDtqnv5GwXtAr3ajAwoAGF6H+qnu5JE
         XLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680186071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sfjgn2sklT68/0BLeF+AeFT45mcxXZf7FXc0FH6Wl20=;
        b=yJWV5PBSj40cHpJKcvgnNR7Ag5C/JNiV4VB1vC91Ruuv4ChLEB/V8vRiU1jQMwr9jw
         fdPBnZuQ+2rsDsAJpZDZihX7oxrXFjL/k/Oke01MfEMmhbueEUe3nf1PEg+1VEb2tlFe
         KESGOyhbU2T8dPJSx2h+Uq7PPQQ7RFh8ct67lNpAXd39/T+C02T9hom1KcdHy4cs20wK
         TB2Wy7NhXqmybJeJfH3H4YJbW7MyTApGskKBN/+iRZh7XxKTUj6Yh7X6vwkaDoms2uzD
         pMEORAMkX1TRp3oNVc36kUYtLkG8xEAfesV4CuMxA2n5w0p5qOlaA+nXPf2o8C/kGc5x
         SiKw==
X-Gm-Message-State: AAQBX9dbtW9g0jXTn3gdK8K+uFxAXG+bbSaPhlyY5dB8UAXmJSPlwup/
        uQl/zo97hGKSj8gyJHuqjq/eaOlEUeg2kdfbEeVBeREhWZIzKmrU
X-Google-Smtp-Source: AKy350YW/TLCSUTasJvb+twytxxuh4IwsLR1qvC1jNpbA1Tx7TAo0p3sJxo1L0jBKBVevjs1xmX0N5y3Go5scX2UhbM=
X-Received: by 2002:a5d:4349:0:b0:2df:ebbe:7d46 with SMTP id
 u9-20020a5d4349000000b002dfebbe7d46mr2838344wrr.2.1680186071175; Thu, 30 Mar
 2023 07:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230323062451.2925996-1-danishanwar@ti.com> <20230323062451.2925996-4-danishanwar@ti.com>
 <20230327210126.GC3158115@p14s> <4e239000-c5f7-a42e-157e-5b668c6b2908@ti.com>
In-Reply-To: <4e239000-c5f7-a42e-157e-5b668c6b2908@ti.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Thu, 30 Mar 2023 08:21:00 -0600
Message-ID: <CANLsYkxcprFh4SNxb=TkTLT7PNR6=QPFW5HhqPouPP3+oYk7Sg@mail.gmail.com>
Subject: Re: [EXTERNAL] Re: [PATCH v5 3/5] soc: ti: pruss: Add
 pruss_cfg_read()/update() API
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 at 04:00, Md Danish Anwar <a0501179@ti.com> wrote:
>
> Hi Mathieu,
>
> On 28/03/23 02:31, Mathieu Poirier wrote:
> > On Thu, Mar 23, 2023 at 11:54:49AM +0530, MD Danish Anwar wrote:
> >> From: Suman Anna <s-anna@ti.com>
> >>
> >> Add two new generic API pruss_cfg_read() and pruss_cfg_update() to
> >> the PRUSS platform driver to read and program respectively a register
> >> within the PRUSS CFG sub-module represented by a syscon driver.
> >>
> >> These APIs are internal to PRUSS driver. Various useful registers
> >> and macros for certain register bit-fields and their values have also
> >> been added.
> >>
> >> Signed-off-by: Suman Anna <s-anna@ti.com>
> >> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> >> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> >> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> >> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> >> ---
> >>  drivers/soc/ti/pruss.c |   1 +
> >>  drivers/soc/ti/pruss.h | 112 ++++++++++++++++++++++++++++++++++++++++=
+
> >>  2 files changed, 113 insertions(+)
> >>  create mode 100644 drivers/soc/ti/pruss.h
> >>
> >
> > This patch doesn't compile without warnings.
> >
>
> I checked the warnings. Below are the warnings that I am getting for thes=
e patch.
>
> In file included from drivers/soc/ti/pruss.c:24:
> drivers/soc/ti/pruss.h:103:12: warning: =E2=80=98pruss_cfg_update=E2=80=
=99 defined but not used
> [-Wunused-function]
>   103 | static int pruss_cfg_update(struct pruss *pruss, unsigned int reg=
,
>       |            ^~~~~~~~~~~~~~~~
> drivers/soc/ti/pruss.h:84:12: warning: =E2=80=98pruss_cfg_read=E2=80=99 d=
efined but not used
> [-Wunused-function]
>    84 | static int pruss_cfg_read(struct pruss *pruss, unsigned int reg,
> unsigned int *val)
>
> These warnings are coming because pruss_cfg_read() / update() APIs are
> introduced in this patch but they are used later.
>
> One way to resolve this warning is to make this API "inline". I compiled =
after
> making these APIs inline, it got compiled without any warnings.
>
> The other solution is to merge a user API of these APIs in this patch. Pa=
tch 4
> and 5 introduces some APIs that uses pruss_cfg_read() / update() APIs. If=
 we
> squash patch 5 (as patch 5 uses both read() and update() APIs where as pa=
tch 4
> only uses update() API) with this patch and make it a single patch where
> pruss_cfg_read() / update() is introduced as well as used, then this warn=
ing
> will be resolved.
>

The proper way to do this is to introduce new APIs only when they are neede=
d.

> I still think making these APIs "inline" is a better option as these APIs
> implement very simple one line logic and can be made inline.
>
> Please let me know what do you think and which approach sounds better.
>
>
> >> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> >> index 126b672b9b30..2fa7df667592 100644
> >> --- a/drivers/soc/ti/pruss.c
> >> +++ b/drivers/soc/ti/pruss.c
> >> @@ -21,6 +21,7 @@
> >>  #include <linux/regmap.h>
> >>  #include <linux/remoteproc.h>
> >>  #include <linux/slab.h>
> >> +#include "pruss.h"
> >>
> >>  /**
> >>   * struct pruss_private_data - PRUSS driver private data
> >> diff --git a/drivers/soc/ti/pruss.h b/drivers/soc/ti/pruss.h
> >> new file mode 100644
> >> index 000000000000..4626d5f6b874
> >> --- /dev/null
> >> +++ b/drivers/soc/ti/pruss.h
> >> @@ -0,0 +1,112 @@
> >> +/* SPDX-License-Identifier: GPL-2.0-only */
> >> +/*
> >> + * PRU-ICSS Subsystem user interfaces
> >> + *
> >> + * Copyright (C) 2015-2023 Texas Instruments Incorporated - http://ww=
w.ti.com
> >> + *  MD Danish Anwar <danishanwar@ti.com>
> >> + */
> >> +
> >> +#ifndef _SOC_TI_PRUSS_H_
> >> +#define _SOC_TI_PRUSS_H_
> >> +
> >> +#include <linux/bits.h>
> >> +#include <linux/regmap.h>
> >> +
> >> +/*
> >> + * PRU_ICSS_CFG registers
> >> + * SYSCFG, ISRP, ISP, IESP, IECP, SCRP applicable on AMxxxx devices o=
nly
> >> + */
> >> +#define PRUSS_CFG_REVID         0x00
> >> +#define PRUSS_CFG_SYSCFG        0x04
> >> +#define PRUSS_CFG_GPCFG(x)      (0x08 + (x) * 4)
> >> +#define PRUSS_CFG_CGR           0x10
> >> +#define PRUSS_CFG_ISRP          0x14
> >> +#define PRUSS_CFG_ISP           0x18
> >> +#define PRUSS_CFG_IESP          0x1C
> >> +#define PRUSS_CFG_IECP          0x20
> >> +#define PRUSS_CFG_SCRP          0x24
> >> +#define PRUSS_CFG_PMAO          0x28
> >> +#define PRUSS_CFG_MII_RT        0x2C
> >> +#define PRUSS_CFG_IEPCLK        0x30
> >> +#define PRUSS_CFG_SPP           0x34
> >> +#define PRUSS_CFG_PIN_MX        0x40
> >> +
> >> +/* PRUSS_GPCFG register bits */
> >> +#define PRUSS_GPCFG_PRU_GPO_SH_SEL              BIT(25)
> >> +
> >> +#define PRUSS_GPCFG_PRU_DIV1_SHIFT              20
> >> +#define PRUSS_GPCFG_PRU_DIV1_MASK               GENMASK(24, 20)
> >> +
> >> +#define PRUSS_GPCFG_PRU_DIV0_SHIFT              15
> >> +#define PRUSS_GPCFG_PRU_DIV0_MASK               GENMASK(15, 19)
> >> +
> >> +#define PRUSS_GPCFG_PRU_GPO_MODE                BIT(14)
> >> +#define PRUSS_GPCFG_PRU_GPO_MODE_DIRECT         0
> >> +#define PRUSS_GPCFG_PRU_GPO_MODE_SERIAL         BIT(14)
> >> +
> >> +#define PRUSS_GPCFG_PRU_GPI_SB                  BIT(13)
> >> +
> >> +#define PRUSS_GPCFG_PRU_GPI_DIV1_SHIFT          8
> >> +#define PRUSS_GPCFG_PRU_GPI_DIV1_MASK           GENMASK(12, 8)
> >> +
> >> +#define PRUSS_GPCFG_PRU_GPI_DIV0_SHIFT          3
> >> +#define PRUSS_GPCFG_PRU_GPI_DIV0_MASK           GENMASK(7, 3)
> >> +
> >> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_POSITIVE   0
> >> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE_NEGATIVE   BIT(2)
> >> +#define PRUSS_GPCFG_PRU_GPI_CLK_MODE            BIT(2)
> >> +
> >> +#define PRUSS_GPCFG_PRU_GPI_MODE_MASK           GENMASK(1, 0)
> >> +#define PRUSS_GPCFG_PRU_GPI_MODE_SHIFT          0
> >> +
> >> +#define PRUSS_GPCFG_PRU_MUX_SEL_SHIFT           26
> >> +#define PRUSS_GPCFG_PRU_MUX_SEL_MASK            GENMASK(29, 26)
> >> +
> >> +/* PRUSS_MII_RT register bits */
> >> +#define PRUSS_MII_RT_EVENT_EN                   BIT(0)
> >> +
> >> +/* PRUSS_SPP register bits */
> >> +#define PRUSS_SPP_XFER_SHIFT_EN                 BIT(1)
> >> +#define PRUSS_SPP_PRU1_PAD_HP_EN                BIT(0)
> >> +#define PRUSS_SPP_RTU_XFR_SHIFT_EN              BIT(3)
> >> +
> >> +/**
> >> + * pruss_cfg_read() - read a PRUSS CFG sub-module register
> >> + * @pruss: the pruss instance handle
> >> + * @reg: register offset within the CFG sub-module
> >> + * @val: pointer to return the value in
> >> + *
> >> + * Reads a given register within the PRUSS CFG sub-module and
> >> + * returns it through the passed-in @val pointer
> >> + *
> >> + * Return: 0 on success, or an error code otherwise
> >> + */
> >> +static int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsi=
gned int *val)
> >> +{
> >> +    if (IS_ERR_OR_NULL(pruss))
> >> +            return -EINVAL;
> >> +
> >> +    return regmap_read(pruss->cfg_regmap, reg, val);
> >> +}
> >> +
> >> +/**
> >> + * pruss_cfg_update() - configure a PRUSS CFG sub-module register
> >> + * @pruss: the pruss instance handle
> >> + * @reg: register offset within the CFG sub-module
> >> + * @mask: bit mask to use for programming the @val
> >> + * @val: value to write
> >> + *
> >> + * Programs a given register within the PRUSS CFG sub-module
> >> + *
> >> + * Return: 0 on success, or an error code otherwise
> >> + */
> >> +static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
> >> +                        unsigned int mask, unsigned int val)
> >> +{
> >> +    if (IS_ERR_OR_NULL(pruss))
> >> +            return -EINVAL;
> >> +
> >> +    return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
> >> +}
> >> +
> >> +#endif  /* _SOC_TI_PRUSS_H_ */
> >> --
> >> 2.25.1
> >>
>
> --
> Thanks and Regards,
> Danish.
