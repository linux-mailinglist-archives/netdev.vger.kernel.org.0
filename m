Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0675D37076F
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 15:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhEANl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 09:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhEANl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 09:41:57 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB82C06174A
        for <netdev@vger.kernel.org>; Sat,  1 May 2021 06:41:06 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id u25so1468495ljg.7
        for <netdev@vger.kernel.org>; Sat, 01 May 2021 06:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=RodplBs7snHB6ziU56Pb1VudTK0ma992dJ5M/fbIlwI=;
        b=RO21o+FbSvryfD7tkvFCV8YQQwPKCCykdUpB+euNV0jtRCrIlLQQ6NEokl631kjKWx
         hivQ9ONtupr9fjRkinc6DZTYTdFy388lyGq7JQt8oiD0auoYzLkUgx4KsZfttgFkFqhJ
         ReBPyHyh1THqKDxYRPa95nIA1JDlwH2WgXP6SscXvYEOJuEh0nSCqxurCKJ2o3YDw30d
         f/b4AXvi6oTWJ/MitC/luR3hEq8cOPR6MUQcq9NqHgMvY4AvTvHNVmIr7G1zFHFYDDS6
         XKnzo8xPgr5yN/zHNaFIqwuaZObNWCXGuFdC/tRtQHRCu9jvY8lRTb+1gM5SDdjaoRuD
         /1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=RodplBs7snHB6ziU56Pb1VudTK0ma992dJ5M/fbIlwI=;
        b=NvUFjcbvhffWmqoeh5x7eJhA6zcsCXceIa1rki/pSxQGvK+Wjy3/MPGEmV5skjmmmR
         LomQtKXmktFSJe1oRybf6xE+O9LsA8dM2Lte5YoRdrhS6kZIBCIHAtmrxwHB1CwsFTvP
         ZsFR8liL2dmxXyqzDdG2gbZ/O+cyvjinrBwl+alkG6MOp9/vFh1BW0L3c80SDq9/PsaG
         /U7SNW+iZA1WD7E/86jBPxGCDvI8oFRMJifzjx6gSkR7UUCAQfDj5lY7I4M30A8FrMwI
         neQRpSSBo5OZv92MkmoNIiJ2MRXfFlt3mYatO9ji0o3yPkypk7n5GpGq2/T5kGh8d9VC
         kvzg==
X-Gm-Message-State: AOAM533tTsjELahop8uxvrg9ePmFVxv2T4NjYXDilxqe3UmF3kPR3Jtq
        FNmvJ3Iyuop8rKnWvm0bjQVxSBgBQSY=
X-Google-Smtp-Source: ABdhPJwsM4oGkVDPw/Bj5UwkOR5QhY1o41ma3/0hvOgr5QXeeMTVyLbtozilEAu23Q+lkLOsrHeRew==
X-Received: by 2002:a05:651c:293:: with SMTP id b19mr5311675ljo.451.1619876463558;
        Sat, 01 May 2021 06:41:03 -0700 (PDT)
Received: from [192.168.0.91] ([188.242.181.97])
        by smtp.googlemail.com with ESMTPSA id u22sm566616ljk.6.2021.05.01.06.41.02
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 01 May 2021 06:41:02 -0700 (PDT)
Message-ID: <608D5CA3.7020700@gmail.com>
Date:   Sat, 01 May 2021 16:50:27 +0300
From:   Nikolai Zhubr <zhubr.2@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To:     Johannes Berg <johannes@sipsolutions.net>
CC:     Chris Snook <chris.snook@gmail.com>, netdev@vger.kernel.org
Subject: Re: A problem with "ip=..." ipconfig and Atheros alx driver.
References: <608BF122.7050307@gmail.com>                 (sfid-20210430_135009_123201_5C9D80DA) <419eea59adc7af954f98ac81ec41a7be9cc0d9bb.camel@sipsolutions.net>        <608C3B2C.8040005@gmail.com> (sfid-20210430_190603_013225_96A76113) <acd09ebe17b438fad20d4863dfece84144b5e027.camel@sipsolutions.net> <608C9A57.5010102@gmail.com>
In-Reply-To: <608C9A57.5010102@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

01.05.2021 3:01, I wrote:
[...]
>> https://p.sipsolutions.net/5adbe659fb061f06.txt
>
> Is it supposed to work correctly for unmodified 5.12 kernel? Because it

Success! I've found an apparently missing mutex_unlock() in alx_probe() 
just before the "return 0" line. With that inserted, your patch indeed 
fixes the 120 s boot delay here. And the link apparenly also works fine 
after boot, in normal operation.
Can it be somehow reviewed and submitted unstream please?
I'd like it also ported to 4.xx then. (Maybe I can port myself though)
(Very happy!)


Thank you,

Regards,
Nikolai
