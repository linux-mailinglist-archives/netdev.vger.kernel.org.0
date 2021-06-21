Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BE53AEA8E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhFUN5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:57:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47682 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhFUN53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 09:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0y2AG1KVARbZJSAErpRPTxZwN4qEY/8lMyi8ZL6CDdI=; b=dCabUN7Zaz9cX57l2rnk4XrXcs
        CYTzJc2t50zqXaqUItVT1fWpcJxtuLALnTUVLxqJ9xb3Jenvh3LvUGJSP3SjrF6Vz5rjPuiFpAfC8
        /tWgXylYpXG59HhQxKe5CkEcEcHwZkftozHDE/DAHz9Pgvg0rS7gOD+Qd9vhWuJZfYEE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvKOO-00AVt7-My; Mon, 21 Jun 2021 15:55:12 +0200
Date:   Mon, 21 Jun 2021 15:55:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 2/6] net: dsa: export the
 dsa_port_is_{user,cpu,dsa} helpers
Message-ID: <YNCaQK8Yfj2m2txE@lunn.ch>
References: <20210618183017.3340769-1-olteanv@gmail.com>
 <20210618183017.3340769-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210618183017.3340769-3-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 09:30:13PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The difference between dsa_is_user_port and dsa_port_is_user is that the
> former needs to look up the list of ports of the DSA switch tree in
> order to find the struct dsa_port, while the latter directly receives it
> as an argument.
> 
> dsa_is_user_port is already in widespread use and has its place, so
> there isn't any chance of converting all callers to a single form.
> But being able to do:
> 	dsa_port_is_user(dp)
> instead of
> 	dsa_is_user_port(dp->ds, dp->index)
> 
> is much more efficient too, especially when the "dp" comes from an
> iterator over the DSA switch tree - this reduces the complexity from
> quadratic to linear.
> 
> Move these helpers from dsa2.c to include/net/dsa.h so that others can
> use them too.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
