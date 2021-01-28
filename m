Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6984E3068DA
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhA1Axj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:53:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhA1Axb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:53:31 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4vYG-002wyO-1Z; Thu, 28 Jan 2021 01:52:48 +0100
Date:   Thu, 28 Jan 2021 01:52:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 3/4] Revert "net: Have netpoll bring-up DSA
 management interface"
Message-ID: <YBIK4D10bXnBzUBy@lunn.ch>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <20210127010028.1619443-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127010028.1619443-4-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 03:00:27AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This reverts commit 1532b9778478577152201adbafa7738b1e844868.
> 
> The above commit is good and it works, however it was meant as a bugfix
> for stable kernels and now we have more self-contained ways in DSA to
> handle the situation where the DSA master must be brought up.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
