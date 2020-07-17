Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D24522301D
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgGQAxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:53:01 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:52476 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726138AbgGQAxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:53:01 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 8054A632727EF276D8D9;
        Fri, 17 Jul 2020 08:52:59 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 17 Jul 2020 08:52:58 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 17 Jul 2020 08:52:58 +0800
Subject: Re: [PATCH net-next 2/2] hinic: add log in exception handling
 processes
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200716125056.27160-1-luobin9@huawei.com>
 <20200716125056.27160-3-luobin9@huawei.com>
 <20200716082710.22dd7c97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <f677003d-fff8-53f2-9564-eb2286614fdd@huawei.com>
Date:   Fri, 17 Jul 2020 08:52:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200716082710.22dd7c97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/7/16 23:27, Jakub Kicinski wrote:
> On Thu, 16 Jul 2020 20:50:56 +0800 Luo bin wrote:
>> improve the error message when functions return failure and dump
>> relevant registers in some exception handling processes
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> 
> For kernel builds with W=1 C=1 flags this patch adds 12 warnings to
> drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c and 39 warnings to 
> drivers/net/ethernet/huawei/hinic/hinic_hw_if.h.
> 
> It seems like you're missing byte swaps.
> .
> 
Will fix. Thank you!
