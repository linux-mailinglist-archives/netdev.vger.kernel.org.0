Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDF61BACEF
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgD0Si6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbgD0Si5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:38:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5106C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:38:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFFED15D54AB1;
        Mon, 27 Apr 2020 11:38:56 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:38:56 -0700 (PDT)
Message-Id: <20200427.113856.1982664581620846848.davem@davemloft.net>
To:     baruch@tkos.co.il
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com
Subject: Re: [PATCH net v4] net: phy: marvell10g: fix temperature sensor on
 2110
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7f1ffa0c51d4f7be6867878e601037ae3326ac01.1587882126.git.baruch@tkos.co.il>
References: <7f1ffa0c51d4f7be6867878e601037ae3326ac01.1587882126.git.baruch@tkos.co.il>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:38:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>
Date: Sun, 26 Apr 2020 09:22:06 +0300

> Read the temperature sensor register from the correct location for the
> 88E2110 PHY. There is no enable/disable bit on 2110, so make
> mv3310_hwmon_config() run on 88X3310 only.
> 
> Fixes: 62d01535474b61 ("net: phy: marvell10g: add support for the 88x2110 PHY")
> Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Applied and queued up for -stable, thanks.
