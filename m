Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32325118E37
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfLJQxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:53:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727506AbfLJQxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 11:53:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nle1PkxwDcP+EJHDKJe3B/yvtlr/x4MsEF2G1YxXulw=; b=ZsNymnfuX5fc1kz4NIILm49xWh
        bWIyZhe4zYeZq8If8RuvaU6uLt4VYCrHX3wol1g+yTRf4du1q+7bBYpT9quidTIAtFZm0BooHfMtP
        z9A+tPdTCRPWhVKeJLjHWF4ZfPYPUXOIdpaIQDxZAyVov7zgLCGX6DUGr5tUusH9ee9A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieild-0005TO-LC; Tue, 10 Dec 2019 17:53:45 +0100
Date:   Tue, 10 Dec 2019 17:53:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 02/14] net: sfp: derive interface mode from
 ethtool link modes
Message-ID: <20191210165345.GH27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKny-0004uf-A2@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKny-0004uf-A2@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:18:34PM +0000, Russell King wrote:
> We don't need the EEPROM ID to derive the phy interface mode as we can
> derive it merely from the ethtool link modes.  Remove the EEPROM ID
> argument to sfp_select_interface().
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
