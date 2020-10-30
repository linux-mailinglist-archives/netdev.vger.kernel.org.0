Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AB62A0F69
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgJ3U0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:26:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgJ3U0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 16:26:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYayJ-004PXA-HK; Fri, 30 Oct 2020 21:26:03 +0100
Date:   Fri, 30 Oct 2020 21:26:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH v3 2/3] net: ftgmac100: add handling of mdio/phy nodes
 for ast2400/2500
Message-ID: <20201030202603.GH1042051@lunn.ch>
References: <20201030133707.12099-1-i.mikhaylov@yadro.com>
 <20201030133707.12099-3-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030133707.12099-3-i.mikhaylov@yadro.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 04:37:06PM +0300, Ivan Mikhaylov wrote:
> phy-handle can't be handled well for ast2400/2500 which has an embedded
> MDIO controller. Add ftgmac100_mdio_setup for ast2400/2500 and initialize
> PHYs from mdio child node with of_mdiobus_register.
> 
> Signed-off-by: Ivan Mikhaylov <i.mikhaylov@yadro.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
