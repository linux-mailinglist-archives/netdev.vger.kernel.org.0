Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AA7249008
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHRVTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHRVTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:19:40 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC5CC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:19:39 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a5so19559309wrm.6
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 14:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1M9o6jNTGSqUTEZ7n9bG5IRFEil1hGA6YlL+EeSjHik=;
        b=nSrxnZY3gCZWVhX1Vbf5kNOvxZxXBgtuQTngfaAVqmZ2lBb0WQhftyUwo7oTjubxsB
         nifGdtg46PYCi/iGat3SfqyCbNtJf4vgmeE9X3tu97dq8CsITo6LDnEeMxeRtx7YeTs/
         NySXSQMtXsLz0f/2RFWZXpCRnG47/lUaMPfBdBRSJ087c3IrwabEeDb8nLKu0U02w4FO
         gxHfnreOFaCzJC5sBxBsIRv9NGlaHndF976i63o9zH1b5rhX+1G6bVXxzTxjqrJeMir1
         mHVaiHwenraLvIxFEOgwvQj/Q8kc94dv7noAoVkK506WJwU8jzs1sR24bAP8EGQAxN7n
         77yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1M9o6jNTGSqUTEZ7n9bG5IRFEil1hGA6YlL+EeSjHik=;
        b=XqyRm0vr7YPsWiP4i4L7YNmwsUODVdBx09O/tAQBbWUS78nzn+oRs7kTKpGdDkYC7V
         VIeF42R05K20H5u6u3p0t0UwxjWeMQPDJnOebXghAO96utRX1ZGr5IQe6wO48FxOtSRL
         HedFivkbwu2uKA8lU3T9exXidh3sZF1A/qmOBIHtxgHtVjfn24wdiMFEQbrZHN+Rr72W
         +SXJMCyYxS/6jWGDKO4Ad/GS8QUxEoG4qPQusBVH8EAV3lhfxoJVn+s66/8k82JUr4ts
         V/MidrOaDDseb3D6q8MpDaUmWAvlwBG0CprQeKN7h2TITWQ+5PDeeZ2iFc2j4kFEPYox
         DYIQ==
X-Gm-Message-State: AOAM531ZXnfnoGyM/zdwe9r6k+QafUlV+R7QDMojueWx5FEdghAQWcUy
        eXOi2T4T83I+k8Q50447nONM0YekE2nfZpzB06h9cA==
X-Google-Smtp-Source: ABdhPJxrigIfdnHvv4dl5XoCOgYKhBq6dA/rVOeNIUEVSW7OpIi9sjnSLfldxnsuaHQdTVMj35xroDf96rXdjixSkyw=
X-Received: by 2002:adf:9ed4:: with SMTP id b20mr1009430wrf.206.1597785576153;
 Tue, 18 Aug 2020 14:19:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzYMaU14=5bzzasAANJW7w2pNxHZOMDwsDF_btVWvf9ADA@mail.gmail.com>
 <C50F3QS9W4JM.1OIVL1ZHWEIWI@maharaja>
In-Reply-To: <C50F3QS9W4JM.1OIVL1ZHWEIWI@maharaja>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 18 Aug 2020 14:19:24 -0700
Message-ID: <CANP3RGcVidrH6Hbne-MZ4YPwSbtF9PcWbBY0BWnTQC7uTNjNbw@mail.gmail.com>
Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bimmy.pujari@intel.com, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, mchehab@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, ashkan.nikravesh@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 2:11 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> On Mon Jul 27, 2020 at 10:01 PM PDT, Andrii Nakryiko wrote:
> > On Mon, Jul 27, 2020 at 4:35 PM <bimmy.pujari@intel.com> wrote:
> > >
> > > From: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
> > >
> > > The existing bpf helper functions to get timestamp return the time
> > > elapsed since system boot. This timestamp is not particularly useful
> > > where epoch timestamp is required or more than one server is involved
> > > and time sync is required. Instead, you want to use CLOCK_REALTIME,
> > > which provides epoch timestamp.
> > > Hence add bfp_ktime_get_real_ns() based around CLOCK_REALTIME.
> > >
> >
> > This doesn't seem like a good idea. With time-since-boot it's very
> > easy to translate timestamp into a real time on the host.
>
> For bpftrace, we have a need to get millisecond-level precision on
> timestamps. bpf has nanosecond level precision via
> bpf_ktime_get[_boot]_ns(), but to the best of my knowledge userspace
> doesn't have a high precision boot timestamp.
>
> There's /proc/stat's btime, but that's second-level precision. There's
> also /proc/uptime which has millisecond-level precision but you need to
> make a second call to get current time. Between those two calls there
> could be some unknown delta. For millisecond we could probably get away
> with calculating a delta and warning on large delta but maybe one day
> we'll want microsecond-level precision.
>
> I'll probably put up a patch to add nanoseconds to btime (new field in
> /proc/stat) to see how it's received. But either this patch or my patch
> would work for bpftrace.
>
> [...]
>
> Thanks,
> Daniel

Not sure what problem you're trying to solve and thus what exactly you
need... but you can probably get something very very close with 1 or 2
of clock_gettime(CLOCK_{BOOTTIME,MONOTONIC,REALTIME}) possibly in a
triple vdso call sandwich and iterated a few times and picking the one
with smallest delta between 1st and 3rd calls.  And then assuming the
avg of 1st and 3rd matches the 2nd.
ie.

5 times do:
t1[i] = clock_gettime(REALTIME)
t2[i] = clock_gettime(BOOTTIME)
t3[i] = clock_gettime(REALTIME)

pick i so t3[i] - t1[i] is smallest

t2[i] is near equivalent to (t1[i] + t3[i]) / 2

which basically gives you a REAL to BOOT offset.
