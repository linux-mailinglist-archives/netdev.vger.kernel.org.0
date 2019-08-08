Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4933865AC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 17:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733193AbfHHPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:25:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44610 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732698AbfHHPZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 11:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fui130ED+/x15a0urb5H8gvIS0rYY1pJ52buUNv/GUY=; b=jyqrfcjOsaG7bR8VJGRHSaNr/A
        g7LXLu2uPuY1exDDwl9vx0FczGnhndX6L5bmlE5CkhA7sA199ym60ywOVcERwuXWLRDvbXoJkczIP
        d8DVMkkdhgDSzUzJxh/+pEACBj/0o8aYfmV3hHQrDVh2jjLIb9cdSyfbp8Q+Xc7/y/js=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvkI1-0003ph-Em; Thu, 08 Aug 2019 17:25:17 +0200
Date:   Thu, 8 Aug 2019 17:25:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v2 04/15] net: phy: adin: add support for interrupts
Message-ID: <20190808152517.GD27917@lunn.ch>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
 <20190808123026.17382-5-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808123026.17382-5-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 03:30:15PM +0300, Alexandru Ardelean wrote:
> This change adds support for enabling PHY interrupts that can be used by
> the PHY framework to get signal for link/speed/auto-negotiation changes.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
