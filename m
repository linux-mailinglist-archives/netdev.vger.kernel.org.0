Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35A7264C2B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIJSDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:03:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55776 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgIJSDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 14:03:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGQuP-00E6iA-2R; Thu, 10 Sep 2020 20:02:57 +0200
Date:   Thu, 10 Sep 2020 20:02:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] net: phy: dp83869: support Wake on LAN
Message-ID: <20200910180257.GD3354160@lunn.ch>
References: <20200903114259.14013-1-dmurphy@ti.com>
 <20200903114259.14013-3-dmurphy@ti.com>
 <20200905113428.5bd7dc95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5051f1e2-4f8e-a021-df6c-d4066938422f@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5051f1e2-4f8e-a021-df6c-d4066938422f@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >   static int dp83869_config_port_mirroring(struct phy_device *phydev)
> > >   {
> > >   	struct dp83869_private *dp83869 = phydev->priv;
> > Overall this code looks quite similar to dp83867, is there no way to
> > factor this out?
> 
> Factor what out?  Yes the DP83867 and DP83869 are very similar in registers
> and bitmaps.  They just differ in their feature sets.
> 
> The WoL code was copied and pasted to the 869 and I would like to keep the
> two files as similar as I can as it will be easier to fix and find bugs.

It will be even easier if they shared the same code. You could create
a library of functions, like bcm-phy-lib.c.

  Andrew
