Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779212F03B9
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 22:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbhAIVL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 16:11:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbhAIVL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 16:11:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyLVQ-00HAUi-J2; Sat, 09 Jan 2021 22:10:40 +0100
Date:   Sat, 9 Jan 2021 22:10:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2 4/6] dpaa2-eth: retry the probe when the MAC
 is not yet discovered on the bus
Message-ID: <X/ob0GWVJvlKXsHy@lunn.ch>
References: <20210108090727.866283-1-ciorneiioana@gmail.com>
 <20210108090727.866283-5-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108090727.866283-5-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 11:07:25AM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> The fsl_mc_get_endpoint() function now returns -EPROBE_DEFER when the
> dpmac device was not yet discovered by the fsl-mc bus. When this
> happens, pass the error code up so that we can retry the probe at a
> later time.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
