Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A546F6AA6
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfKJSAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:00:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59256 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfKJSAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 13:00:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ezuULAJgDNUXdHkI7+QITheW6FpqGjiHxGKWp+F9CxY=; b=o9q54/JKDCEqIk2313OPcBhjXF
        tF2Zut3c1TbrtKE7EsSmo4BO9MN6WqYnUSIWMc/Rr5dhrfeGHz1j3tn7+DCeuVqY9t6LAzBGUtnaR
        3JLuLjiR7QPuzwq4RmWcki5+hyGdaoOK6lJtkgVGy0UFm/5C2rqMykhdYEKNStTvNFcQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTrVr-0007CF-CB; Sun, 10 Nov 2019 19:00:35 +0100
Date:   Sun, 10 Nov 2019 19:00:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/17] net: sfp: move tx disable on device down
 to main state machine
Message-ID: <20191110180035.GN25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnr8-00059T-Fs@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnr8-00059T-Fs@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:18PM +0000, Russell King wrote:
> Move the tx disable assertion on device down to the main state
> machine.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
