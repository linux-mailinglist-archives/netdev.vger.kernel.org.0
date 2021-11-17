Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3732453F56
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhKQES5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhKQES5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 23:18:57 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD5FC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 20:15:59 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id o15-20020a9d410f000000b0055c942cc7a0so2345850ote.8
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 20:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xWqTH1RstVYTGuS4Vj0YJf/DNrjplEcQgUfE7e5VoLk=;
        b=DZ7Jp3lsao83Vp0NnRmqXfoEJ6XhX96khr2Nm5Nn6BwyBHtqUsiPvyuKIDa1ExW22+
         artyRnXDjFW+JyHJ5v6liDvRhDmECRgG8Tc6G/wDDWqHma0FLrwOO1iqOWscq8HymU9w
         yWk/IyO3LWfwWg79hEoU3OcJexD8w/yivBG5yLnVgRA+C1BOXLErNp0eDidwE5cZ9MUb
         k6cnrAYBuBaZYsXPmqtWIrZccZLOLtU5mGMTWlxdYyC8QpX67lbHIQDhGM1fsd3klJCs
         wLqt8GIq7T0CfmPbPjQHSPYhIMDhP908cSBb4G7AXgPSo9Jhvd0ZoXfdxv3Il+3xkwrc
         BJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xWqTH1RstVYTGuS4Vj0YJf/DNrjplEcQgUfE7e5VoLk=;
        b=Wqc2IelgRy25ecOHGHczk6s4HjPIK7Qk1uBJ79esj5uHnBGp9zHlwi/xnu41vGdp28
         Riy5TzGAM/9/43DkHMOcnbTfCbJf3n1rm252dfGgSadKeHsarwMi2rjPI61NWwkMUenm
         4KXzOEikkJIJUvHMCHpbUNGCqWNfm4tLUpOcehE0u/jYHcZh7T4XWd6fMJ5GeeGBkHfo
         EsEvBXpB4uyZCZ6kncQBREbe47+PH7Avxs2ssbTVJkCWDvI0i3pwGBsDHCMWvjcEI54t
         TBtBMPOCEgjP+c1ibdRUqHUD5Sa67B9LbtLR7pqIMBExaH9kJmxKCb+ZN8Ou/YrvtXOQ
         8Qsw==
X-Gm-Message-State: AOAM531FbaoArrb7cenSJ8AIt/lxu+c94FspYQCd2F8z30o4372A2HjE
        s6Dk7DmdZNoJf708H4fhtLc=
X-Google-Smtp-Source: ABdhPJwcD9CyU+VzGKFMKeZG5rltUYpF8DWD2mJWqZj/DEAkbDHcfUufsRfi1lTVOfSKszzBLE5QDA==
X-Received: by 2002:a05:6830:1358:: with SMTP id r24mr11167238otq.8.1637122558917;
        Tue, 16 Nov 2021 20:15:58 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id j5sm721481ots.68.2021.11.16.20.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 20:15:58 -0800 (PST)
Message-ID: <d83d3013-0a06-b633-fded-b563fa52b200@gmail.com>
Date:   Tue, 16 Nov 2021 21:15:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [Patch net v3 2/2] selftests: add a test case for rp_filter
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-3-xiyou.wangcong@gmail.com>
 <YYuObqtyYUuWLarX@Laptop-X1>
 <CAM_iQpV99vbCOZUj_9chHt8TXeiXqbvwKW7r8T9t1hpTa79qdQ@mail.gmail.com>
 <YZR0y7J/MeYD9Hfm@Laptop-X1>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YZR0y7J/MeYD9Hfm@Laptop-X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/21 8:19 PM, Hangbin Liu wrote:
> On Sun, Nov 14, 2021 at 09:08:41PM -0800, Cong Wang wrote:
>>> Hi Wang Cong,
>>>
>>> Have you tried this test recently? I got this test failed for a long time.
>>> Do you have any idea?
>>>
>>> IPv4 rp_filter tests
>>>     TEST: rp_filter passes local packets                                [FAIL]
>>>     TEST: rp_filter passes loopback packets                             [FAIL]
>>
>> Hm, I think another one also reported this before, IIRC, it is
>> related to ping version or cmd option. Please look into this if
>> you can, otherwise I will see if I can reproduce this on my side.
> 
> I tried both iputils-s20180629 and iputils-20210722 on 5.15.0. All tests
> failed. Not sure where goes wrong.
> 

no idea. If you have the time can you verify that indeed the failure is
due to socket lookup ... ie., no raw socket found because of the bind to
device setting. Relax that and it should work which is indicative of the
cmsg bind works but SO_BINDTODEVICE does not.
