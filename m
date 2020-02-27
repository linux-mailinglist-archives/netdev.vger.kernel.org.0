Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5EE1712AA
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgB0Ijg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:39:36 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3027 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728440AbgB0Ijf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 03:39:35 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id E19E8D2589D9E7932342;
        Thu, 27 Feb 2020 16:39:29 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Feb 2020 16:39:15 +0800
Received: from [10.173.219.71] (10.173.219.71) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 27 Feb 2020 16:39:15 +0800
Subject: Re: [PATCH net-next 1/2] hinic: Fix a irq affinity bug
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aviad.krawczyk@huawei.com>, <luoxianjun@huawei.com>
References: <20200218194013.23837-1-luobin9@huawei.com>
 <20200219.104754.1226041715847841139.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <5797dc75-4f93-77db-9a72-e138cb15a7df@huawei.com>
Date:   Thu, 27 Feb 2020 16:39:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200219.104754.1226041715847841139.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.173.219.71]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David:

Thanks for your reply, we'll fix and resubmit.

On 2020/2/20 2:47, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Tue, 18 Feb 2020 19:40:12 +0000
>
>> do not use a local variable as an input parameter of irq_set_affinity_hint
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> Bug fixes should target 'net' instead of 'net-next'.
>
> Every patch series containing more than one patch should have an appropriate
> header posting.
> .
