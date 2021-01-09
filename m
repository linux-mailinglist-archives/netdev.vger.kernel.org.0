Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF5D2F03BC
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 22:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbhAIVLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 16:11:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbhAIVLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 16:11:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyLVt-00HAVJ-45; Sat, 09 Jan 2021 22:11:09 +0100
Date:   Sat, 9 Jan 2021 22:11:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 3/6] bus: fsl-mc: return -EPROBE_DEFER when a
 device is not yet discovered
Message-ID: <X/ob7cm/NOt5qnZ4@lunn.ch>
References: <20210108090727.866283-1-ciorneiioana@gmail.com>
 <20210108090727.866283-4-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108090727.866283-4-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 11:07:24AM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> The fsl_mc_get_endpoint() should return a pointer to the connected
> fsl_mc device, if there is one. By interrogating the MC firmware, we
> know if there is an endpoint or not so when the endpoint device is
> actually searched on the fsl-mc bus and not found we are hitting the
> case in which the device has not been yet discovered by the bus.
> 
> Return -EPROBE_DEFER so that callers can differentiate this case.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Acked-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
