Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513D730E316
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 20:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhBCTIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 14:08:48 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.21]:13528 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhBCTIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 14:08:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1612379088;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
        From:Subject:Sender;
        bh=vnuPGdqqISQYz9i9yG4JwhcjsBtN1NGznXFOHqH7VFM=;
        b=msLt/599JycnkucklwKiSC5SO/wWUeGTlQRFVoVgZ8mTbrTnocUhtf4eJdiwq5+iSq
        ErYZJoNS09HsTL7aOWcnIe7vsqKwOPyqOomvz/Pxqf4/mvaMqi91eeYXb1g7le0C7wBr
        EQJkbY1+59L3uRryxgwq8L3LhV7vX/w92z3y4jno9kmg51tqLTcCNhF0ZIIVVHwBGwfx
        sd8/RNDKA3BiaC4LKD7cv8FDlFl4fD9CSjqP8ylZGM0925ldx/1ZlcXX8/raFlmB6nzq
        12hascy2Hlhjer59RoqGZys54jM+1USnZdmHCxxQTPuPaniALN+26ocMvQaqil51YvRn
        UN2w==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMGUMh5mURM"
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 47.16.0 DYNA|AUTH)
        with ESMTPSA id w076a1x13J4lO14
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 3 Feb 2021 20:04:47 +0100 (CET)
Subject: Re: [PATCH RESEND iproute2 5.11] iplink_can: add Classical CAN frame
 LEN8_DLC support
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
References: <20210125104055.79882-1-socketcan@hartkopp.net>
 <b835a46c-f950-6c58-f50f-9b2f4fd66b46@gmail.com>
 <d8ba08c4-a1c2-78b8-1b09-36c522b07a8c@hartkopp.net>
 <586c2310-17ee-328e-189c-f03aae1735e9@gmail.com>
 <fe697032-88f2-c1f1-8afc-f4469a5f3bd5@hartkopp.net>
 <1bf605b4-70e5-e5f2-f076-45c9b52a5758@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <dccf261d-6cc3-f79a-8044-f0800c88108d@hartkopp.net>
Date:   Wed, 3 Feb 2021 20:04:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <1bf605b4-70e5-e5f2-f076-45c9b52a5758@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03.02.21 16:47, David Ahern wrote:
> On 2/2/21 10:30 AM, Oliver Hartkopp wrote:
>>
>>
>> On 02.02.21 16:35, David Ahern wrote:
>>> On 2/2/21 3:48 AM, Oliver Hartkopp wrote:
>>>>
>>>> Are you sure this patch is correctly assigned to iproute2-next?
>>>>
>>>> IMO it has to be applied to iproute2 as the functionality is already in
>>>> v5.11 which is in rc6 right now.
>>>>
>>>
>>> new features land in iproute2-next just as they do for the kernel with
>>> net-next.
>>>
>>> Patches adding support for kernel features should be sent in the same
>>> development window if you want the iproute2 support to match kernel
>>> version.
>>>
>>
>> Oh, I followed the commits from iproute2 until the new include files
>> from (in this case) 5.11 pre rc1 had been updated (on 2020-12-24):
>>
>> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=2953235e61eb672bbdd2de84eb5b91c388f9a9b5
>>
>>
>> I thought the uapi updates in iproute2 are *always* pulled from the
>> kernel and not from iprout2-next which was new to me.
> 
> I sync kernel headers for iproute2-next with net-next, not linux-next.

Ok. Got it.

>>
>> Do you expect patches for iproute2-next when the relevant changes become
>> available in linux-next then?
>>
>> Even though I did not know about iproute2-next the patch is needed for
>> the 5.11 kernel (as written in the subject).
>>
> 
> 
>  From a cursory look it appears CAN commits do not go through the netdev
> tree yet the code is under net/can and the admin tool is through
> iproute2 and netdevs. Why is that? If features patches flowed through
> net-next, we would not have this problem.

CAN commits go through linux-can-next -> net-next. Same for linux-can -> 
net.

The len8_dlc patches also went through linux-can-next -> net-next -> net 
-> linux

iproute2 provides the configuration interface for CAN drivers under 
driver/net/can only.

My only fault was, that I did not send the patch for iproute2-next at 
the time when the len8_dlc patches were in net-next, right?

I was just not aware of iproute2-next.

The former patches I posted for iproute2 were always applied by Stephen 
to the iproute2 tree directly.

Regards,
Oliver
