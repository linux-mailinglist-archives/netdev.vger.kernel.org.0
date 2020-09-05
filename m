Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B88125E8C1
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgIEPhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:37:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgIEPhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 11:37:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEaFt-00DMjP-8A; Sat, 05 Sep 2020 17:37:29 +0200
Date:   Sat, 5 Sep 2020 17:37:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: bcm_sf2: Ensure that MDIO
 diversion is used
Message-ID: <20200905153729.GG3164319@lunn.ch>
References: <20200904213730.3467899-1-f.fainelli@gmail.com>
 <20200904213730.3467899-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904213730.3467899-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 02:37:30PM -0700, Florian Fainelli wrote:
> Registering our slave MDIO bus outside of the OF infrastructure is
> necessary in order to avoid creating double references of the same
> Device Tree nodes, however it is not sufficient to guarantee that the
> MDIO bus diversion is used because of_phy_connect() will still resolve
> to a valid PHY phandle and it will connect to the PHY using its parent
> MDIO bus which is still the SF2 master MDIO bus. The reason for that is
> because BCM7445 systems were already shipped with a Device Tree blob
> looking like this (irrelevant parts omitted for simplicity):

Hi Florian

Thanks for the extended commit message.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
