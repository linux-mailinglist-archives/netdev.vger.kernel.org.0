Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91EE936031C
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhDOHSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:18:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39368 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230372AbhDOHR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618471054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0WnUGWj6mmdpbk5EPEs1Mzx7dyk9BlduW5BXBGRUq4=;
        b=JjDpkIcokTjJXVryPlQYzm2yc2NLMlTo9pTVRmaqdZbamVHVDF7EjnY04812IMYwbRhvAS
        E7Jm2kKd8Lid25VpImJKnxY/N0sCOLFXQck/qT6vrrxp1wqtjho0un9uC/D3R0W7kBvXzJ
        oPpSUPym3VwLKrFdI973CTJizSOuGJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-Dle6J09lNr2HRO6FMp9cYg-1; Thu, 15 Apr 2021 03:17:32 -0400
X-MC-Unique: Dle6J09lNr2HRO6FMp9cYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21BB01854E25;
        Thu, 15 Apr 2021 07:17:31 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-61.pek2.redhat.com [10.72.12.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9021F61D31;
        Thu, 15 Apr 2021 07:17:22 +0000 (UTC)
Subject: Re: [PATCH 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block for
 vDPA
To:     Zhu Lingshan <lingshan.zhu@linux.intel.com>,
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d6b27f59-ff17-1d63-0065-fd03ee36cd2d@redhat.com>
Date:   Thu, 15 Apr 2021 15:17:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <10700088-3358-739b-5770-612ab761598c@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/15 下午2:41, Zhu Lingshan 写道:
>>>>
>>>> I think we've discussed this sometime in the past but what's the 
>>>> reason for such whitelist consider there's already a get_features() 
>>>> implemention?
>>>>
>>>> E.g Any reason to block VIRTIO_BLK_F_WRITE_ZEROS or 
>>>> VIRTIO_F_RING_PACKED?
>>>>
>>>> Thanks
>>> The reason is some feature bits are supported in the device but not 
>>> supported by the driver, e.g, for virtio-net, mq & cq implementation 
>>> is not ready in the driver.
>>
>>
>> I understand the case of virtio-net but I wonder why we need this for 
>> block where we don't vq cvq.
>>
>> Thanks
> This is still a subset of the feature bits read from hardware, I leave 
> it here to code consistently, and indicate what we support clearly.
> Are you suggesting remove this feature bits list and just use what we 
> read from hardware?
>
> Thansk 


Yes, please do that.

The whiltelist doesn't help in this case I think.

Thanks

