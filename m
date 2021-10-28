Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586B243DA14
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 06:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhJ1EHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 00:07:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53574 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJ1EHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 00:07:54 -0400
Received: from [IPV6:2620:137:e001:0:c663:d265:4cca:c19] (unknown [IPv6:2620:137:e001:0:c663:d265:4cca:c19])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id F00D04F69302C;
        Wed, 27 Oct 2021 21:05:26 -0700 (PDT)
Message-ID: <97a1d4b8-b6c1-8cfc-3978-6efd3e0925bd@eaglescrag.net>
Date:   Wed, 27 Oct 2021 21:05:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: Unsubscription Incident
Content-Language: en-MW
To:     Slade Watkins <slade@sladewatkins.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
 <YXY15jCBCAgB88uT@d3>
 <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
 <61f29617-1334-ea71-bc35-0541b0104607@pensando.io>
 <20211027123408.0d4f36f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61e27841-5ceb-1975-ab3b-abdf8973c9f2@eaglescrag.net>
 <CA+pv=HOyQHAzeYJwZmp_gncxj-iXmFL7kYowbYfwf1ntc64rgg@mail.gmail.com>
From:   John 'Warthog9' Hawley <warthog9@eaglescrag.net>
In-Reply-To: <CA+pv=HOyQHAzeYJwZmp_gncxj-iXmFL7kYowbYfwf1ntc64rgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 27 Oct 2021 21:05:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/21 17:27, Slade Watkins wrote:
> On Wed, Oct 27, 2021 at 4:42 PM John 'Warthog9' Hawley
> <warthog9@eaglescrag.net> wrote:
>>
>> On 10/27/21 12:34 PM, Jakub Kicinski wrote:
>>> On Mon, 25 Oct 2021 11:34:28 -0700 Shannon Nelson wrote:
>>>>>> It happened to a bunch of people on gmail:
>>>>>> https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u
>>>>> I can at least confirm that this didn't happen to me on my hosted
>>>>> Gmail through Google Workspace. Could be wrong, but it seems isolated
>>>>> to normal @gmail.com accounts.
>>>>>
>>>>> Best,
>>>>>
>>>>
>>>> Alternatively, I can confirm that my pensando.io address through gmail
>>>> was affected until I re-subscribed.
>>>
>>> Did it just work after re-subscribing again? Without cleaning the inbox?
>>> John indicated off list that Gmail started returning errors related to
>>> quota, no idea what that translates to in reality maybe they added some
>>> heuristic on too many emails from one source?
>>
>> At least for the users I've had anyone mention to me (which for the
>> record apparently this happened on the 11th, and people are only
>> reaching out now about), the reasons for the unsubscribe was that the
>> upstream servers were reporting that the users in question were over
>> quota permanently.  We take that hinting at face value, and since the
>> server is telling us (basically) that the user isn't going to be
>> accepting mail anytime soon, we go ahead and unsubscribe them and clear
>> the queue so that the users don't cause unnecessary back log.  Noting,
>> this is an automated process that runs and deals with this that runs
>> periodically.
>>
>> Also noting, that there's not a good way to notify individuals when this
>> happens because, unsurprisingly, their email providers aren't accepting
>> mail from us.
>>
>> If folks reach out to postmaster@ I'm more than happy to take a look at
>> the 'why' something happened, and I'm happy to re-subscribe folks in the
>> backend saving them the back and forth with majorodomo's command system.
>>
> 
> John,
> That's great.
> 
>>
>> If I had to speculate, something glitched at gmail, a subset of users
>> got an odd error code returned (which likely wasn't the correct error
>> code for the situation, and noting the number of affected users is
>> fairly small given the number of users from gmail that are subscribed).
>>   Likely similar to when gmail had that big outage and it reported
>> something way off base and as a result every gmail user got unsubscribed
>> (and subsequently resubscribed in the backend by me when the outage was
>> over).
>>
> 
> Is there any way to detect if something like that affects Google
> Workspace hosted inboxes too? Sounds like those in that group who were
> affected were very few though but I thought I'd ask anyway.

Looking back around then it looks like a few individual users might have 
been, but it's sporadic on the domains that aren't gmail.com, so it 
doesn't look like (to what I can see anyway) it was a full worksapce for 
instance.

The real problem is the error that was getting kicked back was a generic 
enough error, that's it's hard to tell what users may have actually been 
over quota vs. something else.

- John 'Warthog9' Hawley
