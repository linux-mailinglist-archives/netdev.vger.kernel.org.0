Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE6218B3E0
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgCSNEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:04:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45000 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgCSNEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 09:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ALEhqzUrdWOrOtrsu5TizOy7Y+cg2H0bWBjU7zo4CqA=; b=AjKCdmNyspJyHUcO6CU/0cJDlk
        69L+e1V6H+HHaWWjdftzXM/ba0jNXxpN4zh701dbzLsUmkjk+GhlSidH8gz2tQ5bDQwDEPpA/sXgC
        dZH/URHTh51VXi/DZ34sT+h6uqOGxUyH5sW2vOKufrVbIjNK60sggv2z3/cGgMoGvV8g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEuqb-0006YF-4A; Thu, 19 Mar 2020 14:04:29 +0100
Date:   Thu, 19 Mar 2020 14:04:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
Message-ID: <20200319130429.GC24972@lunn.ch>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
 <20200318232159.GA25745@shell.armlinux.org.uk>
 <b0bc3ca0-0c1b-045e-cd00-37fc85c4eebf@gmail.com>
 <20200319112535.GD25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319112535.GD25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The only time that this helps is if PHY drivers implement reading a
> vendor register to report the actual link speed, and the PHY specific
> driver is used.

So maybe we either need to implement this reading of the vendor
register as a driver op, or we have a flag indicating the driver is
returning the real speed, not the negotiated speed?

	   Andrew
