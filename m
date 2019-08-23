Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2FD69A6F9
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 07:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391955AbfHWFRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 01:17:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:38604 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391807AbfHWFRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 01:17:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 22:17:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,420,1559545200"; 
   d="scan'208";a="186777188"
Received: from pkacprow-mobl.ger.corp.intel.com ([10.252.30.96])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Aug 2019 22:17:40 -0700
Message-ID: <84a882c0bd2954c21735005534abb5568b2fc806.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: fix old-style declaration
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     YueHaibing <yuehaibing@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, sara.sharon@intel.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Fri, 23 Aug 2019 08:17:39 +0300
In-Reply-To: <20190726141838.19424-1-yuehaibing@huawei.com>
References: <20190726141838.19424-1-yuehaibing@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-07-26 at 22:18 +0800, YueHaibing wrote:
> There expect the 'static' keyword to come first in a
> declaration, and we get a warning for this with "make W=1":
> 
> drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:427:1: warning:
>  'static' is not at beginning of declaration [-Wold-style-declaration]
> drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:434:1: warning:
>  'static' is not at beginning of declaration [-Wold-style-declaration]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Thanks! Johannes applied this in our internal tree a few weeks ago and
it will reach the mainline following our usual upstreaming process.

--
Cheers,
Luca.

