Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34B21E243D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 16:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgEZOjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 10:39:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49706 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbgEZOjL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 10:39:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wl9BZBNvREjJb/srdAAXoRj2hTSd93f5CQXbd/2vFb8=; b=XiC9LrKxjvSem8C3BH/jLavZix
        6on/uPIRJFsSzbrN4QQmS4s+wqWOG6lrziZNMvEmUiAyy6JiN9jCtOIJjyQfLoPD/LKhBdaiFmQPa
        0yRIpbYQs0rVzHlF3YSl5G9B2wW/6yad9x/tWd+NRaGwBraAIGxCgF0aAZKcrl1wh9xw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdajS-003I6i-AK; Tue, 26 May 2020 16:39:06 +0200
Date:   Tue, 26 May 2020 16:39:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 1/7] net: mdiobus: add clause 45 mdiobus accessors
Message-ID: <20200526143906.GK768009@lunn.ch>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdabd-0005s5-DB@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jdabd-0005s5-DB@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 03:31:01PM +0100, Russell King wrote:
> There is a recurring pattern throughout some of the PHY code converting
> a devad and regnum to our packed clause 45 representation. Rather than
> having this scattered around the code, let's put a common translation
> function in mdio.h, and provide some register accessors.
> 
> Convert the phylib core, phylink, bcm87xx and cortina to use these.

Hi Russell

This is a useful patch whatever we decide about C45 probing. If you
can do some basic testing of it, i say submit it for this merge
window.

	Andrew
