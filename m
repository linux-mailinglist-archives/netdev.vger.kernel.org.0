Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D37AC221
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 23:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404506AbfIFVmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 17:42:45 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35967 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404330AbfIFVmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 17:42:45 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46Q9yV3rdlz1rBnG;
        Fri,  6 Sep 2019 23:42:42 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46Q9yT6wDbz1qqkL;
        Fri,  6 Sep 2019 23:42:41 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id t9OQ9xgR4JfV; Fri,  6 Sep 2019 23:42:40 +0200 (CEST)
X-Auth-Info: XI9LOAh4ifYqfsMPbJx/yTDhFQxMQ7fjF21BOqFvQ+A=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri,  6 Sep 2019 23:42:40 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
Subject: Re: [PATCH net-next 1/3] net: dsa: microchip: add KSZ9477 I2C driver
To:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20190906213054.48908-1-george.mccollister@gmail.com>
 <20190906213054.48908-2-george.mccollister@gmail.com>
Message-ID: <b1e98d5e-50b7-1f2f-6874-9515fcf2b540@denx.de>
Date:   Fri, 6 Sep 2019 23:39:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906213054.48908-2-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/19 11:30 PM, George McCollister wrote:

[...]

> --- /dev/null
> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Microchip KSZ9477 series register access through I2C
> + *
> + * Copyright (C) 2018-2019 Microchip Technology Inc.

Doesn't the copyright need update ?

> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/i2c.h>

Please keep the headers sorted.

> +#include "ksz_common.h"
> +
> +KSZ_REGMAP_TABLE(ksz9477, not_used, 16, 0, 0);
> +

The rest looks good.

[...]

-- 
Best regards,
Marek Vasut
