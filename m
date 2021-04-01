Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8860E352424
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhDAXmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:42:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59490 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233789AbhDAXmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:42:52 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lS6xd-00EPu7-5E; Fri, 02 Apr 2021 01:42:49 +0200
Date:   Fri, 2 Apr 2021 01:42:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 1/3] dpaa2-eth: rename dpaa2_eth_xdp_release_buf
 into dpaa2_eth_recycle_buf
Message-ID: <YGZaeYav5oP8Sbc6@lunn.ch>
References: <20210401163956.766628-1-ciorneiioana@gmail.com>
 <20210401163956.766628-2-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401163956.766628-2-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 07:39:54PM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Rename the dpaa2_eth_xdp_release_buf function into dpaa2_eth_recycle_buf
> since in the next patches we'll be using the same recycle mechanism for
> the normal stack path beside for XDP_DROP.
> 
> Also, rename the array which holds the buffers to be recycled so that it
> does not have any reference to XDP.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
