Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA8C183CA2
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgCLWiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:38:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCLWiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:38:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 18CAC15841EBE;
        Thu, 12 Mar 2020 15:38:13 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:38:12 -0700 (PDT)
Message-Id: <20200312.153812.1984046890896612427.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, geert@linux-m68k.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix MDIO bus PM PHY resuming
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8fb49a53-4c9e-feb9-d4c9-e7ee7fd88597@gmail.com>
References: <8fb49a53-4c9e-feb9-d4c9-e7ee7fd88597@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:38:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 12 Mar 2020 22:25:20 +0100

> So far we have the unfortunate situation that mdio_bus_phy_may_suspend()
> is called in suspend AND resume path, assuming that function result is
> the same. After the original change this is no longer the case,
> resulting in broken resume as reported by Geert.
> 
> To fix this call mdio_bus_phy_may_suspend() in the suspend path only,
> and let the phy_device store the info whether it was suspended by
> MDIO bus PM.
> 
> Fixes: 503ba7c69610 ("net: phy: Avoid multiple suspends")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable, thank you.
