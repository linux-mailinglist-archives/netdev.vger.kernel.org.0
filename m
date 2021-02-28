Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3681C327396
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 18:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhB1RM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 12:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbhB1RMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 12:12:39 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10048C06174A;
        Sun, 28 Feb 2021 09:11:58 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g5so23843438ejt.2;
        Sun, 28 Feb 2021 09:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dfQ46OGWItLgoKPUR/Czwfd0qqTUSj25+jf5yrElG/4=;
        b=GzeA/aDB2UBhnNVhm++I/Jk3Up7Sjll8FWko6UUVrR8GbwUj6tdWvj7U7T3p1JnaWE
         tuDT5n8KyfWwgonEFcDAlbP9Wnm/lzI5ynLZd5zXrmZLcqy0e5qJFV+Ury6tgPUdhcIC
         ZnUpySrUVv3A0oExsLsVOkNej6wDTO/NVed1e1lRxfeovoJIixufVCuML3LKRgEXHaK6
         AQIpA41ncR2vIctG/YIpRBR7PPh4Vs9caRlig7rCLuPUPKUXlteysI6kNYwN/3Yc//ci
         tD2NQsug/MYd9mQ+dWSVvw0ZV+w1YK/V6hQL8df04yN35+nWGaht76tutf0kiQ1Fxgq5
         E6Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dfQ46OGWItLgoKPUR/Czwfd0qqTUSj25+jf5yrElG/4=;
        b=DFk3PQk4Tg5+x/JyUn1GIB9WRKbs4ZjvCjYZr9JKO8621MT6/JMbxVEVcdDoUwHVL+
         For3KnKO03QZ25kxJo4JrfZHSkIeuz8ttxAxFkjgF2q6WYdlaegFsyL7pwebxMCJOuh/
         NrMre9pjnYhb6I4oOeQe6UNOpaC6IPz2m13QnfLeVZ2YZGlmr1DYxmPi+bvVPkKasB7e
         u9RBjICZzwxg7kg714yWmesb+O+Rtbcpc99VRzJxNj+AhqwCvcU1kFYQqrqosKdGeMu3
         qv1KRTCKEbd/EDeY1ITs68EsyfQGwPqrqB4AdfJhZ2zoof+PofoZAtTFpktFx3ZcE2nA
         XTjg==
X-Gm-Message-State: AOAM5304vRkhWj/qH8naxa3syBxpk1crx5yAp/FsV3b7mRkxQxwuuOcN
        4SYwXjH8z05UBhk34i8rBvOfdoP18tGg
X-Google-Smtp-Source: ABdhPJw5sLbCUCcgxkhNvC6IgO3vmNaTgOeasYPBEho60Poa4WNRXoZ/cPiXNkLCHgbgyBJUziViqw==
X-Received: by 2002:a17:906:acb:: with SMTP id z11mr3855755ejf.193.1614532316774;
        Sun, 28 Feb 2021 09:11:56 -0800 (PST)
Received: from localhost.localdomain ([46.53.249.223])
        by smtp.gmail.com with ESMTPSA id fw3sm6654338ejb.82.2021.02.28.09.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 09:11:56 -0800 (PST)
Date:   Sun, 28 Feb 2021 20:11:54 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org
Subject: [PATCH 12/11] pragma once: scripted treewide conversion
Message-ID: <YDvO2kmidKZaK26j@localhost.localdomain>
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[  Bcc a lot of lists so that people understand what's this is all         ]
[  about without creating uber-cc-thread.                                  ]
[  Apologies if I missed your subsystem                                    ]
[  Please see [PATCH 11/11: pragma once: conversion script (in Python 2)]  ]

Hi, Linus.

Please run the script below from top-level directory, it will convert
most kernel headers to #pragma once directive advancing them into
21-st century.

The advantages are:

* less LOC

	18087 files changed, 18878 insertions(+), 99804 deletions(-)
	= -81 kLOC (give or take)

* less mental tax on developers forced to name things which aren't even
  real code

* less junk in preprocessor hashtables and editors/IDEs autocompletion
  lists

There are two bit exceptions: UAPI headers and ACPICA.
Given ubiquity of #pragma once, I personally think even these subsystems
should be converted in the future.

Compile tested on alpha, arc, arm, arm64, h8300, ia64, m68k, microblaze,
mips, nios2, parisc, powerpc, riscv, s390, sh, sparc, um-i386, um-x86_64,
i386, x86_64, xtensa (allnoconfig, all defconfigs, allmodconfig with or
without SMP/DEBUG_KERNEL + misc stuff).

Not compile tested on csky, hexagon, nds32, openrisc. 

Love,
	Alexey

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>



#!/bin/sh -x
find . -type f -name '*.h' -print	|\
LC_ALL=C sort				|\
sed -e 's#^./##g'			|\
xargs ./scripts/pragma-once.py

find . -type d -name 'uapi' | xargs git checkout -f
git checkout -f arch/alpha/include/asm/cmpxchg.h
git checkout -f arch/arm/mach-imx/hardware.h
git checkout -f arch/arm/mach-ixp4xx/include/mach/hardware.h
git checkout -f arch/arm/mach-sa1100/include/mach/hardware.h
git checkout -f arch/mips/include/asm/mips-cps.h
git checkout -f arch/x86/boot/boot.h
git checkout -f arch/x86/boot/ctype.h
git checkout -f arch/x86/include/asm/cpufeatures.h
git checkout -f arch/x86/include/asm/disabled-features.h
git checkout -f arch/x86/include/asm/required-features.h
git checkout -f arch/x86/include/asm/vmxfeatures.h
git checkout -f arch/x86/include/asm/vvar.h
git checkout -f drivers/acpi/acpica/
git checkout -f drivers/gpu/drm/amd/pm/inc/vega10_ppsmc.h
git checkout -f drivers/gpu/drm/amd/pm/powerplay/ppsmc.h
git checkout -f drivers/input/misc/yealink.h
git checkout -f drivers/media/usb/dvb-usb-v2/mxl111sf-demod.h
git checkout -f drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
git checkout -f drivers/pcmcia/yenta_socket.h
git checkout -f drivers/staging/rtl8723bs/include/hal_com_h2c.h
git checkout -f include/linux/acpi.h
git checkout -f include/linux/bitops.h
git checkout -f include/linux/compiler_types.h
git checkout -f include/linux/device.h
git checkout -f include/linux/kbuild.h
git checkout -f include/linux/libfdt_env.h
git checkout -f include/linux/local_lock.h
git checkout -f include/linux/spinlock.h
git checkout -f include/linux/spinlock_api_smp.h
git checkout -f include/linux/spinlock_types.h
git checkout -f include/linux/tracepoint.h
git checkout -f mm/gup_test.h
git checkout -f net/batman-adv/main.h
git checkout -f scripts/dtc/
git checkout -f tools/include/linux/bitops.h
git checkout -f tools/include/linux/compiler.h
git checkout -f tools/testing/selftests/clone3/clone3_selftests.h
git checkout -f tools/testing/selftests/futex/include/atomic.h
git checkout -f tools/testing/selftests/futex/include/futextest.h
git checkout -f tools/testing/selftests/futex/include/logging.h
git checkout -f tools/testing/selftests/kselftest.h
git checkout -f tools/testing/selftests/kselftest_harness.h
git checkout -f tools/testing/selftests/pidfd/pidfd.h
git checkout -f tools/testing/selftests/x86/helpers.h
