Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2CF3379F8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCKQtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhCKQss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:48:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D839164FCE;
        Thu, 11 Mar 2021 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615481327;
        bh=jL91dOaGVs4bBrezrwlrOsn3W2DczOQxqXnEvntgwy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IhnaPH0+58zsiwIQcvQSpGw441wzOzLBYehbD+aO9SfoPDy9xWi3Xy+ZHesFoRBL+
         8wHq4l+XkOw7zJCI/dr1h1u6zYQ66sv4EtOyNVuO4rNvu3Qsic5/MgFW7vItFq5pMp
         cX1nfbyuCH4cbSYNEHNgakKi84yCAs9FUJT8caB8=
Date:   Thu, 11 Mar 2021 17:48:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, jhugo@codeaurora.org
Subject: Re: [PATCH net-next v4 1/2] net: Add a WWAN subsystem
Message-ID: <YEpJ7Gf9IyDiMtR+@kroah.com>
References: <1615480746-28518-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615480746-28518-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 05:39:05PM +0100, Loic Poulain wrote:
> --- /dev/null
> +++ b/drivers/net/wwan/Kconfig
> @@ -0,0 +1,19 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Wireless WAN device configuration
> +#
> +
> +menuconfig WWAN
> +	bool "Wireless WAN"
> +	help
> +	  This section contains Wireless WAN driver configurations.
> +
> +if WWAN
> +
> +config WWAN_CORE
> +	tristate "WWAN Driver Core"
> +	help
> +	  Say Y here if you want to use the WWAN driver core. This driver
> +	  provides a common framework for WWAN drivers.

module name if chosen?

thanks,

greg k-h
