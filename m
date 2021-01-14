Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05C2F64F6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 16:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbhANPp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 10:45:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727335AbhANPp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 10:45:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l04nc-000a2B-Qo; Thu, 14 Jan 2021 16:44:36 +0100
Date:   Thu, 14 Jan 2021 16:44:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org
Subject: Re: [PATCH net-next] net: mvpp2: extend mib-fragments name to
 mib-fragments-err
Message-ID: <YABm5PDi94I5VKQp@lunn.ch>
References: <1610618858-5093-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610618858-5093-1-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 12:07:38PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> This patch doesn't change any functionality, but just extend
> MIB counter register and ethtool-statistic names with "err".
> 
> The counter MVPP2_MIB_FRAGMENTS_RCVD in fact is Error counter.
> Extend REG name and appropriated ethtool statistic reg-name
> with the ERR/err.

> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -1566,7 +1566,7 @@ static u32 mvpp2_read_index(struct mvpp2 *priv, u32 index, u32 reg)
>  	{ MVPP2_MIB_FC_RCVD, "fc_received" },
>  	{ MVPP2_MIB_RX_FIFO_OVERRUN, "rx_fifo_overrun" },
>  	{ MVPP2_MIB_UNDERSIZE_RCVD, "undersize_received" },
> -	{ MVPP2_MIB_FRAGMENTS_RCVD, "fragments_received" },
> +	{ MVPP2_MIB_FRAGMENTS_ERR_RCVD, "fragments_err_received" },

Hi Stefan

I suspect this is now ABI and you cannot change it. You at least need
to argue why it is not ABI.

  Andrew
