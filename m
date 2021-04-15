Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24393615C1
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbhDOW56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:57:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234949AbhDOW55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:57:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXAvR-00GyPK-Kl; Fri, 16 Apr 2021 00:57:29 +0200
Date:   Fri, 16 Apr 2021 00:57:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: phy: add genphy_c45_pma_suspend/resume
Message-ID: <YHjE2TsfLskNWVj9@lunn.ch>
References: <20210415092538.78398-1-radu-nicolae.pirea@oss.nxp.com>
 <20210415092538.78398-2-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415092538.78398-2-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 12:25:37PM +0300, Radu Pirea (NXP OSS) wrote:
> Add generic PMA suspend and resume callback functions for C45 PHYs.
> 
> Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
