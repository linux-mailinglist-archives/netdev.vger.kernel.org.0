Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061E5203CC9
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgFVQnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbgFVQnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:43:21 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4126C061573;
        Mon, 22 Jun 2020 09:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=CaWTfYYdh6pgg+kLLYceaxurrT4fdWAXB5VzJ6H/HiY=; b=P2K7//hF5X8GRKGgwW+CrGu9PQ
        8PNkj2zc+d53x14aH4UACX4ayn/1LH4vyXz++oUmlOfXaWiRhP/LXZe/fQRX6zXLnlFIdTC9BfoM4
        c/x1xMnQZ2378YnXhtPHacHNr6pqum23NPrJbZZtO+cP8/TIsARCI+iTtTFyqGdlkclbvQAk40Add
        eyBkRcMnG+VzCG9lX756znLjB3MAMUxCaEs9XmH64xCTVly8Buca0nlg0/PFsiEjmqBhcnUrhM0YM
        chsk7a11HgtmExEUcXUVms8rZzYDQ7FqoeG6FFh6OmkqLUK3gO5yh4VTjXFZIXMHKCcXRrsH2NV6L
        NYRDSqhw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnPXE-0007n0-BS; Mon, 22 Jun 2020 16:43:04 +0000
Subject: Re: [PATCH 4/5] Huawei BMA: Adding Huawei BMA driver: cdev_veth_drv
To:     yunaixin03610@163.com, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, wuguanping@huawei.com,
        wangqindong@huawei.com
References: <20200622160311.1533-1-yunaixin03610@163.com>
 <20200622160311.1533-5-yunaixin03610@163.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5a1badbb-19f7-09b5-0bb6-c2624e227b80@infradead.org>
Date:   Mon, 22 Jun 2020 09:43:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622160311.1533-5-yunaixin03610@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/20 9:03 AM, yunaixin03610@163.com wrote:
> diff --git a/drivers/net/ethernet/huawei/bma/Makefile b/drivers/net/ethernet/huawei/bma/Makefile
> index e6e46d820082..c626618f47fb 100644
> --- a/drivers/net/ethernet/huawei/bma/Makefile
> +++ b/drivers/net/ethernet/huawei/bma/Makefile
> @@ -5,3 +5,4 @@
>  obj-$(CONFIG_BMA) += edma_drv/
>  obj-$(CONFIG_BMA) += cdev_drv/
>  obj-$(CONFIG_BMA) += veth_drv/
> +obj-$(CONFIG_BMA) += cdev_veth_drv/
> \ No newline at end of file

Please fix the "No newline" warning.

> diff --git a/drivers/net/ethernet/huawei/bma/cdev_veth_drv/Kconfig b/drivers/net/ethernet/huawei/bma/cdev_veth_drv/Kconfig
> new file mode 100644
> index 000000000000..97829c5487c2
> --- /dev/null
> +++ b/drivers/net/ethernet/huawei/bma/cdev_veth_drv/Kconfig
> @@ -0,0 +1,11 @@
> +#
> +# Huawei BMA software driver configuration
> +#
> +
> +config BMA
> +	tristate "Huawei BMA Software Communication Driver"
> +
> +	---help---

Juse use
	help

> +	  This driver supports Huawei BMA Software. It is used 
> +	  to communication between Huawei BMA and BMC software.
> +


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
