Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD0135A730
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234861AbhDITgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:36:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43168 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhDITgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:36:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUwvN-00FqyA-U9; Fri, 09 Apr 2021 21:36:13 +0200
Date:   Fri, 9 Apr 2021 21:36:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
Message-ID: <YHCsrVNcZmeTPJzW@lunn.ch>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 09:41:06PM +0300, Radu Pirea (NXP OSS) wrote:
> Add driver for tja1103 driver and for future NXP C45 PHYs.

So apart from c45 vs c22, how does this differ to nxp-tja11xx.c?

Do we really want two different drivers for the same hardware? 
Can we combine them somehow?

> +config NXP_C45_PHY
> +	tristate "NXP C45 PHYs"

This is also very vague. So in the future it will support PHYs other
than the TJA series?

     Andrew
