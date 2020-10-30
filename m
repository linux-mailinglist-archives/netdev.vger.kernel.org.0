Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5262B29FD6C
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 06:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgJ3Fsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 01:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgJ3Fsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 01:48:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938C6C0613D4;
        Thu, 29 Oct 2020 22:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=C8nOGEB9+7gSvITmKEcodA3o6SzFPOIfJZ7sTsW9pwY=; b=gl8xCFEB4IfN/X6awW1jnfXbYK
        zOW4ZE0DLQFQG/4nHnjgqGty7LROKhwC2uHg03SquKFh3pRbqGBVHvlmV3R+OeQrH1+P7rvfWPZBn
        hl/cy085Li5NB7hfS8RENSZYfil3mY4SXu8qLM/ivHga2ov9s3SsxjvsALAx2QiZMSs1muYrpMsUc
        OGbEcQY67dSBR5011BQHMu0Rsoq0yH9FngVE2d/nsDuMZw8bcylbn+8ZRp1Ibdr8MMuZ6GGLdBjWS
        3p7TRIsHM+R2hkSrcQ0GX/AZitZY6JZWYvGOLQIlIoZRnRKRJInjRJkblOqMRxHbVBfZub0TNzdP9
        yqgqtvQA==;
Received: from [2601:1c0:6280:3f0::371c]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYNH8-0000AK-WD; Fri, 30 Oct 2020 05:48:35 +0000
Subject: Re: [PATCH v11 4/4] bus: mhi: Add userspace client interface driver
To:     Hemant Kumar <hemantk@codeaurora.org>,
        manivannan.sadhasivam@linaro.org, gregkh@linuxfoundation.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhugo@codeaurora.org, bbhatt@codeaurora.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org
References: <1604025946-28288-1-git-send-email-hemantk@codeaurora.org>
 <1604025946-28288-5-git-send-email-hemantk@codeaurora.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <88077bd6-be17-d88a-2959-9ea249614019@infradead.org>
Date:   Thu, 29 Oct 2020 22:48:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1604025946-28288-5-git-send-email-hemantk@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/20 7:45 PM, Hemant Kumar wrote:
> diff --git a/drivers/bus/mhi/Kconfig b/drivers/bus/mhi/Kconfig
> index e841c10..476cc55 100644
> --- a/drivers/bus/mhi/Kconfig
> +++ b/drivers/bus/mhi/Kconfig
> @@ -20,3 +20,16 @@ config MHI_BUS_DEBUG
>  	  Enable debugfs support for use with the MHI transport. Allows
>  	  reading and/or modifying some values within the MHI controller
>  	  for debug and test purposes.
> +
> +config MHI_UCI
> +	tristate "MHI UCI"
> +	depends on MHI_BUS
> +	help
> +	  MHI based Userspace Client Interface (UCI) driver is used for

	  MHI-based

> +	  transferring raw data between host and device using standard file
> +	  operations from userspace. Open, read, write, and close operations
> +	  are supported by this driver. Please check mhi_uci_match_table for

also poll according to the documentation.

> +	  all supported channels that are exposed to userspace.
> +
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called mhi_uci.


-- 
~Randy

