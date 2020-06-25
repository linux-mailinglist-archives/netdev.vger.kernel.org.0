Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8703220A34B
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406471AbgFYQqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:46:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60702 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390448AbgFYQql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 12:46:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joV1H-002ENV-Fl; Thu, 25 Jun 2020 18:46:35 +0200
Date:   Thu, 25 Jun 2020 18:46:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next 1/8] net: phy: mscc: macsec: fix sparse warnings
Message-ID: <20200625164635.GM442307@lunn.ch>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
 <20200625154211.606591-2-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625154211.606591-2-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 05:42:04PM +0200, Antoine Tenart wrote:
> This patch fixes the following sparse warnings when building MACsec
> support in the MSCC PHY driver.
> 
>   mscc_macsec.c:393:42: warning: cast from restricted sci_t
>   mscc_macsec.c:395:42: warning: restricted sci_t degrades to integer
>   mscc_macsec.c:402:42: warning: restricted __be16 degrades to integer
>   mscc_macsec.c:608:34: warning: cast from restricted sci_t
>   mscc_macsec.c:610:34: warning: restricted sci_t degrades to integer
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
