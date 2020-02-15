Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C23E15FFF3
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 20:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgBOTIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 14:08:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47978 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgBOTIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 14:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QEol3oTZBjmjy0sMngt7iENuDAdJ+ACfXW0+2QiMZcA=; b=SmCLr+NAzer/Ki/qsbGz6Onbiu
        a7xRWYKMyaXFPCDBaWBXewuhWuznDslzMsCIDkCMOh5yWYEe/7jOwPJJGdkzo7HA45G/cIc7uMCr3
        mP1+yTWg3kwV5hJ1t34Wo/tq6eVv6xXn7pUMtw/hmbJh0p6d/e7fugpn69d/UKKt6n3Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j32nM-0005E0-CM; Sat, 15 Feb 2020 20:08:04 +0100
Date:   Sat, 15 Feb 2020 20:08:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/10] net: phylink: clarify flow control
 settings in documentation
Message-ID: <20200215190804.GZ31084@lunn.ch>
References: <20200215154839.GR25745@shell.armlinux.org.uk>
 <E1j2zhp-0003Yf-1O@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j2zhp-0003Yf-1O@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 03:50:09PM +0000, Russell King wrote:
> Clarify the expected flow control settings operation in the phylink
> documentation for each negotiation mode.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
