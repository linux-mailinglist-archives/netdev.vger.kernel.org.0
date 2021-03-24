Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B226347FC8
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbhCXRsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237166AbhCXRsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:48:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0ABC061763;
        Wed, 24 Mar 2021 10:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=GfbzyCWmhqrf7i4Ut+Cbux3X47Dt38S4IjAXFE9KKMg=; b=qE53wcKxbbpKhnkRw+2jHeibe2
        wItW068uoVkCD3wt1cUSd9Fq0+hJTC778uxw+mupcfIBdMANRYrggZExb12UmlBMvpTlGnquBdeJr
        oQenlJOME7tEiYpif4eug15UTVud83ZaBl869Tw50LUvJ0X6fa/+Va/Am4kP0izD6pOJKhubgkpqR
        0z8nqNMUTg0/7buSePgW1sz4r1czIt+sMy335D78UtUGSOWZ8m0JlX8z6H4gQv5VN/UgIP9j7/rP6
        w24nT8n55YSL+vWhpjIfPNG5fvA3xYuRV6wZ5UnoO0qZDtnIkQVj9YF7nsrwF/41APP2XQS9IHeFK
        pTEhj5NQ==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP7bQ-00BeJ8-R8; Wed, 24 Mar 2021 17:47:53 +0000
Subject: Re: [PATCH] sfc-falcon: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210324075204.29645-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <cf7e9255-a020-ca45-73ee-cad92db7097b@infradead.org>
Date:   Wed, 24 Mar 2021 10:47:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210324075204.29645-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 12:52 AM, Bhaskar Chowdhury wrote:
> 
> s/maintaning/maintaining/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/net/ethernet/sfc/falcon/net_driver.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
> index a529ff395ead..a381cf9ec4f3 100644
> --- a/drivers/net/ethernet/sfc/falcon/net_driver.h
> +++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
> @@ -637,7 +637,7 @@ union ef4_multicast_hash {
>   * struct ef4_nic - an Efx NIC
>   * @name: Device name (net device name or bus id before net device registered)
>   * @pci_dev: The PCI device
> - * @node: List node for maintaning primary/secondary function lists
> + * @node: List node for maintaining primary/secondary function lists
>   * @primary: &struct ef4_nic instance for the primary function of this
>   *	controller.  May be the same structure, and may be %NULL if no
>   *	primary function is bound.  Serialised by rtnl_lock.
> --


-- 
~Randy

