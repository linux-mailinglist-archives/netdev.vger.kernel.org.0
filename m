Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2127F2CED6D
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgLDLr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727319AbgLDLrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 06:47:25 -0500
Date:   Fri, 4 Dec 2020 12:48:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607082405;
        bh=F+/ErHovTdtUsCMpIvEKrgPVJOpwVez3+Uw4pVqQnXM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=lCi+qOLQegcb1zS0cQxC6f3qalRxPBxOGNFLeqnQnpnhL8KrPTeDz11jk5YYAG4YW
         ODrdlMvx89SV4f6XpOJUwGwjthd3ygdvOwVXN/TdFeG/yxZj1ATvi8gOlYXt7lO1iZ
         DPPoLdfHnWsVA+fm38acp7krMijKmzrgSEtaDY+k=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     broonie@kernel.org, lgirdwood@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jgg@nvidia.com,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] driver core: auxiliary bus: minor coding style tweaks
Message-ID: <X8oh8SCN0D2aF08t@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <X8og8xi3WkoYXet9@kroah.com>
 <X8ohB1ks1NK7kPop@kroah.com>
 <X8ohGE8IBKiafzka@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8ohGE8IBKiafzka@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 12:44:24PM +0100, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> For some reason, the original aux bus patch had some really long lines
> in a few places, probably due to it being a very long-lived patch in
> development by many different people.  Fix that up so that the two files
> all have the same length lines and function formatting styles.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/base/Kconfig     |  2 +-
>  drivers/base/auxiliary.c | 58 ++++++++++++++++++++++------------------
>  2 files changed, 33 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 040be48ce046..ba52b2c40202 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -2,7 +2,7 @@
>  menu "Generic Driver Options"
>  
>  config AUXILIARY_BUS
> -	bool
> +	tristate "aux bus!"
>  
>  config UEVENT_HELPER
>  	bool "Support for uevent helper"

Argh, wrong version of this patch, this was added locally for me to test
with, let me fix up and resend a v2 of this patch.

thanks,

greg k-h
