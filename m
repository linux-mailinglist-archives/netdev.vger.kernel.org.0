Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CF410D2CC
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 09:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfK2IyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 03:54:20 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44772 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfK2IyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 03:54:20 -0500
Received: by mail-lj1-f195.google.com with SMTP id c19so4106899lji.11
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 00:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4cIdzPem1gtTXrJfo2HafRoTCZRg5FNv5NypT6qP45U=;
        b=sh5xZc0HwFEOqs7cDdnGBQgbaeliG0TskKpvg+mwd4TC21KSG2qJ/o+imPQXc6NWG6
         yuRvf2zqJy38q5WSSxIc9fdihJHQU2pYdLKSW61stgQlkMTRuUzoUCk6XXgIKwxz/ZY4
         4rTZDgMnnVV3HVPzqWIK0bAOZgqTk6t5VxoMUGNnDgLm078nn20Bipn52oF5rb35d4Zx
         WT2IXY64UN6YFzZr1/RrDbW5cvy5IYP7esrM7kUJzPKX4oCduuCFMcx94gzixd5PM7qh
         pWNblWuTGHM+MrP+TR0lsDqEvELeq0ck1PlctY9UiRzEniK94N2mJG3RQ/MhVfiPG+fg
         lRHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4cIdzPem1gtTXrJfo2HafRoTCZRg5FNv5NypT6qP45U=;
        b=ELil3vJ1Vwd2DjL0+bG6m/ymk+/mvjM4P7nlnkOicgn1iQYA61SDYXquY91PjXpG4h
         +ui1NBDlDzM28GlpLhCe4TSuejz1siJIfDd6Sh99AyKrCacXi71Rs3CzfPll20GN4pZY
         jpLx+rCCsLOUDfXuorYj6eI3l8QZx7jeoM3/CwiVtLGPlsCoJcMYRgQUZZTsrhTm6yMK
         rejkL+3E2G+JRo161uoo/MLT3/1CWMwc8+iw5bNjbVQ64/0Lm8DK8SiM3mZ57/N1mUrG
         b0sr1kHaBj3U5pzFgtmgWZy8s6NPnXvBsF8IkeHug6xmUMk6vFQcP/eOzsiUUC0QkYlu
         vRHg==
X-Gm-Message-State: APjAAAUP5Qw1cPYn0uu4+cayv1XcXIINCdSIs1ozyWvgo0xDzPjAIqST
        L9WEhoG7aJ6cKFayw9oTl0WlKhEUN3D/vDJA3EbyOA==
X-Google-Smtp-Source: APXvYqyt+7PQVsnFlfoRnd/SSRNCt5JxFY7QCWPcBAiJ7bkcleAU7YSSvhv9WR+7iwmYdFhc3x1cmkttsKVYTTRvJsU=
X-Received: by 2002:a2e:a0c6:: with SMTP id f6mr69283ljm.46.1575017657691;
 Fri, 29 Nov 2019 00:54:17 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
 <20191128073623.GE3317872@kroah.com>
In-Reply-To: <20191128073623.GE3317872@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 29 Nov 2019 14:24:06 +0530
Message-ID: <CA+G9fYtPJLNVvXapfr1vtpH=T6MxU7NY_Kac-T7U31w-kQu62A@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        jouni.hogander@unikie.com, "David S. Miller" <davem@davemloft.net>,
        lukas.bulwahn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Nov 2019 at 13:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:


> Now queued up, I'll push out -rc2 versions with this fix.

Results from Linaro=E2=80=99s test farm.
Regressions detected on i386.

i386 build failed on 4.19 and 4.14

In function 'setup_cpu_entry_area_ptes',
    inlined from 'setup_cpu_entry_areas' at arch/x86/mm/cpu_entry_area.c:20=
9:2:
include/linux/compiler.h:348:38: error: call to
'__compiletime_assert_192' declared with attribute error: BUILD_BUG_ON
failed: (CPU_ENTRY_AREA_PAGES+1)*PAGE_SIZE !=3D CPU_ENTRY_AREA_MAP_SIZE
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                      ^
include/linux/compiler.h:329:4: note: in definition of macro
'__compiletime_assert'
    prefix ## suffix();    \
    ^~~~~~
include/linux/compiler.h:348:2: note: in expansion of macro
'_compiletime_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
  ^~~~~~~~~~~~~~~~~~~
include/linux/build_bug.h:45:37: note: in expansion of macro
'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~

Bisection points to "x86/cpu_entry_area: Add guard page for entry
stack on 32bit" (e50622b4a1, also present in 4.14.y as 880a98c339).


Summary
------------------------------------------------------------------------

kernel: 4.19.87-rc2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-4.19.y
git commit: 63633b307be0161e7bd6f854a28d7d9fa05f69ef
git describe: v4.19.86-309-g63633b307be0
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/bu=
ild/v4.19.86-309-g63633b307be0

Regressions (compared to build v4.19.86)
------------------------------------------------------------------------

i386:
  build:
    * build_process


No fixes (compared to build v4.19.86)


Ran 18913 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c - arm64
- hi6220-hikey - arm64
- i386
- juno-r2 - arm64
- qemu_arm
- qemu_arm64
- qemu_x86_64
- x15 - arm
- x86_64

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-fs-tests
* network-basic-tests
* kvm-unit-tests
* ltp-open-posix-tests
* ssuite
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
