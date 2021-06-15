Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDCD3A749B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhFODGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 23:06:42 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6496 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhFODGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 23:06:40 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G3tPx0KRmzZdWy;
        Tue, 15 Jun 2021 11:01:41 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 11:04:35 +0800
Subject: Re: [RESEND PATCH V3 2/6] PCI: Use cached Device Capabilities 2
 Register
To:     Christoph Hellwig <hch@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-3-git-send-email-liudongdong3@huawei.com>
 <YMbt6699/6r85MYy@infradead.org>
CC:     <helgaas@kernel.org>, <kw@linux.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <1a6ebe32-6312-32fa-b02b-a0f205334e11@huawei.com>
Date:   Tue, 15 Jun 2021 11:04:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YMbt6699/6r85MYy@infradead.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/14 13:49, Christoph Hellwig wrote:
>> +			if (!(bridge->pcie_devcap2 & PCI_EXP_DEVCAP2_ATOMIC_ROUTE))
>
> Overly long line.
>
Will fix.
>> +static void pci_init_devcap2(struct pci_dev *dev)
>> +{
>> +	if (!pci_is_pcie(dev))
>> +		return;
>> +
>> +	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP2, &dev->pcie_devcap2);
>> +}
>
> Wouldn't it make sene to merge this into set_pcie_port_type?
Good suggestion, will do.

Thanks,
Dongdong
> .
>
