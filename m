Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9D12B882E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgKRXJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgKRXJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 18:09:36 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CF4C0613D4;
        Wed, 18 Nov 2020 15:09:53 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id t8so2572422pfg.8;
        Wed, 18 Nov 2020 15:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6yIwsmNeB9bDh6Ury3qYKnUv0CJTQZ2BCGM+oU82b00=;
        b=SNM3hccGJqaCxy3JqxlWrvhy0iKS+CmbFNfNsmFbR/R3CQed7f3cuMYTaxJo9vSLO8
         ixfRQmKsAtAsXcPD3WkDSJveg/W8IiE+b4XX4GDABd0W5bs3Gjrk+dK/duci+0BUFkK3
         NvOXac6OianNSwcSZ4ULiciZyZxXNbbayzQ7d2OAFIdzD01mJS9r2ea6di2xwKP1qPmN
         2dACWQd4ZwxdXgWnRgIfDOc5DYTFCxliIJqxBCZ7ZZ34BMd3nA/USp10xkWq+oeHwntZ
         QVH5gy1QiYqeqG8Tt/7VFNLcTYrcfOtHYBpjbgj5ZZTrkvbdk1OyaP0BABUULxTpxDYZ
         PiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6yIwsmNeB9bDh6Ury3qYKnUv0CJTQZ2BCGM+oU82b00=;
        b=MqoCgx/aIjgnAgssX4EiuhWUAOa5jHE1m3jAUazAxHj5A0WWJpWAwZA8maO4YJOT6q
         ErnywWGCRFQC0/eVGI0mOBOCRE+vtniYWfkCmabm9h7yCvF91wSAnze7BbhM1hUjoI1p
         y7HGqv3NbzroU6nYxPZIHQrVqmIYrqnqLA/5nRiDY9YVcVCD40Sb34B4zgS82+BKnxF4
         j8EsZqASrGCIFXL3vrkm6Nydu67L5u5/BG5S3ISfurKFqJGYi5JnE5unBY84WMhAH/+j
         sr00n7+ZAZhg97w9qGueyd0htNMsE39voL2FznNb1AbsykzCCNGIY1PxyGP5c+oBxaCf
         Oxlw==
X-Gm-Message-State: AOAM533aIC+xdSBltIrEOPz7RZA6icTmi4MP2nIezuPpI80UokuVZ9jS
        BAtoqemUZDTrlInaSpxXbq0=
X-Google-Smtp-Source: ABdhPJzdCzBpX7/37cnRGoPSFuoOy45KoUf628g+Z2PAXdhHa5UjNUfFU/3QebrrtYkU1uWhJB7wTA==
X-Received: by 2002:a17:90b:118b:: with SMTP id gk11mr1321844pjb.178.1605740992943;
        Wed, 18 Nov 2020 15:09:52 -0800 (PST)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id b21sm2565304pji.24.2020.11.18.15.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 15:09:52 -0800 (PST)
From:   rentao.bupt@gmail.com
To:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
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
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH v2 1/2] hwmon: (max127) Add Maxim MAX127 hardware monitoring driver
Date:   Wed, 18 Nov 2020 15:09:28 -0800
Message-Id: <20201118230929.18147-2-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201118230929.18147-1-rentao.bupt@gmail.com>
References: <20201118230929.18147-1-rentao.bupt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

Add hardware monitoring driver for the Maxim MAX127 chip.

MAX127 min/max range handling code is inspired by the max197 driver.

Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
---
 Changes in v2:
   - replace devm_hwmon_device_register_with_groups() with
     devm_hwmon_device_register_with_info() API.
   - divide min/max read and write methods to separate functions.
   - fix raw-to-vin conversion logic.
   - refine ctrl_byte handling so mutex is not needed to protect the
     byte.
   - improve i2c_transfer() error handling.
   - a few other improvements (comments, variable naming, and etc.).

 drivers/hwmon/Kconfig  |   9 ++
 drivers/hwmon/Makefile |   1 +
 drivers/hwmon/max127.c | 346 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 356 insertions(+)
 create mode 100644 drivers/hwmon/max127.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 9d600e0c5584..716df51edc87 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -950,6 +950,15 @@ config SENSORS_MAX1111
 	  This driver can also be built as a module. If so, the module
 	  will be called max1111.
 
+config SENSORS_MAX127
+	tristate "Maxim MAX127 12-bit 8-channel Data Acquisition System"
+	depends on I2C
+	help
+	  Say y here to support Maxim's MAX127 DAS chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called max127.
+
 config SENSORS_MAX16065
 	tristate "Maxim MAX16065 System Manager and compatibles"
 	depends on I2C
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 1083bbfac779..01ca5d3fbad4 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -127,6 +127,7 @@ obj-$(CONFIG_SENSORS_LTC4260)	+= ltc4260.o
 obj-$(CONFIG_SENSORS_LTC4261)	+= ltc4261.o
 obj-$(CONFIG_SENSORS_LTQ_CPUTEMP) += ltq-cputemp.o
 obj-$(CONFIG_SENSORS_MAX1111)	+= max1111.o
+obj-$(CONFIG_SENSORS_MAX127)	+= max127.o
 obj-$(CONFIG_SENSORS_MAX16065)	+= max16065.o
 obj-$(CONFIG_SENSORS_MAX1619)	+= max1619.o
 obj-$(CONFIG_SENSORS_MAX1668)	+= max1668.o
diff --git a/drivers/hwmon/max127.c b/drivers/hwmon/max127.c
new file mode 100644
index 000000000000..3df4c225a6a2
--- /dev/null
+++ b/drivers/hwmon/max127.c
@@ -0,0 +1,346 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Hardware monitoring driver for MAX127.
+ *
+ * Copyright (c) 2020 Facebook Inc.
+ */
+
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/sysfs.h>
+
+/*
+ * MAX127 Control Byte. Refer to MAX127 datasheet, Table 1 "Control-Byte
+ * Format" for details.
+ */
+#define MAX127_CTRL_START	BIT(7)
+#define MAX127_CTRL_SEL_SHIFT	4
+#define MAX127_CTRL_RNG		BIT(3)
+#define MAX127_CTRL_BIP		BIT(2)
+#define MAX127_CTRL_PD1		BIT(1)
+#define MAX127_CTRL_PD0		BIT(0)
+
+#define MAX127_NUM_CHANNELS	8
+#define MAX127_SET_CHANNEL(ch)	(((ch) & 7) << MAX127_CTRL_SEL_SHIFT)
+
+/*
+ * MAX127 channel input ranges. Refer to MAX127 datasheet, Table 3 "Range
+ * and Polarity Selection" for details.
+ */
+#define MAX127_FULL_RANGE	10000	/* 10V */
+#define MAX127_HALF_RANGE	5000	/* 5V */
+
+/*
+ * MAX127 returns 2 bytes at read:
+ *   - the first byte contains data[11:4].
+ *   - the second byte contains data[3:0] (MSB) and 4 dummy 0s (LSB).
+ * Refer to MAX127 datasheet, "Read a Conversion (Read Cycle)" section
+ * for details.
+ */
+#define MAX127_DATA_LEN		2
+#define MAX127_DATA_SHIFT	4
+
+#define MAX127_SIGN_BIT		BIT(11)
+
+struct max127_data {
+	struct mutex lock;
+	struct i2c_client *client;
+	u8 ctrl_byte[MAX127_NUM_CHANNELS];
+};
+
+static int max127_select_channel(struct i2c_client *client, u8 ctrl_byte)
+{
+	int status;
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.flags = 0,
+		.len = sizeof(ctrl_byte),
+		.buf = &ctrl_byte,
+	};
+
+	status = i2c_transfer(client->adapter, &msg, 1);
+	if (status < 0)
+		return status;
+	else if (status != 1)
+		return -EIO;
+
+	return 0;
+}
+
+static int max127_read_channel(struct i2c_client *client, long *val)
+{
+	int status;
+	u8 i2c_data[MAX127_DATA_LEN];
+	struct i2c_msg msg = {
+		.addr = client->addr,
+		.flags = I2C_M_RD,
+		.len = sizeof(i2c_data),
+		.buf = i2c_data,
+	};
+
+	status = i2c_transfer(client->adapter, &msg, 1);
+	if (status < 0)
+		return status;
+	else if (status != 1)
+		return -EIO;
+
+	*val = (i2c_data[1] >> MAX127_DATA_SHIFT) |
+		((u16)i2c_data[0] << MAX127_DATA_SHIFT);
+	return 0;
+}
+
+static long max127_process_raw(u8 ctrl_byte, long raw)
+{
+	long scale, weight;
+
+	/*
+	 * MAX127's data coding is binary in unipolar mode with 1 LSB =
+	 * (Full-Scale/4096) and two’s complement binary in bipolar mode
+	 * with 1 LSB = [(2 x |FS|)/4096].
+	 * Refer to MAX127 datasheet, "Transfer Function" section for
+	 * details.
+	 */
+	scale = (ctrl_byte & MAX127_CTRL_RNG) ? MAX127_FULL_RANGE :
+						MAX127_HALF_RANGE;
+	if (ctrl_byte & MAX127_CTRL_BIP) {
+		weight = (raw & MAX127_SIGN_BIT);
+		raw &= ~MAX127_SIGN_BIT;
+		raw -= weight;
+		raw *= 2;
+	}
+
+	return raw * scale / 4096;
+}
+
+static int max127_read_input(struct max127_data *data, int channel, long *val)
+{
+	long raw;
+	int status;
+	struct i2c_client *client = data->client;
+	u8 ctrl_byte = data->ctrl_byte[channel];
+
+	mutex_lock(&data->lock);
+
+	status = max127_select_channel(client, ctrl_byte);
+	if (status)
+		goto exit;
+
+	status = max127_read_channel(client, &raw);
+	if (status)
+		goto exit;
+
+	*val = max127_process_raw(ctrl_byte, raw);
+
+exit:
+	mutex_unlock(&data->lock);
+	return status;
+}
+
+static int max127_read_min(struct max127_data *data, int channel, long *val)
+{
+	u8 rng_bip = (data->ctrl_byte[channel] >> 2) & 3;
+	static const int min_input_map[4] = {
+		0,			/* RNG=0, BIP=0 */
+		-MAX127_HALF_RANGE,	/* RNG=0, BIP=1 */
+		0,			/* RNG=1, BIP=0 */
+		-MAX127_FULL_RANGE,	/* RNG=1, BIP=1 */
+	};
+
+	*val = min_input_map[rng_bip];
+	return 0;
+}
+
+static int max127_read_max(struct max127_data *data, int channel, long *val)
+{
+	u8 rng_bip = (data->ctrl_byte[channel] >> 2) & 3;
+	static const int max_input_map[4] = {
+		MAX127_HALF_RANGE,	/* RNG=0, BIP=0 */
+		MAX127_HALF_RANGE,	/* RNG=0, BIP=1 */
+		MAX127_FULL_RANGE,	/* RNG=1, BIP=0 */
+		MAX127_FULL_RANGE,	/* RNG=1, BIP=1 */
+	};
+
+	*val = max_input_map[rng_bip];
+	return 0;
+}
+
+static int max127_write_min(struct max127_data *data, int channel, long val)
+{
+	u8 ctrl;
+
+	ctrl = data->ctrl_byte[channel];
+	if (val <= -MAX127_FULL_RANGE) {
+		ctrl |= (MAX127_CTRL_RNG | MAX127_CTRL_BIP);
+	} else if (val < 0) {
+		ctrl |= MAX127_CTRL_BIP;
+		ctrl &= ~MAX127_CTRL_RNG;
+	} else {
+		ctrl &= ~MAX127_CTRL_BIP;
+	}
+	data->ctrl_byte[channel] = ctrl;
+
+	return 0;
+}
+
+static int max127_write_max(struct max127_data *data, int channel, long val)
+{
+	if (val >= MAX127_FULL_RANGE)
+		data->ctrl_byte[channel] |= MAX127_CTRL_RNG;
+	else
+		data->ctrl_byte[channel] &= ~MAX127_CTRL_RNG;
+
+	return 0;
+}
+
+static umode_t max127_is_visible(const void *_data,
+				 enum hwmon_sensor_types type,
+				 u32 attr, int channel)
+{
+	if (type == hwmon_in) {
+		switch (attr) {
+		case hwmon_in_input:
+			return 0444;
+
+		case hwmon_in_min:
+		case hwmon_in_max:
+			return 0644;
+
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int max127_read(struct device *dev, enum hwmon_sensor_types type,
+			u32 attr, int channel, long *val)
+{
+	int status;
+	struct max127_data *data = dev_get_drvdata(dev);
+
+	if (type != hwmon_in)
+		return -EOPNOTSUPP;
+
+	switch (attr) {
+	case hwmon_in_input:
+		status = max127_read_input(data, channel, val);
+		break;
+
+	case hwmon_in_min:
+		status = max127_read_min(data, channel, val);
+		break;
+
+	case hwmon_in_max:
+		status = max127_read_max(data, channel, val);
+		break;
+
+	default:
+		status = -EOPNOTSUPP;
+		break;
+	}
+
+	return status;
+}
+
+static int max127_write(struct device *dev, enum hwmon_sensor_types type,
+			u32 attr, int channel, long val)
+{
+	int status;
+	struct max127_data *data = dev_get_drvdata(dev);
+
+	if (type != hwmon_in)
+		return -EOPNOTSUPP;
+
+	switch (attr) {
+	case hwmon_in_min:
+		status = max127_write_min(data, channel, val);
+		break;
+
+	case hwmon_in_max:
+		status = max127_write_max(data, channel, val);
+		break;
+
+	default:
+		status = -EOPNOTSUPP;
+		break;
+	}
+
+	return status;
+}
+
+static const struct hwmon_ops max127_hwmon_ops = {
+	.is_visible = max127_is_visible,
+	.read = max127_read,
+	.write = max127_write,
+};
+
+static const struct hwmon_channel_info *max127_info[] = {
+	HWMON_CHANNEL_INFO(in,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX,
+			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX),
+	NULL,
+};
+
+static const struct hwmon_chip_info max127_chip_info = {
+	.ops = &max127_hwmon_ops,
+	.info = max127_info,
+};
+
+static int max127_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	int i;
+	struct device *hwmon_dev;
+	struct max127_data *data;
+	struct device *dev = &client->dev;
+
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->client = client;
+	mutex_init(&data->lock);
+	for (i = 0; i < ARRAY_SIZE(data->ctrl_byte); i++)
+		data->ctrl_byte[i] = (MAX127_CTRL_START |
+				      MAX127_SET_CHANNEL(i));
+
+	hwmon_dev = devm_hwmon_device_register_with_info(dev, client->name,
+							 data,
+							 &max127_chip_info,
+							 NULL);
+
+	return PTR_ERR_OR_ZERO(hwmon_dev);
+}
+
+static const struct i2c_device_id max127_id[] = {
+	{ "max127", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max127_id);
+
+static struct i2c_driver max127_driver = {
+	.class		= I2C_CLASS_HWMON,
+	.driver = {
+		.name	= "max127",
+	},
+	.probe		= max127_probe,
+	.id_table	= max127_id,
+};
+
+module_i2c_driver(max127_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mike Choi <mikechoi@fb.com>");
+MODULE_AUTHOR("Tao Ren <rentao.bupt@gmail.com>");
+MODULE_DESCRIPTION("MAX127 Hardware Monitoring driver");
-- 
2.17.1

