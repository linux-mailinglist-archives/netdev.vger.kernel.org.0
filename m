Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33423418939
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 15:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhIZOBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 10:01:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231777AbhIZOA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 10:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mpQfJQ4vBJxTp7tIq7ie6usy/23xefOph6ohHZyt8d8=; b=BYaPkO/UdcgFLrY/096WRfx5EH
        3X0ZzqU2xquvKAYM3MMJSzwpct4nmkE6AgmSSFRMG0FLH5L4qLOkyBKYqDmpM3YmyCKObN8+7Kx0L
        SJS2ODPDXA+32Fox9g30riuCpl6SxdZ/SI19AtvluWp25XzqgqYAiDg/NPVfZBTIL5bY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUUgY-008Jxe-5C; Sun, 26 Sep 2021 15:59:18 +0200
Date:   Sun, 26 Sep 2021 15:59:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: bcmgenet: remove netif_carrier_off
 from adjust_link
Message-ID: <YVB8tljc2dOp3Ixw@lunn.ch>
References: <20210926032114.1785872-1-f.fainelli@gmail.com>
 <20210926032114.1785872-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926032114.1785872-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 25, 2021 at 08:21:11PM -0700, Florian Fainelli wrote:
> From: Doug Berger <opendmb@gmail.com>
> 
> The bcmgenet_mii_setup() function is registered as the adjust_link
> callback from the phylib for the GENET driver.
> 
> The phylib always sets the netif_carrier according to phydev->link
> prior to invoking the adjust_link callback, so there is no need to
> repeat that in the link down case within the network driver.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
