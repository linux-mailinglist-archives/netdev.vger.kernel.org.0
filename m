Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF317EAB33
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 08:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfJaH5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 03:57:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:64655 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbfJaH5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 03:57:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 00:57:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="206036015"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.48]) ([10.238.129.48])
  by FMSMGA003.fm.intel.com with ESMTP; 31 Oct 2019 00:57:39 -0700
Subject: Re: [PATCH V6 6/6] docs: sample driver to demonstrate how to
 implement virtio-mdev framework
To:     Christoph Hellwig <hch@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        cohuck@redhat.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, daniel@ffwll.ch, farman@linux.ibm.com,
        pasic@linux.ibm.com, sebott@linux.ibm.com, oberpar@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, idos@mellanox.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com
References: <20191030064444.21166-1-jasowang@redhat.com>
 <20191030064444.21166-7-jasowang@redhat.com>
 <20191030212312.GA4251@infradead.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <1592d723-a580-8614-3fb4-88560a06cdc1@intel.com>
Date:   Thu, 31 Oct 2019 15:57:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191030212312.GA4251@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/31/2019 5:23 AM, Christoph Hellwig wrote:
> On Wed, Oct 30, 2019 at 02:44:44PM +0800, Jason Wang wrote:
>> This sample driver creates mdev device that simulate virtio net device
>> over virtio mdev transport. The device is implemented through vringh
>> and workqueue. A device specific dma ops is to make sure HVA is used
>> directly as the IOVA. This should be sufficient for kernel virtio
>> driver to work.
>>
>> Only 'virtio' type is supported right now. I plan to add 'vhost' type
>> on top which requires some virtual IOMMU implemented in this sample
>> driver.
> Can we please submit a real driver for it?  A more or less useless
> sample driver doesn't really qualify for our normal kernel requirements
> that infrastructure should have a real user.

Hello Christoph,

I am working on a real hardware driver for it, it's called IFC, I have 
posted RFC V1 and will post RFC V2 soon.

Thanks,
BR
Zhu Lingshan
