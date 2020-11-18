Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FACC2B75F7
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 06:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgKRFeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 00:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgKRFeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 00:34:09 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBC1C0613D4
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 21:34:08 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id f23so1015580ejk.2
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 21:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BopsKmSar3n4P2J12Sr3SxLSSPQixGWTU7etCFUvEQ0=;
        b=CugPd5MD9jNugwhqO/Gr9MkjMcbb6CXIe/YBJ6yWCBjU5fr3YpbYt4AZzxNba/bSYl
         uyDHBGpm4uVezOQh7dKVM83R0kZ0IlQvAbA2PN+lNfsIoadedA4zFWuhVkRA1gYbxIyD
         Xm3as8ORxmOYFMdHgqBb4FkvJgHMHGu4ToX8hECpJACyOPamikY/1/UQHszQLjnJPhQ7
         ebIlRScaG0El2TITFAhbsoeURuVy0UEm4iEaqnsPyHE3UjvEiQA3nOZkrq6d2WzVBVfl
         F+q1amVs1YcZsOVix0qmYlgKOBbaBbP5i+Ul8Y6SMKKYzy7Xtq4pCHAAHoH6UcGMqR6s
         cfvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BopsKmSar3n4P2J12Sr3SxLSSPQixGWTU7etCFUvEQ0=;
        b=jph0Jjh8+O/DzazPXbDiL+mUn7NiEbZtPy6EwT8WdgIPb6GfUZA5kdE7gGkIy0XLAZ
         DwXbVTPyvgoBXv1WiOM8gqxHEeids2jocmjOFsEGdhUd/NPQF8MnGkHD+bNAR4Szi0aR
         Yd9sFXZiZ7gbzawpOCImKLKvaUr221OmPGgSVlvmm8X/Xtl67RmM1XqZ6dxUVTZQ4R7R
         +tp2YZTJrWok7FZp7fYdcMJ2o/6TscxC18LGFKF6vgdiQuPWwC7Wmvd5XpBsMGMN5lKW
         QtC/ZcnIil2Tt/23BJ1yeXEtdrqeV0/dqZpcAoNK51rpt6mKSGrAZqon0Lf9o8GNCHgW
         Y/zA==
X-Gm-Message-State: AOAM532yX2igNe9giTkfDiJOUFHEXgCj+EzqYp+PJW8Iz2aLwbewSmee
        4VgJ2ZUEWi8o2C5deX56hLQ0uSBsDjGFNPKRO7ecdw==
X-Google-Smtp-Source: ABdhPJwogktE2pJm2xh3pNFBobna/9Th5ECROtOqF+Zx+ceiLF964yBgqeJMX0OYZPoDfFT6pYfrw/wIJCLy66utgj8=
X-Received: by 2002:a17:906:3087:: with SMTP id 7mr21857605ejv.375.1605677647248;
 Tue, 17 Nov 2020 21:34:07 -0800 (PST)
MIME-Version: 1.0
References: <20201117122138.925150709@linuxfoundation.org>
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 18 Nov 2020 11:03:55 +0530
Message-ID: <CA+G9fYt+YNy=34HLHpDrc6=73Nhu14NEf7AP+woyZryny+b-2Q@mail.gmail.com>
Subject: Re: [PATCH 5.9 000/255] 5.9.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 at 19:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.9.9 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.9.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
1)
BUG: Invalid wait context on arm64 db410c device while booting.
This issue has not reproduced after several testing loops.
https://lore.kernel.org/stable/CA+G9fYsk54r9Re4E9BWpqsoxLjpCvxRKFWRgdiKVcPo=
YE5z0Hw@mail.gmail.com/T/#u

2)
kselftest test suite version upgrade to v5.9

3)
While running kselftest netfilter on x86, i386, arm64 and arm devices
the following kernel warning was noticed.
WARNING: at net/netfilter/nf_tables_api.c:622
lockdep_nfnl_nft_mutex_not_held+0x19/0x20 [nf_tables]
https://lore.kernel.org/linux-kselftest/CA+G9fYvFUpODs+NkSYcnwKnXm62tmP=3Dk=
sLeBPmB+KFrB2rvCtQ@mail.gmail.com/

4)
From this release we have started building kernels with clang-10 toolchain
and testing LTP testsuite on qemu_arm64, qemu_arm, qemu_x86_64 and qemu_i38=
6.

Summary
------------------------------------------------------------------------

kernel: 5.9.9-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.9.y
git commit: fb1622495321923cbb1ae2c6cf2da1e9ca286800
git describe: v5.9.8-256-gfb1622495321
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.=
y/build/v5.9.8-256-gfb1622495321

No regressions (compared to build v5.9.8)

No fixes (compared to build v5.9.8)

Ran 52946 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu-arm-clang
- qemu-arm64-clang
- qemu-arm64-kasan
- qemu-i386-clang
- qemu-x86_64-clang
- qemu-x86_64-kasan
- qemu_arm
- qemu_arm64
- qemu_arm64-compat
- qemu_i386
- qemu_x86_64
- qemu_x86_64-compat
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
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
* ltp-tracing-tests
* perf
* v4l2-compliance
* ltp-controllers-tests
* ltp-cve-tests
* network-basic-tests
* kselftest
* ltp-open-posix-tests
* kvm-unit-tests
* kunit
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none

--=20
Linaro LKFT
https://lkft.linaro.org
