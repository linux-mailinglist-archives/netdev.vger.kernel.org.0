Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC50BDD57
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391210AbfIYLo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:44:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387930AbfIYLo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:44:28 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3112154ECAB7;
        Wed, 25 Sep 2019 04:44:25 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:44:24 +0200 (CEST)
Message-Id: <20190925.134424.1566106400449419934.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        vivien.didelot@savoirfairelinux.com, woojung.huh@microchip.com
Subject: Re: [PATCH] net: dsa: microchip: Always set regmap stride to 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190921175309.2195-1-marex@denx.de>
References: <20190921175309.2195-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 04:44:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sat, 21 Sep 2019 19:53:09 +0200

> The regmap stride is set to 1 for regmap describing 8bit registers already.
> However, for 16/32/64bit registers, the stride is 2/4/8 respectively. This
> is not correct, as the switch protocol supports unaligned register reads
> and writes and the KSZ87xx even uses such unaligned register accesses to
> read e.g. MIB counter.
> 
> This patch fixes MIB counter access on KSZ87xx.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Please resubmit with an appropriate Fixes: tag as per Florian's feedback.

Thank you.
