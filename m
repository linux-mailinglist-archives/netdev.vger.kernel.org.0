Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A00337D12
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhCKS6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhCKS6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 13:58:20 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537DFC061574;
        Thu, 11 Mar 2021 10:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=gs58FMZ4ZIcfp6tfvdbnTyV06IaEwhAIrr46llssbNY=; b=SmjiH2VQPT/IQ9vdX+mLbBABzW
        7nAGGw1kx3hP4G1deRuKlhGw/pDeioyLbtCldjJuk3WEKTdiP7x40NWrmv3qaWHzZw1M0KwK81cbW
        +x56KLo5eisidpJ669nOaSG90ryudnrK/rJLpY8jgbGPoylfB0x9iBeU+J8kk69/1h+TmOxdx/KBI
        CADghUQjLwN1d6SS78Z2F/okLD5sKPjHkoSq2EtMT+Sxuyv8z3Vumgv6Fd4Sn0+PnxkgSP6545qwy
        z3/UwAsw283xzKhmo0/Smg3a4lyjfRUUsEGVfx9kKSM9UXR+D8NVxkLs4iPwiBzUGTbQEIQg2gAOe
        tIH9mo/g==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKQVj-000xjJ-53; Thu, 11 Mar 2021 18:58:15 +0000
Subject: Re: [PATCH net-next v4 2/2] net: Add Qcom WWAN control driver
To:     Loic Poulain <loic.poulain@linaro.org>, kuba@kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, jhugo@codeaurora.org
References: <1615480746-28518-1-git-send-email-loic.poulain@linaro.org>
 <1615480746-28518-2-git-send-email-loic.poulain@linaro.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <bb73e0bf-1c30-89f7-a28d-4e51998eec9f@infradead.org>
Date:   Thu, 11 Mar 2021 10:58:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1615480746-28518-2-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/21 8:39 AM, Loic Poulain wrote:
> diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
> index b7d58b7..1e8ac0b 100644
> --- a/drivers/net/wwan/Kconfig
> +++ b/drivers/net/wwan/Kconfig
> @@ -16,4 +16,18 @@ config WWAN_CORE
>  	  Say Y here if you want to use the WWAN driver core. This driver
>  	  provides a common framework for WWAN drivers.
>  
> +config MHI_WWAN_CTRL
> +	tristate "MHI WWAN control driver for QCOM based PCIe modems"

	                                      QCOM-based

> +	select WWAN_CORE
> +	depends on MHI_BUS
> +	help
> +	  MHI WWAN CTRL allow QCOM based PCIe modems to expose different modem

	                allows QCOM-based

> +	  control protocols/ports to userspace, including AT, MBIM, QMI, DIAG
> +	  and FIREHOSE. These protocols can be accessed directly from userspace
> +	  (e.g. AT commands) or via libraries/tools (e.g. libmbim, libqmi,
> +	  libqcdm...).
> +
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called mhi_wwan_ctrl.
> +
>  endif # WWAN


-- 
~Randy

