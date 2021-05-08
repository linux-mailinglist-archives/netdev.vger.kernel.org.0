Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77DD37738D
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhEHSIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:08:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59558 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhEHSIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 14:08:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfRMB-003I7v-Qd; Sat, 08 May 2021 20:07:15 +0200
Date:   Sat, 8 May 2021 20:07:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 18/28] net: dsa: qca8k: add
 ethernet-ports fallback to setup_mdio_bus
Message-ID: <YJbTU6JZlgmk3Ycl@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-18-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508002920.19945-18-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 02:29:08AM +0200, Ansuel Smith wrote:
> Dsa now also supports ethernet-ports. Add this new binding as a fallback
> if the ports node can't be found.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
