Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4679F36966C
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 17:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243038AbhDWPys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 11:54:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231409AbhDWPyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 11:54:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZy83-000gYO-Td; Fri, 23 Apr 2021 17:54:03 +0200
Date:   Fri, 23 Apr 2021 17:54:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] phy: nxp-c45-tja11xx: add interrupt support
Message-ID: <YILtm2zWrf2RpJlF@lunn.ch>
References: <20210423150050.1037224-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423150050.1037224-1-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 06:00:50PM +0300, Radu Pirea (NXP OSS) wrote:
> Added .config_intr and .handle_interrupt callbacks.
> 
> Link event interrupt will trigger an interrupt every time when the link
> goes up or down.
> 
> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
