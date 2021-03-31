Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CB73504B8
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhCaQgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:36:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233831AbhCaQfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:35:52 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lRdon-00ECSt-Dz; Wed, 31 Mar 2021 18:35:45 +0200
Date:   Wed, 31 Mar 2021 18:35:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Modi, Geet" <geet.modi@ti.com>
Cc:     "Bajjuri, Praneeth" <praneeth@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH] net: phy: dp83867: perform soft reset and
 retain established link
Message-ID: <YGSk4W4mW8JQPyPl@lunn.ch>
References: <20210324010006.32576-1-praneeth@ti.com>
 <YFsxaBj/AvPpo13W@lunn.ch>
 <404285EC-BBF0-4482-8454-3289C7AF3084@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <404285EC-BBF0-4482-8454-3289C7AF3084@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>     > as per datasheet: https://www.ti.com/lit/ds/symlink/dp83867cr.pdf
> 
>     > 8.6.26 Control Register (CTRL)
>     > do SW_RESTART to perform a reset not including the registers and is
>     > acceptable to do this if a link is already present.
> 
>  
> 
>     I don't see any code here to determine if the like is present. What if
>     the cable is not plugged in?
> 
>     This API is primarily used for reset. Link Status is checked thru different
> register. This shall not impact the cable plug in/out. With this change, it
> will align with DP83822 driver API.

So why is there the comment:

>     >                                            and is
>     > acceptable to do this if a link is already present.

That kind of says, it is not acceptable to do this if the link is not
present. Which is why i'm asking.

	 Andrew
