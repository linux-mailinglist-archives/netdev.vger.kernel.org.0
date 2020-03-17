Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D69188A13
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgCQQUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:20:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41198 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgCQQUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 12:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HRovH6G0RZG3SHyJ4faEeAc3B3T1NOk/4OtmF2uo1qw=; b=UjF9UgYyM3tNlBO8h5x4nCeoZC
        DsPS73t4uWjUJmKkAspP24X1cvlZYRxHZA5aR11ekIxTA+D6LQGtjPxq/gEP/XlU/oRgKWf+rcbRY
        Plpz+ixhDjNNkZ0sQH7HQxvfJJUld8z212tg50a8R/O4ac4WfY4+LxYE0D+r4umlPjEM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEExI-0007c6-5i; Tue, 17 Mar 2020 17:20:36 +0100
Date:   Tue, 17 Mar 2020 17:20:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC net-next 1/5] net: phylink: rename 'ops' to 'mac_ops'
Message-ID: <20200317162036.GY24270@lunn.ch>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaI-0008JA-I7@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jEDaI-0008JA-I7@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 02:52:46PM +0000, Russell King wrote:
> *NOT FOR MERGING*
> 
> Rename the bland 'ops' member of struct phylink to be a more
> descriptive 'mac_ops' - this is necessary as we're about to introduce
> another set of operations.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
