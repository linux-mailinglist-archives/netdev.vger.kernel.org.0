Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E35F2B5956
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 06:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgKQFgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 00:36:04 -0500
Received: from gproxy5-pub.mail.unifiedlayer.com ([67.222.38.55]:36697 "EHLO
        gproxy5-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbgKQFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 00:36:03 -0500
X-Greylist: delayed 1324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2020 00:36:01 EST
Received: from cmgw10.unifiedlayer.com (unknown [10.9.0.10])
        by gproxy5.mail.unifiedlayer.com (Postfix) with ESMTP id B552F140479
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 22:13:55 -0700 (MST)
Received: from bh-25.webhostbox.net ([208.91.199.152])
        by cmsmtp with ESMTP
        id etJTk6zlTDlydetJTkxV26; Mon, 16 Nov 2020 22:13:55 -0700
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.3 cv=YYaTGTZf c=1 sm=1 tr=0
 a=QNED+QcLUkoL9qulTODnwA==:117 a=2cfIYNtKkjgZNaOwnGXpGw==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=kj9zAlcOel0A:10:nop_charset_1
 a=nNwsprhYR40A:10:nop_rcvd_month_year
 a=evQFzbml-YQA:10:endurance_base64_authed_username_1 a=pGLkceISAAAA:8
 a=FOH2dFAWAAAA:8 a=1ZlPNePYmRpBYS09ySgA:9 a=CjuIK1q_8ugA:10:nop_charset_2
 a=i3VuKzQdj-NEYjvDI-p3:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VWJHoKdZasD/t6eHjRpsvDj7GkqNn8pFhbIZBUNigoY=; b=3xPF2/JmhDUnvMTYBDDGVqSCpP
        qEUF4aNPrWuUYUXTTKO8DKqNA7uBOKji/ODqktkzK5c9w2pJ/ayVe9jRY2vMw9lGEA6EeCy5wgLUz
        P8K/03YrWUDWlDrmEh666zc5tsCDbL7HFhAAbgTkLIt9etTq1cqOp8GdAt7iarAHJyZJplLlZyH75
        ibUdEmhp5J03cclN/mBj5A8LFYc2jFW8eV4kfB7ITZRYrmXs0QHicLnOMXoXKDh4esiIO9BJmFann
        vIQTi9zpRka5OTv5rBJyePbzhA+NaAWsVkW1HXQ85b+BrIB7KAQRHwTUcLmmCtPetWpTbKYvBtRwo
        XknQIAdQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:47300 helo=localhost)
        by bh-25.webhostbox.net with esmtpa (Exim 4.93)
        (envelope-from <linux@roeck-us.net>)
        id 1ketJR-003pr2-H7; Tue, 17 Nov 2020 05:13:53 +0000
Date:   Mon, 16 Nov 2020 21:13:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     rentao.bupt@gmail.com
Cc:     Jean Delvare <jdelvare@suse.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Subject: Re: [PATCH 1/2] hwmon: (max127) Add Maxim MAX127 hardware monitoring
 driver
Message-ID: <20201117051352.GA208504@roeck-us.net>
References: <20201117010944.28457-1-rentao.bupt@gmail.com>
 <20201117010944.28457-2-rentao.bupt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117010944.28457-2-rentao.bupt@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1ketJR-003pr2-H7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:47300
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 5
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 05:09:43PM -0800, rentao.bupt@gmail.com wrote:
> From: Tao Ren <rentao.bupt@gmail.com>
> 
> Add hardware monitoring driver for the Maxim MAX127 chip.
> 
> MAX127 min/max range handling code is inspired by the max197 driver.
> 
> Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
> ---
>  drivers/hwmon/Kconfig  |   9 ++
>  drivers/hwmon/Makefile |   1 +
>  drivers/hwmon/max127.c | 286 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 296 insertions(+)
>  create mode 100644 drivers/hwmon/max127.c
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 9d600e0c5584..716df51edc87 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -950,6 +950,15 @@ config SENSORS_MAX1111
>  	  This driver can also be built as a module. If so, the module
>  	  will be called max1111.
>  
> +config SENSORS_MAX127
> +	tristate "Maxim MAX127 12-bit 8-channel Data Acquisition System"
> +	depends on I2C
> +	help
> +	  Say y here to support Maxim's MAX127 DAS chips.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called max127.
> +
>  config SENSORS_MAX16065
>  	tristate "Maxim MAX16065 System Manager and compatibles"
>  	depends on I2C
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 1083bbfac779..01ca5d3fbad4 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -127,6 +127,7 @@ obj-$(CONFIG_SENSORS_LTC4260)	+= ltc4260.o
>  obj-$(CONFIG_SENSORS_LTC4261)	+= ltc4261.o
>  obj-$(CONFIG_SENSORS_LTQ_CPUTEMP) += ltq-cputemp.o
>  obj-$(CONFIG_SENSORS_MAX1111)	+= max1111.o
> +obj-$(CONFIG_SENSORS_MAX127)	+= max127.o
>  obj-$(CONFIG_SENSORS_MAX16065)	+= max16065.o
>  obj-$(CONFIG_SENSORS_MAX1619)	+= max1619.o
>  obj-$(CONFIG_SENSORS_MAX1668)	+= max1668.o
> diff --git a/drivers/hwmon/max127.c b/drivers/hwmon/max127.c
> new file mode 100644
> index 000000000000..df74a95bcf28
> --- /dev/null
> +++ b/drivers/hwmon/max127.c
> @@ -0,0 +1,286 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Hardware monitoring driver for MAX127.
> + *
> + * Copyright (c) 2020 Facebook Inc.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/sysfs.h>
> +
> +/* MAX127 Control Byte. */
> +#define MAX127_CTRL_START	BIT(7)
> +#define MAX127_CTRL_SEL_OFFSET	4

That would better be named _SHIFT.

> +#define MAX127_CTRL_RNG		BIT(3)
> +#define MAX127_CTRL_BIP		BIT(2)
> +#define MAX127_CTRL_PD1		BIT(1)
> +#define MAX127_CTRL_PD0		BIT(0)
> +
> +#define MAX127_NUM_CHANNELS	8
> +#define MAX127_SET_CHANNEL(ch)	(((ch) & 7) << (MAX127_CTRL_SEL_OFFSET))

() around MAX127_CTRL_SEL_OFFSET is unnecessary.

> +
> +#define MAX127_INPUT_LIMIT	10	/* 10V */
> +
> +/*
> + * MAX127 returns 2 bytes at read:
> + *   - the first byte contains data[11:4].
> + *   - the second byte contains data[3:0] (MSB) and 4 dummy 0s (LSB).
> + */
> +#define MAX127_DATA1_SHIFT	4
> +
> +struct max127_data {
> +	struct mutex lock;
> +	struct i2c_client *client;
> +	int input_limit;
> +	u8 ctrl_byte[MAX127_NUM_CHANNELS];
> +};
> +
> +static int max127_select_channel(struct max127_data *data, int channel)
> +{
> +	int status;
> +	struct i2c_client *client = data->client;
> +	struct i2c_msg msg = {
> +		.addr = client->addr,
> +		.flags = 0,
> +		.len = 1,
> +		.buf = &data->ctrl_byte[channel],
> +	};
> +
> +	status = i2c_transfer(client->adapter, &msg, 1);
> +	if (status != 1)
> +		return status;
> +

Other drivers assume that this function can return 0. Please
take that into account as well.

> +	return 0;
> +}
> +
> +static int max127_read_channel(struct max127_data *data, int channel, u16 *vin)
> +{
> +	int status;
> +	u8 i2c_data[2];
> +	struct i2c_client *client = data->client;
> +	struct i2c_msg msg = {
> +		.addr = client->addr,
> +		.flags = I2C_M_RD,
> +		.len = 2,
> +		.buf = i2c_data,
> +	};
> +
> +	status = i2c_transfer(client->adapter, &msg, 1);
> +	if (status != 1)
> +		return status;

Same as above.

> +
> +	*vin = ((i2c_data[0] << 8) | i2c_data[1]) >> MAX127_DATA1_SHIFT;

THis seems wrong. D4..D11 end up in but 8..15, and D0..D3 end up in bit
0..3. Seems to me the upper byte should be left shifted 4 bit.
The result then needs to be scaled to mV (see below).

Also, for consistency I would suggest to either use () for both
parts of the logical or operation or for none.

> +	return 0;
> +}
> +
> +static ssize_t max127_input_show(struct device *dev,
> +				 struct device_attribute *dev_attr,
> +				 char *buf)
> +{
> +	u16 vin;
> +	int status;
> +	struct max127_data *data = dev_get_drvdata(dev);
> +	struct sensor_device_attribute *attr = to_sensor_dev_attr(dev_attr);
> +
> +	if (mutex_lock_interruptible(&data->lock))
> +		return -ERESTARTSYS;

I don't think the _interruptible is warranted in this driver.

> +
> +	status = max127_select_channel(data, attr->index);
> +	if (status)
> +		goto exit;
> +
> +	status = max127_read_channel(data, attr->index, &vin);
> +	if (status)
> +		goto exit;
> +
> +	status = sprintf(buf, "%u", vin);

This is not correct. The ABI expects values in milli-Volt, and per datasheet
the values need to be scaled depending on polarity and range settings (see
table 3 in datasheet). Also, if the range includes negative numbers,
the reported voltage can obviously be negative. That means %u (and u16)
can not be correct. "Transfer Function" in the datasheet describes how to
convert/scale the received data.

> +
> +exit:
> +	mutex_unlock(&data->lock);
> +	return status;
> +}
> +
> +static ssize_t max127_range_show(struct device *dev,
> +				 struct device_attribute *dev_attr,
> +				 char *buf)
> +{
> +	u8 ctrl, rng_bip;
> +	struct max127_data *data = dev_get_drvdata(dev);
> +	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(dev_attr);
> +	int rng_type = attr->nr;	/* 0 for min, 1 for max */
> +	int channel = attr->index;
> +	int full = data->input_limit;
> +	int half = full / 2;
> +	int range_table[4][2] = {
> +		[0] = {0, half},	/* RNG=0, BIP=0 */
> +		[1] = {-half, half},	/* RNG=0, BIP=1 */
> +		[2] = {0, full},	/* RNG=1, BIP=0 */
> +		[3] = {-full, full},	/* RNG=1, BIP=1 */
> +	};

This can be a static const table. The variables 'full' and 'half'
are effectively constants and not really needed.

> +
> +	if (mutex_lock_interruptible(&data->lock))
> +		return -ERESTARTSYS;
> +	ctrl = data->ctrl_byte[channel];
> +	mutex_unlock(&data->lock);

This lock is only needed because "ctrl" is written piece by piece.
I would suggest to rewrite the store function to write ctrl atomically.
Then the lock here is no longer needed.

> +
> +	rng_bip = (ctrl >> 2) & 3;
> +	return sprintf(buf, "%d", range_table[rng_bip][rng_type]);
> +}
> +
> +static void max127_set_range(struct max127_data *data, int channel)
> +{
> +	data->ctrl_byte[channel] |= MAX127_CTRL_RNG;
> +}
> +
> +static void max127_clear_range(struct max127_data *data, int channel)
> +{
> +	data->ctrl_byte[channel] &= ~MAX127_CTRL_RNG;
> +}
> +
> +static void max127_set_polarity(struct max127_data *data, int channel)
> +{
> +	data->ctrl_byte[channel] |= MAX127_CTRL_BIP;
> +}
> +
> +static void max127_clear_polarity(struct max127_data *data, int channel)
> +{
> +	data->ctrl_byte[channel] &= ~MAX127_CTRL_BIP;
> +}
> +
> +static ssize_t max127_range_store(struct device *dev,
> +				  struct device_attribute *devattr,
> +				  const char *buf,
> +				  size_t count)
> +{
> +	struct max127_data *data = dev_get_drvdata(dev);
> +	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
> +	int rng_type = attr->nr;	/* 0 for min, 1 for max */
> +	int channel = attr->index;
> +	int full = data->input_limit;
> +	int half = full / 2;
> +	long input, output;
> +
> +	if (kstrtol(buf, 0, &input))
> +		return -EINVAL;
> +
> +	if (rng_type == 0) {	/* min input */
> +		if (input <= -full)
> +			output = -full;
> +		else if (input < 0)
> +			output = -half;
> +		else
> +			output = 0;
> +	} else {		/* max input */
> +		output = (input >= full) ? full : half;
> +	}
> +

With the _info API, I would suggest to separate min and max functions.
This would both simplify the code and make it easier to read and
review. 

> +	if (mutex_lock_interruptible(&data->lock))
> +		return -ERESTARTSYS;

This should be rewritten to update "ctrl" in one step.
Something like

	u8 ctrl;
	...
	ctrl = data->ctrl_byte[channel];
	if (output == -MAX127_INPUT_LIMIT)
		ctrl |= MAX127_CTRL_RNG | MAX127_CTRL_BIP;
	else if (output == -half)
		ctrl |= MAX127_CTRL_BIP;
		ctrl &= ~MAX127_CTRL_RNG;
	else if (output == 0)
		ctrl &= ~MAX127_CTRL_BIP;
	else lf (output == half)
		ctrl &= ~MAX127_CTRL_RNG;
	else
		ctrl |= MAX127_CTRL_RNG;

	data->ctrl_byte[channel] = ctrl;

I would suggest to separate the min and max functions, though.

> +
> +	if (output == -full) {
> +		max127_set_polarity(data, channel);
> +		max127_set_range(data, channel);
> +	} else if (output == -half) {
> +		max127_set_polarity(data, channel);
> +		max127_clear_range(data, channel);
> +	} else if (output == 0) {
> +		max127_clear_polarity(data, channel);
> +	} else if (output == half) {
> +		max127_clear_range(data, channel);
> +	} else {
> +		max127_set_range(data, channel);
> +	}
> +
> +	mutex_unlock(&data->lock);
> +
> +	return count;
> +}
> +
> +#define MAX127_SENSOR_DEV_ATTR_DEF(ch)					   \
> +	static SENSOR_DEVICE_ATTR_RO(in##ch##_input, max127_input, ch);	   \
> +	static SENSOR_DEVICE_ATTR_2_RW(in##ch##_min, max127_range, 0, ch); \
> +	static SENSOR_DEVICE_ATTR_2_RW(in##ch##_max, max127_range, 1, ch)
> +
> +MAX127_SENSOR_DEV_ATTR_DEF(0);
> +MAX127_SENSOR_DEV_ATTR_DEF(1);
> +MAX127_SENSOR_DEV_ATTR_DEF(2);
> +MAX127_SENSOR_DEV_ATTR_DEF(3);
> +MAX127_SENSOR_DEV_ATTR_DEF(4);
> +MAX127_SENSOR_DEV_ATTR_DEF(5);
> +MAX127_SENSOR_DEV_ATTR_DEF(6);
> +MAX127_SENSOR_DEV_ATTR_DEF(7);
> +
> +#define MAX127_SENSOR_DEVICE_ATTR(ch)			\
> +	&sensor_dev_attr_in##ch##_input.dev_attr.attr,	\
> +	&sensor_dev_attr_in##ch##_min.dev_attr.attr,	\
> +	&sensor_dev_attr_in##ch##_max.dev_attr.attr
> +
> +static struct attribute *max127_attrs[] = {
> +	MAX127_SENSOR_DEVICE_ATTR(0),
> +	MAX127_SENSOR_DEVICE_ATTR(1),
> +	MAX127_SENSOR_DEVICE_ATTR(2),
> +	MAX127_SENSOR_DEVICE_ATTR(3),
> +	MAX127_SENSOR_DEVICE_ATTR(4),
> +	MAX127_SENSOR_DEVICE_ATTR(5),
> +	MAX127_SENSOR_DEVICE_ATTR(6),
> +	MAX127_SENSOR_DEVICE_ATTR(7),
> +	NULL,
> +};
> +
> +ATTRIBUTE_GROUPS(max127);
> +
> +static const struct attribute_group max127_attr_groups = {
> +	.attrs = max127_attrs,
> +};
> +
> +static int max127_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	int i;
> +	struct device *hwmon_dev;
> +	struct max127_data *data;
> +	struct device *dev = &client->dev;
> +
> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->client = client;
> +	mutex_init(&data->lock);
> +	data->input_limit = MAX127_INPUT_LIMIT;

What is the point of input_limit ? It is never modified.
Why not use MAX127_INPUT_LIMIT directly where needed ?

> +	for (i = 0; i < ARRAY_SIZE(data->ctrl_byte); i++)
> +		data->ctrl_byte[i] = (MAX127_CTRL_START |
> +				      MAX127_SET_CHANNEL(i));
> +
> +	hwmon_dev = devm_hwmon_device_register_with_groups(dev,
> +				client->name, data, max127_groups);

Please use the devm_hwmon_device_register_with_info() API.

Thanks,
Guenter

> +
> +	return PTR_ERR_OR_ZERO(hwmon_dev);
> +}
> +
> +static const struct i2c_device_id max127_id[] = {
> +	{ "max127", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, max127_id);
> +
> +static struct i2c_driver max127_driver = {
> +	.class		= I2C_CLASS_HWMON,
> +	.driver = {
> +		.name	= "max127",
> +	},
> +	.probe		= max127_probe,
> +	.id_table	= max127_id,
> +};
> +
> +module_i2c_driver(max127_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mike Choi <mikechoi@fb.com>");
> +MODULE_AUTHOR("Tao Ren <rentao.bupt@gmail.com>");
> +MODULE_DESCRIPTION("MAX127 Hardware Monitoring driver");
> -- 
> 2.17.1
> 
