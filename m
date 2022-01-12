Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFC648CBA7
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356782AbiALTNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:13:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356769AbiALTLX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 14:11:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=V3MklzZNdawzVK+oVASgZ9JYoB5WDQelZ8fP9c6dJ7Y=; b=M26jxjwLTk+pRxB2OLICzHfnzu
        kPVYzK5u0Za0a4fxmNVvJmNvDEkUnI5Fx+kKmLA+GKkFn0Rpyxr+7VdJQm+c0glRugg5Sc7a2YA9s
        cpxQmOgp8L2/egQ5PUC+VpAUwq9Tve+qTd/o6ieaj9GREkfAmrttdHq/ldfEZuWwzrOM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7j1i-001E2s-DY; Wed, 12 Jan 2022 20:11:18 +0100
Date:   Wed, 12 Jan 2022 20:11:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, michal.simek@xilinx.com,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net
Subject: Re: [PATCH net v2 1/9] net: axienet: increase reset timeout
Message-ID: <Yd8n1vjj7G0xga5U@lunn.ch>
References: <20220112173700.873002-1-robert.hancock@calian.com>
 <20220112173700.873002-2-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112173700.873002-2-robert.hancock@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 11:36:52AM -0600, Robert Hancock wrote:
> The previous timeout of 1ms was too short to handle some cases where the
> core is reset just after the input clocks were started, which will
> be introduced in an upcoming patch. Increase the timeout to 50ms. Also
> simplify the reset timeout checking to use read_poll_timeout.
> 
> Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
