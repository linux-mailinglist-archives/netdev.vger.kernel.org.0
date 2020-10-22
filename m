Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EE0295F4A
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 15:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899235AbgJVNEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 09:04:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507448AbgJVNEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 09:04:25 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVaGV-002yOS-8X; Thu, 22 Oct 2020 15:04:23 +0200
Date:   Thu, 22 Oct 2020 15:04:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Charles Hsu <hsu.yuegteng@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] hwmon: (pmbus) Add driver for STMicroelectronics
 PM6764TR Voltage Regulator
Message-ID: <20201022130423.GC688778@lunn.ch>
References: <CAJArhDY9MYZ4UN1-=mmZRYj8zJ7JtF9=xtpLBiyPux6bjg-FaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJArhDY9MYZ4UN1-=mmZRYj8zJ7JtF9=xtpLBiyPux6bjg-FaQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 07:51:51PM +0800, Charles Hsu wrote:
> Add the pmbus driver for the STMicroelectronics pm6764tr voltage regulator.
> 
> Signed-off-by: Charles Hsu <hsu.yungteng@gmail.com>

Hi Charles

Seems a bit odd sending a HWMON driver to the netdev list!


> diff --git a/drivers/hwmon/pmbus/Makefile b/drivers/hwmon/pmbus/Makefile
> index 4c97ad0bd791..bb89fcf9544d 100644
> --- a/drivers/hwmon/pmbus/Makefile
> +++ b/drivers/hwmon/pmbus/Makefile
> @@ -32,3 +32,4 @@ obj-$(CONFIG_SENSORS_UCD9000) += ucd9000.o
>  obj-$(CONFIG_SENSORS_UCD9200) += ucd9200.o
>  obj-$(CONFIG_SENSORS_XDPE122) += xdpe12284.o
>  obj-$(CONFIG_SENSORS_ZL6100) += zl6100.o
> +obj-$(CONFIG_SENSORS_PM6764TR) += pm6764tr.o

This file is sorted. Please don't insert at the end.

> +#define PM6764TR_PMBUS_READ_VOUT 0xD4
> +
> +static int pm6764tr_read_word_data(struct i2c_client *client, int
> page, int reg)
> +{
> + int ret;
> +
> + switch (reg) {
> + case PMBUS_VIRT_READ_VMON:
> + ret = pmbus_read_word_data(client, page,
> +   PM6764TR_PMBUS_READ_VOUT);
> + break;
> + default:
> + ret = -ENODATA;
> + break;
> + }
> + return ret;
> +}


It looks like your mailer has corrupted your patch.

   Andrew
