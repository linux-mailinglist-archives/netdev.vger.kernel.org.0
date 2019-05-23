Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D128049
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbfEWOyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:54:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45136 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730752AbfEWOyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 10:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QsNRmpnjYf1hJO0vJAth46QB5G5/Hx/TJi5PoeQ3ZKE=; b=gnDHUvE0zYfVe/z+pFqNNld1Lg
        LFU1f7r1uQbzTxj5uh6S7jG65QicVcmNQ2tjUhDripR/Wdu3IwAQGSTVWu3HWfLLgf9uO6bYmgvuK
        /vQxUPYFYvqqQ/biLuaKgrMPlE7rzUfQvNlyA+TSlR3SM/w1zgZoS05GO7HZ8t0fW+/k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTp6n-00067V-HQ; Thu, 23 May 2019 16:54:17 +0200
Date:   Thu, 23 May 2019 16:54:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yash Shah <yash.shah@sifive.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, nicolas.ferre@microchip.com,
        palmer@sifive.com, aou@eecs.berkeley.edu, ynezz@true.cz,
        paul.walmsley@sifive.com, sachin.ghadi@sifive.com
Subject: Re: [PATCH 2/2] net: macb: Add support for SiFive FU540-C000
Message-ID: <20190523145417.GD19369@lunn.ch>
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
 <1558611952-13295-3-git-send-email-yash.shah@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558611952-13295-3-git-send-email-yash.shah@sifive.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int fu540_macb_tx_set_rate(struct clk_hw *hw, unsigned long rate,
> +				  unsigned long parent_rate)
> +{
> +	rate = fu540_macb_tx_round_rate(hw, rate, &parent_rate);
> +	iowrite32(rate != 125000000, mgmt->reg);

That looks odd. Writing the result of a comparison to a register?

     Andrew
