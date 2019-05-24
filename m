Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7BF2A018
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404212AbfEXUtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:49:42 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36853 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404182AbfEXUtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:49:41 -0400
Received: by mail-lj1-f195.google.com with SMTP id z1so4327960ljb.3;
        Fri, 24 May 2019 13:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VhdT2Uy3Pi6rfMZvbQxZ0OsYh/yykRYbEqsyaHR8QXw=;
        b=COq1Qwldga6qm3NHELwVkj4YtfxbMalPMy+X/x1ci3lZmksF7YOH0oBtRhxmSMpRPm
         76d69IC6iVHUG1kUE3dNdYX85VdTLQwrxmoAHtWgU1qjH58cQWQtVODsBC6HhVUOy2A7
         J91dQdJ5GPzdpc7/49JCkRVJDYLeq2EsFjCotWlDIgKGHIhLo0/ZGt5mNi6Q1nXj6VQ8
         VJOmQyFTMwnFQhK9le/Ept7NaW2YxFQTnr7eBmmskdnxmf7Wl6O6pTazLsC9jyHzECeU
         hIw4Q0yv63wrkTTEKIdntzMpXd28nCQAzmwKpPpxtVzRXbTe+q6q9iDh67H2ntMlE1RM
         iIaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VhdT2Uy3Pi6rfMZvbQxZ0OsYh/yykRYbEqsyaHR8QXw=;
        b=jt/H/pOwcNIhaMcT5YolWzGtXJCl8q2vcbHigerXfow5Qy7ZDN9KAqmR6BDf4/uGKD
         9/iQlTdAHR9Qt6I1fd3pRTpeidhJ9INn4q49dckMvp3pG8C8bgIjDYowzJgc0Cx0CvST
         Wl4GOx+Bi+YQ5pbjfuDzzPpchZ7/8/tmfcD1eUV1IaBF1nUv0D6Yjd1d8mEgrq8sJnO4
         cND+ulJHimCy2tp1DC1uZy8ucP5HsfPbmoonLYJAIonciOwiqWGjI+RJgFWVD6CWRo79
         D9A5az2cqSKQ2p3VQIIE1rjEJlKXECCiVr9g3nKQTr1EEaNkv6dQwH5mjSub1iVeDmt8
         cQbw==
X-Gm-Message-State: APjAAAV1l+K66yUyYl+ioE/5O3+7mEGL4JnVvfPh3gGYUoSZ3UnBmZ/F
        A6uChP1a6M+47lcGWzsf2a3bBnEsGjZKX4Ef9Fg=
X-Google-Smtp-Source: APXvYqy2UI/rZfZDvCke9BTAdI57OyrfDA2hvmMsq1QhIxpqi/JV9Ex2oV/fsS9k3ekCpzrzVLBvDGQaY1eTz2e6A1E=
X-Received: by 2002:a2e:9d09:: with SMTP id t9mr21035214lji.151.1558730979076;
 Fri, 24 May 2019 13:49:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190523125355.18437-1-mrostecki@opensuse.org> <4642ca96-22ab-ad61-a6a1-1d2ef7239cb8@fb.com>
In-Reply-To: <4642ca96-22ab-ad61-a6a1-1d2ef7239cb8@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 May 2019 13:49:26 -0700
Message-ID: <CAADnVQKYiv2ZMTLcJ6ZAoSA8u7+GZe+o-00qidefuNPa7KsbbA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 RESEND 0/2] Move bpf_printk to bpf_helpers.h
To:     Yonghong Song <yhs@fb.com>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 9:52 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/23/19 5:53 AM, Michal Rostecki wrote:
> > This series of patches move the commonly used bpf_printk macro to
> > bpf_helpers.h which is already included in all BPF programs which
> > defined that macro on their own.
> >
> > v1->v2:
> > - If HBM_DEBUG is not defined in hbm sample, undefine bpf_printk and set
> >    an empty macro for it.
> >
> > Michal Rostecki (2):
> >    selftests: bpf: Move bpf_printk to bpf_helpers.h
> >    samples: bpf: Do not define bpf_printk macro
> >
> >   samples/bpf/hbm_kern.h                                | 11 ++---------
> >   samples/bpf/tcp_basertt_kern.c                        |  7 -------
> >   samples/bpf/tcp_bufs_kern.c                           |  7 -------
> >   samples/bpf/tcp_clamp_kern.c                          |  7 -------
> >   samples/bpf/tcp_cong_kern.c                           |  7 -------
> >   samples/bpf/tcp_iw_kern.c                             |  7 -------
> >   samples/bpf/tcp_rwnd_kern.c                           |  7 -------
> >   samples/bpf/tcp_synrto_kern.c                         |  7 -------
> >   samples/bpf/tcp_tos_reflect_kern.c                    |  7 -------
> >   samples/bpf/xdp_sample_pkts_kern.c                    |  7 -------
> >   tools/testing/selftests/bpf/bpf_helpers.h             |  8 ++++++++
> >   .../testing/selftests/bpf/progs/sockmap_parse_prog.c  |  7 -------
> >   .../selftests/bpf/progs/sockmap_tcp_msg_prog.c        |  7 -------
> >   .../selftests/bpf/progs/sockmap_verdict_prog.c        |  7 -------
> >   .../testing/selftests/bpf/progs/test_lwt_seg6local.c  |  7 -------
> >   tools/testing/selftests/bpf/progs/test_xdp_noinline.c |  7 -------
> >   tools/testing/selftests/bpf/test_sockmap_kern.h       |  7 -------
> >   17 files changed, 10 insertions(+), 114 deletions(-)
>
> Ack for the whole series.
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
