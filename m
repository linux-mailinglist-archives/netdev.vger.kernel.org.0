Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB75E1C7391
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgEFPFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:05:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45234 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbgEFPFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 11:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nN4D8JtEEP1wZ2Y7nc5/OfITuaB3tWamF5TgeN8sta0=; b=iTu00gS5iqMUZ7X3od9P+UOz52
        o8NkYK4oQXGCwv0+rS3ucqdHvhoxbpouKto4XOkZJpFwTR2vnIXnePEqi+oqh5CxfMkvpTbZOEyII
        3mxpjpXJw8M1kB7cqJkbz0+OmK/i4KjevTAcDcqr3F1fOF5P7LuZ1HGok38bEB4kPEiM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jWLc6-00168s-Id; Wed, 06 May 2020 17:05:34 +0200
Date:   Wed, 6 May 2020 17:05:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v6 2/2] net: phy: tja11xx: add support for
 master-slave configuration
Message-ID: <20200506150534.GI224913@lunn.ch>
References: <20200505063506.3848-1-o.rempel@pengutronix.de>
 <20200505063506.3848-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505063506.3848-3-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 08:35:06AM +0200, Oleksij Rempel wrote:
> The TJA11xx PHYs have a vendor specific Master/Slave configuration bit,
> which is not compatible with IEEE 803.2-2018 spec for 100Base-T1
> devices. So, provide a custom config_ange call back to solve this
> problem.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
