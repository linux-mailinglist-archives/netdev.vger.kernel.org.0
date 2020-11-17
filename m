Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491E52B570F
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgKQCtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:49:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59258 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgKQCtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 21:49:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ker3o-007SRm-N0; Tue, 17 Nov 2020 03:49:36 +0100
Date:   Tue, 17 Nov 2020 03:49:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 1/3] net: dsa: tag_dsa: Allow forwarding of
 redirected IGMP traffic
Message-ID: <20201117024936.GI1752213@lunn.ch>
References: <20201114234558.31203-1-tobias@waldekranz.com>
 <20201114234558.31203-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114234558.31203-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 12:45:56AM +0100, Tobias Waldekranz wrote:
> When receiving an IGMP/MLD frame with a TO_CPU tag, the switch has not
> performed any forwarding of it. This means that we should not set the
> offload_fwd_mark on the skb, in case a software bridge wants it
> forwarded.
> 
> This is a port of:
> 
> 1ed9ec9b08ad ("dsa: Allow forwarding of redirected IGMP traffic")
> 
> Which corrected the issue for chips using EDSA tags, but not for those
> using regular DSA tags.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
