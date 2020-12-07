Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4A42D1444
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgLGPCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:02:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33842 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLGPCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 10:02:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 1BDD94A48D2AF;
        Mon,  7 Dec 2020 07:01:24 -0800 (PST)
Date:   Mon, 07 Dec 2020 07:01:23 -0800 (PST)
Message-Id: <20201207.070123.2205337287463864568.davem@davemloft.net>
To:     m.grzeschik@pengutronix.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 3/6] net: dsa: microchip: ksz8795: move register
 offsets and shifts to separate struct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201207125627.30843-4-m.grzeschik@pengutronix.de>
References: <20201207125627.30843-1-m.grzeschik@pengutronix.de>
        <20201207125627.30843-4-m.grzeschik@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 07 Dec 2020 07:01:24 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>
Date: Mon,  7 Dec 2020 13:56:24 +0100

> @@ -991,13 +1090,16 @@ static void ksz8_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  static void ksz8_config_cpu_port(struct dsa_switch *ds)
>  {
>  	struct ksz_device *dev = ds->priv;
> +	struct ksz8 *ksz8 = dev->priv;
> +	const u8 *regs = ksz8->regs;
> +	const u32 *masks = ksz8->masks;
>  	struct ksz_port *p;
>  	u8 remote;
>  	int i;
>  

Please use reverse christmas tree ordering for local variables.

Thank you.
