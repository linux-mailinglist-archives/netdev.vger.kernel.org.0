Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B011AE790
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 23:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgDQV2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 17:28:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45252 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgDQV2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 17:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hyLBXQXtWodGwneleHMM9khAKkIEX8kgCmevzd2/PYg=; b=HvGk58NlppiJK/TZb6csWf6vOK
        ayDc414HTT15qa8Znf3XhT6UVbCVCtThrCvS8bwSL9H1p31pvcV55Q6GasHnWfNfSrj1yaByDZ87h
        SaA7Landul0gLpPkJ3e1B+8p4Tj+4rubHqV7Bd1/rwlmHQd+DYOrX0sQFgcBPpKisMbo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPYXF-003M43-VB; Fri, 17 Apr 2020 23:28:29 +0200
Date:   Fri, 17 Apr 2020 23:28:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 3/3] net: phy: bcm54140: add hwmon support
Message-ID: <20200417212829.GJ785713@lunn.ch>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc>
 <20200417195003.GG785713@lunn.ch>
 <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
 <20200417201338.GI785713@lunn.ch>
 <84679226df03bdd8060cb95761724d3a@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84679226df03bdd8060cb95761724d3a@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 11:08:56PM +0200, Michael Walle wrote:
> Am 2020-04-17 22:13, schrieb Andrew Lunn:
> > > Correct, and this function was actually stolen from there ;) This was
> > > actually stolen from the mscc PHY ;)
> > 
> > Which in itself indicates it is time to make it a helper :-)
> 
> Sure, do you have any suggestions?

mdiobus_get_phy() does the bit i was complaining about, the mdiobus
internal knowledge.

	Andrew
