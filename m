Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD6D380E64
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 18:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhENQrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 12:47:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230268AbhENQrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 12:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VaBlezcUePt4UxGYIj7HflX5EiYVhTB2nTsXUJyWYuA=; b=LIeZ75gSgJbqjew0iAaLhmmA82
        Gz/UDYV4VpTdCOaNsRyESuvHHPLYhVeAXcu+xrevzvMYLws33M88Vblci3MVbk87qxmqRMr/yQheL
        g3NHXv9bZxsbRjMSWvPG9C9po5Vy0yTnAkYJRJMF8eHD+cdrnNYvPbDgYaoyUEjEzuuE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhawj-004DAY-Rk; Fri, 14 May 2021 18:45:53 +0200
Date:   Fri, 14 May 2021 18:45:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next v5 12/25] net: dsa: qca8k: limit port5 delay
 to qca8337
Message-ID: <YJ6pQVsCKPoJ8wQF@lunn.ch>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
 <20210511020500.17269-13-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511020500.17269-13-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 04:04:47AM +0200, Ansuel Smith wrote:
> Limit port5 rx delay to qca8337. This is taken from the legacy QSDK code
> that limits the rx delay on port5 to only this particular switch version,
> on other switch only the tx and rx delay for port0 are needed.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

This should really be controlled by the phy-mode, but i suspect it is
too late to fix now without breaking some boards.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
