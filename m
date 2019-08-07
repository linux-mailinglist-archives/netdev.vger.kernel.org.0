Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2833384CC4
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 15:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388276AbfHGNU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 09:20:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40982 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387957AbfHGNU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 09:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t8aqXvPw0q5E+uBD13OrFAzMjz9c4sMlYhrCXiVJ+Fg=; b=TrO4rgDO8G9WbuFurc3pU56kH8
        QVrR8oeF35DVeaV4u77u9VHnRv7tmmgwDOMAmiU4xJ5o2gqvJC5OP9kEaQXzQtpILrtNRH1HMo1Xk
        IG2b6BIy4ZlTuYAytzkkIEJaK3f2CBqeLEmW/GWA5pmFav7uRcBH0bKfDu50PaE16uJc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvLrX-0004qH-N1; Wed, 07 Aug 2019 15:20:19 +0200
Date:   Wed, 7 Aug 2019 15:20:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH 06/16] net: phy: adin: support PHY mode converters
Message-ID: <20190807132019.GL20422@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-7-alexandru.ardelean@analog.com>
 <20190805145105.GN24275@lunn.ch>
 <15cf5732415c313a7bfe610e7039e7c97b987073.camel@analog.com>
 <20190806153910.GB20422@lunn.ch>
 <7747cb845a9122004b9565f444b4719170f74b35.camel@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7747cb845a9122004b9565f444b4719170f74b35.camel@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is it ok if we defer the solution for this drivers/patchset?

Yes, not a problem if phy-mode means phy-mode.

     Andrew
