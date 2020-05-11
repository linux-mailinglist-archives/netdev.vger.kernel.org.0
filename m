Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA131CE0D3
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 18:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbgEKQne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 12:43:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54022 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbgEKQnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 12:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eRjPsZzdo+/6CCY3nphHHJ4kzK+ecmkd6v9ybypxAbc=; b=jJKxa2Fl0/f0A/XajTDMJPX04q
        oVajAzyfqgGf/MAPGHYGW/S0ublGtndJZAXfzia7Z2gkui8iRk0JPbUd//IkC7UOn3LgjRc7oIzgA
        tYqQp9ugwtL+uujqUSazG6hEghbCbCL6Y49X28Wy4jFIy+gHQrs7E/wmHHpBYuHrgmqg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYBWW-001sNG-Tq; Mon, 11 May 2020 18:43:24 +0200
Date:   Mon, 11 May 2020 18:43:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200511164324.GE413878@lunn.ch>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200511111134.GD25096@plvision.eu>
 <20200511112905.GH2245@nanopsycho>
 <20200511124245.GA409897@lunn.ch>
 <20200511130252.GE25096@plvision.eu>
 <20200511135359.GB413878@lunn.ch>
 <20200511141117.GF25096@plvision.eu>
 <20200511153243.GJ2245@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511153243.GJ2245@nanopsycho>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Though in this case, it is not really a MAC, it is a BASE_MAC...
> Maybe in DSA world this is usual?

In the DSA world we take the MAC address from the master interface.
And all slave interfaces have the same MAC address, so it is not
really a base MAC, it is The MAC. The slaves are however allowed to
change their MAC address.

Where the master interface gets its MAC address from is somebody elses
problem.

	Andrew
