Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83C63E1570
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241653AbhHENPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:15:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7794 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241638AbhHENPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 09:15:06 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GgTbl2KdxzYlJg;
        Thu,  5 Aug 2021 21:14:43 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 5 Aug 2021 21:14:50 +0800
Subject: Re: [PATCH V7 7/9] PCI/sysfs: Add a 10-Bit Tag sysfs file
To:     Logan Gunthorpe <logang@deltatee.com>, <helgaas@kernel.org>,
        <hch@infradead.org>, <kw@linux.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
References: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
 <1628084828-119542-8-git-send-email-liudongdong3@huawei.com>
 <75243571-3213-6ae2-040f-ae1b1f799e42@deltatee.com>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <8758a42b-233b-eb73-dce4-493e0ce8eed5@huawei.com>
Date:   Thu, 5 Aug 2021 21:14:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <75243571-3213-6ae2-040f-ae1b1f799e42@deltatee.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/4 23:51, Logan Gunthorpe wrote:
>
>
>
> On 2021-08-04 7:47 a.m., Dongdong Liu wrote:
>> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
>> sending Requests to other Endpoints (as opposed to host memory), the
>> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
>> unless an implementation-specific mechanism determines that the Endpoint
>> supports 10-Bit Tag Completer capability. Add a 10bit_tag sysfs file,
>> write 0 to disable 10-Bit Tag Requester when the driver does not bind
>> the device if the peer device does not support the 10-Bit Tag Completer.
>> This will make P2P traffic safe. the 10bit_tag file content indicate
>> current 10-Bit Tag Requester Enable status.
>
> Can we not have both the sysfs file and the command line parameter? If
> the user wants to disable it always for a specific device this sysfs
> parameter is fairly awkward. A script at boot to unbind the driver, set
> the sysfs file and rebind the driver is not trivial and the command line
> parameter offers additional options for users.
Does the command line parameter as "[PATCH V6 7/8] PCI: Add 
"pci=disable_10bit_tag=" parameter for peer-to-peer support" does?

Do we also need such command line if we already had sysfs file?
I think we may not need.

Thanks,
Dongdong
>
> Logan
> .
>
