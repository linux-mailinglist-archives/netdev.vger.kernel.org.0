Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13FD279B9C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIZRtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:49:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIZRtD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:49:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMEJi-00GITK-K4; Sat, 26 Sep 2020 19:49:02 +0200
Date:   Sat, 26 Sep 2020 19:49:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 05/16] net: dsa: make the .flow_dissect
 tagger callback return void
Message-ID: <20200926174902.GC3883417@lunn.ch>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
 <20200926173108.1230014-6-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926173108.1230014-6-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 08:30:57PM +0300, Vladimir Oltean wrote:
> There is no tagger that returns anything other than zero, so just change
> the return type appropriately.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
