Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AFB95747
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 08:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbfHTGXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 02:23:14 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:48743 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbfHTGXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 02:23:13 -0400
X-Originating-IP: 90.65.161.137
Received: from localhost (lfbn-1-1545-137.w90-65.abo.wanadoo.fr [90.65.161.137])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id C639B40008;
        Tue, 20 Aug 2019 06:23:08 +0000 (UTC)
Date:   Tue, 20 Aug 2019 08:23:08 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 15/17] mfd: ioc3: Add driver for SGI IOC3 chip
Message-ID: <20190820062308.GK3545@piout.net>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
 <20190819163144.3478-16-tbogendoerfer@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819163144.3478-16-tbogendoerfer@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 19/08/2019 18:31:38+0200, Thomas Bogendoerfer wrote:
> diff --git a/drivers/mfd/ioc3.c b/drivers/mfd/ioc3.c
> new file mode 100644
> index 000000000000..5bcb3461a189
> --- /dev/null
> +++ b/drivers/mfd/ioc3.c
> @@ -0,0 +1,586 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * SGI IOC3 multifunction device driver
> + *
> + * Copyright (C) 2018, 2019 Thomas Bogendoerfer <tbogendoerfer@suse.de>
> + *
> + * Based on work by:
> + *   Stanislaw Skowronek <skylark@unaligned.org>
> + *   Joshua Kinard <kumba@gentoo.org>
> + *   Brent Casavant <bcasavan@sgi.com> - IOC4 master driver
> + *   Pat Gefre <pfg@sgi.com> - IOC3 serial port IRQ demuxer
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/interrupt.h>
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/platform_data/sgi-w1.h>
> +#include <linux/rtc/ds1685.h>
I don't think this include is necessary.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
