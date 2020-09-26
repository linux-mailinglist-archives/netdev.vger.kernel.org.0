Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108C1279C58
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 22:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgIZUZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 16:25:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57200 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgIZUZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 16:25:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMGkg-00GJPl-Vj; Sat, 26 Sep 2020 22:25:02 +0200
Date:   Sat, 26 Sep 2020 22:25:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v3 net-next 06/15] net: dsa: add a generic procedure for
 the flow dissector
Message-ID: <20200926202502.GC3887691@lunn.ch>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
 <20200926193215.1405730-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926193215.1405730-7-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 10:32:06PM +0300, Vladimir Oltean wrote:
> For all DSA formats that don't use tail tags, it looks like behind the
> obscure number crunching they're all doing the same thing: locating the
> real EtherType behind the DSA tag. Nonetheless, this is not immediately
> obvious, so create a generic helper for those DSA taggers that put the
> header before the EtherType.
> 
> Another assumption for the generic function is that the DSA tags are of
> equal length on RX and on TX. Prior to the previous patch, this was not
> true for ocelot and for gswip. The problem was resolved for ocelot, but
> for gswip it still remains, so that can't use this helper yet.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
