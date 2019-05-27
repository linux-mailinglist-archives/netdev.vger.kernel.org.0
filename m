Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB52BA9D
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 21:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfE0TTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 15:19:44 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33765 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfE0TTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 15:19:44 -0400
Received: by mail-pg1-f194.google.com with SMTP id h17so9553120pgv.0
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 12:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oqCJMBhMdM8/SO6cIBeBfGttFIDkrCTWEzRWQVpwvzs=;
        b=KqgIbxpWpjPYbu3OfU0Ct8Il3fKEr0rTqYWB5oJ9A3ZhsPFUgm7PmJGVWymquK7uhD
         ud0C/2v0EFjzowCm7pgSkcSGAu9JzzCrvwN6S9EVPc8EJytzkNRRS+715/39j0WicCKL
         Rgk9LBqLg9V+O5NVERcGCaXtXpoudABqQwEe267rM6tPJ4PPZCATxSsmy8eNrIwlinNj
         JM8N9Fj6QUo/mcs63FWynwixvA6lpHeL4CBhHx31f8IejnpdFQ6eYrOI872lPL+aUkiN
         YpMOUPvdOSn5JgkXsbt2r/p68pYFavR5MXUmrv5Z/EWgs98pCdK0AJIu/XXt3fEuf9zl
         0IDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oqCJMBhMdM8/SO6cIBeBfGttFIDkrCTWEzRWQVpwvzs=;
        b=kJKseRpL9f2OXSTjYUwus71gQ7e2g/b0JUv2FIIJVt1vuZu1OC3fqnb2WvOh3b5Hqh
         /Xv6zm+iqcIIa18aGSsJkUCD7tuXjF6TTZLvNJMpJGq4bx/aKR0jM7vRziTbBL4btRdW
         s5xHsf5mz7acAp8d78Oy6UEHzyistfVh53jv4Cl8EKAN1iax7s7whE3lDuCJ/s9RibHG
         jNkwoYDrRJc/OrYm+VSr068IzfMvEp3Yh/p7zXx8GDYq8FOxrihKveKKfCM9P0fEiJ1d
         Q/iP4U13EBKeTfUUcBN8axGaek7BoUUbsF73/qrZ5ky0B6LgfANfArBYp6hmTc+dxb3b
         QN8A==
X-Gm-Message-State: APjAAAV0TC0yw05JPPrH0i/7b2aiV5ncws554ii78OdEQF9bIw7H8K6f
        goKI+54v7B1XKQnTNWiLJQcqzeeO
X-Google-Smtp-Source: APXvYqxZOSZP3OqKR4OagWeISV71wRxStt6qm7Zp/qcZDrJVv4nWYkzQiOuvlJRmewQTw9by2X2Oyg==
X-Received: by 2002:a62:2b82:: with SMTP id r124mr130341463pfr.235.1558984783092;
        Mon, 27 May 2019 12:19:43 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id d13sm13421679pfh.113.2019.05.27.12.19.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 12:19:42 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: export phy_queue_state_machine
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e3ce708d-d841-bd7e-30bb-bff37f3b89ac@gmail.com>
 <ce95f8fa-29b2-53d0-6f69-72f9196aa7cb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <a8bc78a5-1641-3949-437d-2cd8918c1691@gmail.com>
Date:   Mon, 27 May 2019 12:19:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <ce95f8fa-29b2-53d0-6f69-72f9196aa7cb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2019 11:28 AM, Heiner Kallweit wrote:
> We face the issue that link change interrupt and link status may be
> reported by different layers. As a result the link change interrupt
> may occur before the link status changes.
> Export phy_queue_state_machine to allow PHY drivers to specify a
> delay between link status change interrupt and link status check.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> ---
>  drivers/net/phy/phy.c | 8 +++++---
>  include/linux/phy.h   | 2 +-
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index e88854292..20955836c 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -29,6 +29,8 @@
>  #include <linux/uaccess.h>
>  #include <linux/atomic.h>
>  
> +#define PHY_STATE_TIME	HZ
> +
>  #define PHY_STATE_STR(_state)			\
>  	case PHY_##_state:			\
>  		return __stringify(_state);	\
> @@ -478,12 +480,12 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
>  }
>  EXPORT_SYMBOL(phy_mii_ioctl);
>  
> -static void phy_queue_state_machine(struct phy_device *phydev,
> -				    unsigned int secs)
> +void phy_queue_state_machine(struct phy_device *phydev, unsigned int jiffies)

mod_delayed_work() takes an unsigned long delay argument, so I would
replicate that here as well. Other than that, making PHY_STATE_TIME
local to phy.c is definitively a good idea.

>  {
>  	mod_delayed_work(system_power_efficient_wq, &phydev->state_queue,
> -			 secs * HZ);
> +			 jiffies);
>  }
> +EXPORT_SYMBOL(phy_queue_state_machine);
>  
>  static void phy_trigger_machine(struct phy_device *phydev)
>  {
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 7180b1d1e..b133d59f3 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -188,7 +188,6 @@ static inline const char *phy_modes(phy_interface_t interface)
>  
>  
>  #define PHY_INIT_TIMEOUT	100000
> -#define PHY_STATE_TIME		1
>  #define PHY_FORCE_TIMEOUT	10
>  
>  #define PHY_MAX_ADDR	32
> @@ -1137,6 +1136,7 @@ int phy_driver_register(struct phy_driver *new_driver, struct module *owner);
>  int phy_drivers_register(struct phy_driver *new_driver, int n,
>  			 struct module *owner);
>  void phy_state_machine(struct work_struct *work);
> +void phy_queue_state_machine(struct phy_device *phydev, unsigned int jiffies);
>  void phy_mac_interrupt(struct phy_device *phydev);
>  void phy_start_machine(struct phy_device *phydev);
>  void phy_stop_machine(struct phy_device *phydev);
> 

-- 
Florian
