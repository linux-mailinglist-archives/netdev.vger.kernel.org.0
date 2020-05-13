Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF241D048D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732056AbgEMBvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:51:42 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:36068 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726028AbgEMBvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 21:51:41 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id D2758F3EE58754A4C876;
        Wed, 13 May 2020 09:51:39 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 13 May 2020 09:51:39 +0800
Received: from [10.173.219.71] (10.173.219.71) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 13 May 2020 09:51:39 +0800
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <20200512133051.7d740613@canb.auug.org.au>
 <20200512094731.346c0d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <c49a4d39-9f83-a68a-fa0d-ef5fd3bc4acc@huawei.com>
Date:   Wed, 13 May 2020 09:51:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200512094731.346c0d8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.173.219.71]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/5/13 0:47, Jakub Kicinski wrote:

> On Tue, 12 May 2020 13:30:51 +1000 Stephen Rothwell wrote:
>> Hi all,
>>
>> Today's linux-next merge of the net-next tree got conflicts in:
>>
>>    drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
>>    drivers/net/ethernet/huawei/hinic/hinic_main.c
>>
>> between commit:
>>
>>    e8a1b0efd632 ("hinic: fix a bug of ndo_stop")
>>
>> from the net tree and commit:
>>
>>    7dd29ee12865 ("hinic: add sriov feature support")
>>
>> from the net-next tree.
>>
>> I fixed it up (I think, see below) and can carry the fix as necessary. This
>> is now fixed as far as linux-next is concerned, but any non trivial
>> conflicts should be mentioned to your upstream maintainer when your tree
>> is submitted for merging.  You may also want to consider cooperating
>> with the maintainer of the conflicting tree to minimise any particularly
>> complex conflicts.
> I had a feeling this was gonna happen :(
>
> Resolution looks correct, thank you!
>
> Luo bin, if you want to adjust the timeouts (you had slightly different
> ones depending on the command in the first version of the fix) - you can
> follow up with a patch to net-next once Dave merges net into net-next
> (usually happens every two weeks).

> OK. Thanks.
> .
