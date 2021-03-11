Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD0336BEE
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCKGPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:15:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhCKGPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:15:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615443302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EGHGtDY6oYOq4ktx0P7B3AMQkeS8BtbFf081LchZP84=;
        b=Vn9HfzsqX9qSz5fdAqwoM0ON26D8lBZ9t6ig8dahiTsMPN5rrzXgrB2QrVdlTLDahsY9g6
        EoBBO7Fnpiku6YwzgAYi7bptEIEV+//aMyaY7KCTgVqakuEElUPmboId6kC6EGdZmZ9oE5
        3qg+rrIzkX6QWivgOt+UTzhvDbVylRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-F6FLOejKPrGzpWAcUACzDg-1; Thu, 11 Mar 2021 01:14:58 -0500
X-MC-Unique: F6FLOejKPrGzpWAcUACzDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F68A1858F2B;
        Thu, 11 Mar 2021 06:14:57 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8CE062463;
        Thu, 11 Mar 2021 06:14:48 +0000 (UTC)
Subject: Re: [PATCH V3 3/6] vDPA/ifcvf: rename original IFCVF dev ids to N3000
 ids
To:     Zhu Lingshan <lingshan.zhu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-4-lingshan.zhu@intel.com>
 <5e2b22cc-7faa-2987-a30a-ce32f10099b6@redhat.com>
 <4472d8f3-ef44-37a0-8ee1-82caa4a0a843@linux.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a14608bb-bd32-00fe-94bf-1d87361c89df@redhat.com>
Date:   Thu, 11 Mar 2021 14:14:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <4472d8f3-ef44-37a0-8ee1-82caa4a0a843@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/11 12:23 下午, Zhu Lingshan wrote:
>
>
> On 3/11/2021 11:25 AM, Jason Wang wrote:
>>
>> On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
>>> IFCVF driver probes multiple types of devices now,
>>> to distinguish the original device driven by IFCVF
>>> from others, it is renamed as "N3000".
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> ---
>>>   drivers/vdpa/ifcvf/ifcvf_base.h | 8 ++++----
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 8 ++++----
>>>   2 files changed, 8 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> index 75d9a8052039..794d1505d857 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>>> @@ -18,10 +18,10 @@
>>>   #include <uapi/linux/virtio_config.h>
>>>   #include <uapi/linux/virtio_pci.h>
>>>   -#define IFCVF_VENDOR_ID        0x1AF4
>>> -#define IFCVF_DEVICE_ID        0x1041
>>> -#define IFCVF_SUBSYS_VENDOR_ID    0x8086
>>> -#define IFCVF_SUBSYS_DEVICE_ID    0x001A
>>> +#define N3000_VENDOR_ID        0x1AF4
>>> +#define N3000_DEVICE_ID        0x1041
>>> +#define N3000_SUBSYS_VENDOR_ID    0x8086
>>> +#define N3000_SUBSYS_DEVICE_ID    0x001A
>>>     #define C5000X_PL_VENDOR_ID        0x1AF4
>>>   #define C5000X_PL_DEVICE_ID        0x1000
>>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> index 26a2dab7ca66..fd5befc5cbcc 100644
>>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>>> @@ -480,10 +480,10 @@ static void ifcvf_remove(struct pci_dev *pdev)
>>>   }
>>>     static struct pci_device_id ifcvf_pci_ids[] = {
>>> -    { PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
>>> -        IFCVF_DEVICE_ID,
>>> -        IFCVF_SUBSYS_VENDOR_ID,
>>> -        IFCVF_SUBSYS_DEVICE_ID) },
>>> +    { PCI_DEVICE_SUB(N3000_VENDOR_ID,
>>> +             N3000_DEVICE_ID,
>>
>>
>> I am not sure the plan for Intel but I wonder if we can simply use 
>> PCI_ANY_ID for device id here. Otherewise you need to maintain a very 
>> long list of ids here.
>>
>> Thanks
> Hi Jason,
>
> Thanks! but maybe if we present a very simple and clear list like what 
> e1000 does can help the users understand what we support easily.
>
> Thanks!


That's fine.

Thanks


>>
>>
>>> + N3000_SUBSYS_VENDOR_ID,
>>> +             N3000_SUBSYS_DEVICE_ID) },
>>>       { PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
>>>                C5000X_PL_DEVICE_ID,
>>>                C5000X_PL_SUBSYS_VENDOR_ID,
>>
>

