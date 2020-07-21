Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D78022747A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgGUBYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:24:21 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2983 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbgGUBYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 21:24:20 -0400
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id A146AEC4157B4E421905;
        Tue, 21 Jul 2020 09:24:18 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 21 Jul 2020 09:24:18 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 21 Jul 2020 09:24:17 +0800
Subject: Re: [PATCH net-next v2 1/2] hinic: add support to handle hw abnormal
 event
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200718085830.27821-1-luobin9@huawei.com>
 <20200718085830.27821-2-luobin9@huawei.com>
 <20200720111326.301b6d74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <fc2ee43e-8342-0b9f-6cc1-4eb19cbb93f5@huawei.com>
Date:   Tue, 21 Jul 2020 09:24:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200720111326.301b6d74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/21 2:13, Jakub Kicinski wrote:
> On Sat, 18 Jul 2020 16:58:29 +0800 Luo bin wrote:
>> add support to handle hw abnormal event such as hardware failure,
>> cable unplugged,link error
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
>> ---
>> V1~V2: add link extended state
>> V0~V1: fix auto build test WARNING
> 
> I don't understand what you think devlink health is missing.
> 
> If it is really missing some functionality you require you have to work
> on extending it.
> 
> Dumping error event state into kernel logs when we have specific
> infrastructure built to address this sort of needs won't fly.
> .
> 
Okay, I'll try to implement these functionality based on devlink health.
