Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B499DEF1F
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 05:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfD3DRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 23:17:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35224 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729949AbfD3DRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 23:17:47 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD5EA133FCD5C;
        Mon, 29 Apr 2019 20:17:45 -0700 (PDT)
Date:   Mon, 29 Apr 2019 23:17:44 -0400 (EDT)
Message-Id: <20190429.231744.1945723582423201194.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, nicolas.ferre@microchip.com,
        ludovic.desroches@microchip.com, alexandre.belloni@bootlin.com
Subject: Re: [PATCH net-next] net: phy: micrel: make sure the factory test
 bit is cleared
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190426164123.26735-1-antoine.tenart@bootlin.com>
References: <20190426164123.26735-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 20:17:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Fri, 26 Apr 2019 18:41:23 +0200

> The KSZ8081 PHY has a factory test mode which is set at the de-assertion
> of the reset line based on the RXER (KSZ8081RNA/RND) or TXC
> (KSZ8081MNX/RNB) pin. If a pull-down is missing, or if the pin has a
> pull-up, the factory test mode should be cleared by manually writing a 0
> (according to the datasheet). This patch makes sure this factory test
> bit is cleared in config_init().
> 
> Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied.
