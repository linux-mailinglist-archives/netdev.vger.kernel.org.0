Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001572E766
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 23:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfE2V0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 17:26:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42060 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2V0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 17:26:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F415136DF6FB;
        Wed, 29 May 2019 14:26:35 -0700 (PDT)
Date:   Wed, 29 May 2019 14:26:34 -0700 (PDT)
Message-Id: <20190529.142634.185656643572931597.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
References: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 May 2019 14:26:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 28 May 2019 10:34:42 +0100

> Some boards do not have the PHY firmware programmed in the 3310's flash,
> which leads to the PHY not working as expected.  Warn the user when the
> PHY fails to boot the firmware and refuse to initialise.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied and queued up for -stable, thanks.

Longer term in net-next we can do the PHY_HALTED thing so that the PHY
is accessible to update/fix the broken firmware.
