Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5178635DFDB
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbhDMNMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:12:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48250 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243347AbhDMNMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 09:12:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWIpp-00GTeh-EL; Tue, 13 Apr 2021 15:12:05 +0200
Date:   Tue, 13 Apr 2021 15:12:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, system@metrotek.ru,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: marvell-88x2222: check that link
 is operational
Message-ID: <YHWYpQhjxKBjRvC3@lunn.ch>
References: <cover.1618227910.git.i.bornyakov@metrotek.ru>
 <614b534f1661ecf1fff419e2f36eddfb0e6f066d.1618227910.git.i.bornyakov@metrotek.ru>
 <YHTacMwlsR8Wl5q/@lunn.ch>
 <20210413071930.52vfjkewkufl7hrb@dhcp-179.ddg>
 <20210413092348.GM1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413092348.GM1463@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Indeed - it should be a logical and operation - there is light present
> _and_ the PHY recognises the signal. This is what the commit achieves,
> although (iirc) doesn't cater for the case where there is no SFP cage
> attached.

Hi Russell

Is there something like this in the marvell10 driver?

Also, do you know when there is an SFP cage? Do we need a standardised
DT property for this?

   Andrew
