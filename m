Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32167168795
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 20:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgBUTmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 14:42:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgBUTmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 14:42:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA4F914648EEE;
        Fri, 21 Feb 2020 11:42:52 -0800 (PST)
Date:   Fri, 21 Feb 2020 11:42:52 -0800 (PST)
Message-Id: <20200221.114252.1572219458583551651.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: unregister MDIO bus in
 _devm_mdiobus_free if needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <15ee7621-0e74-a3c1-0778-ca4fa6c2e3c6@gmail.com>
References: <15ee7621-0e74-a3c1-0778-ca4fa6c2e3c6@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2020 11:42:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 17 Feb 2020 21:34:10 +0100

> If using managed MDIO bus handling (devm_mdiobus_alloc et al) we still
> have to manually unregister the MDIO bus. For drivers that don't depend
> on unregistering the MDIO bus at a specific, earlier point in time we
> can make driver author's life easier by automagically unregistering
> the MDIO bus. This extension is transparent to existing drivers.
> 
> Heiner Kallweit (2):
>   net: phy: unregister MDIO bus in _devm_mdiobus_free if needed
>   r8169: let managed MDIO bus handling unregister the MDIO bus

Heiner, I'm going to defer on this.

The existing behavior, this proposal, and the alternatives you
described with Andrew Lunn in the patch #1 discussion all seem
equally cumbersome and awkward to me.
