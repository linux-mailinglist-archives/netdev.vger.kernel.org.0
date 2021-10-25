Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0280439E93
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhJYSg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbhJYSgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:36:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375D8C061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:34:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o4-20020a17090a3d4400b001a1c8344c3fso108388pjf.3
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mIcdTGZ3rsUpwCZEML9x2jvGcR+XEeriRfVZJXhhAZA=;
        b=nW/KzMI2E8QqufpO9gPgMPqYJTJ+YVwGLgwzJAMibewhinPVSWxRDqVFpDHJuQxk3F
         DHgt+QsV746HzclLELOw4LFpr6SC1r6PrrVgSdoP1BJM/PrTLKglmhKcC5B31olWzUU8
         z4ruOiRLxMffksOunh8l7e23BuBVLeH2LVScn4nfL76s2iz2bTuAVBKwn2gtSHA/dEun
         CmXQJfb2rSpIHjZmGucO1yQl7J8ys+0MKPYw4yAiPCC5+ZYlJR8R5kgXjHzqSN72gqmL
         flyqMlO1jU/TNjet7oQlejbYO7kDhX2dt0p7tZ9oQRNRkcwi8sBEEl5P2xEfuCZ/uSQg
         MNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mIcdTGZ3rsUpwCZEML9x2jvGcR+XEeriRfVZJXhhAZA=;
        b=pyTrwxS1R8FFm2uSteqTzjf6jTZ8/4yxGWIzltGJnAvN/CIkrC3XZBPF9mb06GBYc8
         OAi+XsDt/C1/RxRDBxl1w746kIhfkhcVpIpCJN0ie6UWPKr5AIURKy1YRDl1ewBC34ad
         4hx9W1m3iEDQmCE5TZkW9dC0ER1usZ3ibhH/Iws0jlHkVr0RNY4jlkatKXiGA8eDx+oZ
         9k19nR2D4W+xXGCvyRbJdLsw+VvgAogCWCcF9/Yz7B4XVIkU9NhZU7seZV8KRgkjN6U4
         HVO3HRa7XHOThbSzDeiy/uObYID3dGcYk0M9p9qgoyqIXPPaw5pCURS7gFdXvGHcTM9s
         ZEcw==
X-Gm-Message-State: AOAM5333cEpw4QnEYCM3rF0yVnCId+8tJYGh8I3idbsDTdI5tRQWRY1+
        DSMh9GACGHsPJ0M5ocOVv5Qq4A==
X-Google-Smtp-Source: ABdhPJxpeC0Y/A0jR6aWhQGeZ2F9EtTzdtyD9y7y3skZRpvvFwG7BaaToBWnDlXGMWKTWhegTGI7vA==
X-Received: by 2002:a17:902:8a90:b0:13f:ee6e:cc59 with SMTP id p16-20020a1709028a9000b0013fee6ecc59mr17987183plo.75.1635186870579;
        Mon, 25 Oct 2021 11:34:30 -0700 (PDT)
Received: from [192.168.0.14] ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id i5sm17141664pgo.36.2021.10.25.11.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 11:34:30 -0700 (PDT)
Message-ID: <61f29617-1334-ea71-bc35-0541b0104607@pensando.io>
Date:   Mon, 25 Oct 2021 11:34:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: Unsubscription Incident
Content-Language: en-US
To:     Slade Watkins <slade@sladewatkins.com>,
        Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
 <YXY15jCBCAgB88uT@d3>
 <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
From:   Shannon Nelson <snelson@pensando.io>
In-Reply-To: <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/21 10:04 AM, Slade Watkins wrote:
> On Mon, Oct 25, 2021 at 12:43 AM Benjamin Poirier
> <benjamin.poirier@gmail.com> wrote:
>> On 2021-10-22 18:54 +0300, Vladimir Oltean wrote:
>>> On Fri, 22 Oct 2021 at 18:53, Lijun Pan <lijunp213@gmail.com> wrote:
>>>> Hi,
>>>>
>>>>  From Oct 11, I did not receive any emails from both linux-kernel and
>>>> netdev mailing list. Did anyone encounter the same issue? I subscribed
>>>> again and I can receive incoming emails now. However, I figured out
>>>> that anyone can unsubscribe your email without authentication. Maybe
>>>> it is just a one-time issue that someone accidentally unsubscribed my
>>>> email. But I would recommend that our admin can add one more
>>>> authentication step before unsubscription to make the process more
>>>> secure.
>>>>
>>>> Thanks,
>>>> Lijun
>>> Yes, the exact same thing happened to me. I got unsubscribed from all
>>> vger mailing lists.
>> It happened to a bunch of people on gmail:
>> https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u
> I can at least confirm that this didn't happen to me on my hosted
> Gmail through Google Workspace. Could be wrong, but it seems isolated
> to normal @gmail.com accounts.
>
> Best,
>               -slade

Alternatively, I can confirm that my pensando.io address through gmail 
was affected until I re-subscribed.
sln



