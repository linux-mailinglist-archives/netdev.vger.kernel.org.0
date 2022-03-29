Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD914EA466
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 03:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiC2BEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 21:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiC2BEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 21:04:30 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917312A24E;
        Mon, 28 Mar 2022 18:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648515769; x=1680051769;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=E1Mse4J2gkjy4zky9Hh8Adz/f4f0mswnlvb9K0UZs84=;
  b=YYr1t7VPxHjjssml6QxE5xv4/IiWakAtLpoNcXT9rJ+KK1BKCbELmSnm
   yrjD34/e/2Xj4FhYXW2wBkFCJyA2w9gAlGmYt3zR3Zo5xG8jN69VW0WGs
   QTLFOS1RNUIfX6eyx2yTz7qU2upujh8aBzD7YEfyWMEYiBBgcRlabIkqF
   5RGnts+BeP54dd/I6/y68HF7bWjpzhChpxMIyDWzlAvFbKStUhhdt0pgx
   CjTTafsKwK/3gvHosZ2aMRfDpUjvmvoyTAhXJB9tYOj5+WZPTdIXg3oSi
   KSoawSXBy1zP8K2hAydQvzN4ijy6MxOohhiFjWoDO95XBpxETfr7LWq28
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="319833652"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="319833652"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 18:02:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="652505910"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 18:02:49 -0700
Date:   Mon, 28 Mar 2022 18:05:16 -0700
From:   Alison Schofield <alison.schofield@intel.com>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Cc:     outreachy@lists.linux.dev, toke@toke.dk, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] First Patch: Add Printk to pci.c
Message-ID: <20220329010516.GA1166534@alison-desk>
References: <20220328232449.132550-1-eng.alaamohamedsoliman.am@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328232449.132550-1-eng.alaamohamedsoliman.am@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 01:24:49AM +0200, Alaa Mohamed wrote:
> This patch for adding Printk line to ath9k probe function as a task
> for Outreachy internship
> 
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>

Hi Alaa,

Based on your 'CC to outreachy I can guess you are following out 'First
Patch Tutorial'. A patch for this step does not need to be sent out to
the maintainers and lists, since it's not something we actually want
to change in the Linux Kernel. 

Your next patch, a cleanup patch in drivers/staging/ does need to get
sent. I guess we'll see that soon!

Thanks & welcome to this round of Outreachy,
Alison


> ---
>  drivers/net/wireless/ath/ath9k/pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
> index a074e23013c5..e16bdf343a2f 100644
> --- a/drivers/net/wireless/ath/ath9k/pci.c
> +++ b/drivers/net/wireless/ath/ath9k/pci.c
> @@ -892,6 +892,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	int ret = 0;
>  	char hw_name[64];
>  	int msi_enabled = 0;
> +	printk(KERN_DEBUG "I can modify the Linux kernel!\n");
>  
>  	if (pcim_enable_device(pdev))
>  		return -EIO;
> -- 
> 2.35.1
> 
> 
