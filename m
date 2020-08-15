Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7548E24521B
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 23:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgHOVnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 17:43:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54712 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgHOVnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 17:43:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k70NJ-009VEr-5j; Sat, 15 Aug 2020 19:53:49 +0200
Date:   Sat, 15 Aug 2020 19:53:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Clemens Gruber <clemens.gruber@pqgruber.com>
Cc:     netdev <netdev@vger.kernel.org>, fugang.duan@nxp.com,
        Chris Healy <cphealy@gmail.com>,
        David Miller <davem@davemloft.net>, Dave Karr <dkarr@vyex.com>
Subject: Re: [PATCH net-next v5] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Message-ID: <20200815175349.GG2239279@lunn.ch>
References: <20200502152504.154401-1-andrew@lunn.ch>
 <20200815165556.GA503896@workstation.tuxnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200815165556.GA503896@workstation.tuxnet>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 15, 2020 at 06:55:56PM +0200, Clemens Gruber wrote:
> Hi,
> 
> this patch / commit f166f890c8 ("net: ethernet: fec: Replace interrupt
> driven MDIO with polled IO") broke networking on i.MX6Q boards with
> Marvell 88E1510 PHYs (Copper / 1000Base-T).

Hi Clemens

Please could you try:

https://www.spinics.net/lists/netdev/msg675568.html

	Andrew
