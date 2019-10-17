Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28D52DB965
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 23:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395457AbfJQV7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 17:59:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51600 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733238AbfJQV7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 17:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=114cGOXdIYdNiPZFR4ELOkx6rjRTcSQU7fbuI7oiAt8=; b=Emw5kctjJuU/UajdJsL7jcuz08
        gRofogWUyIKrLG7gS4mgYbEpqsH26PTpL3E6XG69g2W5f13/2zEdVofGWHfhr2IAQGpZb6YCA5bjz
        T3wm5xSMbaF9FSmbY015OFsNl8j1xv07LrTkPrHC5yM9COeywkZaxLCY0I//I/MlfRqM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLDne-0006mf-K3; Thu, 17 Oct 2019 23:59:14 +0200
Date:   Thu, 17 Oct 2019 23:59:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>, hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next v2 1/2] net: phy: Use genphy_loopback() by
 default
Message-ID: <20191017215914.GA24810@lunn.ch>
References: <20191017214453.18934-1-f.fainelli@gmail.com>
 <20191017214453.18934-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017214453.18934-2-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 02:44:52PM -0700, Florian Fainelli wrote:
> The standard way of putting a PHY device into loopback is most often
> suitable for testing. This is going to be necessary in a subsequent
> patch that adds RGII debugging capability using the loopback feature.
> 
> Clause 45 PHYs are not supported through a generic method yet.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
