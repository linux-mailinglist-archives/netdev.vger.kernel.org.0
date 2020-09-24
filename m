Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0B427659F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgIXBH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:07:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52288 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726681AbgIXBH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 21:07:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLFjH-00FxEx-4Z; Thu, 24 Sep 2020 03:07:23 +0200
Date:   Thu, 24 Sep 2020 03:07:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v2 1/3] net: pcs-lynx: add support for 10GBASER
Message-ID: <20200924010723.GG3770354@lunn.ch>
References: <20200923154123.636-1-ioana.ciornei@nxp.com>
 <20200923154123.636-2-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923154123.636-2-ioana.ciornei@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 06:41:21PM +0300, Ioana Ciornei wrote:
> Add support in the Lynx PCS module for the 10GBASE-R mode which is only
> used to get the link state, since it offers a single fixed speed.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
