Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC3D1F9C55
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 17:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbgFOPw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 11:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgFOPw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 11:52:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AD8C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 08:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=CJU1WBE7XqUEUojZeC3eWFb2noipA7E6MzEdTAZ8cpc=; b=s/qrrBWvem745zhwXKoFaX7xt2
        uJOxCogSKudKA/4cCulBwdVin5+JpMAEF5j/sx4Wg+hlcNXUzu3XLjGdX+qRBklHXjOeH+FME2nQ6
        Hr6tgQWbPBi6JzFmuYA8NMhPALXBVEBG0yA32LV3bKOrTIoBT/KSMAwqDuKjE01KGmcbJ9loOC3m7
        CRmw2LpgZAWabRssoYdFip0M98EAIvp8ELPCV5ia1VtmOMZ5vYPxV3PEIiO9boWstzlDZJIFmBSom
        xUfYBe8D1DbVCIjgHPW3M7UE+1apVuC++qLf0d0I4QuRgospB0HB7ys6WeEBTa0brctOcB0bhBGs9
        gsXAviRw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jkrPt-0000mE-PN; Mon, 15 Jun 2020 15:52:57 +0000
Subject: Re: [PATCH 1/5] Huawei BMA: Adding Huawei BMA driver: host_edma_drv
To:     yunaixin03610@163.com, netdev@vger.kernel.org
Cc:     yunaixin <yunaixin@huawei.com>
References: <20200615145906.1013-1-yunaixin03610@163.com>
 <20200615145906.1013-2-yunaixin03610@163.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0aaa651f-2b9e-074c-e815-75b7995376f7@infradead.org>
Date:   Mon, 15 Jun 2020 08:52:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615145906.1013-2-yunaixin03610@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/20 7:59 AM, yunaixin03610@163.com wrote:
> diff --git a/drivers/net/ethernet/huawei/bma/Kconfig b/drivers/net/ethernet/huawei/bma/Kconfig
> new file mode 100644
> index 000000000000..1a92c1dd83f3
> --- /dev/null
> +++ b/drivers/net/ethernet/huawei/bma/Kconfig
> @@ -0,0 +1 @@
> +source "drivers/net/ethernet/huawei/bma/edma_drv/Kconfig"
> \ No newline at end of file

Add newline.

> diff --git a/drivers/net/ethernet/huawei/bma/Makefile b/drivers/net/ethernet/huawei/bma/Makefile
> new file mode 100644
> index 000000000000..8f589f7986d6
> --- /dev/null
> +++ b/drivers/net/ethernet/huawei/bma/Makefile
> @@ -0,0 +1,5 @@
> +# 
> +# Makefile for BMA software driver
> +# 
> +
> +obj-$(CONFIG_BMA) += edma_drv/
> \ No newline at end of file

Add newline.

> diff --git a/drivers/net/ethernet/huawei/bma/edma_drv/Kconfig b/drivers/net/ethernet/huawei/bma/edma_drv/Kconfig
> new file mode 100644
> index 000000000000..97829c5487c2
> --- /dev/null
> +++ b/drivers/net/ethernet/huawei/bma/edma_drv/Kconfig
> @@ -0,0 +1,11 @@
> +#
> +# Huawei BMA software driver configuration
> +#
> +
> +config BMA
> +	tristate "Huawei BMA Software Communication Driver"
> +
> +	---help---

	help

> +	  This driver supports Huawei BMA Software. It is used 
> +	  to communication between Huawei BMA and BMC software.

	  to communicate

> +


-- 
~Randy

