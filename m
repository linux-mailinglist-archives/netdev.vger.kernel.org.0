Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07927437A2D
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhJVPlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:41:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:5593 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233313AbhJVPlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 11:41:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="210112356"
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="210112356"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 08:38:24 -0700
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="569231738"
Received: from smile.fi.intel.com ([10.237.72.184])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2021 08:38:21 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1mdwcI-00092C-F4;
        Fri, 22 Oct 2021 18:37:58 +0300
Date:   Fri, 22 Oct 2021 18:37:58 +0300
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com
Subject: Re: [PATCH 14/14] net: wwan: t7xx: Add maintainers and documentation
Message-ID: <YXLa1sQH9Mo83F0S@smile.fi.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
 <20211021202738.729-15-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021202738.729-15-ricardo.martinez@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 01:27:38PM -0700, Ricardo Martinez wrote:
> Adds maintainers and documentation for MediaTek t7xx 5G WWAN modem
> device driver.
> 
> Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

Are they co-developers or who? This SoB chain seems broken.

> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>

...

> +MEDIATEK T7XX 5G WWAN MODEM DRIVER
> +M:	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> +M:	Intel Corporation <linuxwwan@intel.com>
> +R:	Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>
> +R:	Liu Haijun <haijun.liu@mediatek.com>
> +R:	M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> +R:	Ricardo Martinez <ricardo.martinez@linux.intel.com>
> +L:	netdev@vger.kernel.org

> +S:	Maintained

You are not getting paid for this?

	Supported:   Someone is actually paid to look after this.
	Maintained:  Someone actually looks after it.

> +F:	drivers/net/wwan/t7xx/

-- 
With Best Regards,
Andy Shevchenko


