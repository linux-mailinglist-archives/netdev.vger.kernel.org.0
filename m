Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76F279C59
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 22:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgIZU14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 16:27:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57212 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgIZU14 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 16:27:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMGnS-00GJQn-IX; Sat, 26 Sep 2020 22:27:54 +0200
Date:   Sat, 26 Sep 2020 22:27:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v3 net-next 07/15] net: dsa: point out the tail taggers
Message-ID: <20200926202754.GD3887691@lunn.ch>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
 <20200926193215.1405730-8-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926193215.1405730-8-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 10:32:07PM +0300, Vladimir Oltean wrote:
> The Marvell 88E6060 uses tag_trailer.c and the KSZ8795, KSZ9477 and
> KSZ9893 switches also use tail tags.
> 
> Tell that to the DSA core, since this makes a difference for the flow
> dissector. Most switches break the parsing of frame headers, but these
> ones don't, so no flow dissector adjustment needs to be done for them.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
