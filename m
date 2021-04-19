Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE94364A89
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 21:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241691AbhDST0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 15:26:32 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:48636 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230126AbhDST0b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 15:26:31 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lYZWp-0001It-Nq; Mon, 19 Apr 2021 21:25:51 +0200
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
 <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
 <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
 <1617763692.9857.7.camel@realtek.com>
 <1dc7e487-b97b-8584-47f7-37f3385c7bf9@lwfinger.net>
 <15737dcf-95ac-1ce6-a681-94ff5db968e4@maciej.szmigiero.name>
 <c5556a207c5c40ac849c6a0e1919baca@realtek.com>
 <220c4fe4-c9e1-347a-8cef-cd91d31c56df@maciej.szmigiero.name>
 <cfcc2988-3f20-3588-2f76-f04d09043811@maciej.szmigiero.name>
 <35249c6028f645a79c4186c9689ba8aa@realtek.com>
 <52f89f4f-568e-f04e-5c3e-e31f4a9e0910@lwfinger.net>
 <56d52ee8681a43aaa20924c5fa047bf0@realtek.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
Message-ID: <584036ac-f3d7-f6a1-3f4a-136c7af10b5a@maciej.szmigiero.name>
Date:   Mon, 19 Apr 2021 21:25:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <56d52ee8681a43aaa20924c5fa047bf0@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.04.2021 09:04, Pkshih wrote:
> 
>> -----Original Message-----
>> From: Larry Finger [mailto:larry.finger@gmail.com] On Behalf Of Larry Finger
>> Sent: Monday, April 19, 2021 9:23 AM
>> To: Pkshih; Maciej S. Szmigiero
>> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> johannes@sipsolutions.net; kvalo@codeaurora.org
>> Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
>>
>> On 4/18/21 7:32 PM, Pkshih wrote:
>>>
>>>> -----Original Message-----
>>>> From: Maciej S. Szmigiero [mailto:mail@maciej.szmigiero.name]
>>>> Sent: Sunday, April 18, 2021 2:08 AM
>>>> To: Pkshih
>>>> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>> johannes@sipsolutions.net; kvalo@codeaurora.org; Larry Finger
>>>> Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
>>>>
>>>> On 08.04.2021 21:04, Maciej S. Szmigiero wrote:
>>>>> On 08.04.2021 06:42, Pkshih wrote:
>>>>>>> -----Original Message-----
>>>>>>> From: Maciej S. Szmigiero [mailto:mail@maciej.szmigiero.name]
>>>>>>> Sent: Thursday, April 08, 2021 4:53 AM
>>>>>>> To: Larry Finger; Pkshih
>>>>>>> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>>>>>>> johannes@sipsolutions.net; kvalo@codeaurora.org
>>>>>>> Subject: Re: rtlwifi/rtl8192cu AP mode broken with PS STA
>>>>>>>
>>>>> (...)
>>>>>>>> Maceij,
>>>>>>>>
>>>>>>>> Does this patch fix the problem?
>>>>>>>
>>>>>>> The beacon seems to be updating now and STAs no longer get stuck in PS
>>>>>>> mode.
>>>>>>> Although sometimes (every 2-3 minutes with continuous 1s interval pings)
>>>>>>> there is around 5s delay in updating the transmitted beacon - don't know
>>>>>>> why, maybe the NIC hardware still has the old version in queue?
>>>>>>
>>>>>> Since USB device doesn't update every beacon, dtim_count isn't updated neither.
>>>>>> It leads STA doesn't awake properly. Please try to fix dtim_period=1 in
>>>>>> hostapd.conf, which tells STA awakes every beacon interval.
>>>>>
>>>>> The situation is the same with dtim_period=1.
>>>>>
>>>> (...)
>>>>
>>>> Ping-Ke,
>>>> are you going to submit your set_tim() patch so at least the AP mode is
>>>> usable with PS STAs or are you waiting for a solution to the delayed
>>>> beacon update issue?
>>>>
>>>
>>> I'm still trying to get a 8192cu, and then I can reproduce the symptom you
>>> met. However, I'm busy now; maybe I have free time two weeks later.
>>>
>>> Do you think I submit the set_tim() patch with your Reported-by and Tested-by first?
>>
>> PK,
>>
>> I would say yes. Get the fix in as soon as possible.
>>
> 
> I have sent a patch that only 8192cu, which is the only one USB device supported by rtlwifi,
> schedules a work to update beacon content to wifi card.
> 
> https://lore.kernel.org/linux-wireless/20210419065956.6085-1-pkshih@realtek.com/T/#u

Thanks, I have tested the patch and it seems to work as good as the previous one.
It definitely improves things.

However, it would be great to eventually fix the update delay issue, too.
It looks to me like possibly just a missing beacon queue flush.

> --
> Ping-Ke
> 

Maciej
