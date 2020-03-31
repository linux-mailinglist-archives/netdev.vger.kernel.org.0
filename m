Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A71A199DE3
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 20:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgCaSQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 14:16:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33031 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgCaSQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 14:16:34 -0400
Received: by mail-wm1-f65.google.com with SMTP id z14so2623805wmf.0
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 11:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PXTiuqmZWrcjodbsvDQnmyLy0wfTLvhqsK85sw0Sx68=;
        b=COr/qkM+rdowkWWM20uDS9CPNdupfrEvd6iy2ZGlukVB9XTpGIHlj7B//atqxv6yWs
         1LI+dBUlJncCPUOwll+thEkJzLmbxBHcNLteD34GPbB98mwUBoPFDC4nWN3pPD4uFfQb
         fLUKhFyz7yLLA2yXj0xS4w94m3MZJhxW7he+7MlGtGlUnOJD3BOcS5VIzKDOqR0I08Ex
         vZPpXFKEmCIMrVUjRJDoZ0clFsBJBLftmkYYUf/yVuxrxsRAvkR5IYDm7xXEdxUZy/In
         DcSrhYXmotBRNCmKzcDkeJyWYWUOd5y4/whd8ZfKR+hbdYpCOTiA1P/MgfFbMSx9veGh
         Wgig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PXTiuqmZWrcjodbsvDQnmyLy0wfTLvhqsK85sw0Sx68=;
        b=RphgfoXSlMD8D7emhaC8eaJ3YooUyrd7a1P5iM7PR/0taA4mP7R5CcGNUsGBlietPx
         XBeECFD/o8p63if7mBReVX6uBh9+RCXhyz4PenerPkJRjt/d48Nap43Pv3DLZ+qr+RpN
         nTnu7nPKFa9vQhV9X45scNB9h2LSpDEeQO2xvQQfPUOSxCxG6+3DJUghG/I8VzHI5QPL
         eqbqRlcs2Q+6uqlS9Cc/CqkCcY37Js1P7SogKQA8ept5poQ0zibQVCKgblDM816Fy+No
         MbMW4+ouw05Kf+qphIC8XWVlYezFXWyRMBuXXOajNZZjzjFbMQgTszKk61JZcji7v9KH
         lYLQ==
X-Gm-Message-State: AGi0PuY+sHToFw9YyK3T4yXKJduIg0jc1A1yT83iA3BpqMfDINLvcxU3
        aNm4xoOyf50JQD77ZDwLu/XHMqxd
X-Google-Smtp-Source: APiQypJ2Hw8yBTLS9PH6dqtYxtoW9eznHt0tk2cTUS/+g1rOfsdvgHLU42f7203s5vbEBMhd40hRpw==
X-Received: by 2002:a05:600c:2294:: with SMTP id 20mr135517wmf.130.1585678592287;
        Tue, 31 Mar 2020 11:16:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:a9f2:3c66:5355:19b? (p200300EA8F296000A9F23C665355019B.dip0.t-ipconnect.de. [2003:ea:8f29:6000:a9f2:3c66:5355:19b])
        by smtp.googlemail.com with ESMTPSA id v11sm27902294wrm.43.2020.03.31.11.16.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 11:16:31 -0700 (PDT)
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
To:     Baruch Siach <baruch@tkos.co.il>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Shmuel Hazan <sh@tkos.co.il>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8f4ecf61-ed50-9de6-f20a-0ade5f3dcb9a@gmail.com>
Date:   Tue, 31 Mar 2020 20:16:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.03.2020 19:47, Baruch Siach wrote:
> When Marvell 88X3310 and 88E2110 hardware configuration SPI_CONFIG strap
> bit is pulled up, the host must load firmware to the PHY after reset.
> Add support for loading firmware.
> 
> Firmware files are available from Marvell under NDA.
> 

Loading firmware files that are available under NDA only in GPL-licensed
code may be problematic. I'd expect firmware files to be available in
linux-firmware at least.
I'd be interested in how the other phylib maintainers see this.

Two more remarks inline.

Last but not least:
The patch should have been annotated "net-next", and net-next is closed currently.

> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/net/phy/marvell10g.c | 114 +++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 64c9f3bba2cd..9572426ba1c6 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -27,13 +27,28 @@
>  #include <linux/marvell_phy.h>
>  #include <linux/phy.h>
>  #include <linux/sfp.h>
> +#include <linux/firmware.h>
> +#include <linux/delay.h>
>  
>  #define MV_PHY_ALASKA_NBT_QUIRK_MASK	0xfffffffe
>  #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
>  
> +#define MV_FIRMWARE_HEADER_SIZE		32
> +
>  enum {
>  	MV_PMA_BOOT		= 0xc050,
>  	MV_PMA_BOOT_FATAL	= BIT(0),
> +	MV_PMA_BOOT_PROGRESS_MASK = 0x0006,
> +	MV_PMA_BOOT_WAITING	= 0x0002,
> +	MV_PMA_BOOT_FW_LOADED	= BIT(6),
> +
> +	MV_PCS_FW_LOW_WORD	= 0xd0f0,
> +	MV_PCS_FW_HIGH_WORD	= 0xd0f1,
> +	MV_PCS_RAM_DATA		= 0xd0f2,
> +	MV_PCS_RAM_CHECKSUM	= 0xd0f3,
> +
> +	MV_PMA_FW_REV1		= 0xc011,
> +	MV_PMA_FW_REV2		= 0xc012,
>  
>  	MV_PCS_BASE_T		= 0x0000,
>  	MV_PCS_BASE_R		= 0x1000,
> @@ -223,6 +238,99 @@ static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
>  	return 0;
>  }
>  
> +static int mv3310_write_firmware(struct phy_device *phydev, const u8 *data,
> +		unsigned int size)
> +{
> +	unsigned int low_byte, high_byte;
> +	u16 checksum = 0, ram_checksum;
> +	unsigned int i = 0;
> +
> +	while (i < size) {
> +		low_byte = data[i++];
> +		high_byte = data[i++];
> +		checksum += low_byte + high_byte;
> +		phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_DATA,
> +				(high_byte << 8) | low_byte);
> +		cond_resched();
> +	}
> +
> +	ram_checksum = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_CHECKSUM);
> +	if (ram_checksum != checksum) {
> +		dev_err(&phydev->mdio.dev, "firmware checksum failed");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static void mv3310_report_firmware_rev(struct phy_device *phydev)
> +{
> +	int rev1, rev2;
> +
> +	rev1 = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_REV1);
> +	rev2 = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_REV2);
> +	if (rev1 < 0 || rev2 < 0)
> +		return;
> +
> +	dev_info(&phydev->mdio.dev, "Loaded firmware revision %d.%d.%d.%d",
> +			(rev1 & 0xff00) >> 8, rev1 & 0x00ff,
> +			(rev2 & 0xff00) >> 8, rev2 & 0x00ff);
> +}
> +
> +static int mv3310_load_firmware(struct phy_device *phydev)
> +{
> +	const struct firmware *fw_entry;
> +	char *fw_file;
> +	int ret;
> +
> +	switch (phydev->drv->phy_id) {
> +	case MARVELL_PHY_ID_88X3310:
> +		fw_file = "mrvl/x3310fw.hdr";

Firmware files should be declared with MODULE_FIRMWARE().

> +		break;
> +	case MARVELL_PHY_ID_88E2110:
> +		fw_file = "mrvl/e21x0fw.hdr";
> +		break;
> +	default:
> +		dev_warn(&phydev->mdio.dev, "unknown firmware file for %s PHY",
> +				phydev->drv->name);
> +		return -EINVAL;
> +	}
> +
> +	ret = request_firmware(&fw_entry, fw_file, &phydev->mdio.dev);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Firmware size must be larger than header, and even */
> +	if (fw_entry->size <= MV_FIRMWARE_HEADER_SIZE ||
> +			(fw_entry->size % 2) != 0) {
> +		dev_err(&phydev->mdio.dev, "firmware file invalid");
> +		return -EINVAL;
> +	}
> +
> +	/* Clear checksum register */
> +	phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_CHECKSUM);
> +
> +	/* Set firmware load address */
> +	phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_FW_LOW_WORD, 0);
> +	phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_FW_HIGH_WORD, 0x0010);
> +
> +	ret = mv3310_write_firmware(phydev,
> +			fw_entry->data + MV_FIRMWARE_HEADER_SIZE,
> +			fw_entry->size - MV_FIRMWARE_HEADER_SIZE);
> +	if (ret < 0)
> +		return ret;
> +
> +	phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT,
> +			MV_PMA_BOOT_FW_LOADED, MV_PMA_BOOT_FW_LOADED);
> +
> +	release_firmware(fw_entry);
> +
> +	msleep(100);
> +	mv3310_report_firmware_rev(phydev);
> +
> +	return 0;
> +}
> +
>  static const struct sfp_upstream_ops mv3310_sfp_ops = {
>  	.attach = phy_sfp_attach,
>  	.detach = phy_sfp_detach,
> @@ -249,6 +357,12 @@ static int mv3310_probe(struct phy_device *phydev)
>  		return -ENODEV;
>  	}
>  
> +	if ((ret & MV_PMA_BOOT_PROGRESS_MASK) == MV_PMA_BOOT_WAITING) {
> +		ret = mv3310_load_firmware(phydev);
> +		if (ret < 0)
> +			return ret;

You bail out from probe if a firmware file can't be loaded that is
available under NDA only. That doesn't seem to be too nice.

> +	}
> +
>  	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> 

