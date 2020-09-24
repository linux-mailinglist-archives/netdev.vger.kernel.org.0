Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC92277425
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 16:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgIXOhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 10:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgIXOhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 10:37:34 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369D3C0613D3
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 07:37:34 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id q13so966716vkd.0
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 07:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Y+sY5R9BB1m0tnZgETWGm1/pCFVH9axPAXKPrQuX+UI=;
        b=hR3QsXIYBnI6Vd62/KFSvHz3GH86eRf00HC7RuFHojqbSkEvtqengUdf4AU2sLWRrP
         9Twxsb0n4+YqJaA0gfey8koYjKFs4GtdaCNV9vNmWeGQHWBs0ixYNUowWV7LbUbTkhgN
         wwIxNaMOTXqRm6XHIQmThYm377r0mkynlyfrtGG4SI1kzRfRteqJ4SQE7tGkKZY8m5fi
         PJSat0T3igs534E2sK/LM/S6inDijwqy0CCiqWPZkJbjYTy2hWkgLFiiHcQP8zPYN59y
         ITS0efQRzOiylzUcenR0rU7DW67u3oSqk4Cd8r5H1IJP9O98G8qTy4nTNQdyBt5/jqOw
         i0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Y+sY5R9BB1m0tnZgETWGm1/pCFVH9axPAXKPrQuX+UI=;
        b=dWwS5c0DIsCQ7RpVINUGr+FqdBAKng+++AIOH50LcvpN7HG6JXAxQhav0/+JSTHDnc
         Z57Kj/SK4cWQSpJej0eoyHEjMwQzr2kHRiK/9nJ0Rnc5f22RNM55b+4pJF+G69oKHeWl
         qq2xJlbrebIVVJ4Od58QD5JOf7V2Rj/vqU9nR143suOwbfNzK0IhANo6h1NP3qEwuCZL
         hjaOkqH2VT+n78mTwc8HyG9eaij7wS9UiOPRb0s36mScTfcBl7t//03OTcL5NQMvwe5T
         5eedSynRAzRmTrUZ27Ql/U52alNzUWjt+V+Zl4bSp/DblaxyWwIKM0BwFlfnL2Xjw2Sq
         6yyQ==
X-Gm-Message-State: AOAM5312a0sVTdR4nnQNi07PwAWqDIgS9JgLQ5Kj6aD9JfpOetnDVpmA
        LOU6Z4ZY+BqiBg8FLPcxJDFDz/JT6GJLGpSnkvzMHg==
X-Google-Smtp-Source: ABdhPJz/1ugw5vGXzY5IhqsVU4RR0CGvMpxr2KfhDZ18CkSWeRw1I+fPQbfCgpteCj5LxlXmT9qvi7F0gzCfzTRQNNY=
X-Received: by 2002:a1f:7882:: with SMTP id t124mr4288846vkc.22.1600958252946;
 Thu, 24 Sep 2020 07:37:32 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 24 Sep 2020 20:07:21 +0530
Message-ID: <CA+G9fYt86DcPWokgFx4ZhsMKEjEXuUhtOTAn0hZk9mjTgy+YWQ@mail.gmail.com>
Subject: i386: allmodconfig build failed on linux next
To:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i386 allmodconfig build failed on linux next due to below errors.
Since we recently started building allmodconfig. we do not have when
this problem started.

We are building with gcc-8, gcc-9 and gcc-10.

Build log:
------------
make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux ARCH=3Di386 HOSTCC=3Dgcc
CC=3D"sccache gcc" O=3Dbuild allmodconfig

make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Di386 HOSTCC=3Dgc=
c
CC=3D"sccache gcc" O=3Dbuild

../drivers/bus/mhi/core/debugfs.c: In function =E2=80=98mhi_debugfs_events_=
show=E2=80=99:
../drivers/bus/mhi/core/debugfs.c:74:51: warning: cast from pointer to
integer of different size [-Wpointer-to-int-cast]
   74 |   seq_printf(m, " local rp: 0x%llx db: 0x%llx\n", (u64)ring->rp,
      |                                                   ^
../drivers/bus/mhi/core/debugfs.c:74:45: warning: format =E2=80=98%llx=E2=
=80=99
expects argument of type =E2=80=98long long unsigned int=E2=80=99, but argu=
ment 4 has
type =E2=80=98dma_addr_t=E2=80=99 {aka =E2=80=98unsigned int=E2=80=99} [-Wf=
ormat=3D]
   74 |   seq_printf(m, " local rp: 0x%llx db: 0x%llx\n", (u64)ring->rp,
      |                                          ~~~^
      |                                             |
      |                                             long long unsigned int
      |                                          %x
   75 |       mhi_event->db_cfg.db_val);
      |       ~~~~~~~~~~~~~~~~~~~~~~~~
      |                        |
      |                        dma_addr_t {aka unsigned int}
../drivers/bus/mhi/core/debugfs.c: In function =E2=80=98mhi_debugfs_channel=
s_show=E2=80=99:
../drivers/bus/mhi/core/debugfs.c:122:7: warning: cast from pointer to
integer of different size [-Wpointer-to-int-cast]
  122 |       (u64)ring->rp, (u64)ring->wp,
      |       ^
../drivers/bus/mhi/core/debugfs.c:122:22: warning: cast from pointer
to integer of different size [-Wpointer-to-int-cast]
  122 |       (u64)ring->rp, (u64)ring->wp,
      |                      ^
../drivers/bus/mhi/core/debugfs.c:121:62: warning: format =E2=80=98%llx=E2=
=80=99
expects argument of type =E2=80=98long long unsigned int=E2=80=99, but argu=
ment 5 has
type =E2=80=98dma_addr_t=E2=80=99 {aka =E2=80=98unsigned int=E2=80=99} [-Wf=
ormat=3D]
  121 |   seq_printf(m, " local rp: 0x%llx local wp: 0x%llx db: 0x%llx\n",
      |                                                           ~~~^
      |                                                              |
      |
long long unsigned int
      |                                                           %x
  122 |       (u64)ring->rp, (u64)ring->wp,
  123 |       mhi_chan->db_cfg.db_val);
      |       ~~~~~~~~~~~~~~~~~~~~~~~
      |                       |
      |                       dma_addr_t {aka unsigned int}
In file included from /usr/include/sys/socket.h:33,
                 from ../net/bpfilter/main.c:6:
/usr/include/bits/socket.h:354:11: fatal error: asm/socket.h: No such
file or directory
  354 | # include <asm/socket.h>
      |           ^~~~~~~~~~~~~~
compilation terminated.
make[3]: *** [scripts/Makefile.userprogs:43: net/bpfilter/main.o] Error 1
make[3]: Target '__build' not remade because of errors.
make[2]: *** [../scripts/Makefile.build:500: net/bpfilter] Error 2
In file included from ../include/linux/printk.h:7,
                 from ../include/linux/kernel.h:16,
                 from ../arch/x86/include/asm/percpu.h:27,
                 from ../arch/x86/include/asm/current.h:6,
                 from ../include/linux/sched.h:12,
                 from ../fs/btrfs/extent-tree.c:6:
../fs/btrfs/extent-tree.c: In function =E2=80=98__btrfs_free_extent=E2=80=
=99:
../include/linux/kern_levels.h:5:18: warning: format =E2=80=98%lu=E2=80=99 =
expects
argument of type =E2=80=98long unsigned int=E2=80=99, but argument 8 has ty=
pe
=E2=80=98unsigned int=E2=80=99 [-Wformat=3D]
    5 | #define KERN_SOH "\001"  /* ASCII Start Of Header */
      |                  ^~~~~~
../include/linux/kern_levels.h:10:19: note: in expansion of macro =E2=80=98=
KERN_SOH=E2=80=99
   10 | #define KERN_CRIT KERN_SOH "2" /* critical conditions */
      |                   ^~~~~~~~
../fs/btrfs/ctree.h:3148:24: note: in expansion of macro =E2=80=98KERN_CRIT=
=E2=80=99
 3148 |  btrfs_printk(fs_info, KERN_CRIT fmt, ##args)
      |                        ^~~~~~~~~
../fs/btrfs/extent-tree.c:3187:4: note: in expansion of macro =E2=80=98btrf=
s_crit=E2=80=99
 3187 |    btrfs_crit(info,
      |    ^~~~~~~~~~
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/linux/Makefile:1792: net] Error 2
In file included from ../drivers/net/ethernet/intel/ice/ice_flex_pipe.c:6:
../drivers/net/ethernet/intel/ice/ice_flex_pipe.c: In function
=E2=80=98ice_free_flow_profs=E2=80=99:
../drivers/net/ethernet/intel/ice/ice_flow.h:197:33: warning: cast
from pointer to integer of different size [-Wpointer-to-int-cast]
  197 | #define ICE_FLOW_ENTRY_HNDL(e) ((u64)e)
      |                                 ^
../drivers/net/ethernet/intel/ice/ice_flex_pipe.c:2921:9: note: in
expansion of macro =E2=80=98ICE_FLOW_ENTRY_HNDL=E2=80=99
 2921 |         ICE_FLOW_ENTRY_HNDL(e));
      |         ^~~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/ethernet/intel/ice/ice_flow.c:5:
../drivers/net/ethernet/intel/ice/ice_flow.c: In function =E2=80=98ice_flow=
_add_entry=E2=80=99:
../drivers/net/ethernet/intel/ice/ice_flow.h:197:33: warning: cast
from pointer to integer of different size [-Wpointer-to-int-cast]
  197 | #define ICE_FLOW_ENTRY_HNDL(e) ((u64)e)
      |                                 ^
../drivers/net/ethernet/intel/ice/ice_flow.c:946:13: note: in
expansion of macro =E2=80=98ICE_FLOW_ENTRY_HNDL=E2=80=99
  946 |  *entry_h =3D ICE_FLOW_ENTRY_HNDL(e);
      |             ^~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/intel/ice/ice_flow.c: In function =E2=80=98ice_flow=
_rem_entry=E2=80=99:
../drivers/net/ethernet/intel/ice/ice_flow.h:198:32: warning: cast to
pointer from integer of different size [-Wint-to-pointer-cast]
  198 | #define ICE_FLOW_ENTRY_PTR(h) ((struct ice_flow_entry *)(h))
      |                                ^
../drivers/net/ethernet/intel/ice/ice_flow.c:974:10: note: in
expansion of macro =E2=80=98ICE_FLOW_ENTRY_PTR=E2=80=99
  974 |  entry =3D ICE_FLOW_ENTRY_PTR(entry_h);
      |          ^~~~~~~~~~~~~~~~~~
In file included from ../include/linux/kernel.h:14,
                 from ../arch/x86/include/asm/percpu.h:27,
                 from ../arch/x86/include/asm/current.h:6,
                 from ../arch/x86/include/asm/processor.h:17,
                 from ../arch/x86/include/asm/timex.h:5,
                 from ../include/linux/timex.h:65,
                 from ../include/linux/time32.h:13,
                 from ../include/linux/time.h:73,
                 from ../include/linux/efi.h:17,
                 from ../drivers/firmware/efi/mokvar-table.c:35:
../drivers/firmware/efi/mokvar-table.c: In function =E2=80=98efi_mokvar_tab=
le_init=E2=80=99:
../include/linux/minmax.h:18:28: warning: comparison of distinct
pointer types lacks a cast
   18 |  (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
      |                            ^~
../include/linux/minmax.h:32:4: note: in expansion of macro =E2=80=98__type=
check=E2=80=99
   32 |   (__typecheck(x, y) && __no_side_effects(x, y))
      |    ^~~~~~~~~~~
../include/linux/minmax.h:42:24: note: in expansion of macro =E2=80=98__saf=
e_cmp=E2=80=99
   42 |  __builtin_choose_expr(__safe_cmp(x, y), \
      |                        ^~~~~~~~~~
../include/linux/minmax.h:51:19: note: in expansion of macro =E2=80=98__car=
eful_cmp=E2=80=99
   51 | #define min(x, y) __careful_cmp(x, y, <)
      |                   ^~~~~~~~~~~~~
../drivers/firmware/efi/mokvar-table.c:149:15: note: in expansion of macro =
=E2=80=98min=E2=80=99
  149 |    map_size =3D min(map_size_needed + 2*EFI_PAGE_SIZE,
      |               ^~~
../drivers/staging/media/atomisp/pci/atomisp_compat_css20.c: In
function =E2=80=98__set_css_print_env=E2=80=99:
../drivers/staging/media/atomisp/pci/atomisp_compat_css20.c:860:50:
error: assignment to =E2=80=98int (*)(const char *, char *)=E2=80=99 from i=
ncompatible
pointer type =E2=80=98int (__attribute__((regparm(0))) *)(const char *, cha=
r
*)=E2=80=99 [-Werror=3Dincompatible-pointer-types]
  860 |   isp->css_env.isp_css_env.print_env.debug_print =3D vprintk;
      |                                                  ^
../drivers/staging/media/atomisp/pci/atomisp_compat_css20.c: In
function =E2=80=98atomisp_css_load_firmware=E2=80=99:
../drivers/staging/media/atomisp/pci/atomisp_compat_css20.c:893:49:
error: assignment to =E2=80=98int (*)(const char *, char *)=E2=80=99 from i=
ncompatible
pointer type =E2=80=98int (__attribute__((regparm(0))) *)(const char *, cha=
r
*)=E2=80=99 [-Werror=3Dincompatible-pointer-types]
  893 |  isp->css_env.isp_css_env.print_env.error_print =3D vprintk;
      |                                                 ^
cc1: some warnings being treated as errors
make[5]: *** [../scripts/Makefile.build:283:
drivers/staging/media/atomisp/pci/atomisp_compat_css20.o] Error 1
In file included from ../include/linux/printk.h:409,
                 from ../include/linux/kernel.h:16,
                 from ../drivers/staging/media/atomisp/pci/hmm/hmm.c:23:
../drivers/staging/media/atomisp/pci/hmm/hmm.c: In function =E2=80=98hmm_al=
loc=E2=80=99:
../drivers/staging/media/atomisp/pci/hmm/hmm.c:272:3: warning: format
=E2=80=98%ld=E2=80=99 expects argument of type =E2=80=98long int=E2=80=99, =
but argument 6 has type
=E2=80=98size_t=E2=80=99 {aka =E2=80=98unsigned int=E2=80=99} [-Wformat=3D]
  272 |   "%s: pages: 0x%08x (%ld bytes), type: %d from highmem %d,
user ptr %p, cached %d\n",
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~
../include/linux/dynamic_debug.h:129:15: note: in definition of macro
=E2=80=98__dynamic_func_call=E2=80=99
  129 |   func(&id, ##__VA_ARGS__);  \
      |               ^~~~~~~~~~~
../include/linux/dynamic_debug.h:161:2: note: in expansion of macro
=E2=80=98_dynamic_func_call=E2=80=99
  161 |  _dynamic_func_call(fmt,__dynamic_dev_dbg,   \
      |  ^~~~~~~~~~~~~~~~~~
../include/linux/dev_printk.h:123:2: note: in expansion of macro
=E2=80=98dynamic_dev_dbg=E2=80=99
  123 |  dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
      |  ^~~~~~~~~~~~~~~
../include/linux/dev_printk.h:123:23: note: in expansion of macro =E2=80=98=
dev_fmt=E2=80=99
  123 |  dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
      |                       ^~~~~~~
../drivers/staging/media/atomisp/pci/hmm/hmm.c:271:2: note: in
expansion of macro =E2=80=98dev_dbg=E2=80=99
  271 |  dev_dbg(atomisp_dev,
      |  ^~~~~~~
../drivers/staging/media/atomisp/pci/hmm/hmm.c:272:25: note: format
string is defined here
  272 |   "%s: pages: 0x%08x (%ld bytes), type: %d from highmem %d,
user ptr %p, cached %d\n",
      |                       ~~^
      |                         |
      |                         long int
      |                       %d
make[5]: Target '__build' not remade because of errors.
make[4]: *** [../scripts/Makefile.build:500:
drivers/staging/media/atomisp] Error 2
make[4]: Target '__build' not remade because of errors.
make[3]: *** [../scripts/Makefile.build:500: drivers/staging/media] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [../scripts/Makefile.build:500: drivers/staging] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [/linux/Makefile:1792: drivers] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:185: __sub-make] Error 2
make: Target '__all' not remade because of errors.

--=20
Linaro LKFT
https://lkft.linaro.org
