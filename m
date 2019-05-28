Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988292C8E7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 16:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfE1Og6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 10:36:58 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:36597 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfE1Og6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 10:36:58 -0400
Received: from bootlin.com (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 4155D200013;
        Tue, 28 May 2019 14:36:50 +0000 (UTC)
Date:   Tue, 28 May 2019 16:36:52 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: report if the PHY fails to boot
 firmware
Message-ID: <20190528163525.534e31a9@bootlin.com>
In-Reply-To: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
References: <E1hVYVG-0005D8-8w@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Tue, 28 May 2019 10:34:42 +0100
Russell King <rmk+kernel@armlinux.org.uk> wrote:

>Some boards do not have the PHY firmware programmed in the 3310's flash,
>which leads to the PHY not working as expected.  Warn the user when the
>PHY fails to boot the firmware and refuse to initialise.
>
>Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>---
>I think this patch needs testing with the Marvell 88x2110 PHY before
>this can be merged into mainline, but I think it should go into -rc
>and be back-ported to stable trees to avoid user frustration

I've tested this on a 88x2110 and a 88e2010, who both have the same
register at the same location, at are potentially subject to the same
issue.

Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Thanks,

Maxime
