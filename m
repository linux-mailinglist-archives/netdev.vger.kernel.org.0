Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EC02CD94C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgLCOgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:36:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730430AbgLCOgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 09:36:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkphi-00A385-BB; Thu, 03 Dec 2020 15:35:30 +0100
Date:   Thu, 3 Dec 2020 15:35:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: Add entry for Marvell Prestera Ethernet
 Switch driver
Message-ID: <20201203143530.GH2333853@lunn.ch>
References: <20201203100436.25630-1-mickeyr@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203100436.25630-1-mickeyr@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 12:04:36PM +0200, Mickey Rachamim wrote:
> Add maintainers info for new Marvell Prestera Ethernet switch driver.
> 
> Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a7bdebf955bb..04a27eb89428 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10540,6 +10540,15 @@ S:	Supported
>  F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
>  F:	drivers/net/ethernet/marvell/octeontx2/af/
>  
> +MARVELL PRESTERA ETHERNET SWITCH DRIVER
> +M:	Vadym Kochan <vkochan@marvell.com>

Hi Mickey

All the commits came from

Vadym Kochan <vadym.kochan@plvision.eu>

Has Marvell purchased PL Vision?

    Andrew
