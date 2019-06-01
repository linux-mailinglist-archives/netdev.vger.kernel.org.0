Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC2231FCF
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 17:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFAPmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 11:42:35 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37138 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfFAPmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 11:42:35 -0400
Received: by mail-lf1-f65.google.com with SMTP id m15so10307255lfh.4;
        Sat, 01 Jun 2019 08:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ANAnojDFgO/UEOlubtSuomjYlfi+/05syRfAQew4Lkc=;
        b=BWe3vZYk2212WygQaRKlhOpRBvB4lylIckxRox790gWm26U5NjY3x6nsinUGmJR/Ot
         vu4u0v2+q1Utb2Ud96218SSO/CgAae857yAyxW7poZSMvXFKCzM8b2cEW9v1cCB1943Q
         9jA5EZ96jgiydsflEcKjIRORIgYkSXJak4RuQNc1olKMoHdsjLRCBbIwopCFcz6gyenB
         WQoEH9M9xoEtdtQNzeZXj/Ea+uOsA0w5Fl6dCoN057C+dhy7uAR3R4ORpoSaJ5ExD4+A
         BgjCGvoTlDsUwGb2jF/Kd8MtRGl+jYLUQWRK7EdwmoCreKB+V/WaZxYCtB9sjh2J5XlI
         rSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ANAnojDFgO/UEOlubtSuomjYlfi+/05syRfAQew4Lkc=;
        b=Bif2dm23coOiTkvWzLafMhwctIsfRDUnGf7vfQTyUMFqPfSv1fc1M+u8gfEAkKW/8C
         qcxjdSaWyUPWVt/Yiu21pQ7gxduaauX9TJM3mevsSlu3meMrVVEYouO8TVLhRyyA6Z5F
         HZM/Tt7k5KugK2HyoxDTHNbaVrpqu67WjxJweshbBZtNydm2YNatQQXTzI1o92b70a7K
         NZzNV41keJ4eNfIauPkGUqBKx+vXk4m0SFd9m0zIZBN6Ndx09up2ObamSqlfAz4T04Ji
         RU8fNVn+G3t8bTX2QcNZImrYzUegk99ChfHnNXQjhmMs+mohZ8t+yCtlLoWLjS6Ub7av
         joDA==
X-Gm-Message-State: APjAAAVmirC+F5mk/cjTXtvvU0xCJaAZpLWZHZgMOyZcQaZ4ZsNxkEOb
        o5Ml/j3InG7AOyVHwr6YFBcVniMXySu/wrchGvQ=
X-Google-Smtp-Source: APXvYqytR1+jWyGN6bSKk5YHqC9B/y7Dba5mi2AgjkjhDwtD1lpQ7TlbddjDrIvEUcp0YLJt1cM/vJ8MjIjGQhARSvw=
X-Received: by 2002:a19:ab1a:: with SMTP id u26mr1575334lfe.6.1559403753167;
 Sat, 01 Jun 2019 08:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <201906011337.lBp5SlWB%lkp@intel.com>
In-Reply-To: <201906011337.lBp5SlWB%lkp@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 1 Jun 2019 08:42:21 -0700
Message-ID: <CAADnVQJC5Gx5Z=2=mngHMU65fGoesMBWy5pifeDquPOhefMF-A@mail.gmail.com>
Subject: Re: [bpf:master 3/3] kernel/bpf/arraymap.c:657:36: error: invalid
 application of 'sizeof' to incomplete type 'struct perf_sample_data'
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Cc:     Matt Mullins <mmullins@fb.com>, kbuild-all@01.org,
        Andrew Hall <hall@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matt,

due to this build issue I removed your commit from bpf tree.
Please fix and resubmit.

Thanks!

On Fri, May 31, 2019 at 10:48 PM kbuild test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git master
> head:   0b21b5502f561940e0d29f7ec5f840309e4a0243
> commit: 0b21b5502f561940e0d29f7ec5f840309e4a0243 [3/3] bpf: preallocate a perf_sample_data per event fd
> config: m68k-allyesconfig (attached as .config)
> compiler: m68k-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 0b21b5502f561940e0d29f7ec5f840309e4a0243
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=m68k
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    kernel/bpf/arraymap.c: In function 'bpf_event_entry_gen':
> >> kernel/bpf/arraymap.c:657:36: error: invalid application of 'sizeof' to incomplete type 'struct perf_sample_data'
>      ee = kzalloc(sizeof(*ee) + sizeof(struct perf_sample_data), GFP_ATOMIC);
>                                        ^~~~~~
>
> vim +657 kernel/bpf/arraymap.c
>
>    651
>    652  static struct bpf_event_entry *bpf_event_entry_gen(struct file *perf_file,
>    653                                                     struct file *map_file)
>    654  {
>    655          struct bpf_event_entry *ee;
>    656
>  > 657          ee = kzalloc(sizeof(*ee) + sizeof(struct perf_sample_data), GFP_ATOMIC);
>    658          if (ee) {
>    659                  ee->event = perf_file->private_data;
>    660                  ee->perf_file = perf_file;
>    661                  ee->map_file = map_file;
>    662                  ee->sd = (void *)ee + sizeof(*ee);
>    663          }
>    664
>    665          return ee;
>    666  }
>    667
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
