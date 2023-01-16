Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3FA266CE8E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 19:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbjAPSPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 13:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbjAPSO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 13:14:29 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF32234FB;
        Mon, 16 Jan 2023 10:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673892076; x=1705428076;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a9IkWEVze0aTO+howO3YtNxpHKbT43mKMZb2o79oLCg=;
  b=kT8EBbnP+CTtodg+EKiQCZdgK7GBybTPgfjCN1BKE88igfh07vwx27FG
   zlo600jHbiA4ctZXmhai2ovWIN+d/VFwnJZNM1pkipFSQFCBkSWgLFFfl
   dhvzJ3hnwudvKb9qd1MnqivXjJXSr7wkG2JBW3GqSJBiZo5L1YCQ1DlnQ
   1HeQu+bitkQg3Z5wTDKZ5p3w1FsRBkseJhL4W45XOxhk++lER7yrnNYKz
   eqbe87YNImmDmJ3cDTi5WoSjSEPS66JIQLSQtViYZrV9Wq4hGqhOZJKbX
   HoByp1YOpI44UaSiD08J1A4kCevKxNS57t4SMIY/U5l6KTleDqKZ/RyUp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="351765966"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="351765966"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 10:00:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="766980666"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="766980666"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jan 2023 10:00:21 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pHTmN-00ACrw-13;
        Mon, 16 Jan 2023 20:00:19 +0200
Date:   Mon, 16 Jan 2023 20:00:19 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: Re: [net-next: PATCH v4 5/8] device property: introduce
 fwnode_find_parent_dev_match
Message-ID: <Y8WQszCL6CicJSuU@smile.fi.intel.com>
References: <20230116173420.1278704-1-mw@semihalf.com>
 <20230116173420.1278704-6-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116173420.1278704-6-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 06:34:17PM +0100, Marcin Wojtas wrote:
> Add a new generic routine fwnode_find_parent_dev_match that can be used
> e.g. as a callback for class_find_device(). It searches for the struct
> device corresponding to a struct fwnode_handle by iterating over device
> and its parents.

If it helps you, I have no objections, hence
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  include/linux/property.h |  1 +
>  drivers/base/property.c  | 23 ++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/include/linux/property.h b/include/linux/property.h
> index 37179e3abad5..4ae20d7c5103 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -109,6 +109,7 @@ struct device *fwnode_get_next_parent_dev(struct fwnode_handle *fwnode);
>  unsigned int fwnode_count_parents(const struct fwnode_handle *fwn);
>  struct fwnode_handle *fwnode_get_nth_parent(struct fwnode_handle *fwn,
>  					    unsigned int depth);
> +int fwnode_find_parent_dev_match(struct device *dev, const void *data);
>  bool fwnode_is_ancestor_of(struct fwnode_handle *ancestor, struct fwnode_handle *child);
>  struct fwnode_handle *fwnode_get_next_child_node(
>  	const struct fwnode_handle *fwnode, struct fwnode_handle *child);
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index bbb3e499ff4a..84849d4934cc 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -693,6 +693,29 @@ struct fwnode_handle *fwnode_get_nth_parent(struct fwnode_handle *fwnode,
>  }
>  EXPORT_SYMBOL_GPL(fwnode_get_nth_parent);
>  
> +/**
> + * fwnode_find_parent_dev_match - look for a device matching the struct fwnode_handle
> + * @dev: the struct device to initiate the search
> + * @data: pointer passed for comparison
> + *
> + * Looks up the device structure corresponding with the fwnode by iterating
> + * over @dev and its parents.
> + * The routine can be used e.g. as a callback for class_find_device().
> + *
> + * Returns: %1 - match is found
> + *          %0 - match not found
> + */
> +int fwnode_find_parent_dev_match(struct device *dev, const void *data)
> +{
> +	for (; dev; dev = dev->parent) {
> +		if (device_match_fwnode(dev, data))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fwnode_find_parent_dev_match);
> +
>  /**
>   * fwnode_is_ancestor_of - Test if @ancestor is ancestor of @child
>   * @ancestor: Firmware which is tested for being an ancestor
> -- 
> 2.29.0
> 

-- 
With Best Regards,
Andy Shevchenko


