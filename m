Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720FC3B9DAF
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhGBIsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:48:55 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13052 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhGBIsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 04:48:54 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GGTB815PLzZkn2;
        Fri,  2 Jul 2021 16:43:12 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 16:46:20 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 2 Jul 2021
 16:46:19 +0800
Subject: Re: [PATCH net-next v3 1/3] selftests/ptr_ring: add benchmark
 application for ptr_ring
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <brouer@redhat.com>, <paulmck@kernel.org>,
        <peterz@infradead.org>, <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
 <1625142402-64945-2-git-send-email-linyunsheng@huawei.com>
 <e1ec4577-a48f-ff56-b766-1445c2501b9f@redhat.com>
 <91bcade8-f034-4bc7-f329-d5e1849867e7@huawei.com>
 <20210702042838-mutt-send-email-mst@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <661a84bc-e7c5-bc21-25ac-75a68efa79ca@huawei.com>
Date:   Fri, 2 Jul 2021 16:46:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210702042838-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/2 16:30, Michael S. Tsirkin wrote:
> On Fri, Jul 02, 2021 at 04:17:17PM +0800, Yunsheng Lin wrote:
>>> Let's reuse ptr_ring.c in tools/virtio/ringtest. Nothing virt specific there.
>>
>> It *does* have some virtio specific at the end of ptr_ring.c.
>> It can be argued that the ptr_ring.c in tools/virtio/ringtest
>> could be refactored to remove the function related to virtio.
>>
>> But as mentioned in the previous disscusion [1], the tools/virtio/
>> seems to have compile error in the latest kernel, it does not seems
>> right to reuse that.
>> And most of testcase in tools/virtio/ seems
>> better be in tools/virtio/ringtest instead，so until the testcase
>> in tools/virtio/ is compile-error-free and moved to tools/testing/
>> selftests/, it seems better not to reuse it for now.
> 
> 
> That's a great reason to reuse - so tools/virtio/ stays working.
> Please just fix that.

I understand that you guys like to see a working testcase of virtio.
I would love to do that if I have the time and knowledge of virtio,
But I do not think I have the time and I am familiar enough with
virtio to fix that now.


> 
