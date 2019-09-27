Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6849DC0AF4
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 20:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfI0SVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 14:21:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35176 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfI0SVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 14:21:38 -0400
Received: from localhost (231-157-167-83.reverse.alphalink.fr [83.167.157.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 58699153ED970;
        Fri, 27 Sep 2019 11:21:36 -0700 (PDT)
Date:   Fri, 27 Sep 2019 20:21:34 +0200 (CEST)
Message-Id: <20190927.202134.199674863087018843.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        vivien.didelot@savoirfairelinux.com, woojung.huh@microchip.com
Subject: Re: [PATCH V2] net: dsa: microchip: Always set regmap stride to 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925220842.4301-1-marex@denx.de>
References: <20190925220842.4301-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 11:21:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Thu, 26 Sep 2019 00:08:42 +0200

> The regmap stride is set to 1 for regmap describing 8bit registers already.
> However, for 16/32/64bit registers, the stride is 2/4/8 respectively. This
> is not correct, as the switch protocol supports unaligned register reads
> and writes and the KSZ87xx even uses such unaligned register accesses to
> read e.g. MIB counter.
> 
> This patch fixes MIB counter access on KSZ87xx.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Fixes: 46558d601cb6 ("net: dsa: microchip: Initial SPI regmap support")
> Fixes: 255b59ad0db2 ("net: dsa: microchip: Factor out regmap config generation into common header")

Applied.
