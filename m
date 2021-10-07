Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C63B424B27
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240035AbhJGAde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:33:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53296 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230443AbhJGAdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:33:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TlbyboHcS7ad1wnQ59C4BfD/EqXlIcbqsHTWWn4Otf8=; b=LfE6AA6Y+bELnEbK5N0JdbzHRD
        RuJcpBJRK29eXgYAYC4WASy9lLix0IbhH9hx7gx9QkMrYe2RrwYcv/TghUJ9xsrJj6zLr7tx3pVuN
        SyO4fpoOt8IJPuGELXqieB5sn1T7tMbwmazwdzTr8qKHf0CKKOtoYo/BoNZH++6GtE0c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYHJx-009tHY-DI; Thu, 07 Oct 2021 02:31:37 +0200
Date:   Thu, 7 Oct 2021 02:31:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 11/13] devicetree: net: dsa: qca8k: Document
 qca,sgmii-enable-pll
Message-ID: <YV4/6TRdd3N1v8Zv@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-12-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +- qca,sgmii-enable-pll  : For SGMII CPU port, explicitly enable PLL, TX and RX
> +                          chain along with Signal Detection.

Continuing on with the comment in the previous post. You might want to
give a hit when this is needed.

     Andrew
