Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F6C284BC5
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 14:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgJFMlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 08:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgJFMlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 08:41:01 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92656C061755;
        Tue,  6 Oct 2020 05:41:01 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id y198so10074661qka.0;
        Tue, 06 Oct 2020 05:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JaPcxTzHOUYSQCnzELOojEKcjmTrX8LESVFQagjWhck=;
        b=HOJNvrVoZQZdk40LnRGQYDH8TyQKVGQFHrekgmxL28a1RKktojXVKlLt1v8A8tobgQ
         rzStEJ0fXQged/50vnIu6n39N3w4LJa0JqDJry21gsqWlpo+Mepm57yCt/TZPoWZXepH
         5zz3r2F5xZkfdPP9Wr6oRk6rYhASD5kLXXgKhe4sTfbAVCAj7/JLCJtF11g92FjMO1o9
         xx/KZMH6WlbLfhNIeZGEQwJ4GmE7oprcBjMMzZOujky1aFZYuPQUNimZI/4NbewQF/SZ
         pbD/JylWg/DKZnZwLe/hcG4wKrtaffvKDtIZsGJHkC7FJtGEsquZTPEoP+Q2wQkI79Dv
         uqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JaPcxTzHOUYSQCnzELOojEKcjmTrX8LESVFQagjWhck=;
        b=KFOZbJvt74HANy1FV6YuocyUxCiqKvECnlrn3IvdyB7VJh/7AM5NJ2uSZXR5kJ9bo/
         5JmY2n/GqekYwQ4buxKUg4uT9KybLK3BlOpoQ/0BG7F3EMGIDN0zUnoTJobAKR+ADN01
         VxNW929E8bf2wgMoOgABDFjFnV4eZTdfjK1/CkjKGIDy4KSdYMtNzoJ8b58qJLEdg9AG
         OEFKCNPJ0MrNdX9G4ftfFQ76YovKg68H5Y0pGI3lHKf1cO6FlJiGJgoaqC582xcq39F0
         aWleTNSxj4x3FKwqtCTsPCFf4yMwvuylfGbhg+SFYQzCtAfOUbC/hZeyqIf0eQIiE4xE
         W4RQ==
X-Gm-Message-State: AOAM533bWu+T9wutHRv9BTUYCPfqcjJAfy5I57RrfVArK70Rcc/S+UXV
        VjJTI8oMt3qiUUZyAM9Wh6M=
X-Google-Smtp-Source: ABdhPJzwWbtY06hLKwxuR0LFgyHV8RZT87PYv1SxqOJUhSGqN46nXcpIwo0odOCSItAMJ740qHzxvQ==
X-Received: by 2002:a37:5144:: with SMTP id f65mr5193131qkb.351.1601988060707;
        Tue, 06 Oct 2020 05:41:00 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:1102::1844? ([2620:10d:c091:480::1:e46d])
        by smtp.gmail.com with ESMTPSA id s3sm203856qkj.27.2020.10.06.05.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 05:40:59 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [RFC] Status of orinoco_usb
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20201002103517.fhsi5gaepzbzo2s4@linutronix.de>
 <20201002113725.GB3292884@kroah.com>
 <20201002115358.6aqemcn5vqc5yqtw@linutronix.de>
 <20201002120625.GA3341753@kroah.com> <877ds4damx.fsf@codeaurora.org>
 <0c67580b-1bed-423b-2f00-49eae20046aa@broadcom.com>
Message-ID: <7f6e7c37-b7d6-1da4-6a3d-257603afd2ae@gmail.com>
Date:   Tue, 6 Oct 2020 08:40:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <0c67580b-1bed-423b-2f00-49eae20046aa@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/20 3:45 AM, Arend Van Spriel wrote:
> + Jes
> 
> On 10/5/2020 4:12 PM, Kalle Valo wrote:
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>
>>> On Fri, Oct 02, 2020 at 01:53:58PM +0200, Sebastian Andrzej Siewior
>>> wrote:
>>>> On 2020-10-02 13:37:25 [+0200], Greg Kroah-Hartman wrote:
>>>>>> Is it possible to end up here in softirq context or is this a relic?
>>>>>
>>>>> I think it's a relic of where USB host controllers completed their
>>>>> urbs
>>>>> in hard-irq mode.  The BH/tasklet change is a pretty recent change.
>>>>
>>>> But the BH thingy for HCDs went in v3.12 for EHCI. XHCI was v5.5. My
>>>> guess would be that people using orinoco USB are on EHCI :)
>>>
>>> USB 3 systems run XHCI, which has a USB 2 controller in it, so these
>>> types of things might not have been noticed yet.  Who knows :)
>>>
>>>>>> Should it be removed?
>>>>>
>>>>> We can move it out to drivers/staging/ and then drop it to see if
>>>>> anyone
>>>>> complains that they have the device and is willing to test any
>>>>> changes.
>>>>
>>>> Not sure moving is easy since it depends on other files in that folder.
>>>> USB is one interface next to PCI for instance. Unless you meant to move
>>>> the whole driver including all interfaces.
>>>> I was suggesting to remove the USB bits.
>>>
>>> I forgot this was tied into other code, sorry.  I don't know what to
>>> suggest other than maybe try to fix it up the best that you can, and
>>> let's see if anyone notices...
>>
>> That's what I would suggest as well.
>>
>> These drivers for ancient hardware are tricky. Even if there doesn't
>> seem to be any users on the driver sometimes people pop up reporting
>> that it's still usable. We had that recently with one another wireless
>> driver (forgot the name already).
> 
> Quite a while ago I shipped an orinoco dongle to Jes Sorensen which he
> wanted to use for some intern project if I recall correctly. Guess that
> idea did not fly yet.

I had an outreachy intern who worked on some of it, so I shipped all my
Orinoco hardware to her. We never made as much progress as I had hoped,
and I haven't had time to work on it since.

Cheers,
Jes

