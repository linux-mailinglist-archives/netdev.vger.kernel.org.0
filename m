Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07296DE8BF
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 11:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfJUJ5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 05:57:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:62060 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbfJUJ5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 05:57:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 02:57:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,323,1566889200"; 
   d="scan'208";a="196065800"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.136]) ([10.238.129.136])
  by fmsmga008.fm.intel.com with ESMTP; 21 Oct 2019 02:57:28 -0700
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016013050.3918-1-lingshan.zhu@intel.com>
 <20191016013050.3918-2-lingshan.zhu@intel.com>
 <2d711b6b-3bdc-afaa-8110-beebd6c5a896@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <32d4c431-24f2-f9f0-8573-268abc7bb71c@intel.com>
Date:   Mon, 21 Oct 2019 17:57:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <2d711b6b-3bdc-afaa-8110-beebd6c5a896@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/16/2019 4:45 PM, Jason Wang wrote:
>
> On 2019/10/16 上午9:30, Zhu Lingshan wrote:
>> + */
>> +#define IFCVF_TRANSPORT_F_START 28
>> +#define IFCVF_TRANSPORT_F_END   34
>> +
>> +#define IFC_SUPPORTED_FEATURES \
>> +        ((1ULL << VIRTIO_NET_F_MAC)            | \
>> +         (1ULL << VIRTIO_F_ANY_LAYOUT)            | \
>> +         (1ULL << VIRTIO_F_VERSION_1) | \
>> +         (1ULL << VHOST_F_LOG_ALL)            | \
>
>
> Let's avoid using VHOST_F_LOG_ALL, using the get_mdev_features() instead.
Thanks, I will remove VHOST_F_LOG_ALL
>
>
>> +         (1ULL << VIRTIO_NET_F_GUEST_ANNOUNCE)        | \
>> +         (1ULL << VIRTIO_NET_F_CTRL_VQ)            | \
>> +         (1ULL << VIRTIO_NET_F_STATUS)            | \
>> +         (1ULL << VIRTIO_NET_F_MRG_RXBUF)) /* not fully supported */
>
>
> Why not having VIRTIO_F_IOMMU_PLATFORM and VIRTIO_F_ORDER_PLATFORM?

I will add VIRTIO_F_ORDER_PLATFORM, for VIRTIO_F_IOMMU_PLATFORM, if we 
add this bit, QEMU may enable viommu, can cause troubles in LM (through 
we don't support LM in this version driver)

Thanks,
BR
Zhu Lingshan
>
> Thanks
>
