Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EFA33F78C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhCQRwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbhCQRw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 13:52:29 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25986C06174A;
        Wed, 17 Mar 2021 10:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=nE45k8FixLnSufakV+tBQGAF9aOc9NiNiG7mBSO7nh4=; b=lfPgb9Z31TuQRauM8ZNsdVcckv
        Xl5YXjzSFB/Olw8k2lkfOmyXSGCy9iP0ZQ46sJtFlU3TBg3EiDaD+6Q1qNeynYR5+2ZB993On+lj/
        q8fmoIVUpT1dvRt4Xjz8C0Y/xKrzcz7EpP+UteqVVt5zRZSEnpcihIt6mL/zrkgT5ylFKKZ+jDbRn
        1/yB14CqxtmHdqs8KfMcC3RyDN7wtdsh2fvsIVA3qwhyX56BPupBnCCDd0D21/YdVwIpEgxlUuMQs
        XMboLCg3uPHa5rkX6+oPODFGqKfdAjuiRQj+UV+bSMsGw6vK4NaaGi5nmjzcjCAPyMoP0rhqhtwZr
        xztB3uhg==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMaLJ-001feL-W4; Wed, 17 Mar 2021 17:52:26 +0000
Subject: Re: [PATCH] net: ethernet: intel: Fix a typo in the file
 ixgbe_dcb_nl.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210317100001.2172893-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7ee2ccf4-5b1f-eb3c-9d8f-d3381a347bc3@infradead.org>
Date:   Wed, 17 Mar 2021 10:52:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210317100001.2172893-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 3:00 AM, Bhaskar Chowdhury wrote:
> 
> s/Reprogam/Reprogram/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
> index c00332d2e02a..72e6ebffea33 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c
> @@ -361,7 +361,7 @@ static u8 ixgbe_dcbnl_set_all(struct net_device *netdev)
>  	}
> 
>  #ifdef IXGBE_FCOE
> -	/* Reprogam FCoE hardware offloads when the traffic class
> +	/* Reprogram FCoE hardware offloads when the traffic class
>  	 * FCoE is using changes. This happens if the APP info
>  	 * changes or the up2tc mapping is updated.
>  	 */
> --


-- 
~Randy

