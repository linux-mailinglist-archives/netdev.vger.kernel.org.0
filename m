Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A446C2D1EDA
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgLHAQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:16:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727330AbgLHAQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 19:16:14 -0500
Date:   Mon, 7 Dec 2020 16:15:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607386534;
        bh=iBHjuV31uGtt8jlL1eodDrZ9iRatja0EukFJFpSWcJA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Va1VG9UqqGxwzGX0+K2WudhywapqDL/tpIozuqjWnDB0iSXrU67t775WQKwW5nvAN
         LABQa1wcYkfE/34qzHTZ1hg5TRUbLIk+YWfeFgdTzL0k6A25Gov8FJ9cvgFo4Avoqm
         NEHzLU9fEq1stCVAlaYT3Qb219yeO2AR0BjfLAH2eN21WY5mu0bkU8m0jNC2whN2os
         7OUX9Y1zQCIkxduxJrRTIKMB/OcSuKG2xSHh1tWCFa8RZykMtxc5gL2AYNLq1HAY78
         KcUoio2Fry1HldDwuL8/xE80EiXkkcJpYLR/GSoq1hnasDdCuc+clC4pVBlXWyl4wy
         kG4AaAZSMtcfA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mickey Rachamim <mickeyr@marvell.com>
Cc:     "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>
Subject: Re: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera Ethernet
 Switch driver
Message-ID: <20201207161533.7f68fd7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205164300.28581-1-mickeyr@marvell.com>
References: <20201205164300.28581-1-mickeyr@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Dec 2020 18:43:00 +0200 Mickey Rachamim wrote:
> Add maintainers info for new Marvell Prestera Ethernet switch driver.
> 
> Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
> ---
> v2:
>  Update the maintainers list according to community recommendation.
> 
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 061e64b2423a..c92b44754436 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10550,6 +10550,14 @@ S:	Supported
>  F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
>  F:	drivers/net/ethernet/marvell/octeontx2/af/
>  
> +MARVELL PRESTERA ETHERNET SWITCH DRIVER
> +M:	Vadym Kochan <vkochan@marvell.com>
> +M:	Taras Chornyi <tchornyi@marvell.com>

Just a heads up, again, we'll start removing maintainers who aren't
participating, so Taras needs to be active. We haven't seen a single
email from him so far AFAICT.

> +L:	netdev@vger.kernel.org

nit: I don't think you need to list netdev, it'll get inherited from
the general entry for networking drivers (you can test running
get_maintainer.pl on a patch to the driver and see if it reports it).

> +S:	Supported
> +W:	http://www.marvell.com

The website entry is for a project-specific website. If you have a link
to a site with open resources about the chips/driver that'd be great,
otherwise please drop it. Also https is expected these days ;)

> +F:	drivers/net/ethernet/marvell/prestera/
> +
>  MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
>  M:	Nicolas Pitre <nico@fluxnic.net>
>  S:	Odd Fixes

