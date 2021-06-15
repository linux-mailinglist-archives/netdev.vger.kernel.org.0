Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEAD3A74A1
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhFODJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 23:09:18 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6497 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhFODJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 23:09:12 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G3tSr1TCnzZgch;
        Tue, 15 Jun 2021 11:04:12 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 11:07:06 +0800
Subject: Re: [RESEND PATCH V3 4/6] PCI: Enable 10-Bit tag support for PCIe
 Endpoint devices
To:     Christoph Hellwig <hch@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-5-git-send-email-liudongdong3@huawei.com>
 <YMbvGYR/pAMwKMbB@infradead.org>
CC:     <helgaas@kernel.org>, <kw@linux.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <9a44a46a-7270-1e86-2476-49a4743f14df@huawei.com>
Date:   Tue, 15 Jun 2021 11:07:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YMbvGYR/pAMwKMbB@infradead.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/14 13:54, Christoph Hellwig wrote:
> On Sun, Jun 13, 2021 at 05:29:13PM +0800, Dongdong Liu wrote:
>> +static void pci_configure_10bit_tags(struct pci_dev *dev)
>> +{
>> +	struct pci_dev *bridge;
>> +
>> +	if (!pci_is_pcie(dev))
>> +		return;
>> +
>> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP))
>> +		return;
>
> Doesn't the second check imply the first one?
Yes, no need the first one, will delete.

Thanks,
Dongdong
>
> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> .
>
