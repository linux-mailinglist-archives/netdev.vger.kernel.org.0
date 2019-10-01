Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF4FC4016
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 20:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfJASlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:41:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41055 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfJASlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:41:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id h7so16765293wrw.8;
        Tue, 01 Oct 2019 11:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8+r8RfqDgu0go6yTuK/jo/fR+Eq9OvzH+4tlbcxmP7U=;
        b=LgdWF+O98eoFdcKaS08MlkOya8L34FL3wco0V1BUbCBek4NhD+P4lrXvPwPO3kA0K8
         2zMqrNsQp5euIfyU//wfIEoUHC5Eaq4y20+t8Fq/QspcXk38UPDmypjPXQ3KkfKp20es
         FE44IS0hwsegLVYJrZwOgBsfwtl2NruT2OUMzChltQhdwnTA+nyXDLa7zWjBwSLQRe9f
         fvr2XP3K07zdlh7otVn+awPh3cCOuti+l5mEju3Q5XS1mh7vPFJUQ41FZ9J4dKrUHbax
         tteA3LzYQ99NNPZR1U1isOe5CyOqFfhV+Joo6MUPjsFf7RXhnL2Fjsa4qCZZacx2ez82
         CrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8+r8RfqDgu0go6yTuK/jo/fR+Eq9OvzH+4tlbcxmP7U=;
        b=QM60vus+enyQLj6cm8bxDO4+Qaxv0MzUfdqn8F9BG/N9qEx6Kr0vgUXUSPCpY7loCt
         0FdvCfg2v33nIipXTJKUO6g+Nzkpy3+EkbB4gKo7wHIZZZnyOQo9+YJMaNpIX8g0Gbxk
         QMNONoysR/pbYKyHgObwmJA4ckr6yEvRD8orU0obRV9dS6t4L+UEevYJkq3baPGX+rx2
         zExL+mtHOdFzA1mHsYoZknCvW7Fw71uxH+ww7U0V6S502Em5mDXKMjX0RNQ6pRyrzzAE
         StjvSxll5rb7O6aePOlM1YC0KF8VWy76od1wDdqCJ0ZSieyVU7wR1Iaff08ZnBcdL97n
         6jgQ==
X-Gm-Message-State: APjAAAVw7jaGkWEkZWhs+BvQdj3XhgPf4h7VHy30TWFcTw6siGKgx5Kp
        3i0IdAI+Fv3ggU/ALATMNzrRuAe0
X-Google-Smtp-Source: APXvYqy7VD4Nt/xgSsqzlTJgI4u9Y1d0cdSqfTArp8mKqItZUZVXfEwoFAJkzvpLOXNC5iG695Dvlg==
X-Received: by 2002:a5d:4803:: with SMTP id l3mr20455200wrq.301.1569955258342;
        Tue, 01 Oct 2019 11:40:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:ad11:16fb:d8da:de15? (p200300EA8F266400AD1116FBD8DADE15.dip0.t-ipconnect.de. [2003:ea:8f26:6400:ad11:16fb:d8da:de15])
        by smtp.googlemail.com with ESMTPSA id y3sm5503701wmg.2.2019.10.01.11.40.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:40:57 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] net: phy: at803x: use PHY_ID_MATCH_EXACT for IDs
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191001060811.24291-1-o.rempel@pengutronix.de>
 <20191001060811.24291-2-o.rempel@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4fc4c81f-8fe7-a641-c906-df0af2a63749@gmail.com>
Date:   Tue, 1 Oct 2019 20:37:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191001060811.24291-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.10.2019 08:08, Oleksij Rempel wrote:
> Use exact match for all IDs. We have no sanity checks, so we can peek
> a device with no exact ID and different register layout.
> 

I think it would be better to use PHY_ID_MATCH_EXACT for the newly
added AR9331 only. The mask 0xffffffef for the other Atheros PHY's
may be there for a reason. In this case other PHY's matching the
mask would be silently switched to the genphy driver and may
misbehave.

> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/at803x.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index 6ad8b1c63c34..7895dbe600ac 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -364,9 +364,8 @@ static int at803x_aneg_done(struct phy_device *phydev)
>  static struct phy_driver at803x_driver[] = {
>  {
>  	/* ATHEROS 8035 */
> -	.phy_id			= ATH8035_PHY_ID,
> +	PHY_ID_MATCH_EXACT(ATH8035_PHY_ID),
>  	.name			= "Atheros 8035 ethernet",
> -	.phy_id_mask		= AT803X_PHY_ID_MASK,
>  	.probe			= at803x_probe,
>  	.config_init		= at803x_config_init,
>  	.set_wol		= at803x_set_wol,
> @@ -378,9 +377,8 @@ static struct phy_driver at803x_driver[] = {
>  	.config_intr		= at803x_config_intr,
>  }, {
>  	/* ATHEROS 8030 */
> -	.phy_id			= ATH8030_PHY_ID,
> +	PHY_ID_MATCH_EXACT(ATH8030_PHY_ID),
>  	.name			= "Atheros 8030 ethernet",
> -	.phy_id_mask		= AT803X_PHY_ID_MASK,
>  	.probe			= at803x_probe,
>  	.config_init		= at803x_config_init,
>  	.link_change_notify	= at803x_link_change_notify,
> @@ -393,9 +391,8 @@ static struct phy_driver at803x_driver[] = {
>  	.config_intr		= at803x_config_intr,
>  }, {
>  	/* ATHEROS 8031 */
> -	.phy_id			= ATH8031_PHY_ID,
> +	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
>  	.name			= "Atheros 8031 ethernet",
> -	.phy_id_mask		= AT803X_PHY_ID_MASK,
>  	.probe			= at803x_probe,
>  	.config_init		= at803x_config_init,
>  	.set_wol		= at803x_set_wol,
> @@ -411,9 +408,7 @@ static struct phy_driver at803x_driver[] = {
>  module_phy_driver(at803x_driver);
>  
>  static struct mdio_device_id __maybe_unused atheros_tbl[] = {
> -	{ ATH8030_PHY_ID, AT803X_PHY_ID_MASK },
> -	{ ATH8031_PHY_ID, AT803X_PHY_ID_MASK },
> -	{ ATH8035_PHY_ID, AT803X_PHY_ID_MASK },
> +	{ PHY_ID_MATCH_VENDOR(ATH8030_PHY_ID) },
>  	{ }
>  };
>  
> 

