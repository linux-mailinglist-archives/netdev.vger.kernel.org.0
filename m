Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C336FF0F4
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbfKPQI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:08:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729833AbfKPQI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 11:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xn3+jb6JC42T48+MMvIpyv/NoNdueKhAQ9hcJt9HOsY=; b=JKQZ6wbUeGfSC14u9Vwgh7bGvZ
        hOkDglocG2Nf3JSmPV2bDp3frh0n3PiHcrA7ToMBM98V1hjnxe6OL5mJuET1ZiNF9GsYAJ5D/kI5t
        yZJVEZF3kxeRBnjhE+y0oAuuK4Y2qeGDIvKfJC/b24G7AJ7eVkh83rv3t+UZMn8jAlsA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iW0d6-0005u2-B0; Sat, 16 Nov 2019 17:08:56 +0100
Date:   Sat, 16 Nov 2019 17:08:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: phy: add core phylib sfp support
Message-ID: <20191116160856.GE5653@lunn.ch>
References: <20191115195339.GR25745@shell.armlinux.org.uk>
 <E1iVhi7-0007b1-99@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iVhi7-0007b1-99@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 07:56:51PM +0000, Russell King wrote:
> Add core phylib help for supporting SFP sockets on PHYs.  This provides
> a mechanism to inform the SFP layer about PHY up/down events, and also
> unregister the SFP bus when the PHY is going away.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
