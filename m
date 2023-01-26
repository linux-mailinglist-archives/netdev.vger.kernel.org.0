Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCED67C58E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 09:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjAZIML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 03:12:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56870 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjAZIMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 03:12:10 -0500
Received: from [IPV6:2620:137:e001:0:a10c:af48:696f:8164] (unknown [IPv6:2620:137:e001:0:a10c:af48:696f:8164])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id EFF2283ED027;
        Thu, 26 Jan 2023 00:12:09 -0800 (PST)
Message-ID: <9539b880-642d-9ac5-ccfa-2b237548f4fc@kernel.org>
Date:   Thu, 26 Jan 2023 00:12:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] net: dsa: mt7530: fix tristate and help description
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, erkin.bozoglu@xeront.com
References: <20230125053653.6316-1-arinc.unal@arinc9.com>
 <20230125224411.5a535817@kernel.org>
 <dd21bd3d-b3bb-c90b-8950-e71f4af6b167@kernel.org>
 <1f0e41f4-edf8-fcb5-9bb6-5b5163afa599@arinc9.com>
 <56b25571-6083-47d6-59e9-259a36dab462@kernel.org>
 <c4b65e0d-ce10-1fa4-d468-ba50a5441778@arinc9.com>
From:   John 'Warthog9' Hawley <warthog9@kernel.org>
In-Reply-To: <c4b65e0d-ce10-1fa4-d468-ba50a5441778@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 26 Jan 2023 00:12:10 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/2023 11:48 PM, Arınç ÜNAL wrote:
> On 26.01.2023 10:45, John 'Warthog9' Hawley wrote:
>> On 1/25/2023 11:34 PM, Arınç ÜNAL wrote:
>>> On 26.01.2023 10:23, John 'Warthog9' Hawley wrote:
>>>> On 1/25/2023 10:44 PM, Jakub Kicinski wrote:
>>>>> On Wed, 25 Jan 2023 08:36:53 +0300 Arınç ÜNAL wrote:
>>>>>> Fix description for tristate and help sections which include 
>>>>>> inaccurate
>>>>>> information.
>>>>>>
>>>>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>>
>>>>> Didn't make it thru to the list again :(
>>>>> Double check that none of the addresses in To: or Cc: are missing
>>>>> spaces between name and email or after a dot. That seems to be the 
>>>>> most
>>>>> common cause of trouble. Or try to resend using just emails, no names.
>>>>>
>>>>
>>>> You are also likely to run into trouble if your character set is set 
>>>> to UTF-8.
>>>
>>> I think that may be the problem here. I just resent this with only 
>>> Jakub and the lists without names. It didn't make it to netdev. My 
>>> name includes non-Latin characters. I'm not sure how I can change 
>>> UTF-8 to something else that works with this list. I had no such 
>>> issues with linux-mediatek.
>>>
>>> Arınç
>>>
>>
>> So dug it out of the logs, you aren't running into UTF-8 issues, so 
>> that's good.  However your mail client is appending 'Delivered-To:' to 
>> the messages, which is a significant indicator of some weird mail 
>> problem for lists, I.E. why is a message that's been delivered being 
>> passed back through to the list, which is on the published taboo list:
>>
>> http://vger.kernel.org/majordomo-taboos.txt
>>
>> What are you using to send these messages, as that's a header I 
>> absolutely wouldn't expect to be on messages heading to vger?
> 
> It's just git send-email on git version 2.37.2. Zoho is doing the 
> hosting & SMTP.
> 
> Arınç
> 

Best I can suggest for testing is try sending the patch series to only 
the following 2 e-mail addresses:
	to: testing@vger.kernel.org
	cc: warthog9@eaglescrag.net

That will cut out more or less everything in the interim and might get 
me a better look at the series.

Only other thing I can think of is how is git send-email configured? 
Where the 'Delivered-To:' header is in the headers makes me think that 
it's added somewhere in what zoho is doing, which doesn't particularly 
make any sense, as that would imply you are sending it to yourself and 
then it passes it on?

I'll admit zoho is one of the mail providers that has a tendency to 
reject a lot of mail coming from vger and has been unresponsive to any 
queries I've made on that front (though I'll note your domain is not on 
the list of domains that are having problems there).  Only other thing I 
could suggest is pinging zoho technical support and asking them what's 
up, as that's a very odd header to have there.

- John 'Warthog9' Hawley
