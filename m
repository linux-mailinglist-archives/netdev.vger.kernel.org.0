Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4A229964
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404083AbfEXNwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:52:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55990 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403843AbfEXNwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:52:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mATfS2m6lRxg8VJalhdIKYJyfzYInbV/jwQ5TtoRz+s=; b=LYdi2xZ49FEgXJ/5j0FoVzPGZq
        oB6hBS8/UbPX82Z3ymhdqVG3y+SA0KZW77TFaQVqp3YKu+JPEjEQqkoida+h0tQRVGxPne0AB0fiV
        sgIofE4OY7f8i4itpoJdWFIihR8gTpeqBGrxG3obP4pKDRrxgZRoMkGKB9qjBcx2WeAE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUAcD-0001GF-KK; Fri, 24 May 2019 15:52:09 +0200
Date:   Fri, 24 May 2019 15:52:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V5] net: phy: tja11xx: Add TJA11xx PHY driver
Message-ID: <20190524135209.GG2979@lunn.ch>
References: <20190517235123.32261-1-marex@denx.de>
 <2c30c9c9-1223-ad91-2837-038e0ee5ae23@gmail.com>
 <CA+h21hq6OW2fX_m3rGvhuumhwCj7MM+VjVH_G4RO85hgGa4p7Q@mail.gmail.com>
 <e7539c77-72ea-5c7f-16e3-27840b040702@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7539c77-72ea-5c7f-16e3-27840b040702@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Well, it seems this patch is flagged in patchwork as "changes requested"
> . I don't know what changes are requested though :-(

Hi Marek

The patch was submitted while net-next as closed. That is pretty much
an automatic reject.

Please submit it again, and add on the review tags you have received.
It should then get accepted.

   Andrew
