Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173D23C7DD9
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 07:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhGNFQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 01:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhGNFQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 01:16:48 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3326EC0613DD
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 22:13:56 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id ay16so433900qvb.12
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 22:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZdQWrmG6M3XUqNOIsR3BE6OkJLacu7dzCjviod9+YhI=;
        b=QTziq5m0E1ucoN1dWIZxCPqk9/SFIezVPWo5QTcNJM6S+Nq4gu5ef+MV4g/xQMKGhx
         INZ+XY2BMlgHlkc8CJRHX+cBHWAozMTVef+x/lQT4SeGXmAfE4s0XilBm60/tcMlL9b5
         N6I13oiqPtD9EpjHljgW7Nky5y4KXjViYXG5iXtrEBirLXRQG0g208B3Tgx77SMCgoSo
         qp4J5zMqbX4rpXk1ctGZRXQ9uSCO/GjJ/NeJggDx22XL+9TkHlKxUI/RuAHBU1UpiBn5
         H0hAtrcf0ZPjanpKfYfU/EBSsY34sY3aPQBWF0pvGCCb11bU/mA2jOXGTosXSWUaMc08
         sfuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZdQWrmG6M3XUqNOIsR3BE6OkJLacu7dzCjviod9+YhI=;
        b=eFhe2g6ewQDlMGMQTRePtpYt82l6B15kAiK/2eH2Btdltb7Fe+xAcTN2MUjgZZ9OFO
         H6tRnbemZWbeGCmFBNy3tYBCms75OED7G9mPKX2opf1eMcjgdbXR5at79x9ETa5qCVPZ
         qqKUB3eouYPKUX5QcRBLoGq4e4QzQGv2afHkgBnx81vk5CkTlYayXjNTwOfbRyNQdxRa
         GkZv01ZpF7iFxEdvlMDK2V2DVWJmvuFptZg1tfZSgXcM8XjAgWlN1BPliAv4/eTsg6+d
         O2feg9K0XRS0eYiwb2CYIVb6ohuK9aeFakCar+AbaPa1wFS+PqryIrwi/7F0kwR0kYp9
         rvRQ==
X-Gm-Message-State: AOAM5336EPie1+aCZLDQnKVhaIvlsB9/Ri2CR96RKzkR4S4QQrYTBX/X
        LPRo10Snd0ZbOY/fPfdNcY+1aNh3HOQ7qklC/Nw=
X-Google-Smtp-Source: ABdhPJzSaGJea92VDK8uQSe2xM9Dl/cv2iQLcugmvZnlNdd3+GpOQitQ2CdDrrurV39j7EjgC3El6z1ppc+w8Nwo93s=
X-Received: by 2002:a0c:e7c9:: with SMTP id c9mr8812238qvo.47.1626239635222;
 Tue, 13 Jul 2021 22:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210707051241.20565-1-vjsanjay@gmail.com> <202107130145.OLy5XU3h-lkp@intel.com>
In-Reply-To: <202107130145.OLy5XU3h-lkp@intel.com>
From:   Sanjay Kumar J <vjsanjay@gmail.com>
Date:   Wed, 14 Jul 2021 10:44:08 +0530
Message-ID: <CAN7cG1a1sSQLuotMie44-SHyCQu5E1QCWwJxhqvVWGASaLh1PA@mail.gmail.com>
Subject: Re: [PATCH v2] tools/runqslower: use __state instead of state
To:     kernel test robot <lkp@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, kbuild-all@lists.01.org,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 11:12 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi SanjayKumar,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on bpf-next/master]
> [also build test ERROR on vhost/linux-next ipvs/master v5.14-rc1]
> [cannot apply to bpf/master next-20210712]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
v4 version of the patch is already accepted in bpf tree
commit-id:5616e895ecc56 and also in net tree ommit:5616e895ecc56
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/SanjayKumar-J/tools-runqslower-use-__state-instead-of-state/20210707-131703
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: x86_64-rhel-8.3-kselftests (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/0day-ci/linux/commit/0e86dc86c0f18512dc19ba3d0b001b3f06338a0d
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review SanjayKumar-J/tools-runqslower-use-__state-instead-of-state/20210707-131703
>         git checkout 0e86dc86c0f18512dc19ba3d0b001b3f06338a0d
>         # save the attached .config to linux build tree
>         mkdir build_dir
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash -C tools/testing/selftests/bpf install
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
> >> runqslower.bpf.c:77:12: error: no member named '__state' in 'struct task_struct'; did you mean 'state'?
>            if (prev->__state == TASK_RUNNING)
>                      ^~~~~~~
>                      state
>    /tools/vmlinux.h:1096:20: note: 'state' declared here
>            volatile long int state;
>                              ^
>    1 error generated.
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
