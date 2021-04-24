Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9721B36A1CF
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 17:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhDXPoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 11:44:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhDXPnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 11:43:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1laKR4-000pjt-9R; Sat, 24 Apr 2021 17:43:10 +0200
Date:   Sat, 24 Apr 2021 17:43:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v6 03/10] net: dsa: microchip: ksz8795: move
 register offsets and shifts to separate struct
Message-ID: <YIQ8joi30118oizw@lunn.ch>
References: <20210423080218.26526-1-o.rempel@pengutronix.de>
 <20210423080218.26526-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423080218.26526-4-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
>  {
> +	struct ksz8 *ksz8 = dev->priv;
> +	const u32 *masks = ksz8->masks;
> +	const u8 *regs = ksz8->regs;

Reverse christmas tree.

>  	u16 ctrl_addr;
>  	u32 data;
>  	u8 check;
> @@ -150,6 +204,9 @@ static void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
>  static void ksz8_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
>  			   u64 *dropped, u64 *cnt)
>  {
> +	struct ksz8 *ksz8 = dev->priv;
> +	const u32 *masks = ksz8->masks;
> +	const u8 *regs = ksz8->regs;

Reverse christmas tree.


>  static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
>  {
> +	struct ksz8 *ksz8 = dev->priv;
> +	const u8 *regs = ksz8->regs;

...

>  static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
>  {
> +	struct ksz8 *ksz8 = dev->priv;
> +	const u32 *masks = ksz8->masks;
> +	const u8 *regs = ksz8->regs;
>  	int timeout = 100;

Please fix them all.

Once you have fixed them, you can add my Reviewed-by.

     Andrew
