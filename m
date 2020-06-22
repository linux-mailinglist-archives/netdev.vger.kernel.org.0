Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECF4203CBD
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgFVQlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbgFVQlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:41:02 -0400
X-Greylist: delayed 86 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 Jun 2020 09:41:02 PDT
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF92C061573;
        Mon, 22 Jun 2020 09:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=CdQdTcqcpxTuMRJFfroOoj3zoQHg++YuZPXbDaqaBOQ=; b=Odh/W2Cdx7zhXT3UbuSk0oAGDR
        ucP6i6wR46yU7ov33C0Ahcid/UkGPM08Pr4jBwbfyikUo8xMkSDC+pDv/t3V1ZAMZxH1MeYzrVXZY
        GlkfZuZOTSzKvAcvRnNEGw0mwm7yRtS9lT6RudU9h7gqP/e0ZCF2KsXy2i8la0S5iPJ9wdagp3MYA
        mnKC9Oecf7bs0n9L18a3112iIz69HNKbGa25fwEf2mGyW41vguvHZC7aztXtNj5srFpCjFq30+Gil
        w2numkZegyWfr/P9o95U0uU+e8m53RRT7bT4GP7sX2Ba9XYT0X2k6mFOSCW0rYRMTXnPmJPQN9Stt
        usZS+Anw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnPUz-0007gX-VZ; Mon, 22 Jun 2020 16:40:46 +0000
Subject: Re: [PATCH 2/5] Huawei BMA: Adding Huawei BMA driver: host_cdev_drv
To:     yunaixin03610@163.com, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, wuguanping@huawei.com,
        wangqindong@huawei.com
References: <20200622160311.1533-1-yunaixin03610@163.com>
 <20200622160311.1533-3-yunaixin03610@163.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <dbf29039-ec7d-a652-3b91-6c353cce2e00@infradead.org>
Date:   Mon, 22 Jun 2020 09:40:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622160311.1533-3-yunaixin03610@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/20 9:03 AM, yunaixin03610@163.com wrote:
> diff --git a/drivers/net/ethernet/huawei/bma/Makefile b/drivers/net/ethernet/huawei/bma/Makefile
> index 8582fb3998fb..c9bbcbf2a388 100644
> --- a/drivers/net/ethernet/huawei/bma/Makefile
> +++ b/drivers/net/ethernet/huawei/bma/Makefile
> @@ -3,3 +3,4 @@
>  # 
>  
>  obj-$(CONFIG_BMA) += edma_drv/
> +obj-$(CONFIG_BMA) += cdev_drv/
> \ No newline at end of file

Please fix the "No newline" warning.

> diff --git a/drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig b/drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig
> new file mode 100644
> index 000000000000..97829c5487c2
> --- /dev/null
> +++ b/drivers/net/ethernet/huawei/bma/cdev_drv/Kconfig
> @@ -0,0 +1,11 @@
> +#
> +# Huawei BMA software driver configuration
> +#
> +
> +config BMA
> +	tristate "Huawei BMA Software Communication Driver"
> +
> +	---help---

Just use
	help

> +	  This driver supports Huawei BMA Software. It is used 
> +	  to communication between Huawei BMA and BMC software.
> +


-- 
~Randy

