Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0086368025
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbhDVMTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:19:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235232AbhDVMTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 08:19:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZYIM-000Uj3-4U; Thu, 22 Apr 2021 14:18:58 +0200
Date:   Thu, 22 Apr 2021 14:18:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 05/14] net: ethernet: mtk_eth_soc: reduce MDIO
 bus access latency
Message-ID: <YIFpsjiqhqEeVXNd@lunn.ch>
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
 <20210422040914.47788-6-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422040914.47788-6-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 09:09:05PM -0700, Ilya Lipnitskiy wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> usleep_range often ends up sleeping much longer than the 10-20us provided
> as a range here. This causes significant latency in mdio bus acceses,

I found the same with the FEC driver, and make the same change.

> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> [Ilya: use readx_poll_timeout_atomic instead of cond_resched]
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>


Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
