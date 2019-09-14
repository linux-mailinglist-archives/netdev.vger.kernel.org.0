Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A864B2BC0
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfINPIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:08:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45988 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbfINPIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Sep 2019 11:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FIwdJW7J7v/CYDC5sPRxNAwcSvG1f92IalAWQoIEm1g=; b=zJ0Yt3EkMC1J42USq3pIcUsKdb
        3f82VvzIMsWN9t8I+OAPdMgntxq546zGG8ZI8Lfc6eUvdqZp0BWRTFZhc/WZguQlqJmMeHg2yZ6y7
        YZQhZAGjYpZAXwabbvvwkZj7TowZtYBFC9pw+V1SNxmlEX2IIuXoHOK0H5t1P/0IxIi8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i99en-0007yh-Kg; Sat, 14 Sep 2019 17:08:13 +0200
Date:   Sat, 14 Sep 2019 17:08:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: clarify where phylink should be
 used
Message-ID: <20190914150813.GG27922@lunn.ch>
References: <E1i94b6-0008TL-IR@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1i94b6-0008TL-IR@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 10:44:04AM +0100, Russell King wrote:
> Update the phylink documentation to make it clear that phylink is
> designed to be used on the MAC facing side of the link, rather than
> between a SFP and PHY.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
