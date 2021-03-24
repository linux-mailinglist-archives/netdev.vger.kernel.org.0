Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A90348105
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237729AbhCXSzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbhCXSzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:55:05 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26188C061763;
        Wed, 24 Mar 2021 11:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=c3auAjmZMCQ6FyOffUwC94I5nfuI0sgf1bNCB1g+jl0=; b=Bqk+BHe9Sx8gCO+9mYCg0thvtl
        n/b0E4QLrlzO0rXyZYcRyrDiiQ1DeRnTLcZ5OQ0AiMPOwkJhIYVnpegr4ftqeXNJxwtKCak43YAWC
        p4SN8pgzjUU/WP7gAn1ZM5UTYBZJXiPrQ+mOGcHoSiTOTAAn0DAFGF9zoA1a+Gv23A5is9mgwqA3h
        FmGiKeNqM4VPjuXRzRWsd0WrUXsKvmv2uF8+l1IGpL0YhnUjCSWp81vxF96ndqOSPcF7dMrcJIYrh
        g8NWBhK/70H7gBRq0EB5Scsp3HQGKK3ubmMEQzsv16+9vDZ93vTvzIKxSumBaZ4Xs0Nc9EjSWVghG
        fpQGF2EA==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP8ej-0005O2-LQ; Wed, 24 Mar 2021 18:55:02 +0000
Subject: Re: [PATCH v2 22/23] RDMA/irdma: Add irdma Kconfig/Makefile and
 remove i40iw
To:     Shiraz Saleem <shiraz.saleem@intel.com>, dledford@redhat.com,
        jgg@nvidia.com, kuba@kernel.org, davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-23-shiraz.saleem@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7fdf6b17-064c-e438-c5c5-6cd6218ee1bd@infradead.org>
Date:   Wed, 24 Mar 2021 11:54:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210324000007.1450-23-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/21 5:00 PM, Shiraz Saleem wrote:
> diff --git a/drivers/infiniband/hw/irdma/Kconfig b/drivers/infiniband/hw/irdma/Kconfig
> new file mode 100644
> index 00000000..6585842
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/Kconfig
> @@ -0,0 +1,11 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +config INFINIBAND_IRDMA
> +	tristate "Intel(R) Ethernet Protocol Driver for RDMA"
> +	depends on INET
> +	depends on IPV6 || !IPV6
> +	depends on PCI
> +	select GENERIC_ALLOCATOR
> +	select CONFIG_AUXILIARY_BUS
> +	help
> +	 This is an Intel(R) Ethernet Protocol Driver for RDMA driver
> +	 that support E810 (iWARP/RoCE) and X722 (iWARP) network devices.


<pseudo bot>

Please follow coding-style for Kconfig files:

from Documentation/process/coding-style.rst, section 10):

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different.  Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces.


thanks.
-- 
~Randy

