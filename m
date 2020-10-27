Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FFE29A246
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 02:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503988AbgJ0BmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 21:42:12 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5211 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436613AbgJ0BmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 21:42:11 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CKvZs5ZpvzkZy4;
        Tue, 27 Oct 2020 09:42:13 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 27 Oct 2020 09:42:02 +0800
Subject: Re: [PATCH net] net: hns3: Clear the CMDQ registers before unmapping
 BAR region
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Zenghui Yu <yuzenghui@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wanghaibin.wang@huawei.com>, <tanhuazhong@huawei.com>
References: <20201023051550.793-1-yuzenghui@huawei.com>
 <3c5c98f9-b4a0-69a2-d58d-bfef977c68ad@huawei.com>
 <e74f0a72-92d1-2ac9-1f4b-191477d673ef@huawei.com>
 <20201026161325.6f33d9c8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <bca7fb17-2390-7ff3-d62d-fe279af6a225@huawei.com>
 <20201026182557.43dcb486@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <416bed1a-ce64-d326-3a7a-a8c8258c0bac@huawei.com>
Date:   Tue, 27 Oct 2020 09:42:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20201026182557.43dcb486@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/10/27 9:25, Jakub Kicinski wrote:
> On Tue, 27 Oct 2020 09:24:10 +0800 Yunsheng Lin wrote:
>>> Fixes: 862d969a3a4d ("net: hns3: do VF's pci re-initialization while PF doing FLR")  
>>
>> The correct Fixes tag should be:
>>
>> Fixes: e3338205f0c7 ("net: hns3: uninitialize pci in the hclgevf_uninit")
> 
> Why is that?
> 
> Isn't the issue the order of cmd vs pci calls? e3338205f0c7 only takes
> the pci call from under an if, the order was wrong before.

You are right, the e3338205f0c7 only add the missing hclgevf_pci_uninit()
when HCLGEVF_STATE_IRQ_INITED is not set.

So I think the tag you provided is correct, thanks.

> .
> 
