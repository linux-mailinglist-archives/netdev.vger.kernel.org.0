Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901CD1D6E55
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 02:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgERAvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 20:51:04 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2137 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726680AbgERAvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 20:51:04 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id E8C08D36FE6B0E58D10F;
        Mon, 18 May 2020 08:51:01 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 May 2020 08:51:01 +0800
Received: from [10.173.219.71] (10.173.219.71) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 18 May 2020 08:51:01 +0800
Subject: Re: [PATCH net-next] hinic: add support to set and get pause param
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>
References: <20200516020030.23017-1-luobin9@huawei.com>
 <20200516.132504.766576117055386086.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <6a340973-ad63-b3e4-a212-4eb9dbe2ee3f@huawei.com>
Date:   Mon, 18 May 2020 08:51:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200516.132504.766576117055386086.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.173.219.71]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will fix. Thanks.

On 2020/5/17 4:25, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Sat, 16 May 2020 02:00:30 +0000
>
>> add support to set pause param with ethtool -A and get pause
>> param with ethtool -a. Also remove set_link_ksettings ops for VF.
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> Why are you using a semaphore and not a plain mutex.
>
> Semaphores should be used as an absolute last resort, and only
> after trying vigorously to use other locking primitives.
> .
