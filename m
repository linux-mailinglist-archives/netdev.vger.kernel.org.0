Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7A516273C
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 14:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgBRNju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 08:39:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51560 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgBRNju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 08:39:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZvM5SJLfCygy+dxNwz0/A0b6jQXOvJ0xzPs0cBdmSKg=; b=LAIeX56UO8rWJZdbAF65v0ChM9
        9v/9mznqO6FhMXCCC8zRD03rRzca9/LhSLn8DD/hUXhshfgL8pD/Gy0jUNx5pVNDy05NqO1J0YeKK
        T28hKdeVK/xUxvAEZY1IOahF3P0wJIX7AK18Tfvtf2wG10uZ7mxaINzzZLPbVFcQg3JM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j436F-0002mI-L1; Tue, 18 Feb 2020 14:39:43 +0100
Date:   Tue, 18 Feb 2020 14:39:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Esben Haabendal <esben@geanix.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Subject: Re: [PATCH 8/8] net: ll_temac: Add ethtool support for coalesce
 parameters
Message-ID: <20200218133943.GA10541@lunn.ch>
References: <20200218082741.7710-1-esben@geanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218082741.7710-1-esben@geanix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Esben

> +	if (ec->tx_coalesce_usecs)
> +		lp->coalesce_delay_tx =
> +			min(255U, (ec->tx_coalesce_usecs * 100) / 512);
> +
> +	pr_info("%d -> %d  %d -> %d\n",
> +		ec->rx_coalesce_usecs, lp->coalesce_delay_rx,
> +		ec->tx_coalesce_usecs, lp->coalesce_delay_tx);

I guess this is left over from debug? You don't actually want it here?

  Andrew
