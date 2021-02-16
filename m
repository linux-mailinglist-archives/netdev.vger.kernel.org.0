Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5F131CD2A
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 16:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBPPtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 10:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhBPPtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 10:49:09 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FF1C061574;
        Tue, 16 Feb 2021 07:48:26 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id b16so6943345otq.1;
        Tue, 16 Feb 2021 07:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=APA6hwAnvuXF3RbI64Y0Of01r1EHRcUtK6WRrMWbpdo=;
        b=j5wHba3jekPQRt4pm7L8dP9oq/WBiw0K/IrWjDxzLlC+pr6qLxjVzk7lqMjqwtoVzt
         +eCm8FGbql0TQACJNAMmm1TQslcDfRayxd/QEEFG+R03SshdlnO21luWMcbzyfbfh4vj
         D0Zq86WBRj5XRyb2YLStKVPW1C3cAJb7xrQr5aeU/xu/55qJ95rQqoPdA+Qdj8P3YENT
         1U/eDPcDN6tGesau5c2Ks2K25H96yyjFWV+AQn78gyxWhuXEHVVC4ApXL8yjt7dpuaHB
         IYu3y2vF8wv4rNoruboZB6hc64QADhcgjZ/EhU2YQSpBz2grGrNagEe4oNeB8caxierm
         Paxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=APA6hwAnvuXF3RbI64Y0Of01r1EHRcUtK6WRrMWbpdo=;
        b=pZ9HJbHM+D6wgMLIFgb+rh68U8evDT9oY4gzQI7RWN1WPwAdLIF1qLXGqQ74EE72ls
         2rINSqDNYd4AetYgmOKpyQ1L93ZtBS2uy6/+h3KHc8lvExkk6aUXHe/rvGH6N3qyad9T
         EV7DiuNtS76oWgloqNvfOQdnrYIyQIogIt2YjMiQYyW/8bfOPATJuT8vm1l64Pdyj5vl
         5r0SELUFSuZnR5PdsUFassCD6oJgQmhitrVFyMl4fCNkkMVBzPwEPyUAXHASIKYKTTRY
         Z3qo1gpk4NCxGLN2tmCzaM9aLgrsmR+vBtcD4xXSMKT5l6waSGY68ssjtwc7hjYCdnbB
         TppA==
X-Gm-Message-State: AOAM530W9Sulg60J/gb8UBQxCQItdv6/ypy3qUTnTtLK70EqOG0X47F9
        QxomvD+poqaKuArz1ra0xEwQw+3UdL8=
X-Google-Smtp-Source: ABdhPJypDSINLM94ZPi9PJDmgYlqYnZau1VLBcNG6it0kaqS6Oj25LHnHsNiUrb+RiwfyI96yJOxGg==
X-Received: by 2002:a9d:578a:: with SMTP id q10mr16318869oth.114.1613490506020;
        Tue, 16 Feb 2021 07:48:26 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id h23sm1546967oie.20.2021.02.16.07.48.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 07:48:25 -0800 (PST)
Subject: Re: [PATCH iproute2-rc] rdma: Fix statistics bind/unbing argument
 handling
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20210214083335.19558-1-leon@kernel.org>
 <5e9a8752-24a1-7461-e113-004b014dcde9@gmail.com> <YCoJULID1x2kulQe@unreal>
 <04d7cd07-c3eb-c39c-bce1-3e9d4d1e4a27@gmail.com> <YCtjO1Q2OnCOlEcu@unreal>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9217385b-6002-83c2-b386-85650ce101bc@gmail.com>
Date:   Tue, 16 Feb 2021 08:48:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YCtjO1Q2OnCOlEcu@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/21 11:16 PM, Leon Romanovsky wrote:
> On Mon, Feb 15, 2021 at 06:56:26PM -0700, David Ahern wrote:
>> On 2/14/21 10:40 PM, Leon Romanovsky wrote:
>>> On Sun, Feb 14, 2021 at 08:26:16PM -0700, David Ahern wrote:
>>>> what does iproute2-rc mean?
>>>
>>> Patch target is iproute2.git:
>>> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/
>>
>> so you are asking them to be committed for the 5.11 release?
> 
> This is a Fix to an existing issue (not theoretical one), so I was under
> impression that it should go to -rc repo and not to -next.

It is assigned to Stephen for iproute2.

> 
> Personally, I don't care to which repo will this fix be applied as long
> as it is applied to one of the two iproute2 official repos.
> 
> Do you have clear guidance when should I send patches to iproute2-rc/iproute2-next?
> 

It's the rc label that needs to be dropped: iproute2 or iproute2-next.
Just like there is net and net-next.
