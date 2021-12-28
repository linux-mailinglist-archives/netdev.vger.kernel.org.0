Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E4748070B
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 08:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhL1HrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 02:47:25 -0500
Received: from mga12.intel.com ([192.55.52.136]:24848 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235307AbhL1HrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 02:47:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640677644; x=1672213644;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VyO5iu68EBwzTW6R2FWft5RvC5TKuO++AyyVXExQUa8=;
  b=XuRH90C6e5vWHI79/18rvlxV/XK7IO5D1q8/o+QFHKrZChkhnshBSHmr
   m4d8lKHmgmQG1JSQj6sP9JNo2lJXUF9FXPOESLcrb46Wk9FvwaL+z7Sxx
   oICyU45j8KbYEjuccYrmgw+2xnSIfWMgVA700BJhaE393kaDcbBtl02zO
   J6BENnUVf5hFz2KISa5bvLvXXRxyPzxuK5G0RMsVt1xYRTT/w4i/q+aYm
   7XETZ2h8PMnxSYgvwXkIA6AQQJGnL8ILOIPq4+bw8oi6PAhAMeY6cLhLT
   P8K9dZP2VtqZi0/YmsjqADaKSE3G+KGqlNo0FNOgEp16+yxfgjdRPRsaN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="221327252"
X-IronPort-AV: E=Sophos;i="5.88,241,1635231600"; 
   d="scan'208";a="221327252"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 23:47:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,241,1635231600"; 
   d="scan'208";a="510103421"
Received: from krausnex-mobl.ger.corp.intel.com (HELO [10.13.8.81]) ([10.13.8.81])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 23:47:22 -0800
Message-ID: <d7d50687-2bee-c540-a7c1-46a6952c0d32@linux.intel.com>
Date:   Tue, 28 Dec 2021 09:47:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [Intel-wired-lan] [PATCH] igc: updated TX timestamp support for
 non-MSI-X platforms
Content-Language: en-US
To:     James McLaughlin <james.mclaughlin@qsc.com>, davem@davemloft.net,
        kuba@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20211217205209.723782-1-james.mclaughlin@qsc.com>
From:   "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>
In-Reply-To: <20211217205209.723782-1-james.mclaughlin@qsc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/2021 22:52, James McLaughlin wrote:
> Time synchronization was not properly enabled on non-MSI-X platforms.
> 
> Signed-off-by: James McLaughlin <james.mclaughlin@qsc.com>
> Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>

