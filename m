Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D898218DCEF
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 01:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgCUA6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 20:58:14 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40898 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCUA6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 20:58:14 -0400
Received: by mail-qt1-f195.google.com with SMTP id i9so6113615qtw.7;
        Fri, 20 Mar 2020 17:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I+f5s6Qx3mGA30y3yxGC38dIVZCM/GPcgKEiP2kqflA=;
        b=UXU2HZ5EtE9VpDOlvDUyHIBhpFeOZJBPImJtDgHByOXqfaEJeU73WBwFwr6bKGaUWi
         HMt2q3WGyp3t6EEkW87AeReSC6wfBATtKOqVerb9Opjyxnl7Mmse3PvEh5uo973qfA4f
         NUjOWu1UITdmDN9Pkjlwaclv5KF2l5E2sh8RMPkar55fSFyrOI9EI0hdWPkw8XXh4c1c
         C2/RsbYbSelXWkamDDyYaHdgmW1LNMD3IpB7JgOhpK6pQhrKBKj1X3K3rDHTbE+tftpE
         6tqscZuqy4tH2Tl1gn6v406x1JF0+iz/d6QrQ6fsCHmZ9vMrWaiBD3pAcEsKqtu/kJr8
         CdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I+f5s6Qx3mGA30y3yxGC38dIVZCM/GPcgKEiP2kqflA=;
        b=gcv3+2uPqBy4TrdQRqdmSPaLofnS3bfnLauR5dAudsB8piNt8gnHvS45QCscsQ3ZIP
         WsMoX84+KGtRzCT+pFH4cjKulQNsBdRYxj2JhVzipdZXAuwz4FK4/gpP5wPHAQaKu1dM
         u1nYP9hUl0qaFBr+Ng+XY0oDwqhHI0bG9aE03VdBwuWHNGIO7S2ifl4K9RMMJ6P6e7zI
         FKAXy2/6yCx3KD6Te8q/rMKWjDcTfkr9BbhOX2U/8D4MChinXz3cIqcX9PJhhIXObpKK
         uDzw51va+h0WbsMzsVSgFpPqvbYRw6eS1Eog1887qiA/uaKJYWyJ9CZIUK0a4DbTp4oJ
         JBug==
X-Gm-Message-State: ANhLgQ3yeiCiZAcUkroCrHNqEqQhRsyubzr1dfn1DJ29gJ/3+7C+ENEM
        vDiUHS5vDt6urugdGQSx3nPzx8WVZRHDDJj2ZqjiAIp0
X-Google-Smtp-Source: ADFU+vswV5YAkIlkcnRWimH0S69o1eY9YC6q1T3MhdwwJdPzQvjpLFFx6CnTBiVrGNjp0x0PNBwODlc9clkA4ApPRq0=
X-Received: by 2002:ac8:46d5:: with SMTP id h21mr11061123qto.59.1584752293022;
 Fri, 20 Mar 2020 17:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200320203615.1519013-5-andriin@fb.com> <202003210811.iMksMQr5%lkp@intel.com>
In-Reply-To: <202003210811.iMksMQr5%lkp@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Mar 2020 17:58:02 -0700
Message-ID: <CAEf4BzYmwpO=d9uvnua7-DQtpfpDjERFV9EApcT15Gj5ughHcw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] bpf: implement bpf_prog replacement for an
 active bpf_cgroup_link
To:     kbuild test robot <lkp@intel.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, kbuild-all@lists.01.org,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 5:34 PM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Andrii,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on bpf-next/master]
> [cannot apply to bpf/master cgroup/for-next v5.6-rc6 next-20200320]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
>
> url:    https://github.com/0day-ci/linux/commits/Andrii-Nakryiko/Add-support-for-cgroup-bpf_link/20200321-045848
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: m68k-sun3_defconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 9.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=9.2.0 make.cross ARCH=m68k
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All error/warnings (new ones prefixed by >>):
>
>    In file included from include/linux/kernel.h:11,
>                     from include/linux/list.h:9,
>                     from include/linux/timer.h:5,
>                     from include/linux/workqueue.h:9,
>                     from include/linux/bpf.h:9,
>                     from kernel/bpf/syscall.c:4:
>    kernel/bpf/syscall.c: In function 'link_update':
> >> include/linux/kernel.h:994:51: error: dereferencing pointer to incomplete type 'struct bpf_cgroup_link'
>      994 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
>          |                                                   ^~
>    include/linux/compiler.h:330:9: note: in definition of macro '__compiletime_assert'
>      330 |   if (!(condition))     \
>          |         ^~~~~~~~~
>    include/linux/compiler.h:350:2: note: in expansion of macro '_compiletime_assert'
>      350 |  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>          |  ^~~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>       39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>          |                                     ^~~~~~~~~~~~~~~~~~
>    include/linux/kernel.h:994:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>      994 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
>          |  ^~~~~~~~~~~~~~~~
>    include/linux/kernel.h:994:20: note: in expansion of macro '__same_type'
>      994 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
>          |                    ^~~~~~~~~~~
> >> kernel/bpf/syscall.c:3612:13: note: in expansion of macro 'container_of'
>     3612 |   cg_link = container_of(link, struct bpf_cgroup_link, link);
>          |             ^~~~~~~~~~~~
>    In file included from <command-line>:
> >> include/linux/compiler_types.h:129:35: error: invalid use of undefined type 'struct bpf_cgroup_link'
>      129 | #define __compiler_offsetof(a, b) __builtin_offsetof(a, b)
>          |                                   ^~~~~~~~~~~~~~~~~~
>    include/linux/stddef.h:17:32: note: in expansion of macro '__compiler_offsetof'
>       17 | #define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
>          |                                ^~~~~~~~~~~~~~~~~~~
>    include/linux/kernel.h:997:21: note: in expansion of macro 'offsetof'
>      997 |  ((type *)(__mptr - offsetof(type, member))); })
>          |                     ^~~~~~~~
> >> kernel/bpf/syscall.c:3612:13: note: in expansion of macro 'container_of'
>     3612 |   cg_link = container_of(link, struct bpf_cgroup_link, link);
>          |             ^~~~~~~~~~~~
> >> kernel/bpf/syscall.c:3618:9: error: implicit declaration of function 'cgroup_bpf_replace'; did you mean 'cgroup_bpf_offline'? [-Werror=implicit-function-declaration]
>     3618 |   ret = cgroup_bpf_replace(cg_link->cgroup, cg_link,
>          |         ^~~~~~~~~~~~~~~~~~
>          |         cgroup_bpf_offline
>    cc1: some warnings being treated as errors
>

Forgot to stub out cgroup_bpf_replace(), will fix in v2.


> vim +994 include/linux/kernel.h
>
> cf14f27f82af78 Alexei Starovoitov 2018-03-28  984
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  985  /**
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  986   * container_of - cast a member of a structure out to the containing structure
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  987   * @ptr:     the pointer to the member.
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  988   * @type:    the type of the container struct this is embedded in.
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  989   * @member:  the name of the member within the struct.
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  990   *
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  991   */
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  992  #define container_of(ptr, type, member) ({                           \
> c7acec713d14c6 Ian Abbott         2017-07-12  993       void *__mptr = (void *)(ptr);                                   \
> c7acec713d14c6 Ian Abbott         2017-07-12 @994       BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&   \
> c7acec713d14c6 Ian Abbott         2017-07-12  995                        !__same_type(*(ptr), void),                    \
> c7acec713d14c6 Ian Abbott         2017-07-12  996                        "pointer type mismatch in container_of()");    \
> c7acec713d14c6 Ian Abbott         2017-07-12  997       ((type *)(__mptr - offsetof(type, member))); })
> ^1da177e4c3f41 Linus Torvalds     2005-04-16  998
>
> :::::: The code at line 994 was first introduced by commit
> :::::: c7acec713d14c6ce8a20154f9dfda258d6bcad3b kernel.h: handle pointers to arrays better in container_of()
>
> :::::: TO: Ian Abbott <abbotti@mev.co.uk>
> :::::: CC: Linus Torvalds <torvalds@linux-foundation.org>
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
