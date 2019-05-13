Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45951B008
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 07:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfEMFlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 01:41:36 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41108 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfEMFlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 01:41:36 -0400
Received: by mail-pf1-f193.google.com with SMTP id l132so6553250pfc.8;
        Sun, 12 May 2019 22:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aCaoOWPqDDX+3hpBqnVqcL0Uhf6k/UKUWdAr6R3F48s=;
        b=VflfWz/VROYd7ymaP2XVUVW+tTvdHPURtK0nla14oBKFXwZZa06BUHVa6ApP5l7nwA
         uzis0GwOIGuvkPiUT4/pFTBmRIFcLs2TN2/NpAZrVswTFODr+HKaxdl3nOS5Vb2f/wHo
         tZGuLUbQ0u1rv31xeYwxsj9/G+Zft/KRlMk+e7QSufi+p7zh98MZZaNiX8LZ/4xOqA6s
         E8QamL3rKo4nYSvRUeHKuUhxXvOvkOMcR83M7DXwJRyOej9aqOeFZ9uNQdiCpBsMorcN
         agGddVW5IbNg8Rj26+JyNV/A1pc+VxMloT3XTaZcNjpve0txv7pnYuPPbzr+Ltglcyj5
         TNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=aCaoOWPqDDX+3hpBqnVqcL0Uhf6k/UKUWdAr6R3F48s=;
        b=aF64rI8YM9gZxrJzLbxK2UjJexCsbxQY10cg667RCcKF1MaXJ7CEh2rABdOp/9WGcT
         I9n/nML8lZ5TbTQhfobR/RGh/7W4KOpBHlwck4YmzKZTYeLI1HNKUQOBwfUj2Uokggmb
         pv2/YVmPoXxURmfKSPNCQM75gEtmyK3r7S8uRzIQQ9x7HygMnMerJg9a5mH+O9dNy1jh
         tVEZVL3W1bjpjWwOdeifLunldaldALehnqEIWOxmvs1m31GMgvgPr3rfc5f+VUtmH3jh
         DFAcIFqvSWqmxMhc9KVzDhPQQTrmUK50TrhxpEaJVd7l6TPQ+gKCoOd+Q9LS/9ijo/QX
         mtIQ==
X-Gm-Message-State: APjAAAVyZuVDY/3l5lZZ6CA4T/vym5ZjcKhl17Y3Jwf9Ze8+TrDMbX9E
        s4pBrmpZF13GLSHKnI/5yjU=
X-Google-Smtp-Source: APXvYqxS6fc4K5+cDgkhyfj7Q+/qCqvCl5927SZa5DSzJKp6ehNSKUAPMqNSOf0PESrZe9HygcAozA==
X-Received: by 2002:a63:1316:: with SMTP id i22mr28826114pgl.274.1557726095696;
        Sun, 12 May 2019 22:41:35 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b16sm19417106pfd.12.2019.05.12.22.41.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 May 2019 22:41:34 -0700 (PDT)
Date:   Sun, 12 May 2019 22:41:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Serge Semin <fancer.lancer@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: phy: realtek: Add rtl8211e rx/tx delays
 config
Message-ID: <20190513054132.GA7563@roeck-us.net>
References: <20190426093010.9609-1-fancer.lancer@gmail.com>
 <20190426212112.5624-1-fancer.lancer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426212112.5624-1-fancer.lancer@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, Apr 27, 2019 at 12:21:11AM +0300, Serge Semin wrote:
> There are two chip pins named TXDLY and RXDLY which actually adds the 2ns
> delays to TXC and RXC for TXD/RXD latching. Alas this is the only
> documented info regarding the RGMII timing control configurations the PHY
> provides. It turns out the same settings can be setup via MDIO registers
> hidden in the extension pages layout. Particularly the extension page 0xa4
> provides a register 0x1c, which bits 1 and 2 control the described delays.
> They are used to implement the "rgmii-{id,rxid,txid}" phy-mode.
> 
> The hidden RGMII configs register utilization was found in the rtl8211e
> U-boot driver:
> https://elixir.bootlin.com/u-boot/v2019.01/source/drivers/net/phy/realtek.c#L99
> 
> There is also a freebsd-folks discussion regarding this register:
> https://reviews.freebsd.org/D13591
> 
> It confirms that the register bits field must control the so called
> configuration pins described in the table 12-13 of the official PHY
> datasheet:
> 8:6 = PHY Address
> 5:4 = Auto-Negotiation
> 3 = Interface Mode Select
> 2 = RX Delay
> 1 = TX Delay
> 0 = SELRGV
> 
> Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

This patch results in a crash when running arm:ast2500-evb in qemu.

[    4.894572] [00000000] *pgd=00000000
[    4.895329] Internal error: Oops: 80000005 [#1] ARM
[    4.896066] CPU: 0 PID: 1 Comm: swapper Not tainted 5.1.0-09698-g1fb3b52 #1
[    4.896364] Hardware name: Generic DT based system
[    4.896823] PC is at 0x0
[    4.897037] LR is at phy_select_page+0x3c/0x7c

Debugging shows that phydev->drv->write_page and phydev->drv->read_page
are NULL, so the crash isn't entirely surprising.

What I don't understand is how this can work in the first place.
The modified entry in realtek_drvs[] doesn't have read_page/write_page
functions defined, yet rtl8211e_config_init() depends on it.
What am I missing here ?

Thanks,
Guenter
