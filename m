Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11D71AE690
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 22:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730960AbgDQUNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 16:13:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730938AbgDQUNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 16:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0kBGVyRSE1ET9y9JaT6y03jCYKop/dsnwR1Vv+D9gK4=; b=qt0zERVTaR61uVqM1lqWJrNQGc
        8eXv1CKXdgjtEaMSosYSvHaTsaoYDYXyrbmZh3Jbr1z5cLMkHRHhxbyF5H00o6TmCikh2D6A6BUPe
        HER1nU4/eg3SPtaWFLFCOX7XAAFN5P6fiWcLz8GGdhnCILTkFwDBT6kVzMOp2GQCwBrg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPXMo-003LX8-6R; Fri, 17 Apr 2020 22:13:38 +0200
Date:   Fri, 17 Apr 2020 22:13:38 +0200
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
Message-ID: <20200417201338.GI785713@lunn.ch>
References: <20200417192858.6997-1-michael@walle.cc>
 <20200417192858.6997-3-michael@walle.cc>
 <20200417195003.GG785713@lunn.ch>
 <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35d00dfe1ad24b580dc247d882aa2e39@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Correct, and this function was actually stolen from there ;) This was
> actually stolen from the mscc PHY ;)

Which in itself indicates it is time to make it a helper :-)

      Andrew
