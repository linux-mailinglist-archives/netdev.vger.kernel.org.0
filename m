Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9BD23144F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgG1U5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgG1U5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:57:10 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8691AC061794;
        Tue, 28 Jul 2020 13:57:10 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id x12so7481560qtp.1;
        Tue, 28 Jul 2020 13:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1yMXU7EUKMHdsvH7lxAwoxCrPaR32XiwKJGHLWTSuNU=;
        b=sdPm3Ndt2+q1V6uWLmFekiouxlxUukz1wDUIfraNAYzs30GhV65xEyvMzHJRBihduI
         HmxZMZz+s7H6zj3aeCeC2/tE4mQ4TjpREqpEfyzSuA1brjWmHqCxCq2Qm16RQeJAAQJX
         JhwJP+TgQZ5G1yChTvtIOwGCx+x3rgOwq3v8NtofCCtg80EIA4V/OnncHdy2wCaeOGiY
         BvQ0wO2xNspwnrmZCcPqHZGVKH/DBKZharqcfop9rNwQ2MuuEAMqpXZWjC3iX6sS9QHI
         K436UPZhOIbD4lwwIs1F8/LSDc5g3r4B0tnewAEcmoTksanOGy4qGHTlkn0wvlS4W8lI
         H+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1yMXU7EUKMHdsvH7lxAwoxCrPaR32XiwKJGHLWTSuNU=;
        b=Nhid3/JsxrtYM8MLHLJR1BfILl4TRXzyUR0J7s+n8y3yu/rpiedrU7nimtvLZXQlzU
         egCZUXGME8CSlKlMeU08olztQlDkzgEJ1OsjMgCR5KnL+ZXGw3TnwJpcAyISbSvNvyo5
         xOZdvbof9+ABESO7bxcYL748Ypl75BEHqmMoYDIUCHjBY4AHpf8tvd4ZEjtKDD1axWdd
         j7Ffwnxd78nVm2KhdO+gEGpQVu+UGtkm3dqhOOXvzjT278nYwmzs8LaIPgumFzPXQiEu
         KkOLbYeA16nWZf10hsYerq/tHqO/krek0y3Gz20tjCtEE7DEUxBth0HDGdemFdzFD8dd
         dE5g==
X-Gm-Message-State: AOAM5335CIzR79u1OaXJ1ArKulPntW6q9ucnz/TlmB90CHNoablwVxnY
        iqQ2P9l+epDpUuR/AWjA4Ys=
X-Google-Smtp-Source: ABdhPJxzdv8TPmKbqDuUUlm0LGyjTWA5VeiTvrejO3QJvbuHOL6J/tB0JkWL7zWiuc/Akugi/+cReA==
X-Received: by 2002:ac8:a41:: with SMTP id f1mr26896254qti.89.1595969829786;
        Tue, 28 Jul 2020 13:57:09 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c842:646d:48fc:f7aa? ([2601:284:8202:10b0:c842:646d:48fc:f7aa])
        by smtp.googlemail.com with ESMTPSA id n68sm24641164qkd.89.2020.07.28.13.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2020 13:57:08 -0700 (PDT)
Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
Cc:     bimmy.pujari@intel.com, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, mchehab@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, ashkan.nikravesh@intel.com
References: <20200727233431.4103-1-bimmy.pujari@intel.com>
 <CAEf4BzYMaU14=5bzzasAANJW7w2pNxHZOMDwsDF_btVWvf9ADA@mail.gmail.com>
 <CANP3RGd2fKh7qXyWVeqPM8nVKZRtJrJ65apmGF=w9cwXy6TReQ@mail.gmail.com>
 <CAEf4BzaiCZ3rOBc0EXuLUuWh9m5QXv=51Aoyi5OHwb6T11nnjw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9e9ca486-f6f5-2301-8850-8f53429b160e@gmail.com>
Date:   Tue, 28 Jul 2020 14:57:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaiCZ3rOBc0EXuLUuWh9m5QXv=51Aoyi5OHwb6T11nnjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/20 12:28 PM, Andrii Nakryiko wrote:
> In some, yes, which also means that in some other they can't. So I'm
> still worried about misuses of REALCLOCK, within (internal daemons
> within the company) our outside (BCC tools and alike) of data centers.
> Especially if people will start using it to measure elapsed time
> between events. I'd rather not have to explain over and over again
> that REALCLOCK is not for measuring passage of time.

Why is documenting the type of clock and its limitations not sufficient?
Users are going to make mistakes and use of gettimeofday to measure time
differences is a common one for userspace code. That should not define
or limit the ability to correctly and most directly do something in bpf.

I have a patch to export local_clock as bpf_ktime_get_fast_ns. It too
can be abused given that it has limitations (can not be used across CPUs
and does not correlate to any exported clock), but it too has important
use cases (twice as fast as bpf_ktime_get_ns and useful for per-cpu
delta-time needs).

Users have to know what they are doing; making mistakes is part of
learning. Proper documentation is all you can do.
