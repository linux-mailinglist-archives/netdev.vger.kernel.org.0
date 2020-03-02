Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DEE1763F5
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbgCBTaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:30:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbgCBT37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 14:29:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E36221475D52E;
        Mon,  2 Mar 2020 11:29:58 -0800 (PST)
Date:   Mon, 02 Mar 2020 11:29:58 -0800 (PST)
Message-Id: <20200302.112958.1038288292834637833.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo@kernel.org, dsahern@gmail.com, toke@toke.dk,
        saeedm@mellanox.com, tariqt@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, thomas.petazzoni@bootlin.com
Subject: Re: [net-next PATCH] mvneta: add XDP ethtool errors stats for TX
 to driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158315678810.1983667.11239367181663328821.stgit@firesoul>
References: <158315678810.1983667.11239367181663328821.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Mar 2020 11:29:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Mon, 02 Mar 2020 14:46:28 +0100

> Adding ethtool stats for when XDP transmitted packets overrun the TX
> queue. This is recorded separately for XDP_TX and ndo_xdp_xmit. This
> is an important aid for troubleshooting XDP based setups.
> 
> It is currently a known weakness and property of XDP that there isn't
> any push-back or congestion feedback when transmitting frames via XDP.
> It's easy to realise when redirecting from a higher speed link into a
> slower speed link, or simply two ingress links into a single egress.
> The situation can also happen when Ethernet flow control is active.
> 
> For testing the patch and provoking the situation to occur on my
> Espressobin board, I configured the TX-queue to be smaller (434) than
> RX-queue (512) and overload network with large MTU size frames (as a
> larger frame takes longer to transmit).
> 
> Hopefully the upcoming XDP TX hook can be extended to provide insight
> into these TX queue overflows, to allow programmable adaptation
> strategies.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied, thanks Jesper.
