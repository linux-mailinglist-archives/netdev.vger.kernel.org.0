Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FD45D33B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhKYCr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:47:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:52588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhKYCp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 21:45:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D22A600EF;
        Thu, 25 Nov 2021 02:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637808166;
        bh=A5Xz253QFaIIllaRE28Z4YMU5BWOrYGANBnXWg6fmBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yp5tJ9H7V+1Vh9IiyFmYW7rNVqfpbNxYx+bVYQxpNu70dRLEUtEzOs0xt5ifSda1f
         eBXLB7bCbdyaOyKLzmBkp2fGMnTdge2CJ1saSqi47gqxRqj4xSHYV5qA65NyfDNQFA
         uvoxsAhlLCy9d2YWUeX9pgwHmH2OmxEDiUytwq33XHiJU8Y1ei14EmugCsZNKgRpcH
         q0iDX3SdLBvaEGgVPPXvEP9mu+FmD2uOQcUmg2LgcMlJybuNrY4edD23XPGaAIxgTH
         zPw+O0L6cnG/kVCI5azgv4hSBpkUn2UdaLOO0E/+D0PPTQ9x3k516tY3q75iwm2yv9
         UsF/d7d9PQQJA==
Date:   Wed, 24 Nov 2021 18:42:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next] net: dsa: felix: enable cut-through
 forwarding between ports by default
Message-ID: <20211124184244.20614c66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124183900.7fb192f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211123132116.913520-1-olteanv@gmail.com>
        <20211124183900.7fb192f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 18:39:00 -0800 Jakub Kicinski wrote:
> > +		/* Enable cut-through forwarding for all traffic classes. */
> > +		if (ocelot_port->speed == min_speed)  
> 
> Any particular reason this is not <= ?

Because it can't be...
