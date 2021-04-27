Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED4136C633
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 14:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbhD0MmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 08:42:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43026 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhD0MmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 08:42:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbN1h-001MfR-Cf; Tue, 27 Apr 2021 14:41:17 +0200
Date:   Tue, 27 Apr 2021 14:41:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Fix 6095/6097/6185 ports
 in non-SERDES CMODE
Message-ID: <YIgGbYtJtq1EnIKD@lunn.ch>
References: <20210426161734.1735032-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426161734.1735032-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 06:17:34PM +0200, Tobias Waldekranz wrote:
> The .serdes_get_lane op used the magic value 0xff to indicate a valid
> SERDES lane and 0 signaled that a non-SERDES mode was set on the port.
> 
> Unfortunately, "0" is also a valid lane ID, so even when these ports
> where configured to e.g. RGMII the driver would set them up as SERDES
> ports.
> 
> - Replace 0xff with 0 to indicate a valid lane ID. The number is on
>   the one hand just as arbitrary, but it is at least the first valid one
>   and therefore less of a surprise.
> 
> - Follow the other .serdes_get_lane implementations and return -ENODEV
>   in the case where no SERDES is assigned to the port.
> 
> Fixes: f5be107c3338 ("net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
