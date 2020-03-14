Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE62185822
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgCOBys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727701AbgCOByr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TQVabTPyJ9UqIS/d7gQW27Tim/RJMMbtIzp/cNX0MPE=; b=ajOTwPrp3utM9KnaILLCpSBCfd
        MzTwRMLbv3ZVX0qWoYe9vSrc2KWTzC3FKT2N6dmyk1/oBn3Wbu8l7AflmswAyhaYtgDXMvMYuU+bp
        TNpKyIUqNsfrih0yYpoIRI6VzYNaOfkX0tw3eHET/QLebdN06euo1o1vptt7nUHAdBDY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDBZD-0001ZZ-Sx; Sat, 14 Mar 2020 19:31:23 +0100
Date:   Sat, 14 Mar 2020 19:31:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: mii: add linkmode_adv_to_mii_adv_x()
Message-ID: <20200314183123.GC5388@lunn.ch>
References: <20200314100916.GE25745@shell.armlinux.org.uk>
 <E1jD3jy-00066B-Sk@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD3jy-00066B-Sk@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:09:58AM +0000, Russell King wrote:
> Add a helper to convert a linkmode advertisement to a clause 37
> advertisement value for 1000base-x and 2500base-x.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
