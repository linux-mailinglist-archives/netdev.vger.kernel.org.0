Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12675138402
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 00:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbgAKXdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 18:33:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49550 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731663AbgAKXdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 18:33:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A265715A0BDF5;
        Sat, 11 Jan 2020 15:33:48 -0800 (PST)
Date:   Sat, 11 Jan 2020 15:33:48 -0800 (PST)
Message-Id: <20200111.153348.1795240699245945693.davem@davemloft.net>
To:     mparab@cadence.com
Cc:     nicolas.ferre@microchip.com, jakub.kicinski@netronome.com,
        andrew@lunn.ch, antoine.tenart@bootlin.com,
        rmk+kernel@armlinux.org.uk, Claudiu.Beznea@microchip.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, dkangude@cadence.com,
        a.fatoum@pengutronix.de, brad.mouring@ni.com, pthombar@cadence.com
Subject: Re: [PATCH v2 net] net: macb: fix for fixed-link mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1578662727-41429-1-git-send-email-mparab@cadence.com>
References: <1578662727-41429-1-git-send-email-mparab@cadence.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 11 Jan 2020 15:33:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Milind Parab <mparab@cadence.com>
Date: Fri, 10 Jan 2020 13:25:27 +0000

>  static int macb_phylink_connect(struct macb *bp)
>  {
>  	struct net_device *dev = bp->dev;
>  	struct phy_device *phydev;
> +	struct device_node *dn = bp->pdev->dev.of_node;
>  	int ret;

Please retain the reverse christmas tree ordering of local variables
here.

Thank you.
