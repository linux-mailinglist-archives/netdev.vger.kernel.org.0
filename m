Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1686321C6AC
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 01:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgGKWso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 18:48:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58940 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgGKWso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 18:48:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juOIQ-004fiE-9O; Sun, 12 Jul 2020 00:48:38 +0200
Date:   Sun, 12 Jul 2020 00:48:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH net-next 0/2] Fix MTU warnings for fec/mv886xxx combo
Message-ID: <20200711224838.GA1110701@lunn.ch>
References: <20200711203206.1110108-1-andrew@lunn.ch>
 <20200711212618.GP1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711212618.GP1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 10:26:18PM +0100, Russell King - ARM Linux admin wrote:
> On Sat, Jul 11, 2020 at 10:32:04PM +0200, Andrew Lunn wrote:
> > Since changing the MTU of dsa slave interfaces was implemented, the
> > fec/mv88e6xxx combo has been giving warnings:
> > 
> > [    2.275925] mv88e6085 0.2:00: nonfatal error -95 setting MTU on port 9
> > [    2.284306] eth1: mtu greater than device maximum
> > [    2.287759] fec 400d1000.ethernet eth1: error -22 setting MTU to include DSA overhead
> > 
> > This patchset adds support for changing the MTU on mv88e6xxx switches,
> > which do support jumbo frames. And it modifies the FEC driver to
> > support its true MTU range, which is larger than the default Ethernet
> > MTU.
> 
> It's not just the fec/mv88e6xxx combo - I've been getting them on
> Clearfog too.  It just hasn't been important enough to report yet.

Hi Russell

That is the combination i have tested. mvneta has support for changing
its MTU. So this should stop the warnings on clearfog as well.

    Andrew
