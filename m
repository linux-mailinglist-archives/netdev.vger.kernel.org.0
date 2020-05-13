Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B701D1F3A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390694AbgEMTbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:31:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58762 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389392AbgEMTbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 15:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1du+c2CL7V/+7gcDWkwxD8HxF7gSpeGkfz5LZanDME0=; b=jB1qOzU+gJuXzzEQhOGrz8uEkB
        CD5wu2KTAKS46BqqJ84NOIstxKAUAZeU+7ATvZaVgkXGfhKP1kA9PXgiGoVeFB58IQIDLag5xrOjj
        AwiKBpaCiT5H1C7667Y63qfsGOo5O0iB9H62QZ5Smpuy8fSUd6vB7k8cbDrhu+nHSq0U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYx5k-002CLm-2E; Wed, 13 May 2020 21:30:56 +0200
Date:   Wed, 13 May 2020 21:30:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test support
Message-ID: <20200513193056.GN499265@lunn.ch>
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
 <20200513133925.GD499265@lunn.ch>
 <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Do these registers all conform to the standard? Can we pull this code
> > out into a library which all standards conformant PHY drivers can use?
> 
> According to opensig, this functionality should be present on all new T1 PHYs.
> But the register/bit layout is no specified as standard. At least I was not able
> to find it. I assume, current layout is TJA11xx specific.

O.K. then:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
