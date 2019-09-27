Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2180C0130
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfI0Ibp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56188 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfI0Ibo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 04:31:44 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 770658535D;
        Fri, 27 Sep 2019 08:31:44 +0000 (UTC)
Received: from [10.72.12.30] (ovpn-12-30.pek2.redhat.com [10.72.12.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F9095C3FA;
        Fri, 27 Sep 2019 08:31:33 +0000 (UTC)
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <1b4b8891-8c14-1c85-1d6a-2eed1c90bcde@redhat.com>
 <20190927045438.GA17152@___>
 <49bb0777-3761-3737-8e5b-568957f9a935@redhat.com>
 <20190927080410.GA22568@___>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cc288a52-dc5e-1a59-6219-8835c898ea73@redhat.com>
Date:   Fri, 27 Sep 2019 16:31:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927080410.GA22568@___>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 27 Sep 2019 08:31:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/27 下午4:04, Tiwei Bie wrote:
> On Fri, Sep 27, 2019 at 03:14:42PM +0800, Jason Wang wrote:
>> On 2019/9/27 下午12:54, Tiwei Bie wrote:
>>>>> +
>>>>> +		/*
>>>>> +		 * In vhost-mdev, userspace should pass ring addresses
>>>>> +		 * in guest physical addresses when IOMMU is disabled or
>>>>> +		 * IOVAs when IOMMU is enabled.
>>>>> +		 */
>>>> A question here, consider we're using noiommu mode. If guest physical
>>>> address is passed here, how can a device use that?
>>>>
>>>> I believe you meant "host physical address" here? And it also have the
>>>> implication that the HPA should be continuous (e.g using hugetlbfs).
>>> The comment is talking about the virtual IOMMU (i.e. iotlb in vhost).
>>> It should be rephrased to cover the noiommu case as well. Thanks for
>>> spotting this.
>>
>> So the question still, if GPA is passed how can it be used by the
>> virtio-mdev device?
> Sorry if I didn't make it clear..
> Of course, GPA can't be passed in noiommu mode.


I see.

Thanks for the confirmation.


>
>
>> Thanks
>>
