Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29F230C054
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhBBNzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:55:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233245AbhBBNwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 08:52:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l6w5z-003nZG-Iz; Tue, 02 Feb 2021 14:51:55 +0100
Date:   Tue, 2 Feb 2021 14:51:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mike Looijmans <mike.looijmans@topic.nl>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
Message-ID: <YBlY+5vB3uRQT41U@lunn.ch>
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
 <YBAVwFlLsfVEHd+E@lunn.ch>
 <20210126134937.GI1551@shell.armlinux.org.uk>
 <YBH+uUUatjfwqFWq@lunn.ch>
 <20210128002555.GQ1551@shell.armlinux.org.uk>
 <YBIPj+3QhWLr9zjT@lunn.ch>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.949ef384-8293-46b8-903f-40a477c056ae.47109184-a5be-4b1d-bb22-724baf83e536@emailsignatures365.codetwo.com>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.0d2bd5fa-15cc-4b27-b94e-83614f9e5b38.a2a17a1f-7cb0-46c3-bdd8-65266e08a153@emailsignatures365.codetwo.com>
 <7cbe00ba-d762-7e18-6936-ae8cbd493ade@topic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cbe00ba-d762-7e18-6936-ae8cbd493ade@topic.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > 
> >      Andrew
> 
> Just wondering, now, a v2 patch isn't needed? Or should I amend the commit
> text?

Hi Mike

Take a look in patchwork.kernel.org. It has been flaky the last few
days. If the patch is not there, you definitively need to repost. If
you do find it, check what state it is in. That will tell you if it
needs reposting.

      Andrew
