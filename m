Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041C5301B4A
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 11:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbhAXK4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 05:56:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726560AbhAXK4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 05:56:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611485686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jg/MMD3ppMA2CP0HbF4fNM0hbiIyr6unKvNIY/Ca9CQ=;
        b=AOq9YOcZ4WBwwPP/ddxIKWEVA/Sr7lRCmGdC/XsBfCY8AGafXIPTg7bx8FZYMRZN0xau5I
        mUcNZspEvzp5MXe5i0JbmDtOkwvpO0Bte1gbBQekCsD/ATGG68PHxS+k/BsqSXEIiLyf2R
        QdmRguVxrlC32y8btmMz2qjQjGoVCwg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-cQQxdMndM52lqc3leeG54w-1; Sun, 24 Jan 2021 05:54:42 -0500
X-MC-Unique: cQQxdMndM52lqc3leeG54w-1
Received: by mail-ed1-f71.google.com with SMTP id q12so848504edr.2
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 02:54:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jg/MMD3ppMA2CP0HbF4fNM0hbiIyr6unKvNIY/Ca9CQ=;
        b=i+ybx/C3WrNy6+dK4FlMcAu5lG/whPRbEbeHok+hK1IQ1VIErfSDUt9epXbSMtR90o
         X3k9xgHpZXu55QjswwyOgFB6y2LhEpBktHeDQ9DNgSodEki5QX+nnELytIhRf0VuQfyP
         Bk2cUeLyG6gmhAYyM2BlF2FbQPmMnORd0F2IiOlzHSfXLQacsrziZ9jcGQfCIgbshoxZ
         jKnSvkUq+73UUG+rPLKkx99gaYnv1HtUIsQa/KI1r3lDcQXyWqoR1DcKJIF/yeqq7lHi
         q9HpuL73JrMz65edlDVdf+sq1lxAJqBoncyOu7DPOdUpYlo8ujcCCsCxwnB4sstu2vXR
         EPxw==
X-Gm-Message-State: AOAM532eeKYl1jlGhA1QZ0ATe9dxFN7TOCeTqpgWt+4uVGS9g+upq3yg
        XIrvNgdi4rYoPcFnZW59zkBGo2mQ671G63/NaRpYsHeBhRetAfSbm7JedBUG0F1xdr7iBy3Uleb
        wwD8rUeRnvXBNkbsQ
X-Received: by 2002:a50:da8b:: with SMTP id q11mr1101122edj.352.1611485680990;
        Sun, 24 Jan 2021 02:54:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycbey/UfEsjUZwK5k6NM43pHiIsZqqRSRgdZMmaBNuDVE2tKEnXnD+E9KsLLan3Pkf0XmrCA==
X-Received: by 2002:a50:da8b:: with SMTP id q11mr1101112edj.352.1611485680822;
        Sun, 24 Jan 2021 02:54:40 -0800 (PST)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-37a3-353b-be90-1238.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:37a3:353b:be90:1238])
        by smtp.gmail.com with ESMTPSA id e22sm6869120ejd.79.2021.01.24.02.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 02:54:40 -0800 (PST)
Subject: Re: pull-request: mac80211 2021-01-18.2
To:     "Peer, Ilan" <ilan.peer@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
References: <20210118204750.7243-1-johannes@sipsolutions.net>
 <77c606d4-a78a-1fa3-5937-b270c3d0bbd3@redhat.com>
 <b83f6cf001c4e3df97eeaed710b34fda0a08265f.camel@sipsolutions.net>
 <BN7PR11MB2610052E380E676ED5CCCC67E9BE9@BN7PR11MB2610.namprd11.prod.outlook.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <348210d8-6940-ca8d-e3b1-f049330a2087@redhat.com>
Date:   Sun, 24 Jan 2021 11:54:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <BN7PR11MB2610052E380E676ED5CCCC67E9BE9@BN7PR11MB2610.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/24/21 10:12 AM, Peer, Ilan wrote:
>> -----Original Message-----
>> From: Johannes Berg <johannes@sipsolutions.net>
>> Sent: Sunday, January 24, 2021 00:16
>> To: Hans de Goede <hdegoede@redhat.com>; netdev@vger.kernel.org
>> Cc: linux-wireless@vger.kernel.org; Peer, Ilan <ilan.peer@intel.com>;
>> Coelho, Luciano <luciano.coelho@intel.com>
>> Subject: Re: pull-request: mac80211 2021-01-18.2
>>
>> On Sat, 2021-01-23 at 22:31 +0100, Hans de Goede wrote:
>>>
>>> So I'm afraid that I have some bad news about this patch, it fixes the
>>> RCU warning which I reported:
>>>
>>> https://lore.kernel.org/linux-wireless/20210104170713.66956-1-hdegoede
>>> @redhat.com/
>>>
>>> But it introduces a deadlock. See:
>>>
>>> https://lore.kernel.org/linux-wireless/d839ab62-e4bc-56f0-d861-f172bf1
>>> 9c4b3@redhat.com/
>>>
>>> for details. Note we really should fix this new deadlock before 5.11
>>> is released. This is worse then the RCU warning which this patch fixes.
>>
>> Ouch. Thanks for the heads-up. I guess I'll revert both patches for now,
>> unless we can quickly figure out a way to get all these paths in order.
>>
> 
> Thanks Hans and Johannes for handling this. I'll try to come up with a solution.

Great, thank you for looking into this. Let me know if you have a patch
which you want me to test on a RTL8723BS adapter.

One thing which I forgot to mention earlier, it is not just lockdep complaining
this appears to be a real deadlock, the wifi no longer functions, where
as it does function with the patch drops.

Regards,

Hans

