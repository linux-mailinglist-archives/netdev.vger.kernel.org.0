Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF71410C88
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhISRJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:09:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229689AbhISRJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 13:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tVV0k8mB14p0z/fC7DcAQMhh5dY2sRTyvTnQkgS+R88=; b=tGOJ8y+K3uCYIE4MuKKzkqrJWK
        CyFKePd/f420EtxomE/x8Rno3oB27FDe4gtgmcXRY7euEzra1KSeNMW5K2Qkh6Kg/uUfaW12REgjN
        E8JMVoxihYokkQTnXaeIXAOt6ZLoJ/aIMo2uI8AiQVAwy9e1U1XxNqy7sG4t3Y7CMMfM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mS0IP-007Mhb-AK; Sun, 19 Sep 2021 19:08:05 +0200
Date:   Sun, 19 Sep 2021 19:08:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 1/3] net: phy: at803x: add support for qca
 8327 A variant internal phy
Message-ID: <YUdudXezLjpC1DO5@lunn.ch>
References: <20210919162817.26924-1-ansuelsmth@gmail.com>
 <20210919162817.26924-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919162817.26924-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 06:28:15PM +0200, Ansuel Smith wrote:
> For qca8327 internal phy there are 2 different switch variant with 2
> different phy id. Add this missing variant so the internal phy can be
> correctly identified and fixed.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
