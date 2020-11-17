Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6202B5718
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgKQCwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:52:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59282 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbgKQCwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 21:52:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ker6C-007STf-1M; Tue, 17 Nov 2020 03:52:04 +0100
Date:   Tue, 17 Nov 2020 03:52:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/3] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
Message-ID: <20201117025204.GK1752213@lunn.ch>
References: <20201114234558.31203-1-tobias@waldekranz.com>
 <20201114234558.31203-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114234558.31203-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 12:45:57AM +0100, Tobias Waldekranz wrote:
> Ethertype DSA encodes exactly the same information in the DSA tag as
> the non-ethertype variety. So refactor out the common parts and reuse
> them for both protocols.
> 
> This is ensures tag parsing and generation is always consistent across
> all mv88e6xxx chips.
> 
> While we are at it, explicitly deal with all possible CPU codes on
> receive, making sure to set offload_fwd_mark as appropriate.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
