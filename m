Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2503F13C8
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 08:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhHSGuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 02:50:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:63302 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230483AbhHSGua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 02:50:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="216223772"
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="216223772"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 23:49:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,334,1620716400"; 
   d="scan'208";a="522315603"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.28.33]) ([10.255.28.33])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 23:49:49 -0700
Subject: Re: [PATCH 0/2] vDPA/ifcvf: enable multiqueue and control vq
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210818095714.3220-1-lingshan.zhu@intel.com>
 <e3ec8ed7-84ac-73cc-0b74-4de1bb6c0030@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <9e6f6cb0-eaed-9d83-c297-3a89f5cc9efd@intel.com>
Date:   Thu, 19 Aug 2021 14:49:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e3ec8ed7-84ac-73cc-0b74-4de1bb6c0030@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2021 12:11 PM, Jason Wang wrote:
>
> 在 2021/8/18 下午5:57, Zhu Lingshan 写道:
>> This series enables multi-queue and control vq features
>> for ifcvf.
>>
>> These patches are based on my previous vDPA/ifcvf management link
>> implementation series:
>> https://lore.kernel.org/kvm/20210812032454.24486-2-lingshan.zhu@intel.com/T/ 
>>
>>
>> Thanks!
>>
>> Zhu Lingshan (2):
>>    vDPA/ifcvf: detect and use the onboard number of queues directly
>>    vDPA/ifcvf: enable multiqueue and control vq
>>
>>   drivers/vdpa/ifcvf/ifcvf_base.c |  8 +++++---
>>   drivers/vdpa/ifcvf/ifcvf_base.h | 19 ++++---------------
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 32 +++++++++++++++-----------------
>>   3 files changed, 24 insertions(+), 35 deletions(-)
>>
>
> Patch looks good.
>
> I wonder the compatibility. E.g does it work on the qemu master 
> without cvq support? (mq=off or not specified)
Hi Jason,

Yes, it works with qemu master. When no cvq/mq support, only one queue 
pair shown.

Thanks,
Zhu Lingshan
>
> Thanks
>

