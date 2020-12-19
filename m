Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718BD2DEFC6
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 14:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgLSNPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 08:15:05 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:49935 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgLSNPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 08:15:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608383686; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=vF2tRJdVs7NAbGUb5gOO9ZX208vXYERNEeC0arSjvdo=; b=NNCCTtRydWe7rRKv3UWMnbPBrWy4zuoDoDLL8nO1qetC8kCcx9+5kuhS6yptelKb4Y3RGByY
 cs2hpqw6cPSkyY2MCYy4zzSK54PEIEK0OI7ot/SFjhI2IH0qocb3Kt6s6IH1y0knj7aoqj/q
 Nxe784VreIuMJXG62/TAWhqV7R4=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fddfcaabfd08afb0de503ec (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 19 Dec 2020 13:14:18
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7E5D6C43463; Sat, 19 Dec 2020 13:14:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 36A10C433CA;
        Sat, 19 Dec 2020 13:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 36A10C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH] [v11] wireless: Initial driver submission for pureLiFi STA devices
References: <20200928102008.32568-1-srini.raju@purelifi.com>
        <20201208115719.349553-1-srini.raju@purelifi.com>
Date:   Sat, 19 Dec 2020 15:14:11 +0200
In-Reply-To: <20201208115719.349553-1-srini.raju@purelifi.com> (Srinivasan
        Raju's message of "Tue, 8 Dec 2020 17:27:04 +0530")
Message-ID: <87o8iqq6os.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> writes:

> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.
>
> This driver implementation has been based on the zd1211rw driver.
>
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management.
>
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture.
>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

[...]

> +int download_fpga(struct usb_interface *intf)
> +{
> +	int r, actual_length;
> +	int fw_data_i, blk_tran_len = 16384;
> +	const char *fw_name;
> +	unsigned char fpga_setting[2];
> +	unsigned char *fpga_dmabuff;
> +	unsigned char *fw_data;
> +	unsigned char fpga_state[9];
> +	struct firmware *fw = NULL;
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +
> +	if ((le16_to_cpu(udev->descriptor.idVendor) ==
> +				PURELIFI_X_VENDOR_ID_0) &&
> +	    (le16_to_cpu(udev->descriptor.idProduct) ==
> +				PURELIFI_X_PRODUCT_ID_0)) {
> +		fw_name = "purelifi/li_fi_x/LiFi-X.bin";
> +		dev_info(&intf->dev, "bin file for X selected\n");
> +
> +	} else if ((le16_to_cpu(udev->descriptor.idVendor)) ==
> +					PURELIFI_XC_VENDOR_ID_0 &&
> +		   (le16_to_cpu(udev->descriptor.idProduct) ==
> +					PURELIFI_XC_PRODUCT_ID_0)) {
> +		fw_name = "purelifi/li_fi_x/LiFi-XC.bin";
> +		dev_info(&intf->dev, "bin file for XC selected\n");
> +
> +	} else {
> +		r = -EINVAL;
> +		goto error;
> +	}
> +
> +	r = request_firmware((const struct firmware **)&fw, fw_name,
> +			     &intf->dev);
> +	if (r) {
> +		dev_err(&intf->dev, "request_firmware failed (%d)\n", r);
> +		goto error;
> +	}
> +	fpga_dmabuff = NULL;
> +	fpga_dmabuff = kmalloc(2, GFP_KERNEL);
> +
> +	if (!fpga_dmabuff) {
> +		r = -ENOMEM;
> +		goto error_free_fw;
> +	}
> +	send_vendor_request(udev, 0x33, fpga_dmabuff, sizeof(fpga_setting));
> +	memcpy(fpga_setting, fpga_dmabuff, 2);
> +	kfree(fpga_dmabuff);
> +
> +	send_vendor_command(udev, 0x34, NULL, 0);

I see lots of magic numbers in the driver like 2, 0x33 and 0x34 here.
Please convert the magic numbers to proper defines explaining the
meaning. And for vendor commands you could even use enum to group them
better in .h file somewhere.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
