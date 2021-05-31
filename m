Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF22395888
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 11:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhEaJ7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 05:59:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:43332 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhEaJ7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 05:59:32 -0400
IronPort-SDR: iu8iJt7uMtizO2c9WWv12EbH6YHIQCxepLragOWhKeyS/tq0uKxCIF2sdKk/IEAk9CBp8GXL0v
 fSMmntFcxD2A==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="190694848"
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="190694848"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 02:57:51 -0700
IronPort-SDR: D87E8g807KfBxpAgMw14PAIF7Ktmu5SkA5rUR+BxswgTXbo+LICnf2zriB4odrnAD94HSgI4np
 PRB7Ctemt9gw==
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="478856558"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.215.190]) ([10.254.215.190])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 02:57:50 -0700
Subject: Re: [PATCH RESEND 1/2] virtio: update virtio id table, add
 transitional ids
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210531072743.363171-1-lingshan.zhu@intel.com>
 <20210531072743.363171-2-lingshan.zhu@intel.com>
 <20210531095804.47629646.cohuck@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <53862384-be2b-4a5f-adbb-37eb25ec9fe1@intel.com>
Date:   Mon, 31 May 2021 17:57:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210531095804.47629646.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/2021 3:58 PM, Cornelia Huck wrote:
> On Mon, 31 May 2021 15:27:42 +0800
> Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
>> This commit updates virtio id table by adding transitional device
>> ids
>> virtio_pci_common.h
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   include/uapi/linux/virtio_ids.h | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
>> index f0c35ce8628c..fcc9ec6a73c1 100644
>> --- a/include/uapi/linux/virtio_ids.h
>> +++ b/include/uapi/linux/virtio_ids.h
>> @@ -57,4 +57,16 @@
>>   #define VIRTIO_ID_BT			28 /* virtio bluetooth */
>>   #define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
>>   
>> +/*
>> + * Virtio Transitional IDs
>> + */
>> +
>> +#define VIRTIO_TRANS_ID_NET		1000 /* transitional virtio net */
>> +#define VIRTIO_TRANS_ID_BLOCK		1001 /* transitional virtio block */
>> +#define VIRTIO_TRANS_ID_BALLOON		1002 /* transitional virtio balloon */
>> +#define VIRTIO_TRANS_ID_CONSOLE		1003 /* transitional virtio console */
>> +#define VIRTIO_TRANS_ID_SCSI		1004 /* transitional virtio SCSI */
>> +#define VIRTIO_TRANS_ID_RNG		1005 /* transitional virtio rng */
>> +#define VIRTIO_TRANS_ID_9P		1009 /* transitional virtio 9p console */
>> +
>>   #endif /* _LINUX_VIRTIO_IDS_H */
> Isn't this a purely virtio-pci concept? (The spec lists the virtio ids
> in the common section, and those transitional ids in the pci section.)
> IOW, is there a better, virtio-pci specific, header for this?
Hi Cornelia,

yes they are pure virtio-pci transitional concept. There is a 
virtio_pci.h, but not looks like
a good place for these stuffs, Michael ever suggested to add these ids 
to virtio_ids.h, so I have
chosen this file.

https://www.spinics.net/lists/netdev/msg739269.html

Thanks
Zhu Lingshan
>

