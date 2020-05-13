Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF351D1AEF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbgEMQX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:23:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732380AbgEMQX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 12:23:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C8VfVf/OuqyzLQjxfFBPY+9cZd8t31ZnOKlYly4ZIjA=; b=Ir0crLbYpBHkGMoZMC+PBfixUk
        eRtmYGBg48HCnVrUKMH9J1PJLSr4K7Vz1rsZ9K/QAJCGplxhuFE/89UAswzOUYb5zGM0oNW1xVfaS
        P0m8fkPIcSG8kfrnUfBdMjC6aVaGUINFApfcKeTHdQ3RAgTlWVbB7q20JXhn3EDIv0qU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYuAl-002BN0-In; Wed, 13 May 2020 18:23:55 +0200
Date:   Wed, 13 May 2020 18:23:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>,
        kernel@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v1] net: phy: at803x: add cable test support
Message-ID: <20200513162355.GJ499265@lunn.ch>
References: <20200513120648.14415-1-o.rempel@pengutronix.de>
 <0c80397b-58b8-0807-0b98-695db8068e25@gmail.com>
 <20200513154544.gwcccvbicpvrj6vm@pengutronix.de>
 <20200513154953.GI499265@lunn.ch>
 <20200513160026.fdls7kpxb6luuwed@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513160026.fdls7kpxb6luuwed@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 06:00:26PM +0200, Oleksij Rempel wrote:
> On Wed, May 13, 2020 at 05:49:53PM +0200, Andrew Lunn wrote:
> > > Uff.. i missed this. Then I'll need only to add some changes on top of
> > > his patch.
> > 
> > I've been chatting with mwalle on IRC today. There should be a repost
> > of the patches soon.
> 
> Cool!
> @Michael, please CC me.
> 
> you can include support for AR9331 and AR8032 in your patch (if you
> like)
> http://www.jhongtech.com/DOWN/ATHEROS--AR8032.pdf
> 
> They have same register, but only 2 pairs.

Hi Oleksij 

Michael just reposted. Please send a follow up patch adding these two
PHYs.

       Andrew
