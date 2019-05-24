Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0775298C1
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391549AbfEXNTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:19:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391124AbfEXNTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nJHMm8ephNoiwFoCA10ZBbTHvz6Psv+u5TytHl2at20=; b=wqHHraoYrCCizoKrTf5ZTIZm4N
        Iyc87TBAMpk2LNVLK7BMPwV2fwvuoGX2K6KD1QDJT1AAVGN3yP5gkt0x1fTJ0aIKSuIE2mB1angO8
        WM3H3OkEWrb4VJpl24R2DGoopLP9mvGV/AECJ0WYh4t1KBKsIjx9bLbuRFxJ7M2j+XhU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUA6j-0000v4-4d; Fri, 24 May 2019 15:19:37 +0200
Date:   Fri, 24 May 2019 15:19:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 8/9] net: dsa: Use PHYLINK for the CPU/DSA
 ports
Message-ID: <20190524131937.GB2979@lunn.ch>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-9-ioana.ciornei@nxp.com>
 <9c953f4f-af27-d87d-8964-16b7e32ce80f@gmail.com>
 <CA+h21hpPyk=BYxBXDH5-SGfJdS-E+X9PfZHAMLYNwhL-1stumA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpPyk=BYxBXDH5-SGfJdS-E+X9PfZHAMLYNwhL-1stumA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Florian,
> 
> Yes we could, but since most of the adjust_link -> phylink_mac_ops
> changes appear trivial, and we have the knowledge behind b53 right
> here, can't we just migrate everything in the next patchset and remove
> adjust_link altogether from DSA?

I agree with Florian, we either need to support both, or their needs
to be another patchset which comes first and converts all DSA drivers
to PHYLINK. And it is this conversion patchset which is likely to
break things, so it would be good to sit in net-next for a week or two
to allow testing, before the second patchset is applied.

   Andrew
