Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB3D1D8945
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgERUee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:34:33 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18779C061A0C;
        Mon, 18 May 2020 13:34:32 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f83so11807805qke.13;
        Mon, 18 May 2020 13:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SjpYMEDgjN1v7AFfuV17lpTKKS3jouvY+EYn/S/9Fc0=;
        b=B2vFrGjgPIZid9GEj0NiKUH0lWhoxw1+K7rw/0Ij07wm+7KFOWTFE1dB/IZeAu00gA
         SESBu3LnlltJqkUogTbo8M97O/BDRqxUuIX3kfC5iVbxATg8ZhrOh1q+I34tbDtpHo+h
         MdgA3l9iMxK3+TVWE+oM68J+BrjAzkojN85nhss2Nw0a0vad8+i+mIUAMwfkJBSxEjRJ
         05dYAty76F25GEaH0xDAmTwVGSxdXeFaB9joyZj4Xs6IbCWeLR2dyw7VKsu4ZdtoN4RX
         URIqOIxP8QCWkde9HjzqRKAnhg5IWSjD6vjBQ4YWUdYTUcgXclp36pP5UtjDouSuUmKO
         59Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SjpYMEDgjN1v7AFfuV17lpTKKS3jouvY+EYn/S/9Fc0=;
        b=gHca5NkxhEJP+M1e55O65GtqdgmuQJo65gUEsIyVtJfIWxRZoWQ6z4JkiOW7j0ecvI
         cjIClSRMDYOAGt/h8q0LeH582HTNNigOGBZYKylVqN2TcM+QBDNpCHuNub+0PpZ4sXSD
         cUrnnHZatM4CHdhMVyb8zIxEUW9lA3XJqm3uFaiVhogAe3M9jmCO3PIO/WIyuVMBc4ag
         LFtgAmA4oayFY6Knzuakb6pxW6bSO7o5UJaY63uLotAj4CqUdVdW3HMuWHls1sWQY0FK
         jnOOexfn3AabY7KFDMxbrl3iToW9xT0is/jWF5790BqESOKptawavmUT4Zx0TzrM41sC
         QzHg==
X-Gm-Message-State: AOAM533rmGpFOuNOaeQr68R08JOy+Ypom3rd6COs0JW082xycTG1O75v
        M5Xf6FeKxdOb2Gd5Qb9HPtVfU/7eTjAnoEKHoIQ=
X-Google-Smtp-Source: ABdhPJzLbF28DrikEwstSuDD/GMAPVNWkqPu0lLIR9/p/TVIRitYN/lwqNfTfq9iV0DG12u2b0xfj7JdLcOLcvBbdmE=
X-Received: by 2002:a37:68f:: with SMTP id 137mr18087107qkg.36.1589834071079;
 Mon, 18 May 2020 13:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1589813738.git.daniel@iogearbox.net>
In-Reply-To: <cover.1589813738.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 13:34:20 -0700
Message-ID: <CAEf4BzY4+9hTg34GHELBCF413HB7EtxxtYyHcTLgT2GczoNiMw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] Add get{peer,sock}name cgroup attach types
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 8:36 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Trivial patch to add get{peer,sock}name cgroup attach types to the BPF
> sock_addr programs in order to enable rewriting sockaddr structs from
> both calls along with libbpf and bpftool support as well as selftests.
>
> Thanks!
>
> Daniel Borkmann (4):
>   bpf: add get{peer,sock}name attach types for sock_addr
>   bpf, libbpf: enable get{peer,sock}name attach types
>   bpf, bpftool: enable get{peer,sock}name attach types
>   bpf, testing: add get{peer,sock}name selftests to test_progs
>
>  include/linux/bpf-cgroup.h                    |   1 +
>  include/uapi/linux/bpf.h                      |   4 +
>  kernel/bpf/syscall.c                          |  12 ++
>  kernel/bpf/verifier.c                         |   6 +-
>  net/core/filter.c                             |   4 +
>  net/ipv4/af_inet.c                            |   8 +-
>  net/ipv6/af_inet6.c                           |   9 +-
>  .../bpftool/Documentation/bpftool-cgroup.rst  |  10 +-
>  .../bpftool/Documentation/bpftool-prog.rst    |   3 +-
>  tools/bpf/bpftool/bash-completion/bpftool     |  15 ++-
>  tools/bpf/bpftool/cgroup.c                    |   7 +-
>  tools/bpf/bpftool/main.h                      |   4 +
>  tools/bpf/bpftool/prog.c                      |   6 +-
>  tools/include/uapi/linux/bpf.h                |   4 +
>  tools/lib/bpf/libbpf.c                        |   8 ++
>  tools/testing/selftests/bpf/network_helpers.c |  11 +-
>  tools/testing/selftests/bpf/network_helpers.h |   1 +
>  .../bpf/prog_tests/connect_force_port.c       | 107 +++++++++++++-----
>  .../selftests/bpf/progs/connect_force_port4.c |  59 +++++++++-
>  .../selftests/bpf/progs/connect_force_port6.c |  70 +++++++++++-
>  20 files changed, 295 insertions(+), 54 deletions(-)
>
> --
> 2.21.0
>

Looks good to me. It would be nice to convert those selftests to use
skeletons and bpf_link-based cgroup attachments, but that's for
another day, I suppose.

I'll also start a new thread regarding the alarming growth of enum
bpf_attach_type (and it's impact on struct cgroup_bpf size), but it's
not specific to this change.

So, for the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>
