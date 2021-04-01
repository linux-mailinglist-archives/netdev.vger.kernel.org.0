Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161D8352423
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbhDAXla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:41:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235847AbhDAXl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:41:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lS6wF-00EPsw-By; Fri, 02 Apr 2021 01:41:23 +0200
Date:   Fri, 2 Apr 2021 01:41:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 3/3] dpaa2-eth: export the rx copybreak value as
 an ethtool tunable
Message-ID: <YGZaIy14TA3prLPs@lunn.ch>
References: <20210401163956.766628-1-ciorneiioana@gmail.com>
 <20210401163956.766628-4-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401163956.766628-4-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 07:39:56PM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> It's useful, especially for debugging purposes, to have the Rx copybreak
> value changeable at runtime. Export it as an ethtool tunable.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
