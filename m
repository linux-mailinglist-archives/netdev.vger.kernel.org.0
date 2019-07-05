Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C251460249
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfGEIiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:38:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:23639 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbfGEIiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:38:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jul 2019 01:38:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,454,1557212400"; 
   d="scan'208";a="185133480"
Received: from mloenko-mobl.amr.corp.intel.com ([10.252.3.191])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jul 2019 01:38:18 -0700
Message-ID: <5129e850dd02f4d823cf2b2c36b9c5ef862251ac.camel@intel.com>
Subject: Re: [PATCH 4/5] iwlwifi: mvm: remove unused .remove_sta_debugfs
 callback
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Erel Geron <erelx.geron@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 05 Jul 2019 11:38:17 +0300
In-Reply-To: <20190612142658.12792-4-gregkh@linuxfoundation.org>
References: <20190612142658.12792-1-gregkh@linuxfoundation.org>
         <20190612142658.12792-4-gregkh@linuxfoundation.org>
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
> The .remove_sta_debugfs callback was not doing anything in this driver,
> so remove it as it is not needed.
> 
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Sara Sharon <sara.sharon@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Erel Geron <erelx.geron@intel.com>
> Cc: Avraham Stern <avraham.stern@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

Thanks, Greg! I applied this to our internal tree and it will reach the
mainline following our normal upstreaming process.

--
Cheers,
Luca.

