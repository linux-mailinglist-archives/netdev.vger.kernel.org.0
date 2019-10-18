Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADCDDBB23
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 02:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439199AbfJRA6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 20:58:06 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48012 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726259AbfJRA6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 20:58:06 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A2C61EE21AE6CDFCD053;
        Fri, 18 Oct 2019 08:58:02 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 18 Oct 2019
 08:57:56 +0800
Subject: Re: [PATCH net-next 00/12] net: hns3: add some bugfixes and
 optimizations
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
 <20191016101943.415d73cf@cakuba.netronome.com>
 <20191016.135003.672960397161023411.davem@davemloft.net>
 <d76b854c-5f6d-27b6-d40e-e3c0404b5695@huawei.com>
 <20191017084743.1a5875ff@cakuba.netronome.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <f7a5ea3c-c0b3-4f90-43e4-2aade8593c10@huawei.com>
Date:   Fri, 18 Oct 2019 08:57:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20191017084743.1a5875ff@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/17 23:47, Jakub Kicinski wrote:
> On Thu, 17 Oct 2019 11:27:09 +0800, tanhuazhong wrote:
>> On 2019/10/17 1:50, David Miller wrote:
>>> From: Jakub Kicinski <jakub.kicinski@netronome.com>
>>> Date: Wed, 16 Oct 2019 10:19:43 -0700
>>>    
>>>> On Wed, 16 Oct 2019 15:16:59 +0800, Huazhong Tan wrote:
>>>>> This patch-set includes some bugfixes and code optimizations
>>>>> for the HNS3 ethernet controller driver.
>>>>
>>>> The code LGTM, mostly, but it certainly seems like patches 2, 3 and 4
>>>> should be a separate series targeting the net tree :(
>>>
>>> Agreed, there are legitimate bug fixes.
>>>
>>> I have to say that I see this happening a lot, hns3 bug fixes targetting
>>> net-next in a larger series of cleanups and other kinds of changes.
>>>
>>> Please handle this delegation properly.  Send bug fixes as a series targetting
>>> 'net', and send everything else targetting 'net-next'.
>>>    
>>
>> Hi, David & Jakub.
>>
>> BTW, patch01 is a cleanup which is needed by patch02,
>> if patch01 targetting 'net-next', patch02 targetting 'net',
>> there will be a gap again. How should I deal with this case?
> 
> You'll need to reorder the cleanup so that the fixes apply to the
> unmodified net tree.
> 
> Then preferably wait for the net tree to be merged back to net-next
> before posting the cleanup that'd conflict.  If the conflict is not
> too hard to resolve you can just post the net-next patches and give
> some instructions on how to resolve the merge conflict under the ---
> lines in the commit message.
> 

ok, thanks.

> .
> 

