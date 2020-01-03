Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7E012FDD3
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgACUWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:22:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46992 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbgACUWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 15:22:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DXlmvzGIFZg8e5QLUFHILq1iokX6z7xR+KUOugOpcFk=; b=SIyeeLJQqmZ/2qTmaHrZ9qQARN
        7X+wcB5fwelP5ttPn5BJGuir3VwzgpFIqZue/nh9qs2Dt8Q75j9PT7xgU00KPHeY1Ecb9bvnzXJEP
        cIk5Z5fjE5AciDvMJV6H0j/qXPgwJJfED73cETIUlrAhrsUS/q3mlM9yFXGL7JidKZ7Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inTSK-0002mu-Q5; Fri, 03 Jan 2020 21:22:00 +0100
Date:   Fri, 3 Jan 2020 21:22:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: phy: add PHY_INTERFACE_MODE_10GBASER
Message-ID: <20200103202200.GP1397@lunn.ch>
References: <20200103115125.GC25745@shell.armlinux.org.uk>
 <E1inLV8-0006gD-P7@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1inLV8-0006gD-P7@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 11:52:22AM +0000, Russell King wrote:
> Recent discussion has revealed that the use of PHY_INTERFACE_MODE_10GKR
> is incorrect. Add a 10GBASE-R definition, document both the -R and -KR
> versions, and the fact that 10GKR was used incorrectly.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
