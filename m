Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6315E1B426
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 12:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfEMKhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 06:37:25 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45229 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfEMKhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 06:37:24 -0400
Received: by mail-lj1-f194.google.com with SMTP id r76so10420899lja.12;
        Mon, 13 May 2019 03:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aTszH/rrIqRd+889JyaS6QLIAk9G7S5fntVRB8ONBec=;
        b=PeI3cZlBkbqlBnHvn2uQf7Y7isXC6lBVcopSIaQsdeS2Wjgy0WIxGKtkXtAPrPVgwU
         l5Vp38X/DuaKydEmLnd6DT62/GyIDQrCEdqhQImgCj02MJej6IuNNQazI9VqlyS/hjOP
         jv60lEZ89W8Cm1fnr6RG05+VrTyfabjUBP1EwP5NO0z6KFLwBKdxaogCh+KJaZuZfDH9
         hPldnlg6uO6x3/RwJsAqdkxmTwyC/qPijLC42iSrkuUUd0QkwrkRAovc5DLtl9dSwFjE
         mBhkDTBVBW829CgjqvyVbOR2glajFlUvwh/+7BNtXlupnY5RKiQBIXiBScekxnvJTLrU
         K0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aTszH/rrIqRd+889JyaS6QLIAk9G7S5fntVRB8ONBec=;
        b=Ww2Yz+69oHL9P9U+yRLtU6tva+J7aso9BsjFFwlC3YDpg5rNcJqsSYnOrTqSYgLNKi
         RMd4n5Gv9GJbFj3VAiGlA0BhGM3Ct+0ujqtpYqO4oBLZyQxkUCbSemrdk0zpckI4YBli
         F4O6+YhYjrjp0P5V/FkTO36/bFvdC1l74b6zRA4gJGpj/eJ8ZqnBTCTg2SCw9c9DUFDx
         /MB+VZGBIauwMW9/8J734s1+gq1A2aqovFAZWNIffwLtkn5i2nVGXpYT0BjN0ipk4FhF
         sBsFZiMCz+uDY9BXRJP8XkxmKPGlYXZH3O30n5cSSpYX0KbqpVZ6dzwM0puVnzofXrIA
         6aSw==
X-Gm-Message-State: APjAAAVm6aTSVGGkvUHhpp4w055GvvOJ3rbmnE7oS8nEisnI11aak1+x
        gsiUGyr3ch+OzwGEeVA3jF4=
X-Google-Smtp-Source: APXvYqz+DcvSkaF/KGXA9PrpDf4JlAX1JCdP3TF/QNID6KRL7O35hZBlUWEwtOb2EnEjLfhOhZkLSg==
X-Received: by 2002:a2e:8744:: with SMTP id q4mr1399659ljj.172.1557743842464;
        Mon, 13 May 2019 03:37:22 -0700 (PDT)
Received: from mobilestation ([5.164.217.122])
        by smtp.gmail.com with ESMTPSA id n26sm2774596lfi.90.2019.05.13.03.37.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 13 May 2019 03:37:21 -0700 (PDT)
Date:   Mon, 13 May 2019 13:37:19 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: phy: realtek: Add rtl8211e rx/tx delays
 config
Message-ID: <20190513103717.yvwfrwsvkovw4w6y@mobilestation>
References: <20190426093010.9609-1-fancer.lancer@gmail.com>
 <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190513054132.GA7563@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513054132.GA7563@roeck-us.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Guenter,

On Sun, May 12, 2019 at 10:41:32PM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Sat, Apr 27, 2019 at 12:21:11AM +0300, Serge Semin wrote:
> > There are two chip pins named TXDLY and RXDLY which actually adds the 2ns
> > delays to TXC and RXC for TXD/RXD latching. Alas this is the only
> > documented info regarding the RGMII timing control configurations the PHY
> > provides. It turns out the same settings can be setup via MDIO registers
> > hidden in the extension pages layout. Particularly the extension page 0xa4
> > provides a register 0x1c, which bits 1 and 2 control the described delays.
> > They are used to implement the "rgmii-{id,rxid,txid}" phy-mode.
> > 
> > The hidden RGMII configs register utilization was found in the rtl8211e
> > U-boot driver:
> > https://elixir.bootlin.com/u-boot/v2019.01/source/drivers/net/phy/realtek.c#L99
> > 
> > There is also a freebsd-folks discussion regarding this register:
> > https://reviews.freebsd.org/D13591
> > 
> > It confirms that the register bits field must control the so called
> > configuration pins described in the table 12-13 of the official PHY
> > datasheet:
> > 8:6 = PHY Address
> > 5:4 = Auto-Negotiation
> > 3 = Interface Mode Select
> > 2 = RX Delay
> > 1 = TX Delay
> > 0 = SELRGV
> > 
> > Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> This patch results in a crash when running arm:ast2500-evb in qemu.
> 
> [    4.894572] [00000000] *pgd=00000000
> [    4.895329] Internal error: Oops: 80000005 [#1] ARM
> [    4.896066] CPU: 0 PID: 1 Comm: swapper Not tainted 5.1.0-09698-g1fb3b52 #1
> [    4.896364] Hardware name: Generic DT based system
> [    4.896823] PC is at 0x0
> [    4.897037] LR is at phy_select_page+0x3c/0x7c
> 
> Debugging shows that phydev->drv->write_page and phydev->drv->read_page
> are NULL, so the crash isn't entirely surprising.
> 
> What I don't understand is how this can work in the first place.
> The modified entry in realtek_drvs[] doesn't have read_page/write_page
> functions defined, yet rtl8211e_config_init() depends on it.
> What am I missing here ?
> 
> Thanks,
> Guenter

Thanks for sending the report. The problem has already been fixed in the net:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=daf3ddbe11a2ff74c95bc814df8e5fe3201b4cb5

-Sergey
