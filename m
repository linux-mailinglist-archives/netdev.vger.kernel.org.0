Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D73365F09
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhDTSKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbhDTSKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:10:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7091DC06138A;
        Tue, 20 Apr 2021 11:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=XKyAAnXa+AAtAAiAcYGKXm97C3Mnk3mRV8T3Uf0k5SQ=; b=MqwtAKWqDwasGHWepcp/np9mz9
        +q0FSAm1hURJ6otOAazoCKmGLQ0FyifDF7jEoF0zQgWjjgu5V+VwBg0rd/2l+vYhKfp6klLeAU0V1
        /aFIOmbjtM7kSlESU6NQ2GWZnzWtnVvwlSsOcqoONokXbnzZN6tUfEuyAg93pI7SN+mA8YeImsQaU
        HtJWngop7zFFfiqkYKKus3e31CKzTsX2Vv8xMEqRe8OPp1fLvC9ni4MluHZ14POH0mjxPlAVz6BY0
        w9IyeUdtSV/jw/lZ/2DL119FN58W/b1GIDkECC+7o3scp8sttqaN5DdLVrx1VhtGQUVUbVs0mldrx
        wZ2aA0nA==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYunK-00FTpS-Vl; Tue, 20 Apr 2021 18:08:34 +0000
Subject: Re: [PATCH V2 16/16] net: iosm: infrastructure
To:     M Chetan Kumar <m.chetan.kumar@intel.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
 <20210420161310.16189-17-m.chetan.kumar@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <26d87564-cc51-021b-9644-8dd05da3159e@infradead.org>
Date:   Tue, 20 Apr 2021 11:08:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210420161310.16189-17-m.chetan.kumar@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 4/20/21 9:13 AM, M Chetan Kumar wrote:

> diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
> new file mode 100644
> index 000000000000..6507970653d2
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
> +	depends on NET

This already depends on NET since it is inside NETDEVICES which
depends on NET.

> +	help
> +	  This section contains all Wireless WAN (WWAN) device drivers.
> +
> +	  If you have one of those WWAN M.2 Modules and wish to use it in Linux
> +	  say Y here and also to the Module specific WWAN Device Driver.
> +
> +	  If unsure, say N.
> +
> +if WWAN
> +source "drivers/net/wwan/iosm/Kconfig"
> +endif # WWAN


-- 
~Randy

