Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52087360339
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhDOHYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:24:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:35788 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhDOHYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 03:24:10 -0400
IronPort-SDR: 2Kg3w7YnkMxgZYvUKucTGMKGT2XDhBq/6VCOXvm7zt9XqVPjmIERt7+cWx2Nt/4N/4aJEllBnA
 gT3FUhxjs5sg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="181927914"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="181927914"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 00:23:47 -0700
IronPort-SDR: kfxF4FwPksoR+4MIAykhuN88Y7X4M9VqYkWzYl6gUP6laeWOL0/X6Ub9CNTU7b3oTZawHAtKwE
 nwx4MZjzznzA==
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="418647970"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.209.173]) ([10.254.209.173])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 00:23:40 -0700
Subject: Re: [PATCH 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block for
 vDPA
To:     Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
 <20210414091832.5132-3-lingshan.zhu@intel.com>
 <54839b05-78d2-8edf-317c-372f0ecda024@redhat.com>
 <1a1f9f50-dc92-ced3-759d-e600abca3138@linux.intel.com>
 <c90a923f-7c8d-9a32-ce14-2370f85f1ba4@redhat.com>
 <10700088-3358-739b-5770-612ab761598c@linux.intel.com>
 <d6b27f59-ff17-1d63-0065-fd03ee36cd2d@redhat.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <af2bb5e6-e690-1aa6-4be3-75a18750aeb4@linux.intel.com>
Date:   Thu, 15 Apr 2021 15:23:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <d6b27f59-ff17-1d63-0065-fd03ee36cd2d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2021 3:17 PM, Jason Wang wrote:
>
> 在 2021/4/15 下午2:41, Zhu Lingshan 写道:
>>>>>
>>>>> I think we've discussed this sometime in the past but what's the 
>>>>> reason for such whitelist consider there's already a 
>>>>> get_features() implemention?
>>>>>
>>>>> E.g Any reason to block VIRTIO_BLK_F_WRITE_ZEROS or 
>>>>> VIRTIO_F_RING_PACKED?
>>>>>
>>>>> Thanks
>>>> The reason is some feature bits are supported in the device but not 
>>>> supported by the driver, e.g, for virtio-net, mq & cq 
>>>> implementation is not ready in the driver.
>>>
>>>
>>> I understand the case of virtio-net but I wonder why we need this 
>>> for block where we don't vq cvq.
>>>
>>> Thanks
>> This is still a subset of the feature bits read from hardware, I 
>> leave it here to code consistently, and indicate what we support 
>> clearly.
>> Are you suggesting remove this feature bits list and just use what we 
>> read from hardware?
>>
>> Thansk 
>
>
> Yes, please do that.
>
> The whiltelist doesn't help in this case I think.
OK, will remove this in V2

Thanks
>
> Thanks

