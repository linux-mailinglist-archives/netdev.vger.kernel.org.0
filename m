Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7E72F2A35
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405624AbhALInw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732457AbhALInw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:43:52 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF90C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:43:11 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id y23so1266831wmi.1
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 00:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hxTy4U1QH17oZBJWOofPoN2X6H3JDhM9Sh7IsXwJBr0=;
        b=CiYB0YD5B/pDp/NzqhvH9knx1XSMqfwsBeAm9QEXzDQhGgGhzxPYXJ88fFmTwaHsLK
         IS+eQowEgwokhu0BrQhKgVg05Cu2I+3FgsOWieXonaRVaWxFIiuAkOX/zTsQtQBKNQOt
         TTMcsRA37aykCWcLzsD6FNlFiVHCc4kwFF4EmKsbfLg+iMdDp8sOJKYWauIS4fxfCAEs
         SejrlbEkG+kfIx8n8k6Jug4mhg8sKZ8zVyvxLyBJX+xlaMHzpVWuTPGM5kRdHWTMCSTb
         JJQy9u5smoEtD1/4SDLlqOrCPBYnXMHlZtEgWKYYqRAW3CCxxIFGH8ne+VPJ7o1/0Kge
         /dJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hxTy4U1QH17oZBJWOofPoN2X6H3JDhM9Sh7IsXwJBr0=;
        b=cCx+Uh42JsHSdU2qAJuB8WdD3EzTmxScJlojuJb9J9zunzoTiqYi/wiAXF+wbm2NMx
         yilrD79qu6iHbgK07DUPjWJzbGGtzy15Kiz8BRvyNIk2CiglckDwMU9VVoM2Ydc0ryL/
         mCxh2DUok0sbOjIJV4TCQB5KCkPPt1lvXhPCHCVlZaSyRvywHWd84F8trFWgS+HwfPtK
         F6gZSJ4kyGEwPuHWjnNZVpznRA6anmjvpAGAN2FarJU/3DMygp0pd6kJ+Q8Jla1nUweZ
         TKBLtFO6lw6MLzKI5lpZ6kTb8i/9PHLOJMVYKHXOFc6evvNubLUZSq47mwq4qyuomBKF
         /2Uw==
X-Gm-Message-State: AOAM530jz6tenL7Eq1VpV+rnsBzks/9TbHiGrWw1SLbvIEOH2uYD47Ag
        iVP+GUPi8YFlgus7+KqfUkw=
X-Google-Smtp-Source: ABdhPJwty7g6FfYgHqlMrMoChgjXBIZaDQIT+38GSciAIk29MhcKuTlOuxXI3Fkmuhe9MNL5OaSmUw==
X-Received: by 2002:a1c:9acb:: with SMTP id c194mr2391060wme.43.1610440990117;
        Tue, 12 Jan 2021 00:43:10 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:d420:a714:6def:4af7? (p200300ea8f065500d420a7146def4af7.dip0.t-ipconnect.de. [2003:ea:8f06:5500:d420:a714:6def:4af7])
        by smtp.googlemail.com with ESMTPSA id i18sm3758179wrp.74.2021.01.12.00.43.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 00:43:09 -0800 (PST)
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, pali@kernel.org
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <51416633-ab53-460f-0606-ef6408299adc@gmail.com>
Date:   Tue, 12 Jan 2021 09:42:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111050044.22002-2-kabel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.01.2021 06:00, Marek Behún wrote:
> Some multigig SFPs from RollBall and Hilink do not expose functional
> MDIO access to the internal PHY of the SFP via I2C address 0x56
> (although there seems to be read-only clause 22 access on this address).
> 
> Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
> Digital Diagnostic Interface - I2C address 0x51. The SFP_PAGE has to be
> selected to 3 and the password must be filled with 0xff bytes for this
> PHY communication to work.
> 
> This extends the mdio-i2c driver to support this protocol by adding a
> special parameter to mdio_i2c_alloc function via which this RollBall
> protocol can be selected.
> 
I'd think that mdio-i2c.c is for generic code. When adding a
vendor-specific protocol, wouldn't it make sense to use a dedicated
source file for it?

> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/mdio/mdio-i2c.c   | 319 +++++++++++++++++++++++++++++++++-
>  drivers/net/phy/sfp.c         |   2 +-
>  include/linux/mdio/mdio-i2c.h |   8 +-
>  3 files changed, 322 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
> index 09200a70b315..7be582c0891a 100644
> --- a/drivers/net/mdio/mdio-i2c.c
> +++ b/drivers/net/mdio/mdio-i2c.c
> @@ -3,6 +3,7 @@
>   * MDIO I2C bridge
>   *
>   * Copyright (C) 2015-2016 Russell King
> + * Copyright (C) 2021 Marek Behun
>   *
>   * Network PHYs can appear on I2C buses when they are part of SFP module.
>   * This driver exposes these PHYs to the networking PHY code, allowing
> @@ -12,6 +13,7 @@
>  #include <linux/i2c.h>
>  #include <linux/mdio/mdio-i2c.h>
>  #include <linux/phy.h>
> +#include <linux/sfp.h>
>  
>  /*
>   * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
> @@ -28,7 +30,7 @@ static unsigned int i2c_mii_phy_addr(int phy_id)
>  	return phy_id + 0x40;
>  }
>  
> -static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
> +static int i2c_mii_read_default(struct mii_bus *bus, int phy_id, int reg)
>  {
>  	struct i2c_adapter *i2c = bus->priv;
>  	struct i2c_msg msgs[2];
> @@ -62,7 +64,8 @@ static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
>  	return data[0] << 8 | data[1];
>  }
>  
> -static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
> +static int i2c_mii_write_default(struct mii_bus *bus, int phy_id, int reg,
> +				 u16 val)
>  {
>  	struct i2c_adapter *i2c = bus->priv;
>  	struct i2c_msg msg;
> @@ -91,9 +94,297 @@ static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
>  	return ret < 0 ? ret : 0;
>  }
>  
> -struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
> +/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
> + * instead via address 0x51, when SFP page is set to 0x03 and password to
> + * 0xffffffff.
> + * Since current SFP code does not modify SFP_PAGE, we set it to 0x03 only at
> + * bus creation time, and expect it to remain set to 0x03 throughout the
> + * lifetime of the module plugged into the system. If the SFP code starts
> + * modifying SFP_PAGE in the future, this code will need to change.
> + *
> + * address  size  contents  description
> + * -------  ----  --------  -----------
> + * 0x80     1     CMD       0x01/0x02/0x04 for write/read/done
> + * 0x81     1     DEV       Clause 45 device
> + * 0x82     2     REG       Clause 45 register
> + * 0x84     2     VAL       Register value
> + */
> +#define ROLLBALL_PHY_I2C_ADDR		0x51
> +#define ROLLBALL_SFP_PASSWORD_ADDR	0x7b
> +
> +#define ROLLBALL_CMD_ADDR		0x80
> +#define ROLLBALL_DATA_ADDR		0x81
> +
> +#define ROLLBALL_CMD_WRITE		0x01
> +#define ROLLBALL_CMD_READ		0x02
> +#define ROLLBALL_CMD_DONE		0x04
> +
> +#define SFP_PAGE_ROLLBALL_MDIO		3
> +
> +static int __i2c_transfer_err(struct i2c_adapter *i2c, struct i2c_msg *msgs,
> +			      int num)
> +{
> +	int ret;
> +
> +	ret = __i2c_transfer(i2c, msgs, num);
> +	if (ret < 0)
> +		return ret;
> +	else if (ret != num)
> +		return -EIO;
> +	else
> +		return 0;
> +}
> +
> +static int __i2c_rollball_get_page(struct i2c_adapter *i2c, int bus_addr,
> +				   u8 *page)
> +{
> +	struct i2c_msg msgs[2];
> +	u8 addr = SFP_PAGE;
> +
> +	msgs[0].addr = bus_addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = 1;
> +	msgs[0].buf = &addr;
> +
> +	msgs[1].addr = bus_addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = 1;
> +	msgs[1].buf = page;
> +
> +	return __i2c_transfer_err(i2c, msgs, 2);
> +}
> +
> +static int __i2c_rollball_set_page(struct i2c_adapter *i2c, int bus_addr,
> +				   u8 page)
> +{
> +	struct i2c_msg msg;
> +	u8 buf[2];
> +
> +	buf[0] = SFP_PAGE;
> +	buf[1] = page;
> +
> +	msg.addr = bus_addr;
> +	msg.flags = 0;
> +	msg.len = 2;
> +	msg.buf = buf;
> +
> +	return __i2c_transfer_err(i2c, &msg, 1);
> +}
> +
> +/* In order to not interfere with other SFP code (which possibly may manipulate
> + * SFP_PAGE), for every transfer we do this:
> + *   1. lock the bus
> + *   2. save content of SFP_PAGE
> + *   3. set SFP_PAGE to 3
> + *   4. do the transfer
> + *   5. restore original SFP_PAGE
> + *   6. unlock the bus
> + * Note that one might think that steps 2 to 5 could be theoretically done all
> + * in one call to i2c_transfer (by constructing msgs array in such a way), but
> + * unfortunately tests show that this does not work :-( Changed SFP_PAGE does
> + * not take into account until i2c_transfer() is done.
> + */
> +static int i2c_transfer_rollball(struct i2c_adapter *i2c,
> +				 struct i2c_msg *msgs, int num)
> +{
> +	u8 saved_page;
> +	int ret;
> +
> +	i2c_lock_bus(i2c, I2C_LOCK_SEGMENT);
> +
> +	/* save original page */
> +	ret = __i2c_rollball_get_page(i2c, msgs->addr, &saved_page);
> +	if (ret)
> +		goto unlock;
> +
> +	/* change to RollBall MDIO page */
> +	ret = __i2c_rollball_set_page(i2c, msgs->addr, SFP_PAGE_ROLLBALL_MDIO);
> +	if (ret)
> +		goto unlock;
> +
> +	/* do the transfer */
> +	ret = __i2c_transfer_err(i2c, msgs, num);
> +	if (ret)
> +		goto unlock;
> +
> +	/* restore original page */
> +	ret = __i2c_rollball_set_page(i2c, msgs->addr, saved_page);
> +
> +unlock:
> +	i2c_unlock_bus(i2c, I2C_LOCK_SEGMENT);
> +
> +	return ret;
> +}
> +
> +static int i2c_rollball_mii_poll(struct mii_bus *bus, int bus_addr, u8 *buf,
> +				 size_t len)
> +{
> +	struct i2c_adapter *i2c = bus->priv;
> +	struct i2c_msg msgs[2];
> +	u8 cmd_addr, tmp, *res;
> +	int i, ret;
> +
> +	cmd_addr = ROLLBALL_CMD_ADDR;
> +
> +	res = buf ? buf : &tmp;
> +	len = buf ? len : 1;
> +
> +	msgs[0].addr = bus_addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = 1;
> +	msgs[0].buf = &cmd_addr;
> +
> +	msgs[1].addr = bus_addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = len;
> +	msgs[1].buf = res;
> +
> +	/* By experiment it takes up to 70 ms to access a register for these
> +	 * SFPs. Sleep 20ms between iteratios and try 10 times.
> +	 */
> +	i = 10;
> +	do {
> +		msleep(20);
> +
> +		ret = i2c_transfer_rollball(i2c, msgs, ARRAY_SIZE(msgs));
> +		if (ret)
> +			return ret;
> +
> +		if (*res == ROLLBALL_CMD_DONE)
> +			return 0;
> +	} while (i-- > 0);
> +
> +	dev_dbg(&bus->dev, "poll timed out\n");
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int i2c_rollball_mii_cmd(struct mii_bus *bus, int bus_addr, u8 cmd,
> +				u8 *data, size_t len)
> +{
> +	struct i2c_adapter *i2c = bus->priv;
> +	struct i2c_msg msgs[2];
> +	u8 cmdbuf[2];
> +
> +	cmdbuf[0] = ROLLBALL_CMD_ADDR;
> +	cmdbuf[1] = cmd;
> +
> +	msgs[0].addr = bus_addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = len;
> +	msgs[0].buf = data;
> +
> +	msgs[1].addr = bus_addr;
> +	msgs[1].flags = 0;
> +	msgs[1].len = sizeof(cmdbuf);
> +	msgs[1].buf = cmdbuf;
> +
> +	return i2c_transfer_rollball(i2c, msgs, ARRAY_SIZE(msgs));
> +}
> +
> +static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
> +{
> +	u8 buf[4], res[6];
> +	int bus_addr, ret;
> +	u16 val;
> +
> +	if (!(reg & MII_ADDR_C45))
> +		return -EOPNOTSUPP;
> +
> +	bus_addr = i2c_mii_phy_addr(phy_id);
> +	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
> +		return 0xffff;
> +
> +	buf[0] = ROLLBALL_DATA_ADDR;
> +	buf[1] = (reg >> 16) & 0x1f;
> +	buf[2] = (reg >> 8) & 0xff;
> +	buf[3] = reg & 0xff;
> +
> +	ret = i2c_rollball_mii_cmd(bus, bus_addr, ROLLBALL_CMD_READ, buf,
> +				   sizeof(buf));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = i2c_rollball_mii_poll(bus, bus_addr, res, sizeof(res));
> +	if (ret == -ETIMEDOUT)
> +		return 0xffff;
> +	else if (ret < 0)
> +		return ret;
> +
> +	val = res[4] << 8 | res[5];
> +
> +	dev_dbg(&bus->dev, "read reg %02x:%04x = %04x\n", (reg >> 16) & 0x1f,
> +		reg & 0xffff, val);
> +
> +	return val;
> +}
> +
> +static int i2c_mii_write_rollball(struct mii_bus *bus, int phy_id, int reg,
> +				  u16 val)
> +{
> +	int bus_addr, ret;
> +	u8 buf[6];
> +
> +	if (!(reg & MII_ADDR_C45))
> +		return -EOPNOTSUPP;
> +
> +	bus_addr = i2c_mii_phy_addr(phy_id);
> +	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
> +		return 0;
> +
> +	buf[0] = ROLLBALL_DATA_ADDR;
> +	buf[1] = (reg >> 16) & 0x1f;
> +	buf[2] = (reg >> 8) & 0xff;
> +	buf[3] = reg & 0xff;
> +	buf[4] = val >> 8;
> +	buf[5] = val & 0xff;
> +
> +	ret = i2c_rollball_mii_cmd(bus, bus_addr, ROLLBALL_CMD_WRITE, buf,
> +				   sizeof(buf));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = i2c_rollball_mii_poll(bus, bus_addr, NULL, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(&bus->dev, "write reg %02x:%04x = %04x\n", (reg >> 16) & 0x1f,
> +		reg & 0xffff, val);
> +
> +	return 0;
> +}
> +
> +static int i2c_mii_init_rollball(struct i2c_adapter *i2c)
> +{
> +	struct i2c_msg msg;
> +	u8 pw[5];
> +	int ret;
> +
> +	pw[0] = ROLLBALL_SFP_PASSWORD_ADDR;
> +	pw[1] = 0xff;
> +	pw[2] = 0xff;
> +	pw[3] = 0xff;
> +	pw[4] = 0xff;
> +
> +	msg.addr = ROLLBALL_PHY_I2C_ADDR;
> +	msg.flags = 0;
> +	msg.len = sizeof(pw);
> +	msg.buf = pw;
> +
> +	ret = i2c_transfer(i2c, &msg, 1);
> +	if (ret < 0)
> +		return ret;
> +	else if (ret != 1)
> +		return -EIO;
> +	else
> +		return 0;
> +}
> +
> +struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
> +			       enum mdio_i2c_proto protocol)
>  {
>  	struct mii_bus *mii;
> +	int ret;
>  
>  	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
>  		return ERR_PTR(-EINVAL);
> @@ -104,10 +395,28 @@ struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
>  
>  	snprintf(mii->id, MII_BUS_ID_SIZE, "i2c:%s", dev_name(parent));
>  	mii->parent = parent;
> -	mii->read = i2c_mii_read;
> -	mii->write = i2c_mii_write;
>  	mii->priv = i2c;
>  
> +	switch (protocol) {
> +	case MDIO_I2C_ROLLBALL:
> +		ret = i2c_mii_init_rollball(i2c);
> +		if (ret < 0) {
> +			dev_err(parent,
> +				"Cannot initialize RollBall MDIO I2C protocol: %d\n",
> +				ret);
> +			mdiobus_free(mii);
> +			return ERR_PTR(ret);
> +		}
> +
> +		mii->read = i2c_mii_read_rollball;
> +		mii->write = i2c_mii_write_rollball;
> +		break;
> +	default:
> +		mii->read = i2c_mii_read_default;
> +		mii->write = i2c_mii_write_default;
> +		break;
> +	}
> +
>  	return mii;
>  }
>  EXPORT_SYMBOL_GPL(mdio_i2c_alloc);
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 91d74c1a920a..958fd514a3b4 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -419,7 +419,7 @@ static int sfp_i2c_configure(struct sfp *sfp, struct i2c_adapter *i2c)
>  	sfp->read = sfp_i2c_read;
>  	sfp->write = sfp_i2c_write;
>  
> -	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c);
> +	i2c_mii = mdio_i2c_alloc(sfp->dev, i2c, MDIO_I2C_DEFAULT);
>  	if (IS_ERR(i2c_mii))
>  		return PTR_ERR(i2c_mii);
>  
> diff --git a/include/linux/mdio/mdio-i2c.h b/include/linux/mdio/mdio-i2c.h
> index b1d27f7cd23f..53eedb0dc1d3 100644
> --- a/include/linux/mdio/mdio-i2c.h
> +++ b/include/linux/mdio/mdio-i2c.h
> @@ -11,6 +11,12 @@ struct device;
>  struct i2c_adapter;
>  struct mii_bus;
>  
> -struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c);
> +enum mdio_i2c_proto {
> +	MDIO_I2C_DEFAULT,
> +	MDIO_I2C_ROLLBALL,
> +};
> +
> +struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
> +			       enum mdio_i2c_proto protocol);
>  
>  #endif
> 

