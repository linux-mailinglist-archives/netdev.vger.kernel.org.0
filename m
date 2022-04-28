Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99865130E7
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiD1KJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 06:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiD1KHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 06:07:47 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DAD5418B
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651139864; x=1682675864;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sogAt3wki0lyPmkWIk7kioQLz8ysJ2e95ukJVvkd+Eo=;
  b=UYI2OYtKrcoB30QqVdltIjrwqK6Ei8wylMYkznr2O5O8Vzziud1uDTq0
   IB/Ke42CgSQLc+UcSz6fJxtqpQDGKuWBruJR96gJDUj3L9kgfOBXHON61
   EzAifdYE7bAraRU5dyE4ZNOZV7qj4NAgGC4s76SNTFmJ5jQ5Na9TjQz61
   qV8z4ABHCC6uD+mtDC7EznfAGw/MltibMIo6U+qpFIC4CmsqNWAHIPvjk
   K3YujvWM9m3DOQO1jyt7a6yNGVnWn/utq2I0jnsD5K2SmLqPDys/Lhw6u
   s7D00TbxNzgjR4Si3IKN3G/RIUnaToSTWnrujrTrVGG1dFAUaFEboCrhG
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="265754642"
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="265754642"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 02:57:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,295,1643702400"; 
   d="scan'208";a="596719692"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 02:57:42 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nk0u3-009Ezt-UG;
        Thu, 28 Apr 2022 12:57:39 +0300
Date:   Thu, 28 Apr 2022 12:57:39 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 04/14] eth: pch_gbe: remove a copy of the
 NAPI_POLL_WEIGHT define
Message-ID: <YmplE5BrOT8RpI8j@smile.fi.intel.com>
References: <20220427154111.529975-1-kuba@kernel.org>
 <20220427154111.529975-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427154111.529975-5-kuba@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 08:41:01AM -0700, Jakub Kicinski wrote:
> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.

LGTM,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: andriy.shevchenko@linux.intel.com
> ---
>  drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> index 1dc40c537281..46da937ad27f 100644
> --- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> +++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
> @@ -32,8 +32,6 @@
>  #define PCI_DEVICE_ID_ROHM_ML7223_GBE		0x8013
>  #define PCI_DEVICE_ID_ROHM_ML7831_GBE		0x8802
>  
> -#define PCH_GBE_TX_WEIGHT         64
> -#define PCH_GBE_RX_WEIGHT         64
>  #define PCH_GBE_RX_BUFFER_WRITE   16
>  
>  /* Initialize the wake-on-LAN settings */
> @@ -1469,7 +1467,7 @@ pch_gbe_clean_tx(struct pch_gbe_adapter *adapter,
>  		   tx_desc->gbec_status, tx_desc->dma_status);
>  
>  	unused = PCH_GBE_DESC_UNUSED(tx_ring);
> -	thresh = tx_ring->count - PCH_GBE_TX_WEIGHT;
> +	thresh = tx_ring->count - NAPI_POLL_WEIGHT;
>  	if ((tx_desc->gbec_status == DSC_INIT16) && (unused < thresh))
>  	{  /* current marked clean, tx queue filling up, do extra clean */
>  		int j, k;
> @@ -1482,13 +1480,13 @@ pch_gbe_clean_tx(struct pch_gbe_adapter *adapter,
>  
>  		/* current marked clean, scan for more that need cleaning. */
>  		k = i;
> -		for (j = 0; j < PCH_GBE_TX_WEIGHT; j++)
> +		for (j = 0; j < NAPI_POLL_WEIGHT; j++)
>  		{
>  			tx_desc = PCH_GBE_TX_DESC(*tx_ring, k);
>  			if (tx_desc->gbec_status != DSC_INIT16) break; /*found*/
>  			if (++k >= tx_ring->count) k = 0;  /*increment, wrap*/
>  		}
> -		if (j < PCH_GBE_TX_WEIGHT) {
> +		if (j < NAPI_POLL_WEIGHT) {
>  			netdev_dbg(adapter->netdev,
>  				   "clean_tx: unused=%d loops=%d found tx_desc[%x,%x:%x].gbec_status=%04x\n",
>  				   unused, j, i, k, tx_ring->next_to_use,
> @@ -1547,7 +1545,7 @@ pch_gbe_clean_tx(struct pch_gbe_adapter *adapter,
>  		tx_desc = PCH_GBE_TX_DESC(*tx_ring, i);
>  
>  		/* weight of a sort for tx, to avoid endless transmit cleanup */
> -		if (cleaned_count++ == PCH_GBE_TX_WEIGHT) {
> +		if (cleaned_count++ == NAPI_POLL_WEIGHT) {
>  			cleaned = false;
>  			break;
>  		}
> @@ -2519,7 +2517,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
>  	netdev->netdev_ops = &pch_gbe_netdev_ops;
>  	netdev->watchdog_timeo = PCH_GBE_WATCHDOG_PERIOD;
>  	netif_napi_add(netdev, &adapter->napi,
> -		       pch_gbe_napi_poll, PCH_GBE_RX_WEIGHT);
> +		       pch_gbe_napi_poll, NAPI_POLL_WEIGHT);
>  	netdev->hw_features = NETIF_F_RXCSUM |
>  		NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
>  	netdev->features = netdev->hw_features;
> -- 
> 2.34.1
> 

-- 
With Best Regards,
Andy Shevchenko


