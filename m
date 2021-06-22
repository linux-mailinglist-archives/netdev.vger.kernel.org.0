Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E0E3B10D8
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhFVX75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhFVX7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:59:36 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A15BC061767
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:57:14 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so254211otl.0
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 16:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D7+Up0CAAEZefc0Jamt+N5dptYxDIjwoUqn3slEq9v8=;
        b=Uy8cIxxtYAZbCKj3TUvARfA/lfKk6q1FwvIaBsuekhRHoCalqRzIIN6LHT5Nc5z0wh
         JMsCO4WSbgq5Xdc0HmW+Zi/GoSdjBPho9KVkVNdsmgE5Nwm1l6QnXtHkv3fCJ7tE7TeO
         ttFafoyBn2N/F0Q42Nd1ZT5/kcE5iNDJTwbog=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D7+Up0CAAEZefc0Jamt+N5dptYxDIjwoUqn3slEq9v8=;
        b=PN9cyOTvBByxRgulCe8zlACiXXon9sTjNtlnesoVenxWXBUV/s+WGGhEYd0xhxCH9A
         LWD7kXk2dFkhAGZ8+n6EFbFphc0xlFGezBPZGfbWEBrn8bCRmf1AosRUmdBdc8vaibi4
         KW6FEt4x7BiTmnuVd8IeZwotgh5vSC+nUIMmHw0u2MsZvPHHGzJWQ3uKoAFa4wDmcnyL
         CLEoLNPugWrWEEAdcTV5H298/gEgLZCTMJULvn8SeAL+vKXceC+WzAMNSFBUi6uKhfG0
         ZrOOauh1+cIUSW1jAqTnspm19iInxEI8R0K5uTxwyMQOADvZo/EYUMkOyDSPK8CHN9bP
         7QVg==
X-Gm-Message-State: AOAM531g/FW+QCdTMD7Kr3oEEV/j7CMbS2coz4IkBfzTV7RGgvzwpycH
        ZExUXziwjYV61SE+a7cvHJ2Waw==
X-Google-Smtp-Source: ABdhPJxo0abcmkMh0h846zDctUjCWzZmT87/FjmvbdhTt7cXD01Nv+hfcB0Y5TTvGRv9BDiZnkMR9A==
X-Received: by 2002:a9d:585:: with SMTP id 5mr5446428otd.12.1624406233379;
        Tue, 22 Jun 2021 16:57:13 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r14sm4544855oie.43.2021.06.22.16.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 16:57:13 -0700 (PDT)
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Greg KH <greg@kroah.com>, Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <YK+esqGjKaPb+b/Q@kroah.com>
 <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
 <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
 <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
 <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
 <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
 <20210610152633.7e4a7304@oasis.local.home>
 <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
 <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
 <ae51f636-8fb5-20b7-bbc5-37e22edb9a02@linuxfoundation.org>
 <YNJrZIMs7RvqRBSG@pendragon.ideasonboard.com>
 <3bfbe45c-2356-6db0-e1b8-11b7e37ae858@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <66fce207-2602-6452-9216-01ebde656bcd@linuxfoundation.org>
Date:   Tue, 22 Jun 2021 17:57:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <3bfbe45c-2356-6db0-e1b8-11b7e37ae858@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/21 5:33 PM, Shuah Khan wrote:
> On 6/22/21 4:59 PM, Laurent Pinchart wrote:
>> Hi Shuah,
>>
>> On Tue, Jun 22, 2021 at 04:33:22PM -0600, Shuah Khan wrote:
>>> On 6/18/21 7:46 AM, Laurent Pinchart wrote:
>>>> On Thu, Jun 10, 2021 at 01:55:23PM -0600, Shuah Khan wrote:
>>>>> On 6/10/21 1:26 PM, Steven Rostedt wrote:
>>>>>> On Thu, 10 Jun 2021 21:39:49 +0300 Laurent Pinchart wrote:
>>>>>>
>>>>>>> There will always be more informal discussions between on-site
>>>>>>> participants. After all, this is one of the benefits of 
>>>>>>> conferences, by
>>>>>>> being all together we can easily organize ad-hoc discussions. 
>>>>>>> This is
>>>>>>> traditionally done by finding a not too noisy corner in the 
>>>>>>> conference
>>>>>>> center, would it be useful to have more break-out rooms with A/V
>>>>>>> equipment than usual ?
>>>>>>
>>>>>> I've been giving this quite some thought too, and I've come to the
>>>>>> understanding (and sure I can be wrong, but I don't think that I am),
>>>>>> is that when doing a hybrid event, the remote people will always be
>>>>>> "second class citizens" with respect to the communication that is 
>>>>>> going
>>>>>> on. Saying that we can make it the same is not going to happen unless
>>>>>> you start restricting what people can do that are present, and that
>>>>>> will just destroy the conference IMO.
>>>>>>
>>>>>> That said, I think we should add more to make the communication 
>>>>>> better
>>>>>> for those that are not present. Maybe an idea is to have break outs
>>>>>> followed by the presentation and evening events that include remote
>>>>>> attendees to discuss with those that are there about what they might
>>>>>> have missed. Have incentives at these break outs (free stacks and
>>>>>> beer?) to encourage the live attendees to attend and have a 
>>>>>> discussion
>>>>>> with the remote attendees.
>>>>>>
>>>>>> The presentations would have remote access, where remote attendees 
>>>>>> can
>>>>>> at the very least write in some chat their questions or comments. If
>>>>>> video and connectivity is good enough, perhaps have a screen where 
>>>>>> they
>>>>>> can show up and talk, but that may have logistical limitations.
>>>>>>
>>>>>
>>>>> You are absolutely right that the remote people will have a hard time
>>>>> participating and keeping up with in-person participants. I have a
>>>>> couple of ideas on how we might be able to improve remote experience
>>>>> without restricting in-person experience.
>>>>>
>>>>> - Have one or two moderators per session to watch chat and Q&A to 
>>>>> enable
>>>>>      remote participants to chime in and participate.
>>>>> - Moderators can make sure remote participation doesn't go 
>>>>> unnoticed and
>>>>>      enable taking turns for remote vs. people participating in 
>>>>> person.
>>>>>
>>>>> It will be change in the way we interact in all in-person sessions for
>>>>> sure, however it might enhance the experience for remote attendees.
>>>>
>>>> A moderator to watch online chat and relay questions is I believe very
>>>> good for presentations, it's hard for a presenter to keep an eye on a
>>>> screen while having to manage the interaction with the audience in the
>>>> room (there's the usual joke of the difference between an introvert and
>>>> an extrovert open-source developer is that the extrovert looks at 
>>>> *your*
>>>> shoes when talking to you, but in many presentations the speaker
>>>> nowadays does a fairly good job as watching the audience, at least from
>>>> time to time :-)).
>>>>
>>>> For workshop or brainstorming types of sessions, the highest barrier to
>>>> participation for remote attendees is local attendees not speaking in
>>>> microphones. That's the number one rule that moderators would need to
>>>> enforce, I think all the rest depends on it. This may require a larger
>>>> number of microphones in the room than usual.
>>>>
>>>
>>> Absolutely. Moderator has to make sure the following things happen for
>>> this to be effective:
>>>
>>> - Watch chat and Q&A, Raise hand from remote participants
>>> - Enforce some kind of taking turns to allow fairness in
>>>     participation
>>> - Have the speaker repeat questions asked in the room (we do that now
>>>     in some talks - both remote and in-person - chat and Q&A needs
>>>     reading out for recording)
>>> - Explore live Transcription features available in the virtual conf.
>>>     platform. You still need humans watching the transcription.
>>> - Have a running session notes combined with transcription.
>>>
>>> Any of these options aren't sustainable when large number of people
>>> are participating remotely or in-person. In general a small number of
>>> people participate either in person or remote in any case, based on
>>> my observation in remote and in-person settings.
>>>
>>> Maybe we can experiment with one or two workshops this time around
>>> and see how it works out. If we can figure an effective way, it would
>>> be beneficial for people that can't travel for one reason or the
>>> other.
>>
>> Can we nominate moderators ahead of time ? For workshop-style
>> discussions, they need to be a person who won't participate actively in
>> the discussions, as it's impossible to both contribute and moderate at
>> the same time.
>>
> 
> Correct. It will be impossible to participate and moderate in workshop
> setting. We have to ask for volunteers and nominate moderators ahead of
> time.
> 

Subsystems could seek volunteers from other subsystems perhaps ...

thanks,
-- Shuah
