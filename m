Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F0F344079
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 13:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCVMHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:07:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40058 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhCVMHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 08:07:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOJLD-00COWM-79; Mon, 22 Mar 2021 13:07:27 +0100
Date:   Mon, 22 Mar 2021 13:07:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix up kerneldoc some more
Message-ID: <YFiIf2AziF8WzE9Z@lunn.ch>
References: <20210322093009.3677265-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322093009.3677265-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 11:30:09AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Commit 0b5294483c35 ("net: dsa: mv88e6xxx: scratch: Fixup kerneldoc")
> has addressed some but not all kerneldoc warnings for the Global 2
> Scratch register accessors. Namely, we have some mismatches between
> the function names in the kerneldoc and the ones in the actual code.
> Let's adjust the comments so that they match the functions they're
> sitting next to.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
