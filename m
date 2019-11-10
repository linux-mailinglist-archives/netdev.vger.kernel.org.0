Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B69EF6AAA
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfKJSH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:07:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59278 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfKJSH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 13:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4hDFRIlAJ7iukVFoE1IMCm0+4I2pn2sMD/WT1mDxPZY=; b=afwSEMTDwls/MA7pCzfQ7Qy6eG
        LxWSz1hdV8dXevtkIO2uWZkvTke0LyOFMLKEJfMUn+ju8WZwzDK5JxXPM0kc5xLCGwsFOwtYqCwlm
        67cbrjsnrjt5PNzkTXcmhf5JayHmvxAgMNJ9F3sDMDhFG6oBUZbOXEgMEN533ZbSu7gk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTrcw-0007Dw-E3; Sun, 10 Nov 2019 19:07:54 +0100
Date:   Sun, 10 Nov 2019 19:07:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 04/17] net: sfp: handle module remove outside
 state machine
Message-ID: <20191110180754.GP25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnrI-00059s-QP@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnrI-00059s-QP@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:28PM +0000, Russell King wrote:
> Removing a module resets the module state machine back to its initial
> state.  Rather than explicitly handling this in every state, handle it
> early on outside of the state machine.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

