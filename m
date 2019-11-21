Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC8E104899
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKUCkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:40:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfKUCkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:40:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ynR2Mus8ynXWFNzxiLjTW7jR8f4Fc4KWTg4Yn5y4ixE=; b=ZkS8O49qDZVvefZ66GvWc+RV9n
        +FMp8y7+wKjf9SeOKF/MiK9OQyI6sMox2vdYHyARB+gNme7nVosxebdgTeA3cWhcguLwqaqo2oVMh
        NS1FLKk0bMrep6nO1IKpOa8WmYCRgggGLU6eCVSHHSx9Wn0DnGHtm+Y+/oFzWhx9JT/E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXcOE-000772-AP; Thu, 21 Nov 2019 03:40:14 +0100
Date:   Thu, 21 Nov 2019 03:40:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/5] net: mscc: ocelot: export ocelot_hwstamp_get/set
 functions
Message-ID: <20191121024014.GK18325@lunn.ch>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
 <20191120082318.3909-2-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120082318.3909-2-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 04:23:14PM +0800, Yangbo Lu wrote:
> Export ocelot_hwstamp_get/set functions so that DSA driver
> is able to reuse them.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
