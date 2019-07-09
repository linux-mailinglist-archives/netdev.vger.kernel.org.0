Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D51B262D48
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfGIBHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:07:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2243 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbfGIBHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 21:07:31 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8F1A245A256F786BE060;
        Tue,  9 Jul 2019 09:07:28 +0800 (CST)
Received: from [127.0.0.1] (10.65.87.206) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 9 Jul 2019
 09:07:19 +0800
Subject: Re: [PATCH] net: hisilicon: Add an tx_desc to adapt HI13X1_GMAC
To:     David Miller <davem@davemloft.net>
References: <1562307003-103516-1-git-send-email-xiaojiangfeng@huawei.com>
 <20190707.221805.2104668553072088371.davem@davemloft.net>
 <20190708.111833.1002341757593028886.davem@davemloft.net>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <dingtianhong@huawei.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <xiekunxun@huawei.com>,
        <jianping.liu@huawei.com>, <nixiaoming@huawei.com>
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Message-ID: <89adc83e-c789-9c61-222b-23110778a873@huawei.com>
Date:   Tue, 9 Jul 2019 09:07:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20190708.111833.1002341757593028886.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.87.206]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/9 2:18, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sun, 07 Jul 2019 22:18:05 -0700 (PDT)
> 
>> From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
>> Date: Fri, 5 Jul 2019 14:10:03 +0800
>>
>>> HI13X1 changed the offsets and bitmaps for tx_desc
>>> registers in the same peripheral device on different
>>> models of the hip04_eth.
>>>
>>> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
>>
>> Applied.
> 
> Actually I didn't apply this because I can't see that HI13X1_GMAC
> kconfig knob anywhere in the tree at all.
> 

Thank you for your guidance, I made a mistake, for which I am
sincerely sorry for wasting your time.

I will submit the correct one again.
I will not make this low-level mistake again.

Thanks,
Jiangfeng Xiao



