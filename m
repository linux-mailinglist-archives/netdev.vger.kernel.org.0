Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3812E286F
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 18:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgLXRk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 12:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgLXRk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 12:40:26 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B6BC061573;
        Thu, 24 Dec 2020 09:39:45 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id d14so2516482qkc.13;
        Thu, 24 Dec 2020 09:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rTTWwvMtGEYtpZ+VsHsHi+ahZuxpKvcxcrMaAqQHYfQ=;
        b=li3d7Ul0SwqX5wc+E2ZO0oA725Q6lPeVeOpjFxkkTlKwWrek60V1ReN6FSDj8nxsrf
         3vXa3mH22+k01GL2jAj3tq+UkjC1mnd3L7qAGAVRdpeg4VLWS398x3gyjwp6sZPRKaf9
         1fYG5PW4MumUw2TUVyAh/pqeAcmsrLOu8u9aAiDKnsZcjnLY/sGajVINT3zRi3VKODBt
         BXjIwLmu+lbsKfJnTCXzWyfGtsEcIjCABk8vats7bmt/81kZg+iV3370RgI/AMeEy23M
         k7877KCTN5/a6Z+8EnvIKejWyPg3m4hbPIOZLF8xpoiT5K0rbbVXHG9XfSher0q+2jGh
         cv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rTTWwvMtGEYtpZ+VsHsHi+ahZuxpKvcxcrMaAqQHYfQ=;
        b=reqgvbBTUjJkyl4OifW9r7YA01S85fNm0GeC/VYdAY4XdMzsIzxkBTzQSEEnCANk1s
         56/BoRVaC+SgdnUQBX6YZOoNE+2PFpfOe54xsYjce/9dJgiRki4A8PxkmfjvFusNGxzO
         1aQCq+trBF0AZ9WOAeepw7oa+uVPaI8yvHGmYkPTPmOR2SWd6ZckL/63RurGIx/ycS2x
         xAQwgbvKAfJBHE95L42EmoFZE89MJaLiscMXYu9Qy48+rRKmDnWsMoGbOQuRDERlsbYu
         pSziNLL6s1fEqdZ/80uE+VYgOwD2soIMCTWKygqPxpfEFVKHFb2PekpotvS2oI+WN88U
         NtMw==
X-Gm-Message-State: AOAM532HpsY0r9JRrOIv1Olxu5av2xlRIJNj5zFQBP/EWyw3TyP3oDeL
        Uq6O69bh1Val9rdoA7C2EkY=
X-Google-Smtp-Source: ABdhPJyy8IKFpLmcPK1GBCWg4VNIV06eHB6aEx81ms3EgFUj8WlLfgD/rYT2lI3TQvOF6+IQuykmqA==
X-Received: by 2002:a05:620a:958:: with SMTP id w24mr32092270qkw.99.1608831585025;
        Thu, 24 Dec 2020 09:39:45 -0800 (PST)
Received: from localhost (pc-145-79-45-190.cm.vtr.net. [190.45.79.145])
        by smtp.gmail.com with ESMTPSA id v4sm16444868qth.16.2020.12.24.09.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 09:39:44 -0800 (PST)
Date:   Thu, 24 Dec 2020 14:39:40 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v10 bpf-next] bpf/selftests: fold
 test_current_pid_tgid_new_ns into test_progs.
Message-ID: <20201224173939.GA7572@localhost>
References: <20201221222315.GA19972@localhost>
 <CAEf4BzbqWa+Eco4u1zN4RqyprezBAJM-O6Oq4xv9q8Ac74ZhWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbqWa+Eco4u1zN4RqyprezBAJM-O6Oq4xv9q8Ac74ZhWg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 12:26:04PM -0800, Andrii Nakryiko wrote:
> On Mon, Dec 21, 2020 at 2:25 PM Carlos Neira <cneirabustos@gmail.com> wrote:
> >
> > Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> > This change folds test cases into test_progs.
> >
> > Changes from v9:
> >
> >  - Added test in root namespace.
> >  - Fixed changed tracepoint from sys_enter to sys_usleep.
> >  - Fixed pid, tgid values were inverted.
> >  - Used CLONE(2) for namespaced test, the new process pid will be 1.
> >  - Used ASSERTEQ on pid/tgid validation.
> >  - Added comment on CLONE(2) call
> >
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---

Andrii,

Thanks for taking the time to check this out.


For the code style issues I found out that I was not using the --strict flag for
checkpatch.pl so I missed those warnings, now I'm using--strict as default. 
I should look into using cindent or clang-format to avoid this.

> 
> See checkpatch.pl errors ([0]), ignore the "do not initialize globals
> with zero" ones. Next time, please don't wait for me to point out
> every single instance where you didn't align wrapped around
> parameters.
> 
>   [0] https://patchwork.hopto.org/static/nipa/405025/11985347/checkpatch/stdout
> 
> >  tools/testing/selftests/bpf/.gitignore        |   1 -
> >  tools/testing/selftests/bpf/Makefile          |   3 +-
> >  .../bpf/prog_tests/ns_current_pid_tgid.c      | 149 ++++++++++------
> >  .../bpf/progs/test_ns_current_pid_tgid.c      |  29 ++--
> >  .../bpf/test_current_pid_tgid_new_ns.c        | 160 ------------------
> >  5 files changed, 106 insertions(+), 236 deletions(-)
> >  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
> >

You are right, the code is redundant I'll reuse it.
> newns_pidtgid and test_ns_current_pid_tgid_global_ns look identical to
> me, am I missing something on why you didn't reuse the testing logic
> between the two?
> 
> > +{
> > +       struct test_ns_current_pid_tgid__bss  *bss;
> > +       int err = 0, duration = 0;
> > +       struct test_ns_current_pid_tgid *skel;
> > +       pid_t pid, tgid;
> > +       struct stat st;
> >
> 
> [...]
