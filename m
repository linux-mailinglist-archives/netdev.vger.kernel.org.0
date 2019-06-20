Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752704D27A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfFTPxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:53:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51855 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFTPxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 11:53:37 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so3601992wma.1
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 08:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=59sOw1Oebt3fIvV/+8aXEs4eROjOmxKYdJI1aO6UkgQ=;
        b=SISGPHft8zTQqSB7wq9CtPBCrHv7OnTSGwBse3rRTdsMB0RWWaf1RHLrT00hMVfeTW
         M2UW6hMTOaUuCTNr7ieSaeMF+xgAU5ikzJaJFSIv/Yapd0nB28qJJwAsGPPRrUZ5lgSa
         xo8OfLTkfmmTe1bjGw3XibDB2iXyZCvrlpqTitRgCl9LgF55HDyvbf3WRseKSHdP20ro
         bgU5e1lQ4v6/l3CJYgWxUGFtBc570LRgiaCAkypokEid2/TjnhmGPTx3UlVJjASgGmX3
         NsivP/b8m2CssCFQoHhdFi2mgyFb2M/DRAPFGQJIBDJ2WU6ZT+TnJtqcI0MdBebjPzSf
         IlVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=59sOw1Oebt3fIvV/+8aXEs4eROjOmxKYdJI1aO6UkgQ=;
        b=OaM4Q5osBU4W1aXbYVO9sbOCeGAVy1OppeiizUsbq8Ab8WYaOOBtv2ieoBs/NQ9oze
         0fUzqnuL+l6O067bQ6FZv2Cc02jCoV6lAIY4YbCmD4KNDNkXidI7uJtgzCTPa77SX2jk
         ISZgSPMQbSyR4BlbVw+C3ngE+XPYPZg/AIrCM77t5x5xRFck5k34k4zkJgrpgzoSXMmL
         OCArpILSamItt6XYRg7g15pIs5Dc17jMRIZ4OhlEsQHS0xFRF6fJshNlmnitLtk8Catc
         hnzhfFqGtnsqZcSAWJ1b5hCg04K5oD3rPjdnZNtk3ISwBinLv5qQd0mBaYIrmEhdfUdv
         ZUrw==
X-Gm-Message-State: APjAAAWovV51VHKPfmRZi/c1MQQW0IoukP2C0rSuuzx62156AQcFP1yB
        o36/Mr6fgwMgy/+qFL0eJBI=
X-Google-Smtp-Source: APXvYqxDVaxLlh9Pgi3fgjO+oeP/eh0en3IwzT1vQwqAGLE2Dmzj3CCJ9WSGtoatnLTotlSoJqFsFA==
X-Received: by 2002:a1c:e718:: with SMTP id e24mr237949wmh.104.1561046015032;
        Thu, 20 Jun 2019 08:53:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:fdf8:4ce8:7b2:7440? (p200300EA8BF3BD00FDF84CE807B27440.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:fdf8:4ce8:7b2:7440])
        by smtp.googlemail.com with ESMTPSA id u25sm5113845wmc.3.2019.06.20.08.53.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 08:53:34 -0700 (PDT)
Subject: Re: network unstable on odroid-c1/meson8b.
To:     Aymeric <mulx@aplu.fr>
Cc:     netdev@vger.kernel.org, linux-amlogic@lists.infradead.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
References: <ff9a72bf-7eeb-542b-6292-dd70abdc4e79@aplu.fr>
 <0df100ad-b331-43db-10a5-3257bd09938d@gmail.com>
 <d2e298040f4887c547da11178f9ea64f@aplu.fr>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1f34f3b6-2c70-9ff3-3f5a-597e4bd9c66f@gmail.com>
Date:   Thu, 20 Jun 2019 17:53:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <d2e298040f4887c547da11178f9ea64f@aplu.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.06.2019 09:55, Aymeric wrote:
> Hi,
> On 2019-06-20 00:14, Heiner Kallweit wrote:
>> On 19.06.2019 22:18, Aymeric wrote:
>>> Hello all,
>>>
> 
>> Kernel 3.10 didn't have a dedicated RTL8211F PHY driver yet, therefore
>> I assume the genphy driver was used. Do you have a line with
>> "attached PHY driver" in dmesg output of the vendor kernel?
> 
> No.
> Here is the full output of the dmesg from vendor kernel [¹].
> 
> I've also noticed something strange, it might be linked, but mac address of the board is set to a random value when using mainline kernel and I've to set it manually but not when using vendor kernel.
> 
>>
>> The dedicated PHY driver takes care of the tx delay, if the genphy
>> driver is used we have to rely on what uboot configured.
>> But if we indeed had an issue with a misconfigured delay, I think
>> the connection shouldn't be fine with just another link partner.
>> Just to have it tested you could make rtl8211f_config_init() in
>> drivers/net/phy/realtek.c a no-op (in current kernels).
>>
> 
> I'm not an expert here, just adding a "return 0;" here[²] would be enough?
> 
>> And you could compare at least the basic PHY registers 0x00 - 0x30
>> with both kernel versions, e.g. with phytool.
>>
> 
> They are not the same but I don't know what I'm looking for, so for kernel 3.10 [³] and for kernel 5.1.12 [⁴].
> 
> Aymeric
> 
> [¹]: https://paste.aplu.fr/?38ef95b44ebdbfc3#G666/YbhgU+O+tdC/2HaimUCigm8ZTB44qvQip/HJ5A=
> [²]: https://github.com/torvalds/linux/blob/241e39004581475b2802cd63c111fec43bb0123e/drivers/net/phy/realtek.c#L164
> [³]: https://paste.aplu.fr/?2dde1c32d5c68f4c#6xIa8MjTm6jpI6citEJAqFTLMMHDjFZRet/M00/EwjU=
> [⁴]: https://paste.aplu.fr/?32130e9bcb05dde7#N/xdnvb5GklcJtiOxMpTCm+9gsUliRwH8X3dcwSV+ng=
> 

The vendor kernel has some, but not really much magic:
https://github.com/hardkernel/linux/blob/odroidc-3.10.y/drivers/amlogic/ethernet/phy/am_rtl8211f.c
The write to RTL8211F_PHYCR2 is overwritten later, therefore we don't have to consider it.

The following should make the current Realtek PHY driver behave like in the vendor driver.
Could you test it?


diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index a669945eb..f300b1cc9 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -163,6 +163,10 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 {
 	u16 val;
 
+	phy_write_paged(phydev, 0x0a43, 0x19, 0x0803);
+	genphy_soft_reset(phydev);
+	return 0;
+
 	/* enable TX-delay for rgmii-{id,txid}, and disable it for rgmii and
 	 * rgmii-rxid. The RX-delay can be enabled by the external RXDLY pin.
 	 */
-- 
2.22.0


