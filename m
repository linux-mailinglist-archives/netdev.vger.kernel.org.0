Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF70CB101
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731720AbfJCVWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:22:32 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46350 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728763AbfJCVWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:22:32 -0400
Received: by mail-qt1-f195.google.com with SMTP id u22so5651867qtq.13;
        Thu, 03 Oct 2019 14:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KudO1+oRE7OC5W3PIQ9AjHPMoLOpGH+EnWx+p184Uzc=;
        b=M+lZAgO63rkB50z2QKfYXN2dvaDO4QYwdYN5rOcquRhXCWprrRkRJI0Lq+RbW5eqbm
         TQRStc7NP4C1i5QmV/K8RE7c9m8VNW7fI3I/74U+XaCnwayNAa/xlSN64BOx8wO3s2C0
         I4nX5DSy2fsQwWwlu+xrE7La0UZP193+wLNfNRQJ0GMz7JzoiYysPy6LdmPiKJUwaiYw
         x83acIIkhdlFAM/0R+Mxl7mNEvCXq2jL/ntI/LN7Zw9L8KOAg6LNxgMAYEfD8HvhxJrt
         2fzjmgxY55knnqVdNaA/0eEYw2UycSeoRsjAg4OeD4INVCuoIBI3tQ1foygde7BXTRRv
         hung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KudO1+oRE7OC5W3PIQ9AjHPMoLOpGH+EnWx+p184Uzc=;
        b=tUSLhJuxhtmndajTnVDYqXhspRUzQqqi/0bGJPXv/X/zx02nzbMoE//LD1b4z1mhl6
         no2wrvLuak5s14t9VQbtFcSLHUyzslEH67/7e7Yb0HLxrO0JPP6HlDAlEDmJ9tGkELKZ
         bL+7HMuTUIaru4U1eSrENWbyTZrE84RXFzU26zqXdabZ/SFykrXT1fLSjKDs+GCwsvqy
         bVWDHmuy2se9qJzr0QvqZeR5CqO2HqAN5nk5hL/LPMvFELGvLnH+1Y3cBaYSB8pinMgI
         7JVQrxelcWjf9BXZxmU/oJ2hK6AY/qvqgdKod8mC8RAUN2vEpSeG7ahEN3I/IdFXAQCi
         Edbw==
X-Gm-Message-State: APjAAAVmXR+N7GhHLS6SH62BO8RraPGMwNH4O3bbcp8IWxH1ip3mDCsT
        /Grp1YsX5i5f/PqT7b6YI5zoGHtquw9qKT5knHE=
X-Google-Smtp-Source: APXvYqw1dT/OHlkVzUujoWq2u+CNNDKvrfQWas0nyYXxDGLMTGlwC6eqnHDDNwJbaYPrPyakf2MBJR33ljZ7liUijCA=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr12170728qtq.141.1570137750969;
 Thu, 03 Oct 2019 14:22:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-3-andriin@fb.com>
 <CAPhsuW4pS_P0n+UCB40uSVKp6W0N4Xas4UT9oofLxSZjhmyeGw@mail.gmail.com>
In-Reply-To: <CAPhsuW4pS_P0n+UCB40uSVKp6W0N4Xas4UT9oofLxSZjhmyeGw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 14:22:20 -0700
Message-ID: <CAEf4BzY2dG0QrBQF8g2w=yvSeVJ7LtWrLOckrWsCAnBvtZgMiQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/7] selftests/bpf: samples/bpf: split off
 legacy stuff from bpf_helpers.h
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 1:09 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Wed, Oct 2, 2019 at 3:01 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Split off few legacy things from bpf_helpers.h into separate
> > bpf_legacy.h file:
> > - load_{byte|half|word};
> > - remove extra inner_idx and numa_node fields from bpf_map_def and
> >   introduce bpf_map_def_legacy for use in samples;
> > - move BPF_ANNOTATE_KV_PAIR into bpf_legacy.h.
> >
> > Adjust samples and selftests accordingly by either including
> > bpf_legacy.h and using bpf_map_def_legacy, or switching to BTF-defined
> > maps altogether.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> with a nit below
>
> > ---
> >  samples/bpf/hbm_kern.h                        | 28 +++++++------
> >  samples/bpf/map_perf_test_kern.c              | 23 +++++------
> >  samples/bpf/parse_ldabs.c                     |  1 +
> >  samples/bpf/sockex1_kern.c                    |  1 +
> >  samples/bpf/sockex2_kern.c                    |  1 +
> >  samples/bpf/sockex3_kern.c                    |  1 +
> >  samples/bpf/tcbpf1_kern.c                     |  1 +
> >  samples/bpf/test_map_in_map_kern.c            | 15 +++----
> >  tools/testing/selftests/bpf/bpf_helpers.h     | 24 +-----------
> >  tools/testing/selftests/bpf/bpf_legacy.h      | 39 +++++++++++++++++++
> >  .../testing/selftests/bpf/progs/sockopt_sk.c  | 13 +++----
> >  tools/testing/selftests/bpf/progs/tcp_rtt.c   | 13 +++----
> >  .../selftests/bpf/progs/test_btf_haskv.c      |  1 +
> >  .../selftests/bpf/progs/test_btf_newkv.c      |  1 +
> >  14 files changed, 92 insertions(+), 70 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/bpf_legacy.h
> >
> > diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
> > index aa207a2eebbd..91880a0e9c2f 100644
> > --- a/samples/bpf/hbm_kern.h
> > +++ b/samples/bpf/hbm_kern.h
> > @@ -24,6 +24,7 @@
> >  #include <net/inet_ecn.h>
> >  #include "bpf_endian.h"
> >  #include "bpf_helpers.h"
> > +#include "bpf_legacy.h"
>
> nit: I guess we don't need bpf_legacy.h here?

You are right, I converted maps to BTF-defined ones, dropping bpf_legacy.h.
