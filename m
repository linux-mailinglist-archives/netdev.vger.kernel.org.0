Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3D114A7F4
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 17:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgA0QWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 11:22:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbgA0QWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 11:22:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jqVwM+IjEqXkV9M8NMwyyP0+f47l+p41i+3R+JYJ8V0=; b=mqlDVbcQuEeg/xh8juESDnyTCA
        EV2SZgsM9/mfEMZJntjYI9HKbPXJqaMO9Wb8xI61gyQhiLVoN8pYugGUCzVwVVMARE5yqbfHIgc4C
        n36zZTIJ9TfLD0EB81WznFHWH9SK9Znf3960J3xkKLzQOT64vsdoDoDqD9p11Av2TsOU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iw79K-0007AO-8b; Mon, 27 Jan 2020 17:22:06 +0100
Date:   Mon, 27 Jan 2020 17:22:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200127162206.GJ13647@lunn.ch>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
 <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127114600.GU25745@shell.armlinux.org.uk>
 <20200127140038.GD13647@lunn.ch>
 <20200127140834.GW25745@shell.armlinux.org.uk>
 <20200127145107.GE13647@lunn.ch>
 <20200127161132.GX25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127161132.GX25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Heiner has another device which has an Aquantia PHY running in an odd
> > mode so that it does 1G over a T2 link. It uses SGMII for this, and
> > that is where we first noticed the issue of the MAC and PCS having
> > different configurations.
> 
> Do you know when the issue appeared?

As far as i understand, it never worked, it is not a regression as
such. But Heiner probably knows more.

      Andrew
