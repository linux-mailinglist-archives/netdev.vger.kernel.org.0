Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECFE199F39
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 21:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgCaThl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 15:37:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40744 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgCaThl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 15:37:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id a81so4243019wmf.5
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 12:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h4Qt1CwjKZp8tnIeFqPOMyR07Powsmy7g+eXNyd0xVY=;
        b=bo+0EZx15XkD4guGd6+fBCe5IU/UU5QLjrCmuAPWwpCDfojPHYNoM4OvI1VJnk9pDZ
         pwoRAUxySWI9yI9BhHfUtW7P4ZscKcxoWOFb/XilKyvp8LCUEybIXr6dXsIQCd6cOm/b
         1WJ75LhU6qNM/8sQScUr1yJWg9He/U928kLoBhlT3dWCq/gtElnDJXA5fzC5VCAhRWts
         zay9igjMTQYPqeNfkJW1JSX9ue5QGOFlRNBvRZn6EgmZ8sFgFwcypOBBCpGnATFHV8Gl
         2DDZvhKHX7C+fPiBmEEnphDqLljqEbfsmM0MVeoYIzyWdflrP/xF1GeKtdHfI9jRNri/
         n6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=h4Qt1CwjKZp8tnIeFqPOMyR07Powsmy7g+eXNyd0xVY=;
        b=BTB1rhGkyGtopvHZynPXwTWf7KO1yHU0RSbF1Xo7qlDZYog+/XIxQuFIwg8zfP0NRV
         HCQt9NQ+KJCAS16JSrT5NJXjVqEVkYkDoVOKcwGuBJEOPiCr0Y53+pTHftLyDdUs+2CG
         zioIllm3niiQn8KbLE8Zt2ZZjLqTbf/fsA7hcB9uIPyy1gXG8nHQNe9u7TqMmDKt51+n
         EsF5SA0ddUJjIS3VnUvP4QnOnna/IJZSaYI/53uijeT9G//MR0OXoEjQi6DX0+77sqay
         V4kwPNwv+fnC4AkfhMhW3SKhlm+rCXPQM5Evhx1I7CZ2TZ1luESzqUWlgl/B8JUpwiek
         w7OA==
X-Gm-Message-State: AGi0PubTkHJCEs2bEOUtBjV+INcZZDrtbPLWYD8YWZDWZ/LOhWqVuFBs
        Z3PzK3tSzoXp3aBClpK6YBE=
X-Google-Smtp-Source: APiQypJVOFzFRoiNtaK9CmoApkjX6zkw8/RLDhOiIgaqgneIt10OGmWbifi087y+42fda1X4IuZD0Q==
X-Received: by 2002:a05:600c:1403:: with SMTP id g3mr448769wmi.76.1585683458129;
        Tue, 31 Mar 2020 12:37:38 -0700 (PDT)
Received: from [10.230.186.223] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k3sm5148831wmf.16.2020.03.31.12.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 12:37:37 -0700 (PDT)
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
To:     Baruch Siach <baruch@tkos.co.il>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Shmuel Hazan <sh@tkos.co.il>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <ad024231-40bd-c82f-e6d0-3b1b00c93e9a@gmail.com>
Date:   Tue, 31 Mar 2020 12:37:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/2020 10:47 AM, Baruch Siach wrote:
> When Marvell 88X3310 and 88E2110 hardware configuration SPI_CONFIG strap
> bit is pulled up, the host must load firmware to the PHY after reset.
> Add support for loading firmware.
> 
> Firmware files are available from Marvell under NDA.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---

[snip]

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

If there is an error upon write, there is really no point in continuing
any further, so you should just break out of the loop and return an
error. Having to continue and then fail the checksum is going to take an
awful amount of time.

> +		cond_resched();
> +	}
> +
> +	ram_checksum = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_CHECKSUM);

Likewise, you need to check for phy_read_mmd() returning < 0.

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

You need to release the firmware file here. There is also possibly
another case that you are not covering here, which is that the firmware
on disk is newer than the firmware *already* loaded in the PHY, this
should presumably update the running firmware to the latest copy.

Without being able to publish the firmware in linux-firmware though, all
of this may be moot.

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

And here too.

> +
> +	phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT,
> +			MV_PMA_BOOT_FW_LOADED, MV_PMA_BOOT_FW_LOADED);
> +
> +	release_firmware(fw_entry);
-- 
Florian
