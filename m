Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C90DBA2F
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 01:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503749AbfJQXcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 19:32:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43744 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438340AbfJQXcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 19:32:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 77FE514304E24;
        Thu, 17 Oct 2019 16:32:06 -0700 (PDT)
Date:   Thu, 17 Oct 2019 16:32:03 -0700 (PDT)
Message-Id: <20191017.163203.1569917936931976372.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, hkallweit1@gmail.com,
        sean.nyekjaer@prevas.dk, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH net V5 1/2] net: phy: micrel: Discern KSZ8051 and
 KSZ8795 PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016133507.10564-1-marex@denx.de>
References: <20191016133507.10564-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 16:32:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Wed, 16 Oct 2019 15:35:06 +0200

> The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
> same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
> in the micrel PHY driver, it is used even with the KSZ87xx switch. This
> is wrong, since the KSZ8051 configures registers of the PHY which are
> not present on the simplified KSZ87xx switch PHYs and misconfigures
> other registers of the KSZ87xx switch PHYs.
> 
> Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
> KSZ87xx switch by checking the Basic Status register Bit 0, which is
> read-only and indicates presence of the Extended Capability Registers.
> The KSZ8051 PHY has those registers while the KSZ87xx switch does not.
> 
> This patch implements simple check for the presence of this bit for
> both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
> PHY driver instance.
> 
> Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied.
