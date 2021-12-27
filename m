Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A9548049A
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 21:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhL0Uio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 15:38:44 -0500
Received: from mga12.intel.com ([192.55.52.136]:41424 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231131AbhL0Uin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 15:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640637523; x=1672173523;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+s36H9N9lS5geSmQnAeo3ibbRrDHDIjsI845MawbcsU=;
  b=QNUW7UqcYpeqoTwwY3PqF4/6bviV9+d3yrpFebgo3YDoAjvw3jW5eNd9
   hNu3Aq8SkRoPqnUaskrf0SpG4iGNpAJVUWAt4AoVo1dHJfdFnYBELvszE
   y//bETyq5ucFH6dUIRW6fNtuJqrzUmk4/k1+JmJ1viouKkEl7oE95IS1D
   8EuoCuw9wenR4NmOllmPVdCR9vZk5fcPAb7k4wQFFdc4OXTFFc/nmmTBs
   WeO4kAjly4PlXytYz3Jc6IP4582TeTfVBsU0wqFHbDREv8e92bR0eVuV4
   G+m48WJRkYwp4x9gALUllJgd65nukgo/633NFDwtbWgl8IP9TzPn8Wd4r
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="221267053"
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="221267053"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 12:38:42 -0800
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="523406864"
Received: from krausnex-mobl.ger.corp.intel.com (HELO [10.255.195.237]) ([10.255.195.237])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 12:38:40 -0800
Message-ID: <1d2b0af5-540c-df14-2f78-9698f7055e5a@linux.intel.com>
Date:   Mon, 27 Dec 2021 22:38:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [Intel-wired-lan] [PATCH v2] igc: Fix TX timestamp support for
 non-MSI-X platforms
Content-Language: en-US
To:     James McLaughlin <james.mclaughlin@qsc.com>, davem@davemloft.net,
        kuba@kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20211217234310.740255-1-james.mclaughlin@qsc.com>
From:   "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>
In-Reply-To: <20211217234310.740255-1-james.mclaughlin@qsc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/2021 01:43, James McLaughlin wrote:
> Time synchronization was not properly enabled on non-MSI-X platforms.
> 
> Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
> 
> Signed-off-by: James McLaughlin <james.mclaughlin@qsc.com>
> Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
> 
> Having trouble with work email client, understand and agree with comments from Vinicius.
> v1->v2 updated commit message, email subject, and reference original commit this is fixing.
> 
>   drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>

