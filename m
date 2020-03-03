Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA0E178368
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbgCCTvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:51:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44296 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728787AbgCCTvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 14:51:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WPokSijLD8Fr2GUcDC5hA4gf0yXyzUhE+iLvk5ACet0=; b=sjlecy+G9M+D6W/OsZS3zhmgJs
        d+LeIRameXlLQMJ3LEjmSXfmq+BWvRmWJY3dRO3MXtjx/8QXaMuM+Vkih4tFgAq6mRm+rt2Jl/Gx+
        dqlGuOYP9nO95VKMOqGbcqMyT81rtOar1xlbpT9xl8aM/Bq6ovgFD2ZoySlHf2jhEUp0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9DZn-0000IW-Rz; Tue, 03 Mar 2020 20:51:35 +0100
Date:   Tue, 3 Mar 2020 20:51:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] net: phy: marvell10g: add mdix control
Message-ID: <20200303195135.GA1092@lunn.ch>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99s1-00011Q-RB@rmk-PC.armlinux.org.uk>
 <20200303170316.GJ24912@lunn.ch>
 <20200303190601.GU25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303190601.GU25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So, if we want to do this, it should be a separate series, fixing
> all locations at the same time.

Hi Russell

A separate series is good for me.

  Andrew
