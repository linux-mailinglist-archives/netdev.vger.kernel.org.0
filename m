Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2CD2492F3
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 04:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgHSClf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 22:41:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:42994 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727063AbgHSClf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 22:41:35 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BC91DAA52303CB9EAE82;
        Wed, 19 Aug 2020 10:41:31 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.81) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 19 Aug 2020
 10:41:30 +0800
Subject: Re: [PATCH net] net: gemini: Fix missing free_netdev() in error path
 of gemini_ethernet_port_probe()
To:     David Miller <davem@davemloft.net>
CC:     <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <kuba@kernel.org>, <mirq-linux@rere.qmqm.pl>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200818134404.63828-1-wanghai38@huawei.com>
 <20200818.125401.958204660420531471.davem@davemloft.net>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <210d463e-e444-66a6-62f3-e39e0940d5f9@huawei.com>
Date:   Wed, 19 Aug 2020 10:41:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200818.125401.958204660420531471.davem@davemloft.net>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/8/19 3:54, David Miller Ð´µÀ:
> From: Wang Hai <wanghai38@huawei.com>
> Date: Tue, 18 Aug 2020 21:44:04 +0800
>
>> Fix the missing free_netdev() before return from
>> gemini_ethernet_port_probe() in the error handling case.
>>
>> Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> You can just convert this function to use 'devm_alloc_etherdev_mqs', which
> is a one line fix.
>
> .
Thanks for your advice, I just sent a v2 patch.
"[PATCH net v2] net: gemini: Fix missing free_netdev() in error path of 
gemini_ethernet_port_probe()"

