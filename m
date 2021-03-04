Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DCA32D441
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 14:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241314AbhCDNgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 08:36:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240738AbhCDNgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 08:36:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHo8N-009I9c-Gh; Thu, 04 Mar 2021 14:35:19 +0100
Date:   Thu, 4 Mar 2021 14:35:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net 2/2] net: dsa: sja1105: fix ucast/bcast flooding
 always remaining enabled
Message-ID: <YEDiF1Gv3VUGfX39@lunn.ch>
References: <20210304105654.873554-1-olteanv@gmail.com>
 <20210304105654.873554-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304105654.873554-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 12:56:54PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In the blamed patch I managed to introduce a bug while moving code
> around: the same logic is applied to the ucast_egress_floods and
> bcast_egress_floods variables both on the "if" and the "else" branches.

Some static analysers will report this.
 
> This is clearly an unintended change compared to how the code used to be
> prior to that bugfix, so restore it.
> 
> Fixes: 7f7ccdea8c73 ("net: dsa: sja1105: fix leakage of flooded frames outside bridging domain")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
