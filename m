Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2097D12D729
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 09:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfLaIwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 03:52:31 -0500
Received: from mga06.intel.com ([134.134.136.31]:15961 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfLaIwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 03:52:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 00:52:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,378,1571727600"; 
   d="scan'208";a="215534602"
Received: from dlmurray-mobl.ger.corp.intel.com ([10.252.21.252])
  by fmsmga007.fm.intel.com with ESMTP; 31 Dec 2019 00:52:23 -0800
Message-ID: <fe9a5800538628e5ad107fe650471da1ddf7bdd9.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: Revert "iwlwifi: mvm: fix scan config
 command size"
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Tova Mussai <tova.mussai@intel.com>,
        Ayala Beker <ayala.beker@intel.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Date:   Tue, 31 Dec 2019 10:52:22 +0200
In-Reply-To: <20191231083604.5639-1-jian-hong@endlessm.com>
References: <20191231083604.5639-1-jian-hong@endlessm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-12-31 at 16:36 +0800, Jian-Hong Pan wrote:
> The Intel(R) Dual Band Wireless AC 9461 WiFi keeps restarting until
> commit 06eb547c4ae4 ("wlwifi: mvm: fix scan config command size") is
> reverted.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=206025
> Fixes: commit 06eb547c4ae4 ("wlwifi: mvm: fix scan config command size")
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> ---

We already have this fix queued up for v5.5-rc*:

https://patchwork.kernel.org/patch/11313069/

Thanks for the patch anyway!

--
Cheers,
Luca.

