Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30954166AA6
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgBTXAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:00:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59950 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTXAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:00:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC0CD15BCCC54;
        Thu, 20 Feb 2020 15:00:53 -0800 (PST)
Date:   Thu, 20 Feb 2020 15:00:51 -0800 (PST)
Message-Id: <20200220.150051.2170993471455503146.davem@davemloft.net>
To:     alexandre.belloni@bootlin.com
Cc:     nicolas.ferre@microchip.com, linux@armlinux.org.uk,
        antoine.tenart@bootlin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: macb: Properly handle phylink on at91rm9200
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219141551.5152-1-alexandre.belloni@bootlin.com>
References: <20200219141551.5152-1-alexandre.belloni@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 15:00:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>
Date: Wed, 19 Feb 2020 15:15:51 +0100

> at91ether_init was handling the phy mode and speed but since the switch to
> phylink, the NCFGR register got overwritten by macb_mac_config(). The issue
> is that the RM9200_RMII bit and the MACB_CLK_DIV32 field are cleared
> but never restored as they conflict with the PAE, GBE and PCSSEL bits.
> 
> Add new capability to differentiate between EMAC and the other versions of
> the IP and use it to set and avoid clearing the relevant bits.
> 
> Also, this fixes a NULL pointer dereference in macb_mac_link_up as the EMAC
> doesn't use any rings/bufffers/queues.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Applied and queued up for -stable, thanks.
