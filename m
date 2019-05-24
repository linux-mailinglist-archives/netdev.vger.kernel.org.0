Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3909429CEC
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731990AbfEXRY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:24:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39387 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731771AbfEXRYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:24:19 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so5914468wma.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qtuLLEDa0YlT+iOzbeKTIV97NcbttvlmjVMK+jl10kg=;
        b=RCD2xoVJpQcwkngZGPziYjmWjG2zSnYInxBmTWHYwPVcpppansIn8hf4cC2yCKtWDI
         R1ujKugoXXZzPQhKjW7Lu+eMgSThcAjsax4QrikouYwxVSkCpWLqpUSmqz9N+/oHTBzo
         MACu6uPgnbW6xu06LbL4oqwB4idJ8L0wsQhOJyZgl0ih9qJ8cluKp4T+MUXg5vrX+kgu
         dfg4wSqRwegAbVtNR8UquRGrXJahBpT0C1sy/16ca14c+ePB7L85bKuN3rmKOlyex0yM
         j1UDGu6QiL/R7RQSsOxR6M5JmT7wMlf7uWIoeS4S+YLOh2Fqbm2VbmJFwUapR4mqZxdE
         wwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qtuLLEDa0YlT+iOzbeKTIV97NcbttvlmjVMK+jl10kg=;
        b=M3/96PIVC4Lu//KIQt3mT9B/asvWJz5lsmj00DVaGP/7fekUtnJfC4fKW2uUGyYbVp
         at8o8JjD71n6mtNPPju2JSEBFrOIiQcLOvZuB4Nx23cp97CvAAds2OK0Ax5i3niO2uHB
         lVf7xGJ5W0I78xdH9n41J8bf32Y/xO+dviWOs9OMeIpQxVgpLMZ37dFDsJ0ZW/tAv36S
         r4ElG9HyU3ekkqM+T4uNM5hKTg+vuCz8zPXGIy2C7ksNs69yQhBCw3kZ/pxwxTOdRC4p
         GwaWhU2Dhh+2FhiO11vF+tTe+pnWtqMmLszn2eZc3Gszr4DK6BmUXtr4wKk9QelYHcqs
         X2IA==
X-Gm-Message-State: APjAAAVN0zC80I03OWYFkfJQeqcWP0/mbpriohoS+fb4QLIkUFEouMUF
        tKHJ7dPQw7Md0N7z6b0vrsRp75Kq
X-Google-Smtp-Source: APXvYqz6WP5c+pyjDPRBG2fNtkIgoR1rB2KU3drk/0OdSNmXPJD6m9u085jvoCjJjyVg29TltOZ/6Q==
X-Received: by 2002:a1c:7411:: with SMTP id p17mr646868wmc.163.1558718657231;
        Fri, 24 May 2019 10:24:17 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f? (p200300EA8BE97A00E8AA5F65936F3A1F.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f])
        by smtp.googlemail.com with ESMTPSA id u2sm7360434wra.82.2019.05.24.10.24.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:24:16 -0700 (PDT)
Subject: Re: [PATCH 2/3] net:phy:dp83867: increase SGMII autoneg timer
 duration
To:     Max Uvarov <muvarov@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net
References: <20190524102541.4478-1-muvarov@gmail.com>
 <20190524102541.4478-3-muvarov@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4cd0770d-5eca-a153-1ed3-32472a1a8860@gmail.com>
Date:   Fri, 24 May 2019 19:24:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190524102541.4478-3-muvarov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.05.2019 12:25, Max Uvarov wrote:
> After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
> That us not enough to finalize autonegatiation on some devices.
> Increase this timer duration to maximum supported 16ms.
> 
> Signed-off-by: Max Uvarov <muvarov@gmail.com>
> ---
>  drivers/net/phy/dp83867.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index afd31c516cc7..66b0a09ad094 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -297,6 +297,19 @@ static int dp83867_config_init(struct phy_device *phydev)
>  			WARN_ONCE(1, "dp83867: err DP83867_10M_SGMII_CFG\n");
>  			return ret;
>  		}
> +
> +		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
> +		 * are 01). That us not enough to finalize autoneg on some
> +		 * devices. Increase this timer duration to maximum 16ms.
> +		 */
In the public datasheet the bits are described as reserved. However, based on
the value, I suppose it's not a timer value but the timer resolution.

> +		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4);
> +		val &= ~(BIT(5) | BIT(6));
> +		ret = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4, val);
> +		if (ret) {
> +			WARN_ONCE(1, "dp83867: error config sgmii auto-neg timer\n");
> +			return ret;

Same comment as for patch 1.

> +		}
> +
>  	}
>  
>  	/* Enable Interrupt output INT_OE in CFG3 register */
> 

