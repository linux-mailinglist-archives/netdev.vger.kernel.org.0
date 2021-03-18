Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51F33FCBA
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 02:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCRBiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 21:38:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33708 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhCRBib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 21:38:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lMhcJ-00BZNc-OB; Thu, 18 Mar 2021 02:38:27 +0100
Date:   Thu, 18 Mar 2021 02:38:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Flood all traffic
 classes on standalone ports
Message-ID: <YFKvE0g7bn6Zv7Ah@lunn.ch>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315211400.2805330-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:13:58PM +0100, Tobias Waldekranz wrote:
> In accordance with the comment in dsa_port_bridge_leave, standalone
> ports shall be configured to flood all types of traffic. This change
> aligns the mv88e6xxx driver with that policy.
> 
> Previously a standalone port would initially not egress any unknown
> traffic, but after joining and then leaving a bridge, it would.
> 
> This does not matter that much since we only ever send FROM_CPUs on
> standalone ports, but it seems prudent to make sure that the initial
> values match those that are applied after a bridging/unbridging cycle.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
