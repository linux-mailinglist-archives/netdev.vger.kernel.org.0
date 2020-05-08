Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE251CA010
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 03:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgEHB1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 21:27:47 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2496 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbgEHB1r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 21:27:47 -0400
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 7D3239F43958117D2E91;
        Fri,  8 May 2020 09:27:44 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 8 May 2020 09:27:07 +0800
Received: from [10.173.219.71] (10.173.219.71) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 8 May 2020 09:27:07 +0800
Subject: Re: [PATCH net] hinic: fix a bug of ndo_stop
To:     David Miller <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>
References: <20200507043222.15522-1-luobin9@huawei.com>
 <20200507.180030.809804789667183990.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <7aff0fa9-3ffe-4c23-40bc-bab09202ee31@huawei.com>
Date:   Fri, 8 May 2020 09:27:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200507.180030.809804789667183990.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.173.219.71]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All right，will fix.

On 2020/5/8 9:00, David Miller wrote:
> From: Luo bin <luobin9@huawei.com>
> Date: Thu, 7 May 2020 04:32:22 +0000
>
>> +	ulong timeo;
> Please fully spell out "unsigned long" for this type.
>
> The same problem exists in your net-next patch submission as well.
>
> Thank you.
> .
