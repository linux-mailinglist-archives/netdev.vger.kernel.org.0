Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782A863382D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiKVJSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiKVJSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:18:15 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C2E43AEA;
        Tue, 22 Nov 2022 01:18:13 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NGdvW4mv2zRpTQ;
        Tue, 22 Nov 2022 17:17:43 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:18:11 +0800
Subject: Re: [PATCH -next] Bluetooth: Fix Kconfig warning for BT_HIDP
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jkosina@suse.cz>, <gregkh@linuxfoundation.org>,
        <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221122034246.24408-1-yuehaibing@huawei.com>
 <29fb52c0-155b-470e-10d5-5e3b2451272d@molgen.mpg.de>
 <CAO-hwJKraiox13k=ukXOhSNt9sTc6Q0KpGR5=AHDknZeR6omwA@mail.gmail.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <ee09680a-899c-96c8-778d-0af04d6d59ee@huawei.com>
Date:   Tue, 22 Nov 2022 17:18:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAO-hwJKraiox13k=ukXOhSNt9sTc6Q0KpGR5=AHDknZeR6omwA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/11/22 17:06, Benjamin Tissoires wrote:
> Hi,
> 
> On Tue, Nov 22, 2022 at 9:37 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>>
>> Dear YueHaibing,
>>
>>
>> Thank you for your patch.
>>
>>
>> Am 22.11.22 um 04:42 schrieb YueHaibing:
>>
>> Maybe use the more specific summary below:
>>
>> Bluetooth: Add HID_SUPPORT dependency for BT_HIDP
>>
>>> commit 25621bcc8976 add HID_SUPPORT, and HID depends on it now.
>>
>> add*s*
>>
>> or
>>
>> Commit 25621bcc8976 ("HID: Kconfig: split HID support and hid-core
>> compilation") introduces the new Kconfig symbol HID_SUPPORT …
>>
>>
>> Kind regards,
>>
>> Paul
>>
>>
>>> Add HID_SUPPORT dependency for BT_HIDP to fix the warning:
>>>
>>> WARNING: unmet direct dependencies detected for HID
>>>    Depends on [n]: HID_SUPPORT [=n]
>>>    Selected by [m]:
>>>    - BT_HIDP [=m] && NET [=y] && BT_BREDR [=y] && INPUT [=m]
>>>
>>> Fixes: 25621bcc8976 ("HID: Kconfig: split HID support and hid-core compilation")
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>> ---
> 
> 
> FWIW, a fix is already in -next:
> https://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git/commit/?h=for-6.2/hid-bpf&id=6cc90ccd4f6cfed98e2a3a378debc69f28d57473

OK, thanks for your info.

> 
>  But thanks for the patch nonetheless!
> 
> Cheers,
> Benjamin
> 
>>
>>>   net/bluetooth/hidp/Kconfig | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
>>> index 14100f341f33..6746be07e222 100644
>>> --- a/net/bluetooth/hidp/Kconfig
>>> +++ b/net/bluetooth/hidp/Kconfig
>>> @@ -1,7 +1,7 @@
>>>   # SPDX-License-Identifier: GPL-2.0-only
>>>   config BT_HIDP
>>>       tristate "HIDP protocol support"
>>> -     depends on BT_BREDR && INPUT
>>> +     depends on BT_BREDR && INPUT && HID_SUPPORT
>>>       select HID
>>>       help
>>>         HIDP (Human Interface Device Protocol) is a transport layer
>>
> 
> .
> 
