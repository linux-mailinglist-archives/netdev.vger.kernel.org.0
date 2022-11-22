Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5626337E6
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiKVJGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbiKVJGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:06:13 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2765018E01;
        Tue, 22 Nov 2022 01:06:12 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NGdZR21JWzJnnW;
        Tue, 22 Nov 2022 17:02:55 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:06:09 +0800
Subject: Re: [PATCH -next] Bluetooth: Fix Kconfig warning for BT_HIDP
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <jkosina@suse.cz>, <gregkh@linuxfoundation.org>,
        <benjamin.tissoires@redhat.com>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221122034246.24408-1-yuehaibing@huawei.com>
 <29fb52c0-155b-470e-10d5-5e3b2451272d@molgen.mpg.de>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <aa9f5313-df1f-bc9c-8fee-ed8b77099e17@huawei.com>
Date:   Tue, 22 Nov 2022 17:06:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <29fb52c0-155b-470e-10d5-5e3b2451272d@molgen.mpg.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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


On 2022/11/22 16:31, Paul Menzel wrote:
> Dear YueHaibing,
> 
> 
> Thank you for your patch.
> 
> 
> Am 22.11.22 um 04:42 schrieb YueHaibing:
> 
> Maybe use the more specific summary below:
> 
> Bluetooth: Add HID_SUPPORT dependency for BT_HIDP
> 
>> commit 25621bcc8976 add HID_SUPPORT, and HID depends on it now.
> 
> add*s*
> 
> or
> 
> Commit 25621bcc8976 ("HID: Kconfig: split HID support and hid-core compilation") introduces the new Kconfig symbol HID_SUPPORT …
> 
> 

Thanks for your review, v2 is on the way.

> Kind regards,
> 
> Paul
> 
> 
>> Add HID_SUPPORT dependency for BT_HIDP to fix the warning:
>>
>> WARNING: unmet direct dependencies detected for HID
>>    Depends on [n]: HID_SUPPORT [=n]
>>    Selected by [m]:
>>    - BT_HIDP [=m] && NET [=y] && BT_BREDR [=y] && INPUT [=m]
>>
>> Fixes: 25621bcc8976 ("HID: Kconfig: split HID support and hid-core compilation")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>   net/bluetooth/hidp/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
>> index 14100f341f33..6746be07e222 100644
>> --- a/net/bluetooth/hidp/Kconfig
>> +++ b/net/bluetooth/hidp/Kconfig
>> @@ -1,7 +1,7 @@
>>   # SPDX-License-Identifier: GPL-2.0-only
>>   config BT_HIDP
>>       tristate "HIDP protocol support"
>> -    depends on BT_BREDR && INPUT
>> +    depends on BT_BREDR && INPUT && HID_SUPPORT
>>       select HID
>>       help
>>         HIDP (Human Interface Device Protocol) is a transport layer
> 
> .
