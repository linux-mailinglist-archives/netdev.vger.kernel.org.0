Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34661AE972
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 05:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgDRDJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 23:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725320AbgDRDJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 23:09:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60391C061A0C;
        Fri, 17 Apr 2020 20:09:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x26so2043093pgc.10;
        Fri, 17 Apr 2020 20:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xUBf/PGWzTKQsCEO+nlF6TylRkukCQPUTSjokALqJCg=;
        b=fMYnar6z1x87ve2AVXXLaZP/u7IPgl+9OLTN0xLSJ8IT2hZfa/kt08n/GRXWz0sW2y
         vI2GDneODE4w8uzfglUrpV7s18yPGRKuTorWWuTVdPMJhNNPQus4O1X0hpeTheXnoPm4
         sI2CAV04f21AsobDGx1IJ0fY85BvOkWTq/xURJ6FgIcc5tkZ/MBrZzmkb/S1yh8AO40y
         jDW58dmYchS+gUcU7zlcxHzhGzeWnw6ArZ5MuchYCFW0poVFpdzuLOiVxFC02xyUpPO1
         gQ2yN58f0tHmrQcPfyHrPdaLbC9pH67SthrLEFe5wPsb8iDLD/AqGvv5yaazTIffct+i
         K/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xUBf/PGWzTKQsCEO+nlF6TylRkukCQPUTSjokALqJCg=;
        b=UEV9n3fpQiiGRJju83QHXiPt/qIuvFNBrfb0N0ctN/wNH+nTqbi02dPdCUqYINdwQU
         y5LDxKNTgmvYNR4K6pG22gkz4OkjpeXHAHAOTdI1i9sMbdaptI6MO6DhyyLy9xLSoaMW
         bFZ2mT0EjxCsW/Yf6V0evNQlnjH8e0xjg/zXgJVf5Pr6uCrc2wJ6XbteMhqkejQz+hcC
         zRed5ku2mgAD4XfnpijOaM3oT8x9LOImeRbz+aJzVsOnjvyVXnDoy7vZ4UOohYbeOYvH
         BUZdwS2Ru/mNHpjAl7daVjSSb0CAZEtkE3irSOKX2hCKRR/gAOLIIHoEnYIZvHeQ5bzj
         FfDQ==
X-Gm-Message-State: AGi0Puaf+HqQ43PhE2Vu8PpIbzAqt8rY5KCJqzN1rsasekvnQvhQw75r
        K8zBihrfFOf0zdekXBIy93s=
X-Google-Smtp-Source: APiQypLBHktItTeXICX5oDYP1McLtu1qvoO/slVhcXPfAelSYMWY1InkMoIq07qUTtlziOWXZImv3Q==
X-Received: by 2002:a62:3812:: with SMTP id f18mr4503007pfa.173.1587179357625;
        Fri, 17 Apr 2020 20:09:17 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l30sm6934082pje.34.2020.04.17.20.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 20:09:16 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
To:     Michael Walle <michael@walle.cc>, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jean Delvare <jdelvare@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <74a19e1a-35cd-708c-2972-8782d21c8e7d@roeck-us.net>
Date:   Fri, 17 Apr 2020 20:09:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200417192858.6997-3-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/20 12:28 PM, Michael Walle wrote:
> The PHY supports monitoring its die temperature as well as two analog
> voltages. Add support for it.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

This will probably fail to compile if HWMON is not enabled or if it is built
as module and this driver is built into the kernel.

> ---
>  Documentation/hwmon/bcm54140.rst |  45 ++++
>  Documentation/hwmon/index.rst    |   1 +
>  drivers/net/phy/bcm54140.c       | 377 +++++++++++++++++++++++++++++++
>  3 files changed, 423 insertions(+)
>  create mode 100644 Documentation/hwmon/bcm54140.rst
> 
> diff --git a/Documentation/hwmon/bcm54140.rst b/Documentation/hwmon/bcm54140.rst
> new file mode 100644
> index 000000000000..bc6ea4b45966
> --- /dev/null
> +++ b/Documentation/hwmon/bcm54140.rst
> @@ -0,0 +1,45 @@
> +.. SPDX-License-Identifier: GPL-2.0-only
> +
> +Broadcom BCM54140 Quad SGMII/QSGMII PHY
> +=======================================
> +
> +Supported chips:
> +
> +   * Broadcom BCM54140
> +
> +     Datasheet: not public
> +
> +Author: Michael Walle <michael@walle.cc>
> +
> +Description
> +-----------
> +
> +The Broadcom BCM54140 is a Quad SGMII/QSGMII PHY which supports monitoring
> +its die temperature as well as two analog voltages.
> +
> +The AVDDL is a 1.0V analogue voltage, the AVDDH is a 3.3V analogue voltage.
> +Both voltages and the temperature are measured in a round-robin fashion.
> +
> +Sysfs entries
> +-------------
> +
> +The following attributes are supported.
> +
> +======================= ========================================================
> +in0_label		"AVDDL"
> +in0_input		Measured AVDDL voltage.
> +in0_min			Minimum AVDDL voltage.
> +in0_max			Maximum AVDDL voltage.
> +in0_alarm		AVDDL voltage alarm.
> +
> +in1_label		"AVDDH"
> +in1_input		Measured AVDDH voltage.
> +in1_min			Minimum AVDDH voltage.
> +in1_max			Maximum AVDDH voltage.
> +in1_alarm		AVDDH voltage alarm.
> +
> +temp1_input		Die temperature.
> +temp1_min		Minimum die temperature.
> +temp1_max		Maximum die temperature.
> +temp1_alarm		Die temperature alarm.
> +======================= ========================================================
> diff --git a/Documentation/hwmon/index.rst b/Documentation/hwmon/index.rst
> index f022583f96f6..19ad0846736d 100644
> --- a/Documentation/hwmon/index.rst
> +++ b/Documentation/hwmon/index.rst
> @@ -42,6 +42,7 @@ Hardware Monitoring Kernel Drivers
>     asb100
>     asc7621
>     aspeed-pwm-tacho
> +   bcm54140
>     bel-pfe
>     coretemp
>     da9052
> diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
> index 97465491b41b..97c364ce05e3 100644
> --- a/drivers/net/phy/bcm54140.c
> +++ b/drivers/net/phy/bcm54140.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/brcmphy.h>
> +#include <linux/hwmon.h>
>  #include <linux/module.h>
>  #include <linux/phy.h>
>  
> @@ -50,6 +51,54 @@
>  #define  BCM54140_RDB_TOP_IMR_PORT1	BIT(5)
>  #define  BCM54140_RDB_TOP_IMR_PORT2	BIT(6)
>  #define  BCM54140_RDB_TOP_IMR_PORT3	BIT(7)
> +#define BCM54140_RDB_MON_CTRL		0x831	/* monitor control */
> +#define  BCM54140_RDB_MON_CTRL_V_MODE	BIT(3)	/* voltage mode */
> +#define  BCM54140_RDB_MON_CTRL_SEL_MASK	GENMASK(2, 1)
> +#define  BCM54140_RDB_MON_CTRL_SEL_TEMP	0	/* meassure temperature */
> +#define  BCM54140_RDB_MON_CTRL_SEL_1V0	1	/* meassure AVDDL 1.0V */
> +#define  BCM54140_RDB_MON_CTRL_SEL_3V3	2	/* meassure AVDDH 3.3V */
> +#define  BCM54140_RDB_MON_CTRL_SEL_RR	3	/* meassure all round-robin */
> +#define  BCM54140_RDB_MON_CTRL_PWR_DOWN	BIT(0)	/* power-down monitor */
> +#define BCM54140_RDB_MON_TEMP_VAL	0x832	/* temperature value */
> +#define BCM54140_RDB_MON_TEMP_MAX	0x833	/* temperature high thresh */
> +#define BCM54140_RDB_MON_TEMP_MIN	0x834	/* temperature low thresh */
> +#define  BCM54140_RDB_MON_TEMP_DATA_MASK GENMASK(9, 0)
> +#define BCM54140_RDB_MON_1V0_VAL	0x835	/* AVDDL 1.0V value */
> +#define BCM54140_RDB_MON_1V0_MAX	0x836	/* AVDDL 1.0V high thresh */
> +#define BCM54140_RDB_MON_1V0_MIN	0x837	/* AVDDL 1.0V low thresh */
> +#define  BCM54140_RDB_MON_1V0_DATA_MASK	GENMASK(10, 0)
> +#define BCM54140_RDB_MON_3V3_VAL	0x838	/* AVDDH 3.3V value */
> +#define BCM54140_RDB_MON_3V3_MAX	0x839	/* AVDDH 3.3V high thresh */
> +#define BCM54140_RDB_MON_3V3_MIN	0x83a	/* AVDDH 3.3V low thresh */
> +#define  BCM54140_RDB_MON_3V3_DATA_MASK	GENMASK(11, 0)
> +#define BCM54140_RDB_MON_ISR		0x83b	/* interrupt status */
> +#define  BCM54140_RDB_MON_ISR_3V3	BIT(2)	/* AVDDH 3.3V alarm */
> +#define  BCM54140_RDB_MON_ISR_1V0	BIT(1)	/* AVDDL 1.0V alarm */
> +#define  BCM54140_RDB_MON_ISR_TEMP	BIT(0)	/* temperature alarm */
> +
> +/* According to the datasheet the formula is:
> + *   T = 413.35 - (0.49055 * bits[9:0])
> + */
> +#define BCM54140_HWMON_TO_TEMP(v) (413350L - (v) * 491)
> +#define BCM54140_HWMON_FROM_TEMP(v) DIV_ROUND_CLOSEST_ULL(413350L - (v), 491)
> +
> +/* According to the datasheet the formula is:
> + *   U = bits[11:0] / 1024 * 220 / 0.2
> + *
> + * Normalized:
> + *   U = bits[11:0] / 4096 * 2514
> + */
> +#define BCM54140_HWMON_TO_IN_1V0(v) ((v) * 2514 >> 11)
> +#define BCM54140_HWMON_FROM_IN_1V0(v) DIV_ROUND_CLOSEST_ULL(((v) << 11), 2514)
> +
> +/* According to the datasheet the formula is:
> + *   U = bits[10:0] / 1024 * 880 / 0.7
> + *
> + * Normalized:
> + *   U = bits[10:0] / 2048 * 4400
> + */
> +#define BCM54140_HWMON_TO_IN_3V3(v) ((v) * 4400 >> 12)
> +#define BCM54140_HWMON_FROM_IN_3V3(v) DIV_ROUND_CLOSEST_ULL(((v) << 12), 4400)
>  
>  #define BCM54140_DEFAULT_DOWNSHIFT 5
>  #define BCM54140_MAX_DOWNSHIFT 9
> @@ -57,6 +106,258 @@
>  struct bcm54140_phy_priv {
>  	int port;
>  	int base_addr;
> +	bool pkg_init;
> +	u16 alarm;
> +};
> +
> +static umode_t bcm54140_hwmon_is_visible(const void *data,
> +					 enum hwmon_sensor_types type,
> +					 u32 attr, int channel)
> +{
> +	switch (type) {
> +	case hwmon_in:
> +		switch (attr) {
> +		case hwmon_in_min:
> +		case hwmon_in_max:
> +			return 0644;
> +		case hwmon_in_label:
> +		case hwmon_in_input:
> +		case hwmon_in_alarm:
> +			return 0444;
> +		default:
> +			return 0;
> +		}
> +	case hwmon_temp:
> +		switch (attr) {
> +		case hwmon_temp_min:
> +		case hwmon_temp_max:
> +			return 0644;
> +		case hwmon_temp_input:
> +		case hwmon_temp_alarm:
> +			return 0444;
> +		default:
> +			return 0;
> +		}
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static int bcm54140_hwmon_read_alarm(struct device *dev, unsigned int bit,
> +				     long *val)
> +{
> +	struct phy_device *phydev = dev_get_drvdata(dev);
> +	struct bcm54140_phy_priv *priv = phydev->priv;
> +	u16 tmp;
> +
> +	/* latch any alarm bits */
> +	tmp = bcm_phy_read_rdb(phydev, BCM54140_RDB_MON_ISR);
> +	if (tmp < 0)
> +		return tmp;
> +	priv->alarm |= tmp;
> +
> +	*val = !!(priv->alarm & bit);
> +	priv->alarm &= ~bit;> +
> +	return 0;
> +}
> +
> +static int bcm54140_hwmon_read_temp(struct device *dev, u32 attr,
> +				    int channel, long *val)
> +{
> +	struct phy_device *phydev = dev_get_drvdata(dev);
> +	u16 reg, tmp;
> +
> +	switch (attr) {
> +	case hwmon_temp_input:
> +		reg = BCM54140_RDB_MON_TEMP_VAL;
> +		break;
> +	case hwmon_temp_min:
> +		reg = BCM54140_RDB_MON_TEMP_MIN;
> +		break;
> +	case hwmon_temp_max:
> +		reg = BCM54140_RDB_MON_TEMP_MAX;
> +		break;
> +	case hwmon_temp_alarm:
> +		return bcm54140_hwmon_read_alarm(dev,
> +						 BCM54140_RDB_MON_ISR_TEMP,
> +						 val);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	tmp = bcm_phy_read_rdb(phydev, reg);
> +	if (tmp < 0)
> +		return tmp;
> +
> +	*val = BCM54140_HWMON_TO_TEMP(tmp & BCM54140_RDB_MON_TEMP_DATA_MASK);
> +
> +	return 0;
> +}
> +
> +static int bcm54140_hwmon_read_in(struct device *dev, u32 attr,
> +				  int channel, long *val)
> +{
> +	struct phy_device *phydev = dev_get_drvdata(dev);
> +	u16 mask = (!channel) ? BCM54140_RDB_MON_1V0_DATA_MASK
> +			      : BCM54140_RDB_MON_3V3_DATA_MASK;
> +	u16 bit, reg, tmp;
> +
> +	switch (attr) {
> +	case hwmon_in_input:
> +		reg = (!channel) ? BCM54140_RDB_MON_1V0_VAL
> +				 : BCM54140_RDB_MON_3V3_VAL;

I am personally neither a friend of unnecessary () nor of
unnecessary negations. Why not the following ?

		reg = channel ? BCM54140_RDB_MON_3V3_VAL :
				BCM54140_RDB_MON_1V0_VAL;

Another option would be to read all those values from a set of
defines, given the expressions are repeated several times.

> +		break;
> +	case hwmon_in_min:
> +		reg = (!channel) ? BCM54140_RDB_MON_1V0_MIN
> +				 : BCM54140_RDB_MON_3V3_MIN;
> +		break;
> +	case hwmon_in_max:
> +		reg = (!channel) ? BCM54140_RDB_MON_1V0_MAX
> +				 : BCM54140_RDB_MON_3V3_MAX;
> +		break;
> +	case hwmon_in_alarm:
> +		bit = (!channel) ? BCM54140_RDB_MON_ISR_1V0
> +				 : BCM54140_RDB_MON_ISR_3V3;
> +		return bcm54140_hwmon_read_alarm(dev, bit, val);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	tmp = bcm_phy_read_rdb(phydev, reg);
> +	if (tmp < 0)
> +		return tmp;
> +
> +	if (!channel)
> +		*val = BCM54140_HWMON_TO_IN_1V0(tmp & mask);
> +	else
> +		*val = BCM54140_HWMON_TO_IN_3V3(tmp & mask);
> +
> +	return 0;
> +}
> +
> +static int bcm54140_hwmon_read(struct device *dev,
> +			       enum hwmon_sensor_types type, u32 attr,
> +			       int channel, long *val)
> +{
> +	switch (type) {
> +	case hwmon_temp:
> +		return bcm54140_hwmon_read_temp(dev, attr, channel, val);
> +	case hwmon_in:
> +		return bcm54140_hwmon_read_in(dev, attr, channel, val);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static const char *const bcm54140_hwmon_in_labels[] = {
> +	"AVDDL",
> +	"AVDDH",
> +};
> +
> +static int bcm54140_hwmon_read_string(struct device *dev,
> +				      enum hwmon_sensor_types type, u32 attr,
> +				      int channel, const char **str)
> +{
> +	switch (type) {
> +	case hwmon_in:
> +		switch (attr) {
> +		case hwmon_in_label:
> +			*str = bcm54140_hwmon_in_labels[channel];
> +			return 0;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static int bcm54140_hwmon_write_temp(struct device *dev, u32 attr,
> +				     int channel, long val)
> +{
> +	struct phy_device *phydev = dev_get_drvdata(dev);
> +	u16 reg;
> +
> +	switch (attr) {
> +	case hwmon_temp_min:
> +		reg = BCM54140_RDB_MON_TEMP_MIN;
> +		break;
> +	case hwmon_temp_max:
> +		reg = BCM54140_RDB_MON_TEMP_MAX;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return bcm_phy_modify_rdb(phydev, reg, BCM54140_RDB_MON_TEMP_DATA_MASK,
> +				  BCM54140_HWMON_FROM_TEMP(val));
> +}
> +
> +static int bcm54140_hwmon_write_in(struct device *dev, u32 attr,
> +				   int channel, long val)
> +{
> +	struct phy_device *phydev = dev_get_drvdata(dev);
> +	u16 mask = (!channel) ? BCM54140_RDB_MON_1V0_DATA_MASK
> +			      : BCM54140_RDB_MON_3V3_DATA_MASK;
> +	unsigned long raw = (!channel) ?  BCM54140_HWMON_FROM_IN_1V0(val)
> +				       :  BCM54140_HWMON_FROM_IN_3V3(val);
> +	u16 reg;
> +
> +	raw = clamp_val(raw, 0, mask);
> +
> +	switch (attr) {
> +	case hwmon_in_min:
> +		reg = (!channel) ? BCM54140_RDB_MON_1V0_MIN
> +				 : BCM54140_RDB_MON_3V3_MIN;
> +		break;
> +	case hwmon_in_max:
> +		reg = (!channel) ? BCM54140_RDB_MON_1V0_MAX
> +				 : BCM54140_RDB_MON_3V3_MAX;
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return bcm_phy_modify_rdb(phydev, reg, mask, raw);
> +}
> +
> +static int bcm54140_hwmon_write(struct device *dev,
> +				enum hwmon_sensor_types type, u32 attr,
> +				int channel, long val)
> +{
> +	switch (type) {
> +	case hwmon_temp:
> +		return bcm54140_hwmon_write_temp(dev, attr, channel, val);
> +	case hwmon_in:
> +		return bcm54140_hwmon_write_in(dev, attr, channel, val);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static const struct hwmon_channel_info *bcm54140_hwmon_info[] = {
> +	HWMON_CHANNEL_INFO(temp,
> +			   HWMON_T_INPUT | HWMON_T_MIN | HWMON_T_MAX |
> +			   HWMON_T_ALARM),
> +	HWMON_CHANNEL_INFO(in,
> +			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX |
> +			   HWMON_I_ALARM | HWMON_I_LABEL,
> +			   HWMON_I_INPUT | HWMON_I_MIN | HWMON_I_MAX |
> +			   HWMON_I_ALARM | HWMON_I_LABEL),
> +	NULL
> +};
> +
> +static const struct hwmon_ops bcm54140_hwmon_ops = {
> +	.is_visible = bcm54140_hwmon_is_visible,
> +	.read = bcm54140_hwmon_read,
> +	.read_string = bcm54140_hwmon_read_string,
> +	.write = bcm54140_hwmon_write,
> +};
> +
> +static const struct hwmon_chip_info bcm54140_chip_info = {
> +	.ops = &bcm54140_hwmon_ops,
> +	.info = bcm54140_hwmon_info,
>  };
>  
>  static int bcm54140_phy_base_read_rdb(struct phy_device *phydev, u16 rdb)
> @@ -203,6 +504,74 @@ static int bcm54140_get_base_addr_and_port(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +/* Check if one PHY has already done the init of the parts common to all PHYs
> + * in the Quad PHY package.
> + */
> +static bool bcm54140_is_pkg_init(struct phy_device *phydev)
> +{
> +	struct mdio_device **map = phydev->mdio.bus->mdio_map;
> +	struct bcm54140_phy_priv *priv;
> +	struct phy_device *phy;
> +	int i, addr;
> +
> +	/* Quad PHY */
> +	for (i = 0; i < 4; i++) {
> +		priv = phydev->priv;
> +		addr = priv->base_addr + i;
> +
> +		if (!map[addr])
> +			continue;
> +
> +		phy = container_of(map[addr], struct phy_device, mdio);
> +
> +		if ((phy->phy_id & phydev->drv->phy_id_mask) !=
> +		    (phydev->drv->phy_id & phydev->drv->phy_id_mask))
> +			continue;
> +
> +		priv = phy->priv;
> +
> +		if (priv && priv->pkg_init)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +static int bcm54140_enable_monitoring(struct phy_device *phydev)
> +{
> +	u16 mask, set;
> +
> +	/* 3.3V voltage mode */
> +	set = BCM54140_RDB_MON_CTRL_V_MODE;
> +
> +	/* select round-robin */
> +	mask = BCM54140_RDB_MON_CTRL_SEL_MASK;
> +	set |= FIELD_PREP(BCM54140_RDB_MON_CTRL_SEL_MASK,
> +			  BCM54140_RDB_MON_CTRL_SEL_RR);
> +
> +	/* remove power-down bit */
> +	mask |= BCM54140_RDB_MON_CTRL_PWR_DOWN;
> +
> +	return bcm_phy_modify_rdb(phydev, BCM54140_RDB_MON_CTRL, mask, set);
> +}
> +
> +static int bcm54140_phy_probe_once(struct phy_device *phydev)
> +{
> +	struct device *hwmon;
> +	int ret;
> +
> +	/* enable hardware monitoring */
> +	ret = bcm54140_enable_monitoring(phydev);
> +	if (ret)
> +		return ret;
> +
> +	hwmon = devm_hwmon_device_register_with_info(&phydev->mdio.dev,
> +						     "BCM54140", phydev,
> +						     &bcm54140_chip_info,
> +						     NULL);
> +	return PTR_ERR_OR_ZERO(hwmon);
> +}
> +
>  static int bcm54140_phy_probe(struct phy_device *phydev)
>  {
>  	struct bcm54140_phy_priv *priv;
> @@ -218,6 +587,14 @@ static int bcm54140_phy_probe(struct phy_device *phydev)
>  	if (ret)
>  		return ret;
>  
> +	if (!bcm54140_is_pkg_init(phydev)) {
> +		ret = bcm54140_phy_probe_once(phydev);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	priv->pkg_init = true;
> +
>  	dev_info(&phydev->mdio.dev,
>  		 "probed (port %d, base PHY address %d)\n",
>  		 priv->port, priv->base_addr);
> 

