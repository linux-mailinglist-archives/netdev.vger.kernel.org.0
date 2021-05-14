Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751FF380E44
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 18:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhENQga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 12:36:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhENQg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 12:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5WnZ1xV29b6kze/gkiOaMlLGs/8KN9ZH+hUHdMCPt70=; b=C2nuqaVvLm6Fk/NYIRap7H0T/X
        yPraMKlKMm3O3ZQbxqv/QlF0dRbejfcBNbt5Ar59Wb2I1iUlS2Jmr2Bz7kPCH/oTwr8H6LX7o/Ux3
        01IBCdUtbC25XOaHSQq1FXHDSRptyGTiH0t1pzB5mTacO8FRhPRfE04ClcDbjaW/3QKM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhamM-004D4d-Rc; Fri, 14 May 2021 18:35:10 +0200
Date:   Fri, 14 May 2021 18:35:10 +0200
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
Subject: Re: [RFC PATCH net-next v5 01/25] net: dsa: qca8k: change simple
 print to dev variant
Message-ID: <YJ6mvkxjaGFyRYE7@lunn.ch>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
 <20210511020500.17269-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511020500.17269-2-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 04:04:36AM +0200, Ansuel Smith wrote:
> Change pr_err and pr_warn to dev variant.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
