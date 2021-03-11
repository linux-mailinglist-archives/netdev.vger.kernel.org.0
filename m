Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3DC336B1A
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 05:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhCKEYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 23:24:05 -0500
Received: from mga05.intel.com ([192.55.52.43]:31125 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231183AbhCKEXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 23:23:53 -0500
IronPort-SDR: yYqZ2YYRzLozLR3nrMW2+rfEP854p7h3gcbf2wspRZzpCARhgKr15HkKNFeA7SzsL1+FKMq95f
 i4oUxo91dOuw==
X-IronPort-AV: E=McAfee;i="6000,8403,9919"; a="273649201"
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="273649201"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 20:23:52 -0800
IronPort-SDR: fEmxznOusV/EE//0QLoDz7Fhmh9dS9730zuo/CNMC2b1gT+6vjt1Gr1uWtlus2v/69m3+HqoFB
 0WpLbgNgCLig==
X-IronPort-AV: E=Sophos;i="5.81,239,1610438400"; 
   d="scan'208";a="410468138"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.170.224]) ([10.249.170.224])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 20:23:49 -0800
Subject: Re: [PATCH V3 3/6] vDPA/ifcvf: rename original IFCVF dev ids to N3000
 ids
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-4-lingshan.zhu@intel.com>
 <5e2b22cc-7faa-2987-a30a-ce32f10099b6@redhat.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <4472d8f3-ef44-37a0-8ee1-82caa4a0a843@linux.intel.com>
Date:   Thu, 11 Mar 2021 12:23:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <5e2b22cc-7faa-2987-a30a-ce32f10099b6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/2021 11:25 AM, Jason Wang wrote:
>
> On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
>> IFCVF driver probes multiple types of devices now,
>> to distinguish the original device driven by IFCVF
>> from others, it is renamed as "N3000".
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.h | 8 ++++----
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 8 ++++----
>>   2 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index 75d9a8052039..794d1505d857 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -18,10 +18,10 @@
>>   #include <uapi/linux/virtio_config.h>
>>   #include <uapi/linux/virtio_pci.h>
>>   -#define IFCVF_VENDOR_ID        0x1AF4
>> -#define IFCVF_DEVICE_ID        0x1041
>> -#define IFCVF_SUBSYS_VENDOR_ID    0x8086
>> -#define IFCVF_SUBSYS_DEVICE_ID    0x001A
>> +#define N3000_VENDOR_ID        0x1AF4
>> +#define N3000_DEVICE_ID        0x1041
>> +#define N3000_SUBSYS_VENDOR_ID    0x8086
>> +#define N3000_SUBSYS_DEVICE_ID    0x001A
>>     #define C5000X_PL_VENDOR_ID        0x1AF4
>>   #define C5000X_PL_DEVICE_ID        0x1000
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 26a2dab7ca66..fd5befc5cbcc 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -480,10 +480,10 @@ static void ifcvf_remove(struct pci_dev *pdev)
>>   }
>>     static struct pci_device_id ifcvf_pci_ids[] = {
>> -    { PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
>> -        IFCVF_DEVICE_ID,
>> -        IFCVF_SUBSYS_VENDOR_ID,
>> -        IFCVF_SUBSYS_DEVICE_ID) },
>> +    { PCI_DEVICE_SUB(N3000_VENDOR_ID,
>> +             N3000_DEVICE_ID,
>
>
> I am not sure the plan for Intel but I wonder if we can simply use 
> PCI_ANY_ID for device id here. Otherewise you need to maintain a very 
> long list of ids here.
>
> Thanks
Hi Jason,

Thanks! but maybe if we present a very simple and clear list like what 
e1000 does can help the users understand what we support easily.

Thanks!
>
>
>> + N3000_SUBSYS_VENDOR_ID,
>> +             N3000_SUBSYS_DEVICE_ID) },
>>       { PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
>>                C5000X_PL_DEVICE_ID,
>>                C5000X_PL_SUBSYS_VENDOR_ID,
>

