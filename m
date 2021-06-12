Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277293A500B
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 20:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhFLSJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 14:09:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60992 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLSJU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 14:09:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Mz3kzdRldhK48HqcXmj3quPndyXKiKqvaRrl1Ug4ytw=; b=avEnA5jyE79GOaAzByCFSrotmp
        vA9gjI01jPVqAzKlO/gHDZIK0G+kPfdFNqj1ERoEyXNez/dglZMvjH8BwtuYo9joK2lUZJyvfuEM+
        jroM5WCfzrgbmAj764fXrFPSIEcLlYN2JetFj7+r/FzP9s+67uWBLxiY+0VH3n3kU14c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ls82O-0091JX-JN; Sat, 12 Jun 2021 20:07:16 +0200
Date:   Sat, 12 Jun 2021 20:07:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Subject: Re: [PATCH net-next 3/4] net: sfp: add support for 25G BASE-R SFPs
Message-ID: <YMT31JI0gg2+1fnt@lunn.ch>
References: <20210611125453.313308-1-steen.hegelund@microchip.com>
 <20210611125453.313308-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611125453.313308-4-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:54:52PM +0200, Steen Hegelund wrote:
> Add support for 25gbase-r modules. This is needed for the Sparx5 switch.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
