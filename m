Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E358424E885
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbgHVQJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 12:09:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgHVQI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 12:08:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9W4Q-00Akq6-Ec; Sat, 22 Aug 2020 18:08:42 +0200
Date:   Sat, 22 Aug 2020 18:08:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Dan Murphy <dmurphy@ti.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: dp83867: apply ti,led-function
 and ti,led-ctrl to registers
Message-ID: <20200822160842.GE2347062@lunn.ch>
References: <20200821072146.8117-1-matthias.schiffer@ew.tq-group.com>
 <20200821072146.8117-2-matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200821072146.8117-2-matthias.schiffer@ew.tq-group.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 09:21:46AM +0200, Matthias Schiffer wrote:
> These DT bindings are already in use by the imx7-mba7 DTS, but they were
> not supported by the PHY driver so far.
> 
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

Sorry, but NACK.

Please look at the work Marek Behún is doing

https://lkml.org/lkml/2020/7/28/765

	Andrew
	
