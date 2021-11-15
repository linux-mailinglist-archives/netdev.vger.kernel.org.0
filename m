Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7581445093D
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhKOQKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbhKOQJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:09:56 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8EDC061208
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:06:52 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id q25so30229550oiw.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2daD3ZB5RRSPMtCIfVP6vXWT0sbo6IGM8cl9T2YYA6A=;
        b=cQ/8Wjy3DisvffjGw7oaVkhWLxWlULIYEpGPHKdtiQIRcqPy2ei3LiGlFoZ714A6/3
         j9IzVtAr2SBfYsNa8Sp7eYHefbdPFULii7p2oK+0DKFCK+ipdn3dMIqYHWTWliTK8lzd
         x7ZCWl0nsBDLXIUy3eY4itHsJU+XaC9nmxDlczq6SkBhlJtosqN7pU1X12K7Q3yHVN84
         685xp63wBtXpljl1flSXl3ZDECO6+rZ2vRvdHvXpzy9Ng4tUKZ0ZnVxm+D/wOD2bUSsQ
         fiSIhrAmXvyaKrCEmKGXXYRt5VhNeVoERI8FGV4jRysxWc5u9lF97CWejhUhP0PCXiVc
         sIpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2daD3ZB5RRSPMtCIfVP6vXWT0sbo6IGM8cl9T2YYA6A=;
        b=ASP+/Lx/3PW/4K9kE0FyWX4etMi14UO3CENX2KAN7mBDLleXy1qm9qmB89ET7pOeyx
         Mf6Y3dVcvYqbGGeYSd9zgdVt4Fujq1Oaj79Q/hF/z6TDN96q6AcdWN9vzDgeOwBx3ruo
         BwKAcFcBYeHbodDL6FEP8fS6/2dFjwxgd2O7joWrBNWiIdGVDrmCvohb7u7UnWvPcRKm
         dUDAluTBqmbQo4wD4LAYtG7pwqz/bTaUD//I++LuI1VVy4XBubyCo8Vc3dvsXRQmrFOe
         iXGxF2tSCtzAbp5ruJDdGKJ3pyRZx0BZQ8hDnSUR1jun/x6RJEFiubzttX5d95kGapRO
         FqhA==
X-Gm-Message-State: AOAM5331yJDLep7FoVXxJo43pDAY4kK4btaLLOHvyPWA+f4+h5SfFryD
        B3P0LqDqUVj755wT3GhtMKA=
X-Google-Smtp-Source: ABdhPJzeQf02N8+lw1XQTa/YFV2i1AmuFyQLJdxubpB8u2e72gsPLgL4D3N52/w6Lt4/VptlZBA+9g==
X-Received: by 2002:aca:ab84:: with SMTP id u126mr45116014oie.41.1636992411724;
        Mon, 15 Nov 2021 08:06:51 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id j187sm3188314oih.5.2021.11.15.08.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 08:06:51 -0800 (PST)
Message-ID: <50364490-9e86-a26e-3a56-78459b3b5151@gmail.com>
Date:   Mon, 15 Nov 2021 09:06:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [Patch net v3 2/2] selftests: add a test case for rp_filter
Content-Language: en-US
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-3-xiyou.wangcong@gmail.com>
 <YYuObqtyYUuWLarX@Laptop-X1>
 <CAM_iQpV99vbCOZUj_9chHt8TXeiXqbvwKW7r8T9t1hpTa79qdQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CAM_iQpV99vbCOZUj_9chHt8TXeiXqbvwKW7r8T9t1hpTa79qdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/21 10:08 PM, Cong Wang wrote:
> On Wed, Nov 10, 2021 at 1:18 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>>
>> On Wed, Jul 17, 2019 at 02:41:59PM -0700, Cong Wang wrote:
>>> Add a test case to simulate the loopback packet case fixed
>>> in the previous patch.
>>>
>>> This test gets passed after the fix:
>>>
>>> IPv4 rp_filter tests
>>>     TEST: rp_filter passes local packets                                [ OK ]
>>>     TEST: rp_filter passes loopback packets                             [ OK ]
>>
>> Hi Wang Cong,
>>
>> Have you tried this test recently? I got this test failed for a long time.
>> Do you have any idea?
>>
>> IPv4 rp_filter tests
>>     TEST: rp_filter passes local packets                                [FAIL]
>>     TEST: rp_filter passes loopback packets                             [FAIL]
> 
> Hm, I think another one also reported this before, IIRC, it is
> related to ping version or cmd option. Please look into this if
> you can, otherwise I will see if I can reproduce this on my side.
> 

The test does 'ping -I dummy1'. As I recall newer version of ping uses
SO_BINDTODEVICE vs cmsg to specify the device binding. The setsockopt is
stronger and I bet the socket lookup is failing. If that is the case,
the test needs to be fixed because it will never pass again.
