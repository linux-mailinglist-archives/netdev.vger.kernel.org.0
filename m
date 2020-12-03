Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB72B2CCDA9
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbgLCDzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 22:55:44 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:34598
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgLCDzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:55:43 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1kkfht-0003ym-Vk
        for netdev@vger.kernel.org; Thu, 03 Dec 2020 04:55:01 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: net: macb: fail when there's no PHY
Date:   Thu, 3 Dec 2020 03:54:57 -0000 (UTC)
Message-ID: <rq9nih$egv$1@ciao.gmane.io>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com> <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch> <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch> <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com>
User-Agent: slrn/1.0.3 (Linux)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-03, Florian Fainelli <f.fainelli@gmail.com> wrote:

> You would have to have a local hack that intercepts the macb_ioctl()
> and instead of calling phylink_mii_ioctl() it would have to
> implement a custom ioctl() that does what
> drivers/net/phy/phy.c::phy_mii_ioctl does except the mdiobus should
> be pointed to the MACB MDIO bus instance and not be derived from the
> phy_device instance (because that one points to the fixed PHY).

So I can avoid my local hack to macb_main.c by doing a doing a local
hack to macb_main.c?

--
Grant





