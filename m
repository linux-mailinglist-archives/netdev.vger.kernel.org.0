Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFB8178B1E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 08:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgCDHKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 02:10:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:11960 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgCDHKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 02:10:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 23:10:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,513,1574150400"; 
   d="scan'208";a="440905257"
Received: from mtosmanx-mobl.amr.corp.intel.com ([10.249.254.162])
  by fmsmga006.fm.intel.com with ESMTP; 03 Mar 2020 23:10:25 -0800
Message-ID: <4e26c715b81fdea7d10e19ca46ffd2645cbe78f9.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: pcie: restore support for Killer Qu C0 NICs
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "Jan Alexander Steffens (heftig)" <jan.steffens@gmail.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 04 Mar 2020 09:10:24 +0200
In-Reply-To: <20200303152925.6BCA8C4479F@smtp.codeaurora.org>
References: <20191224051639.6904-1-jan.steffens@gmail.com>
         <20200303152925.6BCA8C4479F@smtp.codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-03 at 15:29 +0000, Kalle Valo wrote:
> "Jan Alexander Steffens (heftig)" <jan.steffens@gmail.com> wrote:
> 
> > Commit 809805a820c6 ("iwlwifi: pcie: move some cfg mangling from
> > trans_pcie_alloc to probe") refactored the cfg mangling. Unfortunately,
> > in this process the lines which picked the right cfg for Killer Qu C0
> > NICs after C0 detection were lost. These lines were added by commit
> > b9500577d361 ("iwlwifi: pcie: handle switching killer Qu B0 NICs to
> > C0").
> > 
> > I suspect this is more of the "merge damage" which commit 7cded5658329
> > ("iwlwifi: pcie: fix merge damage on making QnJ exclusive") talks about.
> > 
> > Restore the missing lines so the driver loads the right firmware for
> > these NICs.
> > 
> > Fixes: 809805a820c6 ("iwlwifi: pcie: move some cfg mangling from trans_pcie_alloc to probe")
> > Signed-off-by: Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>
> 
> As Luca said, this fails to apply to wireless-drivers. Please rebase and
> resend as v2.

Hmmm, sorry, I confused things a bit.  I missed the fact that wireless-
drivers is already at v5.6.

This patch is not needed in v5.6-rc* because another patch has done a
similar change.  There was some refactoring in this area, so the patch
that is in v5.6 doesn't apply in v5.5, so Jan's patch has to be sent to
stable v5.5 and not be applied in wireless-drivers.

Jan, if you want this to be fixed in v5.5, can you please send it to 
stable@vger.kernel.org with an explanation of why it has to be there
even though it's not in the mainline? Or just send it and CC me, so
I'll reply with an explanation of the issue.

--
Cheers,
Luca.

