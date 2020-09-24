Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC2A27755E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgIXPcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:32:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53372 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbgIXPcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 11:32:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kLTEL-00G2h5-NE; Thu, 24 Sep 2020 17:32:21 +0200
Date:   Thu, 24 Sep 2020 17:32:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jamie Iles <jamie@nuviainc.com>
Cc:     netdev@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: Re: [PATCH] net/fsl: quieten expected MDIO access failures
Message-ID: <20200924153221.GB3821492@lunn.ch>
References: <20200924145645.1789724-1-jamie@nuviainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924145645.1789724-1-jamie@nuviainc.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 03:56:45PM +0100, Jamie Iles wrote:
> MDIO reads can happen during PHY probing, and printing an error with
> dev_err can result in a large number of error messages during device
> probe.  On a platform with a serial console this can result in
> excessively long boot times in a way that looks like an infinite loop
> when multiple busses are present.  Since 0f183fd151c (net/fsl: enable
> extended scanning in xgmac_mdio) we perform more scanning so there are
> potentially more failures.
> 
> Reduce the logging level to dev_dbg which is consistent with the
> Freescale enetc driver.
> 
> Cc: Jeremy Linton <jeremy.linton@arm.com>
> Signed-off-by: Jamie Iles <jamie@nuviainc.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
