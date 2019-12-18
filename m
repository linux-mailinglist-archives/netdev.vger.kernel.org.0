Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88936123C8A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 02:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfLRBk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 20:40:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:45774 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726463AbfLRBk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 20:40:29 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 77B0739E976E5CD87DCA;
        Wed, 18 Dec 2019 09:40:26 +0800 (CST)
Received: from [127.0.0.1] (10.67.103.228) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Dec 2019
 09:40:18 +0800
Subject: Re: [PATCH] net: hisilicon: Fix a BUG trigered by wrong bytes_compl
To:     David Miller <davem@davemloft.net>
References: <1576308182-121147-1-git-send-email-xiaojiangfeng@huawei.com>
 <20191217.134228.92517242104749153.davem@davemloft.net>
CC:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <leeyou.li@huawei.com>, <nixiaoming@huawei.com>
From:   Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Message-ID: <161c304b-46bd-0340-e0e3-3fb8b5a7cd5e@huawei.com>
Date:   Wed, 18 Dec 2019 09:40:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20191217.134228.92517242104749153.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.228]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/12/18 5:42, David Miller wrote:
> From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
> Date: Sat, 14 Dec 2019 15:23:02 +0800
> 
>> In addition, I adjusted the position of "count++;"
>> to make the code more readable.
> 
> This is an unrelated cleanup and should not be done in the same change
> as your bug fix, submit this if you like for net-next after net has next
> been merged into net-next.
> 
>>
>> Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
> 
> You need to provide an appropriate Fixes: tag.
> 
> .
I will provide an appropriate Fixes: tag in v2, thanks for your guidance.

