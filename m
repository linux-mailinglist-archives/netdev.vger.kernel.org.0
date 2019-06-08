Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57DA3A145
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 20:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfFHSqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 14:46:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38494 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbfFHSqH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 14:46:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GckkiKT1Tl9fO6LvWpZfG2l3m5Hm25MNES0Pnb+Idks=; b=DdRoSibu4fyUvRDIwcM1OuqNS6
        a+LPuikSotDadwYYh1beBeOxznXDU31WfjpX0nEKpU6drEp0+qib6XZSAXNS4i8dljW4COw56+iz/
        K8g3qUsxj3cJFzfyxit8GMIi9x9GV4hXo5ZhJP6wL0F6zkhea7dhdcOFs5rVceRC3fPQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZgLp-0005wZ-Ev; Sat, 08 Jun 2019 20:46:01 +0200
Date:   Sat, 8 Jun 2019 20:46:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 2/2] net: stmmac: Convert to phylink
Message-ID: <20190608184601.GA22700@lunn.ch>
References: <cover.1559741195.git.joabreu@synopsys.com>
 <2528141fcc644205dc1c0a0f2640da1a0e7d5935.1559741195.git.joabreu@synopsys.com>
 <34db7462-4f5a-155a-d230-e4c90cee1ce3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34db7462-4f5a-155a-d230-e4c90cee1ce3@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I am not exactly sure removing this is strictly equivalent here, but the
> diff makes it hard to review.

Yes, diff is doing a poor job here. I already asked Jose if a better
diff could be produced by passing extra options.

> - add support for PHYLINK (parts of this patch) but without plugging it
> into the probe/connect path just yet

I don't think this is going to make the diff any better.

I might actually just apply the patches and look at the resulting
files.

  Andrew
