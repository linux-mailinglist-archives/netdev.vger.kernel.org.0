Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C571E3923
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 08:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgE0G0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 02:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbgE0G0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 02:26:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD24C061A0F;
        Tue, 26 May 2020 23:26:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2DE99127F8DB0;
        Tue, 26 May 2020 23:26:22 -0700 (PDT)
Date:   Tue, 26 May 2020 23:26:21 -0700 (PDT)
Message-Id: <20200526.232621.1824602150267081837.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH v2] net: phy: at803x: add cable diagnostics support for
 ATH9331 and ATH8032
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527050843.843-1-o.rempel@pengutronix.de>
References: <20200527050843.843-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 23:26:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Wed, 27 May 2020 07:08:43 +0200

> Add support for Atheros 100Base-T PHYs. The only difference seems to be
> the ability to test 2 pairs instead of 4 and the lack of 1000Base-T
> specific register.
> 
> Only the ATH9331 was tested with this patch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied to net-next, thank you.
