Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8E63478A4
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 13:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhCXMi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 08:38:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234072AbhCXMid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 08:38:33 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lP2mF-00CmDv-4d; Wed, 24 Mar 2021 13:38:23 +0100
Date:   Wed, 24 Mar 2021 13:38:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: axienet: allow setups without MDIO
Message-ID: <YFsyv3FZlz+Tah9s@lunn.ch>
References: <20210324094855.1604778-1-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324094855.1604778-1-daniel@zonque.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 10:48:55AM +0100, Daniel Mack wrote:
> In setups with fixed-link settings on the hardware bus there is no mdio node
> in DTS. axienet_probe() already handles that gracefully but lp->mii_bus is
> then NULL.
> 
> Fix code that tries to blindly grab the MDIO lock by introducing two helper
> functions that make the locking conditional.

Hi Danial

What about axienet_dma_err_handler()?

     Andrew
