Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A3C27F757
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 03:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbgJABYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 21:24:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbgJABYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 21:24:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNnKM-00Gzn5-NE; Thu, 01 Oct 2020 03:24:10 +0200
Date:   Thu, 1 Oct 2020 03:24:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: dsa: mv88e6xxx: serdes link without phy
Message-ID: <20201001012410.GA4050473@lunn.ch>
References: <72e8e25a-db0d-275f-e80e-0b74bf112832@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72e8e25a-db0d-275f-e80e-0b74bf112832@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>                          port@8 {
>                                  reg = <8>;
>                                  label = "internal8";
>                                  phy-mode = "rgmii-id";
>                                  fixed-link {
>                                          speed = <1000>;
>                                          full-duplex;
>                                  };
>                          };
>                          port@9 {
>                                  reg = <9>;
>                                  label = "internal9";
>                                  phy-mode = "rgmii-id";
>                                  fixed-link {
>                                          speed = <1000>;
>                                          full-duplex;
>                                  };
>                          };

> 
> The problem is that by declaring ports 8 & 9 as fixed link the driver 
> sets the ForcedLink in the PCS control register. Which mostly works. 
> Except if I add a chassis controller while the system is running (or one 
> is rebooted) then the newly added controller doesn't see a link on the 
> serdes.

Hi Chris

You say SERDES here, but in DT you have rgmii-id?

Can you run 1000Base-X over these links? If you can, it is probably
worth chatting to Russell King about using inband-signalling, and what
is needed to make it work without having back to back SFPs. If i
remember correctly, Russell has said not much is actually needed.

   Andrew
