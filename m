Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18B62C4017
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 20:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfJASlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:41:03 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53449 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfJASlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:41:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id i16so4499747wmd.3;
        Tue, 01 Oct 2019 11:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ad9CzssPymOGmpiotW53dcVN6Jgme73EHYSK1vbEGGM=;
        b=VE9y2exDYQ7iwgALQkEQazkwcCgDWcrbAlzPRlNSraU8nXtNWAMptA/baTT0J24TUu
         ALLRsmCxj19bnsRVMHd1Mc335jfcWI6e7QWfN2Yw3/oWVw70s9en+9XR0sGLGpaHOfM8
         ozhMd3I/S3kQs0JO4mJzY4I9CcdJCx27r0wXbe/FjFe0mrqocXVWuD24OsbaUtILsIX3
         U8lHMIvflzb1e4dWlGtqUADN9SMh2FFiF4r7BxOP083zCCevY7CcOCA/uHcDSLUCF0mz
         jrr6Z/s89J3pM/BWPfX8yVSjTgxFWUHGKv7UJ598deVb5QtFs4jHxy7feHztMivwUPuv
         G16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ad9CzssPymOGmpiotW53dcVN6Jgme73EHYSK1vbEGGM=;
        b=cf9UGCTPpeV5PPFcrkBMQWgEEOaW93sDPIB53QNiCvpNJ7eT14Vp6zfQet9ZqBmsK/
         6GCxWMTuluunRitydzi/DADA7Fgk6EH4UPpASzNp6Esl1dUpeNdN3oDUMGjN1RLGbYC2
         vclB2O9hsCukr3pK0rdRTVzN9dgNMkHECNOHH64HrrutY0JS+0Oj49QrEDYS0RJzM7S9
         zR87J5QrCIljJVQUhJCuDsH0SDJSFSVFe1g/ossTuR8REyKR7PmVJ9EU1u4AfAXGORGu
         ukhjQkS0XtTT4c8T1Kq8vbnj6nm6cY6vn3Jdzc4/pt4G3vqOI1OpB6WFLEu/Kec7OVTv
         cXbQ==
X-Gm-Message-State: APjAAAVxxz+cHn0tzld5+bxznaalTP3H1aN9R7zblGXRrDSmU4fe6bpO
        udwmNRzwia124BXCMp2hdQi9vHRq
X-Google-Smtp-Source: APXvYqyBTXZQWIIp8yLhfwrMbO01hVdgaxPzAIuBW1bTqraQ0wLQvd6e5VNA8AdtJz1PaG+S8gIxng==
X-Received: by 2002:a1c:d142:: with SMTP id i63mr5063822wmg.53.1569955259525;
        Tue, 01 Oct 2019 11:40:59 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:ad11:16fb:d8da:de15? (p200300EA8F266400AD1116FBD8DADE15.dip0.t-ipconnect.de. [2003:ea:8f26:6400:ad11:16fb:d8da:de15])
        by smtp.googlemail.com with ESMTPSA id q15sm36736242wrg.65.2019.10.01.11.40.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:40:59 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] net: phy: at803x: add ar9331 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191001060811.24291-1-o.rempel@pengutronix.de>
 <20191001060811.24291-3-o.rempel@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <6dca530f-ae31-abe0-a85e-fd3d796fbc87@gmail.com>
Date:   Tue, 1 Oct 2019 20:40:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191001060811.24291-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.10.2019 08:08, Oleksij Rempel wrote:
> Mostly this hardware can work with generic PHY driver, but this change
> is needed to provided interrupt handling support.
> Tested with dsa ar9331-switch driver.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/at803x.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 7895dbe600ac..42492f83c8d7 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -53,6 +53,7 @@
>  #define AT803X_DEBUG_REG_5			0x05
>  #define AT803X_DEBUG_TX_CLK_DLY_EN		BIT(8)
>  
> +#define ATH9331_PHY_ID 0x004dd041
>  #define ATH8030_PHY_ID 0x004dd076
>  #define ATH8031_PHY_ID 0x004dd074
>  #define ATH8035_PHY_ID 0x004dd072
> @@ -403,6 +404,16 @@ static struct phy_driver at803x_driver[] = {
>  	.aneg_done		= at803x_aneg_done,
>  	.ack_interrupt		= &at803x_ack_interrupt,
>  	.config_intr		= &at803x_config_intr,
> +}, {
> +	/* ATHEROS AR9331 */
> +	PHY_ID_MATCH_EXACT(ATH9331_PHY_ID),
> +	.name			= "Atheros AR9331 built-in PHY",
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

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
