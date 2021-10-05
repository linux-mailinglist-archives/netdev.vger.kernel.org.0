Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171EC4230E0
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhJEToX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbhJEToW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:44:22 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B9CC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 12:42:31 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d8so848642edx.9
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 12:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+8SNQ/BUCGUuug/KneYCQ18TWuSycJxPe40EryL3As8=;
        b=IsMRmg3op1/W/FJCoSqfcYl8D6JZHanQtR20HmWJnZI5KPL33yHrD/CjvkGoVoi6KH
         33ajyvHQCKw9c/eANvr6FnieU+KeVuHxIqMNn8IrlBI2CBWZRy3IN+o9a44JHWvaXmgG
         sQLzRRus5aLRTM+iqm9v67n5STspxcuxGmVsSCzxzxLVHGJcRWFf0tSeY89FvXx/3Cd4
         H0yKTk7l5lk1oWrw6sWcdFxyO49Ld937EqhQ6eOFAk8RqSaaybrrRAhEGych25Ce7iQe
         nS9HYRgYvD6sY5+lTIDGqBmzdYMb0sG+VeSKW4ffOogz0iBntObkiV2j7znEwmag5+IW
         01Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+8SNQ/BUCGUuug/KneYCQ18TWuSycJxPe40EryL3As8=;
        b=dUOuTALPr5mH1V46M9Z8qGHiigHYut2jstmweHiABIEiKzqtTvpwloPE7QDmWfyUFO
         NWuyTzdavJYiRtJJ6zxk6ahiuSUlfcQEBh3nWj5CCSkjz62S52IS4gumd2Rh6uKwXdaa
         Eua+VFFHbvKHAus+o4lG/2JogvR7lC02BuEBh1koiMT/5dLqx0zdBvGaxdnhtmzTGj64
         HaQkY++845urr62BGWezlSaqKg2MbI+8hqeuSgSKME4Q/TuWOLdssMq7yBGaVC7KYqK1
         iSJ/WeRyZ0/KY8gWUePhyZVSdYn2jcZHS+f2KauRtEcLGxDRFLgjALagijtDZYEHAHnN
         4A7w==
X-Gm-Message-State: AOAM532i1GAHCxEF1K3mmhw1Ej3WjlWFwmWMhDr3Bp2DtwTIG4LEvpLd
        SsBgBFaLmdKYJ5hHU6+O/InmIzOsFuYNlo7+uZz6yA==
X-Google-Smtp-Source: ABdhPJwle01c7hMxSATBOSlChA/RkP5lX14BdMkY4LtJNlo/XvnowdQCDeBsEBvlm82QD02IXyT06Lb1tJOpy4KLImg=
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr28278167ejb.6.1633462949452;
 Tue, 05 Oct 2021 12:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211005083311.830861640@linuxfoundation.org> <20211005155909.GA1386975@roeck-us.net>
 <4ecdfb07-4957-913a-6bd3-4410bd2cb5c0@iki.fi>
In-Reply-To: <4ecdfb07-4957-913a-6bd3-4410bd2cb5c0@iki.fi>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 6 Oct 2021 01:12:17 +0530
Message-ID: <CA+G9fYs=K4V4MgApsoEfGm6YUFnRSP6X6r7_H0uJ-ZzHp4EFJQ@mail.gmail.com>
Subject: Re: [PATCH 5.14 000/173] 5.14.10-rc2 review
To:     Thomas Backlund <tmb@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 at 00:37, Thomas Backlund <tmb@iki.fi> wrote:
>
> Den 2021-10-05 kl. 18:59, skrev Guenter Roeck:
> > On Tue, Oct 05, 2021 at 10:38:40AM +0200, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 5.14.10 release.
> >> There are 173 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Thu, 07 Oct 2021 08:32:44 +0000.
> >> Anything received after that time might be too late.
> >>
> >
> > AFAICS the warning problems are still seen. Unfortunately I won't be able
> > to bisect since I have limited internet access.
> >
> > Guenter
> >
> > =========================
> > WARNING: held lock freed!
> > 5.14.10-rc2-00174-g355f3195d051 #1 Not tainted
> > -------------------------
> > ip/202 is freeing memory c000000009918900-c000000009918f7f, with a lock still held there!
> > c000000009918a20 (sk_lock-AF_INET){+.+.}-{0:0}, at: .sk_common_release+0x4c/0x1b0
> > 2 locks held by ip/202:
> >   #0: c00000000ae149d0 (&sb->s_type->i_mutex_key#5){+.+.}-{3:3}, at: .__sock_release+0x4c/0x150
> >   #1: c000000009918a20 (sk_lock-AF_INET){+.+.}-{0:0}, at: .sk_common_release+0x4c/0x1b0
> >
> >
>

When I reverted the following two patches the warning got fixed.

73a03563f123 af_unix: fix races in sk_peer_pid and sk_peer_cred accesses
b226d61807f1 net: introduce and use lock_sock_fast_nested()


> Isn't this a fallout of:
>
> queue-5.14/net-introduce-and-use-lock_sock_fast_nested.patch
> that has: Fixes: 2dcb96bacce3 ("net: core: Correct the
> sock::sk_lock.owned lockdep annotations")

I have cherry-picked and tested but still I see this  new warning.

old warings are:
----------------------
[ 22.528947] WARNING: held lock freed!
or
[ 36.765439] WARNING: lock held when returning to user space!


new warning after the cherry pick.
------------------
[   22.330646] ============================================
[   22.335955] WARNING: possible recursive locking detected
[   22.341260] 5.14.10-rc2 #1 Not tainted
[   22.345004] --------------------------------------------
[   22.348869] igb 0000:02:00.0 eno2: renamed from eth1
[   22.350309] sd-resolve/345 is trying to acquire lock:
[   22.350310] ffff9a39c9580120 (sk_lock-AF_INET){+.+.}-{0:0}, at:
udp_destroy_sock+0x3a/0xe0
[   22.350317]
[   22.350317] but task is already holding lock:
[   22.350317] ffff9a39c9580120 (sk_lock-AF_INET){+.+.}-{0:0}, at:
sk_common_release+0x22/0x110
[   22.350321]
[   22.350321] other info that might help us debug this:
[   22.350321]  Possible unsafe locking scenario:
[   22.350321]
[   22.350322]        CPU0
[   22.350322]        ----
[   22.350322]   lock(sk_lock-AF_INET);
[   22.350323]   lock(sk_lock-AF_INET);
[   22.350324]
[   22.350324]  *** DEADLOCK ***
[   22.350324]
[   22.350324]  May be due to missing lock nesting notation
[   22.350324]
[   22.350325] 2 locks held by sd-resolve/345:
[   22.350326]  #0: ffff9a39c0610c10
(&sb->s_type->i_mutex_key#6){+.+.}-{3:3}, at: __sock_release+0x32/0xb0
[   22.424188]  #1: ffff9a39c9580120 (sk_lock-AF_INET){+.+.}-{0:0},
at: sk_common_release+0x22/0x110
[   22.424191]
[   22.424191] stack backtrace:
[   22.424192] CPU: 2 PID: 345 Comm: sd-resolve Not tainted 5.14.10-rc2 #1
[   22.424194] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[   22.424195] Call Trace:
[   22.424196]  dump_stack_lvl+0x49/0x5e
[   22.424200]  dump_stack+0x10/0x12
[   22.424202]  __lock_acquire.cold+0x21f/0x2b8
[   22.424204]  ? lock_is_held_type+0x9d/0x110
[   22.424207]  lock_acquire+0xb5/0x2c0
[   22.424209]  ? udp_destroy_sock+0x3a/0xe0
[   22.424212]  ? sk_common_release+0x22/0x110
[   22.424214]  __lock_sock_fast+0x34/0x90
[   22.424216]  ? udp_destroy_sock+0x3a/0xe0
[   22.424217]  udp_destroy_sock+0x3a/0xe0
[   22.424219]  ? sk_common_release+0x22/0x110
[   22.424220]  sk_common_release+0x22/0x110
[   22.424221]  udp_lib_close+0x9/0x10
[   22.424223]  inet_release+0x48/0x80
[   22.424225]  __sock_release+0x42/0xb0
[   22.424227]  sock_close+0x18/0x20
[   22.424228]  __fput+0xbb/0x270
[   22.424230]  ____fput+0xe/0x10
[   22.424231]  task_work_run+0x64/0xb0
[   22.424234]  exit_to_user_mode_prepare+0x201/0x210
[   22.424237]  syscall_exit_to_user_mode+0x1e/0x50
[   22.424239]  do_syscall_64+0x69/0x80
[   22.424241]  ? do_syscall_64+0x69/0x80
[   22.424243]  ? exc_page_fault+0x7c/0x220
[   22.424244]  ? asm_exc_page_fault+0x8/0x30
[   22.424246]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   22.424248] RIP: 0033:0x7f509b8c4837
[   22.424250] Code: 2c 00 f7 d8 64 89 02 b8 ff ff ff ff c3 48 8b 0d
57 86 2c 00 f7 d8 64 89 01 b8 ff ff ff ff eb c2 0f 1f 00 b8 03 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 31 86 2c 00 f7 d8 64 89
02 b8
[   22.424251] RSP: 002b:00007f509a9419c8 EFLAGS: 00000213 ORIG_RAX:
0000000000000003
[   22.424253] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 00007f509b8c4837
[   22.424254] RDX: 0000000000001387 RSI: 0000000000000000 RDI: 000000000000000c
[   22.424255] RBP: 00007f509a949db8 R08: 0000000000000000 R09: 0000000000005d18
[   22.424256] R10: 00007ffc8831c080 R11: 0000000000000213 R12: 0000000000000000
[   22.424257] R13: 0000000000000000 R14: 00007f509a949db8 R15: 0000000000000004

ref:
new warning after the cherry-pick full test log link,
https://lkft.validation.linaro.org/scheduler/job/3673750


on RC2 the original reported warning links,
https://lkft.validation.linaro.org/scheduler/job/3672925#L1185
https://lkft.validation.linaro.org/scheduler/job/3672930#L1261


>
> BUT:
>
> $ git describe --contains 2dcb96bacce3
> v5.15-rc3~30^2~26
>
> --
> Thomas

- Naresh
