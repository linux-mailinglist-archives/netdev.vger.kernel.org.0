Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85428207EC7
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404580AbgFXVnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404448AbgFXVnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:43:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34436C061573;
        Wed, 24 Jun 2020 14:43:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 956561272E975;
        Wed, 24 Jun 2020 14:43:10 -0700 (PDT)
Date:   Wed, 24 Jun 2020 14:43:09 -0700 (PDT)
Message-Id: <20200624.144309.110827193136110443.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: phy: call phy_disable_interrupts() in
 phy_init_hw()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624112516.7fcd6677@xhacker.debian>
References: <20200624112516.7fcd6677@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 14:43:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Wed, 24 Jun 2020 11:25:16 +0800

> We face an issue with rtl8211f, a pin is shared between INTB and PMEB,
> and the PHY Register Accessible Interrupt is enabled by default, so
> the INTB/PMEB pin is always active in polling mode case.
> 
> As Heiner pointed out "I was thinking about calling
> phy_disable_interrupts() in phy_init_hw(), to have a defined init
> state as we don't know in which state the PHY is if the PHY driver is
> loaded. We shouldn't assume that it's the chip power-on defaults, BIOS
> or boot loader could have changed this. Or in case of dual-boot
> systems the other OS could leave the PHY in whatever state."
> 
> patch1 makes phy_disable_interrupts() non-static so that it could be used
> in phy_init_hw() to have a defined init state.
> 
> patch2 calls phy_disable_interrupts() in phy_init_hw() to have a
> defined init state.
> 
> Since v2:
>   - Don't export phy_disable_interrupts() but just make it non-static
> 
> Since v1:
>   - EXPORT the correct symbol

Series applied, thank you.
