Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5688821A8B2
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGIUJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:09:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55900 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbgGIUJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:09:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jtcrd-004NEB-0d; Thu, 09 Jul 2020 22:09:49 +0200
Date:   Thu, 9 Jul 2020 22:09:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add serdes read/write
 dynamic debug
Message-ID: <20200709200949.GA1037260@lunn.ch>
References: <20200709184318.4192-1-cphealy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709184318.4192-1-cphealy@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:43:18AM -0700, Chris Healy wrote:
> Add deb_dbg print statements in both serdes_read and serdes_write
> functions.

Hi Chris

Why is SERDES access special? Why not all accesses? global1, global2,
global3, port, etc.

As David said, tracepoints are better for this. Take a look at
include/trace/events/mdio.h and drivers/net/phy/mdio_bus.c as an
example which traces all mdio accesses.

	Andrew
