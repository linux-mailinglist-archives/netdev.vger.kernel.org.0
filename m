Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C1D233C32
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgG3XgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728588AbgG3XgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:36:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD79CC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 16:36:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0A76126BEF2C;
        Thu, 30 Jul 2020 16:19:32 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:36:17 -0700 (PDT)
Message-Id: <20200730.163617.337691110259436047.davem@davemloft.net>
To:     Bryan.Whitehead@microchip.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Subject: Re: [PATCH v2 net-next] mscc: Add LCPLL Reset to VSC8574 Family of
 phy drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595870308-19041-1-git-send-email-Bryan.Whitehead@microchip.com>
References: <1595870308-19041-1-git-send-email-Bryan.Whitehead@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:19:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bryan Whitehead <Bryan.Whitehead@microchip.com>
Date: Mon, 27 Jul 2020 13:18:28 -0400

> @@ -929,6 +929,77 @@ static bool vsc8574_is_serdes_init(struct phy_device *phydev)
>  }
>  
>  /* bus->mdio_lock should be locked when using this function */
> +/* Page should already be set to MSCC_PHY_PAGE_EXTENDED_GPIO */
> +static int vsc8574_micro_command(struct phy_device *phydev, u16 command)
 ...
> +/* bus->mdio_lock should be locked when using this function */

Please don't dup this comment, it's not appropriate.

Thank you.
