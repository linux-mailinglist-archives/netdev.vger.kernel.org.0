Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D022231DDEE
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhBQRHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:07:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234327AbhBQRHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 12:07:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lCQHo-006vv8-9k; Wed, 17 Feb 2021 18:06:48 +0100
Date:   Wed, 17 Feb 2021 18:06:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: icplus: Call phy_restore_page() when
 phy_select_page() fails
Message-ID: <YC1NKO2HznLC887f@lunn.ch>
References: <YCy1F5xKFJAaLBFw@mwanda>
 <20210217142838.GM2222@kadam>
 <20210217150621.GG1463@shell.armlinux.org.uk>
 <20210217153357.GE1477@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217153357.GE1477@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm wondering whether we need to add __acquires() and __releases()
> annotations to some of these functions so that sparse can catch
> these cases. Thoughts?

Hi Russell

The more tools we have for catching locking problems the better.
Jakubs patchwork bot should then catch them when a patch is submitted,
if the developer did not run sparse themselves.

       Andrew
