Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38FAC274D
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbfI3UwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:52:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33248 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729503AbfI3UwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:52:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so913807wme.0;
        Mon, 30 Sep 2019 13:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8sM3A81f9Xr+CTFcU63aM7o+IniBWRXvgW3hT44K4eA=;
        b=jvDjmTcZjLLO+pN8Q1nrG5NdUzZ7C3elxPwuszgqv6ffhIYeDSyzB+cNFypKp6ojkY
         Ip9+9SdRMLaVo3rKmzS4qGiUmX1dpde/iZRp00GftPSUtWdc7UEwCt99SHIZLDRJ01nh
         nFjG7pSuMSN0GmBwdQ8RiZtlNaJfwx+6psftsPmzQ24LkTDqFzF0XlLqgz8dWhivsxdJ
         VmFy0qem9usbqvWtNXcqtVFOCaUFyDn6dyh4euwR60erq1H+T2JuE/Hi4HFK7izpUm3P
         X24MITNb4YlGf2Sa29bkEBTt58qUZpX5venmw+TqTxn0N5a17VXUGuPr+SvX/cZUdH2D
         XunA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8sM3A81f9Xr+CTFcU63aM7o+IniBWRXvgW3hT44K4eA=;
        b=bFyG+XvSsWxDSm3pVOrzv6qKRJSOFDM2u6Eyb3LqSiJYagg9oP+7zJlAsAjQbG/JEu
         zJ1f1F0ZtmCoTv21Rg5nob5DrWI5OjoL44xsqOyK96Il9DrXlWtJMVznSW83QnIhhTiy
         BilGC9AoGpUtHYOiR0DW8Q7oC/gMVY29l3GA8dTIP0tllfW0JmwIklFSGGLznm3ATgXS
         aERzH6sIpnHnkopFdD6Flxf6ciaTz9i2xZ//T3s4qb6h0W41qnm9qZ9vT5iqfJSyBCHk
         HsDU/xIH02OUZX5bqqo8g1AzJn4g4/yMOLGU4QLz09oBrDrvhL3XUXEqowkl2xte79so
         +mYg==
X-Gm-Message-State: APjAAAVXVk5tNPXQT24y2JCcYIyaBRG6npiCw+veUbSuG3Mz+zP33qJE
        RvUfrRGct5OIBg1ebFfC7vyUJICV
X-Google-Smtp-Source: APXvYqwyglTDIXFxcjpQPfFoYe0m/+FVKdJ9ImPfKTXtX45DEZK/eGEvy1588/8hMk1iORJ40W2J7w==
X-Received: by 2002:a1c:9d52:: with SMTP id g79mr370084wme.91.1569867578764;
        Mon, 30 Sep 2019 11:19:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:542:c9fe:c835:31f1? (p200300EA8F2664000542C9FEC83531F1.dip0.t-ipconnect.de. [2003:ea:8f26:6400:542:c9fe:c835:31f1])
        by smtp.googlemail.com with ESMTPSA id l9sm168955wme.45.2019.09.30.11.19.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 11:19:38 -0700 (PDT)
Subject: Re: [PATCH v1] net: phy: at803x: add ar9331 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190930092710.32739-1-o.rempel@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <142d584d-e3b1-a544-fd78-ea93a02b594f@gmail.com>
Date:   Mon, 30 Sep 2019 20:19:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190930092710.32739-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2019 11:27, Oleksij Rempel wrote:
> Mostly this hardware can work with generic PHY driver, but this change
> is needed to provided interrupt handling support.
> Tested with dsa ar9331-switch driver.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/at803x.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 6ad8b1c63c34..d62a77adb8e7 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -53,6 +53,7 @@
>  #define AT803X_DEBUG_REG_5			0x05
>  #define AT803X_DEBUG_TX_CLK_DLY_EN		BIT(8)
>  
> +#define AR9331_PHY_ID 0x004dd041
>  #define ATH8030_PHY_ID 0x004dd076
>  #define ATH8031_PHY_ID 0x004dd074
>  #define ATH8035_PHY_ID 0x004dd072
> @@ -406,11 +407,24 @@ static struct phy_driver at803x_driver[] = {
>  	.aneg_done		= at803x_aneg_done,
>  	.ack_interrupt		= &at803x_ack_interrupt,
>  	.config_intr		= &at803x_config_intr,
> +}, {
> +	/* ATHEROS AR9331 */
> +	.phy_id			= AR9331_PHY_ID,
> +	.name			= "Atheros AR9331 built-in PHY",
> +	.phy_id_mask		= AT803X_PHY_ID_MASK,

The ID mask of 0xffffffef is quite strange, it ignores the last
bit of the model number and requires exact match of the revision
number. Unfortunately the original commit doesn't explain why
this mask was chosen. It would only make sense if there are
functionally identical PHY's with e.g. id 0x004dd051.
If in doubt I'd suggest you use macro PHY_ID_MATCH_EXACT.

> +	.probe			= at803x_probe,

After 5c5f626bcace ("net: phy: improve handling link_change_notify
callback") struct at803x_priv isn't used any longer and the probe
callback could be removed. I didn't do that as part of this commit
because I could compile-test the change only.

> +	.config_init		= at803x_config_init,
> +	.suspend		= at803x_suspend,
> +	.resume			= at803x_resume,
> +	/* PHY_BASIC_FEATURES */
> +	.ack_interrupt		= &at803x_ack_interrupt,
> +	.config_intr		= &at803x_config_intr,
>  } };
>  
>  module_phy_driver(at803x_driver);
>  
>  static struct mdio_device_id __maybe_unused atheros_tbl[] = {
> +	{ AR9331_PHY_ID, AT803X_PHY_ID_MASK },

See comment above regarding the id mask.

>  	{ ATH8030_PHY_ID, AT803X_PHY_ID_MASK },
>  	{ ATH8031_PHY_ID, AT803X_PHY_ID_MASK },
>  	{ ATH8035_PHY_ID, AT803X_PHY_ID_MASK },
> 
Heiner
