Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2373305ED
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 03:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhCHCku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 21:40:50 -0500
Received: from mga05.intel.com ([192.55.52.43]:5870 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231134AbhCHCkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 21:40:42 -0500
IronPort-SDR: c9KYFztZKF2pWknP57EcxiLq9g9ArwLlnDeSQKA7B1lbKb4xt2ri360WfQEcWHiY9r2NxJx0IG
 K54w6sZ/NO9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="272975775"
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="272975775"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 18:40:42 -0800
IronPort-SDR: AlUPYTtEdpJhfWZdN1jBx7pGqXZJOp4SZOADbomdbpneUnJ1RGFoarWOrt1yh/1I7b/VmLdiUk
 1A7R6/s17vmg==
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="402646789"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.171.5]) ([10.249.171.5])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 18:40:40 -0800
Subject: Re: [PATCH 3/3] vDPA/ifcvf: bump version string to 1.0
To:     Leon Romanovsky <leon@kernel.org>
Cc:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210305142000.18521-1-lingshan.zhu@intel.com>
 <20210305142000.18521-4-lingshan.zhu@intel.com> <YESWZ0Sjj1YMKETG@unreal>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <8b327a23-1d91-ecc0-d890-45aba52e2030@intel.com>
Date:   Mon, 8 Mar 2021 10:40:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YESWZ0Sjj1YMKETG@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

Thanks for point this out, will send a V2 patchset delete it.

Thanks
Zhu Lingshan

On 3/7/2021 5:01 PM, Leon Romanovsky wrote:
> On Fri, Mar 05, 2021 at 10:20:00PM +0800, Zhu Lingshan wrote:
>> This commit bumps ifcvf driver version string to 1.0
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index fd5befc5cbcc..56a0974cf93c 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -14,7 +14,7 @@
>>   #include <linux/sysfs.h>
>>   #include "ifcvf_base.h"
>>
>> -#define VERSION_STRING  "0.1"
>> +#define VERSION_STRING  "1.0"
> Please delete it instead of bumping it.
> We are not supposed to use in-kernel version for years already.
> https://lore.kernel.org/ksummit-discuss/20170625072423.GR1248@mtr-leonro.local/
>
> Thanks

