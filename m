Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066BA3616C4
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 02:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbhDPA2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 20:28:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234716AbhDPA2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 20:28:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXCKr-00GzPZ-Ea; Fri, 16 Apr 2021 02:27:49 +0200
Date:   Fri, 16 Apr 2021 02:27:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next,v2] net: ethernet: mediatek: ppe: fix busy wait
 loop
Message-ID: <YHjaBWdMzrhajq2Q@lunn.ch>
References: <YHjH3DxteZrID2hW@lunn.ch>
 <20210416001148.333969-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416001148.333969-1-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 05:11:48PM -0700, Ilya Lipnitskiy wrote:
> The intention is for the loop to timeout if the body does not succeed.
> The current logic calls time_is_before_jiffies(timeout) which is false
> until after the timeout, so the loop body never executes.
> 
> Fix by using readl_poll_timeout as a more standard and less error-prone
> solution.
> 
> Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> Cc: Felix Fietkau <nbd@nbd.name>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
