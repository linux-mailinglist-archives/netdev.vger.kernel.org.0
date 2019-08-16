Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95A98FD7A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfHPIPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:15:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34660 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725945AbfHPIPk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:15:40 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E5605258566DB8E4E9ED;
        Fri, 16 Aug 2019 16:15:33 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 16 Aug 2019
 16:15:25 +0800
Subject: Re: [PATCH] arm64: do_csum: implement accelerated scalar version
To:     Will Deacon <will.deacon@arm.com>
References: <20190218230842.11448-1-ard.biesheuvel@linaro.org>
 <d7a16ebd-073f-f50e-9651-68606d10b01c@hisilicon.com>
 <20190412095243.GA27193@fuggles.cambridge.arm.com>
 <41b30c72-c1c5-14b2-b2e1-3507d552830d@arm.com>
 <20190515094704.GC24357@fuggles.cambridge.arm.com>
 <440eb674-0e59-a97e-4a90-0026e2327069@hisilicon.com>
 <20190815164609.GI2015@fuggles.cambridge.arm.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <ilias.apalodimas@linaro.org>,
        "huanglingyan (A)" <huanglingyan2@huawei.com>,
        <steve.capper@arm.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <37fbc2a3-069d-9f75-f3d0-3eda2efa5c9b@hisilicon.com>
Date:   Fri, 16 Aug 2019 16:15:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20190815164609.GI2015@fuggles.cambridge.arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

On 2019/8/16 0:46, Will Deacon wrote:
> On Thu, May 16, 2019 at 11:14:35AM +0800, Zhangshaokun wrote:
>> On 2019/5/15 17:47, Will Deacon wrote:
>>> On Mon, Apr 15, 2019 at 07:18:22PM +0100, Robin Murphy wrote:
>>>> On 12/04/2019 10:52, Will Deacon wrote:
>>>>> I'm waiting for Robin to come back with numbers for a C implementation.
>>>>>
>>>>> Robin -- did you get anywhere with that?
>>>>
>>>> Still not what I would call finished, but where I've got so far (besides an
>>>> increasingly elaborate test rig) is as below - it still wants some unrolling
>>>> in the middle to really fly (and actual testing on BE), but the worst-case
>>>> performance already equals or just beats this asm version on Cortex-A53 with
>>>> GCC 7 (by virtue of being alignment-insensitive and branchless except for
>>>> the loop). Unfortunately, the advantage of C code being instrumentable does
>>>> also come around to bite me...
>>>
>>> Is there any interest from anybody in spinning a proper patch out of this?
>>> Shaokun?
>>
>> HiSilicon's Kunpeng920(Hi1620) benefits from do_csum optimization, if Ard and
>> Robin are ok, Lingyan or I can try to do it.
>> Of course, if any guy posts the patch, we are happy to test it.
>> Any will be ok.
> 
> I don't mind who posts it, but Robin is super busy with SMMU stuff at the
> moment so it probably makes more sense for you or Lingyan to do it.

Thanks for restarting this topic, I or Lingyan will do it soon.

Thanks,
Shaokun

> 
> Will
> 
> .
> 

