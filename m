Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E84D352AB1
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhDBMgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:36:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60172 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhDBMgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 08:36:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lSJ2P-00EUvM-Ac; Fri, 02 Apr 2021 14:36:33 +0200
Date:   Fri, 2 Apr 2021 14:36:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 2/3] dpaa2-eth: add rx copybreak support
Message-ID: <YGcP0Uz5CfCwv5ev@lunn.ch>
References: <20210402095532.925929-1-ciorneiioana@gmail.com>
 <20210402095532.925929-3-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402095532.925929-3-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 12:55:31PM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> DMA unmapping, allocating a new buffer and DMA mapping it back on the
> refill path is really not that efficient. Proper buffer recycling (page
> pool, flipping the page and using the other half) cannot be done for
> DPAA2 since it's not a ring based controller but it rather deals with
> multiple queues which all get their buffers from the same buffer pool on
> Rx.
> 
> To circumvent these limitations, add support for Rx copybreak. For small
> sized packets instead of creating a skb around the buffer in which the
> frame was received, allocate a new sk buffer altogether, copy the
> contents of the frame and release the initial page back into the buffer
> pool.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
