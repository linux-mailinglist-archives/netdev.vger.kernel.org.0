Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6E61E6E33
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436769AbgE1V4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:56:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55438 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436736AbgE1V4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 17:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OY2df1kqKEp/UGNdwwKMp0xgZKMNHgjADUX3HWAIlIk=; b=k4R6RaG4Ls4Jkl1lmrc5Yegz4G
        MA2bLbwa8I+AW3zF6lVMyjY+T1fESmNa2Ix24aX+DwBtGVSl/yrxaXR/S+aAJdmQM/QB0DOy/W/Ml
        7U9Ikiv7W0/+rYSvXAMSwDmYcy9CXc8yC4H6f0o8t1MVj/eQ50e89dDuFmm68vurO0l8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeQVe-003aAu-Em; Thu, 28 May 2020 23:56:18 +0200
Date:   Thu, 28 May 2020 23:56:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, horatiu.vultur@microchip.com,
        allan.nielsen@microchip.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: Re: [PATCH net-next 11/11] net: dsa: ocelot: introduce driver for
 Seville VSC9953 switch
Message-ID: <20200528215618.GA853774@lunn.ch>
References: <20200527234113.2491988-1-olteanv@gmail.com>
 <20200527234113.2491988-12-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527234113.2491988-12-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Extending the Felix driver to probe a PCI as well as a platform device
> would have introduced unnecessary complexity. The 'meat' of both drivers
> is in drivers/net/ethernet/mscc/ocelot*.c anyway, so let's just
> duplicate the Felix driver, s/Felix/Seville/, and define the low-level
> bits in seville_vsc9953.c.

Hi Vladimir

That has resulted in a lot of duplicated code.

Is there an overall family name for these switch?

Could you add foo_set_ageing_time() with both felix and saville share?

      Andrew
