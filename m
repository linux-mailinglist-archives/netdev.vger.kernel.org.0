Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4017B3BBCA3
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 14:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhGEMJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 08:09:31 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6403 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhGEMJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 08:09:29 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GJPTn3QfRz7872;
        Mon,  5 Jul 2021 20:03:25 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 20:06:51 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 5 Jul 2021
 20:06:51 +0800
Subject: Re: [PATCH net-next 0/2] refactor the ringtest testing for ptr_ring
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, <nickhu@andestech.com>,
        <green.hu@gmail.com>, <deanbo422@gmail.com>,
        <akpm@linux-foundation.org>, <yury.norov@gmail.com>,
        <ojeda@kernel.org>, <ndesaulniers@gooogle.com>, <joe@perches.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
 <YOLXTB6VxtLBmsuC@smile.fi.intel.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c6844e2b-530f-14b2-0ec3-d47574135571@huawei.com>
Date:   Mon, 5 Jul 2021 20:06:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YOLXTB6VxtLBmsuC@smile.fi.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/5 17:56, Andy Shevchenko wrote:
> On Mon, Jul 05, 2021 at 11:57:33AM +0800, Yunsheng Lin wrote:
>> tools/include/* have a lot of abstract layer for building
>> kernel code from userspace, so reuse or add the abstract
>> layer in tools/include/ to build the ptr_ring for ringtest
>> testing.
> 
> ...
> 
>>  create mode 100644 tools/include/asm/cache.h
>>  create mode 100644 tools/include/asm/processor.h
>>  create mode 100644 tools/include/generated/autoconf.h
>>  create mode 100644 tools/include/linux/align.h
>>  create mode 100644 tools/include/linux/cache.h
>>  create mode 100644 tools/include/linux/slab.h
> 
> Maybe somebody can change this to be able to include in-tree headers directly?

If the above works, maybe the files in tools/include/* is not
necessary any more, just use the in-tree headers to compile
the user space app?

Or I missed something here?

> 
> Besides above, had you tested this with `make O=...`?

You are right, the generated/autoconf.h is in another directory
with `make O=...`.

Any nice idea to fix the above problem?

> 
