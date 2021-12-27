Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A1948048E
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 21:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhL0Ufh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 15:35:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:18537 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhL0Ufg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 15:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640637336; x=1672173336;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i0+skIG3r3ZUUYPJ5601p7bDL3y6odf9XcyndmoTIqM=;
  b=HfGEOvd7dG0yKLd6culgbrc0pNzt7Xvg5HzCOaOkGVlCm03RIfwDt+vK
   xToAwhOcBGFoHkdNxJjx5ZtQ4RueM5zasXrPEt1ookIOb3s5nToPdA6RO
   Ef62H+iny6tvvyjb7hI5yTYJz8n2DqXXJu96fQ5uYMmU3EBgcdQzvEVNt
   lzQwexgDHbqLGe3OTmSMBWp8T3fhLw/WrLdYYbDuHYenAJeqqx00Uvs+9
   cNquSpy0ri5xRjBu0kk3AzcaKcLXYBpzQtE1gfpouYvnKHhCxNe/WDuA8
   XsoqjJk7zwG3BdhoXedoNcp7wRoAQ7jGV1CIn0lxKULRFcuXTeWm2daHj
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="304626232"
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="304626232"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 12:35:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="523406171"
Received: from krausnex-mobl.ger.corp.intel.com (HELO [10.255.195.237]) ([10.255.195.237])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 12:35:33 -0800
Message-ID: <30f0321d-14de-e2b8-26b3-c0ed3b01f5de@linux.intel.com>
Date:   Mon, 27 Dec 2021 22:35:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [Intel-wired-lan] [PATCH net v1] igc: Do not enable
 crosstimestamping for i225-V models
Content-Language: en-US
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, roots@gmx.de, regressions@leemhuis.info,
        greg@kroah.com, kuba@kernel.org
References: <87wnk8qrt8.fsf@intel.com>
 <20211214003949.666642-1-vinicius.gomes@intel.com>
From:   "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>
In-Reply-To: <20211214003949.666642-1-vinicius.gomes@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/2021 02:39, Vinicius Costa Gomes wrote:
> It was reported that when PCIe PTM is enabled, some lockups could
> be observed with some integrated i225-V models.
> 
> While the issue is investigated, we can disable crosstimestamp for
> those models and see no loss of functionality, because those models
> don't have any support for time synchronization.
> 
> Fixes: a90ec8483732 ("igc: Add support for PTP getcrosststamp()")
> Link: https://lore.kernel.org/all/924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de/
> Reported-by: Stefan Dietrich <roots@gmx.de>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_ptp.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>

