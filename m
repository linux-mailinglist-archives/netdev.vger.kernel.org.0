Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F527117A
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 02:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgITAHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 20:07:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45608 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbgITAHu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 20:07:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJmtO-00FQxv-8w; Sun, 20 Sep 2020 02:07:46 +0200
Date:   Sun, 20 Sep 2020 02:07:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: dsa: rtl8366rb: Roof MTU for switch
Message-ID: <20200920000746.GA3673389@lunn.ch>
References: <20200919220105.311483-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919220105.311483-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int rtl8366rb_setup(struct dsa_switch *ds)
>  {
>  	struct realtek_smi *smi = ds->priv;
> +	struct rtl8366rb *rb = smi->chip_data;
>  	const u16 *jam_table;
>  	u32 chip_ver = 0;
>  	u32 chip_id = 0;

Hi Linus

Reverse Christmas tree means you need to do the assignment later.

Otherwise this looks O.K.

	  Andrew

