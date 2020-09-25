Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CDC278E94
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 18:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbgIYQbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 12:31:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55670 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727402AbgIYQbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 12:31:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLqcy-00GBSq-CK; Fri, 25 Sep 2020 18:31:20 +0200
Date:   Fri, 25 Sep 2020 18:31:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] dpaa2-mac: do not check for both child and
 parent DTS nodes
Message-ID: <20200925163120.GC3856392@lunn.ch>
References: <20200925144421.7811-1-ioana.ciornei@nxp.com>
 <20200925144421.7811-2-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925144421.7811-2-ioana.ciornei@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 05:44:19PM +0300, Ioana Ciornei wrote:
> There is no need to check if both the MDIO controller node and its
> child node, the PCS device, are available since there is no chance that
> the child node would be enabled when the parent it's not.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
