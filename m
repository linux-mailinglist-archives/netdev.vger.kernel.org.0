Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6FA2EFC51
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbhAIArR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:47:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58332 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAIArR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:47:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ky2Ol-00Gzw3-4d; Sat, 09 Jan 2021 01:46:31 +0100
Date:   Sat, 9 Jan 2021 01:46:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: dsa_legacy_fdb_{add,del} can be static
Message-ID: <X/j85y8L6d8ALFRs@lunn.ch>
References: <20210108233054.1222278-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108233054.1222278-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 01:30:54AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Introduced in commit 37b8da1a3c68 ("net: dsa: Move FDB add/del
> implementation inside DSA") in net/dsa/legacy.c, these functions were
> moved again to slave.c as part of commit 2a93c1a3651f ("net: dsa: Allow
> compiling out legacy support"), before actually deleting net/dsa/slave.c
> in 93e86b3bc842 ("net: dsa: Remove legacy probing support"). Along with
> that movement there should have been a deletion of the prototypes from
> dsa_priv.h, they are not useful.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
