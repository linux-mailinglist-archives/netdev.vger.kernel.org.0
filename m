Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9393660247
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfGEIiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:38:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:47803 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbfGEIh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:37:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jul 2019 01:37:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,454,1557212400"; 
   d="scan'208";a="187763795"
Received: from mloenko-mobl.amr.corp.intel.com ([10.252.3.191])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jul 2019 01:37:57 -0700
Message-ID: <9899896581ccedda453d0e81430b76f8fc8b4bb1.camel@intel.com>
Subject: Re: [PATCH 3/5] iwlwifi: dvm: no need to check return value of
 debugfs_create functions
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 05 Jul 2019 11:37:56 +0300
In-Reply-To: <20190612142658.12792-3-gregkh@linuxfoundation.org>
References: <20190612142658.12792-1-gregkh@linuxfoundation.org>
         <20190612142658.12792-3-gregkh@linuxfoundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-12 at 16:26 +0200, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  This driver was saving the debugfs file away to be
> removed at a later time.  However, the 80211 core would delete the whole
> directory that the debugfs files are created in, after it asks the
> driver to do the deletion, so just rely on the 80211 core to do all of
> the cleanup for us, making us not need to keep a pointer to the dentries
> around at all.
> 
> This cleans up the structure of the driver data a bit and makes the code
> a tiny bit smaller.
> 
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Thanks, Greg! I applied this to our internal tree and it will reach the
mainline following our normal upstreaming process.

--
Cheers,
Luca.

