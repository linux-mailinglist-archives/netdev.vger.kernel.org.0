Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3192CC8E0
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgLBVY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:24:27 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:34584
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729401AbgLBVY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:24:27 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1kkZbF-0004ym-9y
        for netdev@vger.kernel.org; Wed, 02 Dec 2020 22:23:45 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: net: macb: fail when there's no PHY
Date:   Wed, 2 Dec 2020 21:23:40 -0000 (UTC)
Message-ID: <rq90ks$mjq$1@ciao.gmane.io>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com> <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch> <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch>
User-Agent: slrn/1.0.3 (Linux)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-02, Andrew Lunn <andrew@lunn.ch> wrote:
>> > So it will access the MDIO bus of the PHY that is attached to the
>> > MAC.
>> 
>> If that's the case, wouldn't the ioctl() calls "just work" even when
>> only the fixed-phy mdio bus and fake PHY are declared in the device
>> tree?
>
> The fixed-link PHY is connected to the MAC. So the IOCTL calls will be
> made to the fixed-link fake MDIO bus.

So how do you control which of the two mdio buses is connected to
the MAC?

> There are plenty of examples to follow.

That's true, but knowing which ones do what you're trying to do is the
hard part. If you already know how to do it, it's easy to find
examples showing it.  :)

--
Grant

