Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD7D41EA1C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353204AbhJAJyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:54:17 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15216 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353121AbhJAJyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 05:54:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633081951; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=2bttLv42HrO8OSNS4BdRIDDtX+8/+9g8pCv8FTqYHyI=; b=Qr2zPMnIy3bNVfalULgSjcVeWGuGZgXvH/cOk18lfDPZDDvl6BwmpEzI5ZVyv2JTQY1Xhhba
 8Kc9XkbmlIGGPPCmojBizlvXZ79PxU3MDWp4MKCyVWfV4ETiRgYUegSGBes7VzM6vW1tgE23
 InbxdT/chHVPtLGY5F8rhzd72yU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6156da5e605ecf100b477d37 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 09:52:30
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E3BECC4361A; Fri,  1 Oct 2021 09:52:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CDC00C4338F;
        Fri,  1 Oct 2021 09:52:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org CDC00C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 09/24] wfx: add hwio.c/hwio.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-10-Jerome.Pouiller@silabs.com>
Date:   Fri, 01 Oct 2021 12:52:20 +0300
In-Reply-To: <20210920161136.2398632-10-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Mon, 20 Sep 2021 18:11:21 +0200")
Message-ID: <87k0ixkr6z.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/net/wireless/silabs/wfx/hwio.c | 340 +++++++++++++++++++++++++
>  drivers/net/wireless/silabs/wfx/hwio.h |  79 ++++++

[...]

> +static int indirect_read(struct wfx_dev *wdev, int reg, u32 addr,
> +			 void *buf, size_t len)
> +{
> +	int ret;
> +	int i;
> +	u32 cfg;
> +	u32 prefetch;
> +
> +	WARN_ON(len >=3D 0x2000);

A define for the magic value, please. I see this 0x2000 limit multiple
times.

> +	WARN_ON(reg !=3D WFX_REG_AHB_DPORT && reg !=3D WFX_REG_SRAM_DPORT);

I see quite a lot of WARN() and WARN_ON() in the driver. Do note that
WARN() and WARN_ON() are a bit dangerous to use in the data path as an
attacker, or even just a bug, might easily spam the kernel log which
might result to host reboots due to watchdog triggering or other
resource starvation. I recommend using some ratelimited versions of
printk() macros, for example dev_*() if they have ratelimits. Not a
blocker, but wanted to point out anyway.

> +int wfx_data_read(struct wfx_dev *wdev, void *buf, size_t len)
> +{
> +	int ret;
> +
> +	WARN((long)buf & 3, "%s: unaligned buffer", __func__);

IS_ALIGNED()?

> +	wdev->hwbus_ops->lock(wdev->hwbus_priv);
> +	ret =3D wdev->hwbus_ops->copy_from_io(wdev->hwbus_priv,
> +					    WFX_REG_IN_OUT_QUEUE, buf, len);
> +	_trace_io_read(WFX_REG_IN_OUT_QUEUE, buf, len);
> +	wdev->hwbus_ops->unlock(wdev->hwbus_priv);
> +	if (ret)
> +		dev_err(wdev->dev, "%s: bus communication error: %d\n",
> +			__func__, ret);
> +	return ret;
> +}
> +
> +int wfx_data_write(struct wfx_dev *wdev, const void *buf, size_t len)
> +{
> +	int ret;
> +
> +	WARN((long)buf & 3, "%s: unaligned buffer", __func__);

IS_ALIGNED()?

> --- /dev/null
> +++ b/drivers/net/wireless/silabs/wfx/hwio.h
> @@ -0,0 +1,79 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Low-level I/O functions.
> + *
> + * Copyright (c) 2017-2020, Silicon Laboratories, Inc.
> + * Copyright (c) 2010, ST-Ericsson
> + */
> +#ifndef WFX_HWIO_H
> +#define WFX_HWIO_H
> +
> +#include <linux/types.h>
> +
> +struct wfx_dev;
> +
> +/* Caution: in the functions below, 'buf' will used with a DMA. So, it m=
ust be
> + * kmalloc'd (do not use stack allocated buffers). In doubt, enable
> + * CONFIG_DEBUG_SG to detect badly located buffer.
> + */
> +int wfx_data_read(struct wfx_dev *wdev, void *buf, size_t buf_len);
> +int wfx_data_write(struct wfx_dev *wdev, const void *buf, size_t buf_len=
);
> +
> +int sram_buf_read(struct wfx_dev *wdev, u32 addr, void *buf, size_t len);
> +int sram_buf_write(struct wfx_dev *wdev, u32 addr, const void *buf, size=
_t len);
> +
> +int ahb_buf_read(struct wfx_dev *wdev, u32 addr, void *buf, size_t len);
> +int ahb_buf_write(struct wfx_dev *wdev, u32 addr, const void *buf, size_=
t len);
> +
> +int sram_reg_read(struct wfx_dev *wdev, u32 addr, u32 *val);
> +int sram_reg_write(struct wfx_dev *wdev, u32 addr, u32 val);
> +
> +int ahb_reg_read(struct wfx_dev *wdev, u32 addr, u32 *val);
> +int ahb_reg_write(struct wfx_dev *wdev, u32 addr, u32 val);

"wfx_" prefix missing from these functions.

> +int config_reg_read(struct wfx_dev *wdev, u32 *val);
> +int config_reg_write(struct wfx_dev *wdev, u32 val);
> +int config_reg_write_bits(struct wfx_dev *wdev, u32 mask, u32 val);
> +
> +#define CTRL_NEXT_LEN_MASK   0x00000FFF
> +#define CTRL_WLAN_WAKEUP     0x00001000
> +#define CTRL_WLAN_READY      0x00002000
> +int control_reg_read(struct wfx_dev *wdev, u32 *val);
> +int control_reg_write(struct wfx_dev *wdev, u32 val);
> +int control_reg_write_bits(struct wfx_dev *wdev, u32 mask, u32 val);
> +
> +#define IGPR_RW          0x80000000
> +#define IGPR_INDEX       0x7F000000
> +#define IGPR_VALUE       0x00FFFFFF
> +int igpr_reg_read(struct wfx_dev *wdev, int index, u32 *val);
> +int igpr_reg_write(struct wfx_dev *wdev, int index, u32 val);

And these too.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
