Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5DD23B0B1
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgHCXKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgHCXKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:10:15 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2EDC06174A;
        Mon,  3 Aug 2020 16:10:15 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id n141so18785869ybf.3;
        Mon, 03 Aug 2020 16:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IeerNnMdzNPokBSrAZxvwikhnnY6fjPj0HBqHI6yPcw=;
        b=SYT/05DR239G4b55qCJdFsqK9trezuDMK2y0KsgKF/OM3SZwWHiKEIf73V3IopT/+y
         lo0S30SCbQt8eNWExCRx2yKOeMh3OIyj9/ybVKfsIZI3b4CY+u00FeK/ufzAFoN+MmHE
         m+4VpDwSk7aCauVvRgJuOWGXrhquNDG/+wJONG5sIqpXkvkuqqGh0Kp6aNrR23UMsemg
         Ve8lkR/E709mnUbqVRFvmtfTVhUMVLfai1oUYV97p5dEdUO++ebYQ+mClxXMefNC6mfF
         ZZ7iDOS37tvDyx70SvvcC7yYYIhROxAVk8sfakpaoiPbvzaPgALxht4KyN8vpaF2GOz+
         m/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IeerNnMdzNPokBSrAZxvwikhnnY6fjPj0HBqHI6yPcw=;
        b=GHgMQUMzNYat5SInNv36T0RNUFO8mff+MJK9VH/iccYyZ8HTQ26JoZoM2AiSaaPmqx
         IsChBzjJv/vgj2fty9zMlvJkk3Darlu9S0+oZCYSFko+OoEowhj4wapZoaYWndqJZ6sE
         6MiWEQlRbrfsh/f/6XdrZ/AVU3y2sPsDgm79J+vrO1Gi2OWP57WmdhmWHFg3UB9Ip4d1
         B+wsArrLXiM3XN5nMJVqZ8vLQ8C04rQhKmBsah4aKK8r122x6vJL1Zi5dauExWLUEso3
         uEo4MqvmIDO4I/UotPnMUDtVoWzEF4iM9LmSqQtu4pEF+AAjnXDul5AtAxSUO1Ycg56r
         h9CA==
X-Gm-Message-State: AOAM5307hYkIJZ0EA+/JrofjWd6DhAFXtHObcqUBGOzhOxysUTkLBG1L
        UbHAkjOs8gDStt4OmBvKjmqscnsH42vVnA/suRA=
X-Google-Smtp-Source: ABdhPJxSMY8GusTSfn3UOvr/45C27iUFsgM4qNRkyoIb04V7YQY6gQgYM73zzZ1MSQ7VDw8mjRDejfLVh4ngYV0CCDo=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr31127256ybg.347.1596496214764;
 Mon, 03 Aug 2020 16:10:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200803224340.2925417-1-yhs@fb.com>
In-Reply-To: <20200803224340.2925417-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Aug 2020 16:10:03 -0700
Message-ID: <CAEf4BzbKFONMZ0r5ky5NPGh+Xi6yn_hhFBrtAXEXiVxg5vZkFQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/2] bpf: change uapi for bpf iterator map elements
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 3, 2020 at 3:44 PM Yonghong Song <yhs@fb.com> wrote:
>
> Andrii raised a concern that current uapi for bpf iterator map
> element is a little restrictive and not suitable for future potential
> complex customization. This is a valid suggestion, considering people
> may indeed add more complex custimization to the iterator, e.g.,
> cgroup_id + user_id, etc. for task or task_file. Another example might
> be map_id plus additional control so that the bpf iterator may bail
> out a bucket earlier if a bucket has too many elements which may hold
> lock too long and impact other parts of systems.
>
> Patch #1 modified uapi with kernel changes. Patch #2
> adjusted libbpf api accordingly.
>
> Changelogs:
>   v2 -> v3:
>     . undo "not reject iter_info.map.map_fd == 0" from v1.
>       In the future map_fd may become optional, so let us use map_fd == 0
>       indicating the map_fd is not set by user space.
>     . add link_info_len to bpf_iter_attach_opts to ensure always correct
>       link_info_len from user. Otherwise, libbpf may deduce incorrect
>       link_info_len if it uses different uapi header than the user app.
>   v1 -> v2:
>     . ensure link_create target_fd/flags == 0 since they are not used. (Andrii)
>     . if either of iter_info ptr == 0 or iter_info_len == 0, but not both,
>       return error to user space. (Andrii)
>     . do not reject iter_info.map.map_fd == 0, go ahead to use it trying to
>       get a map reference since the map_fd is required for map_elem iterator.
>     . use bpf_iter_link_info in bpf_iter_attach_opts instead of map_fd.
>       this way, user space is responsible to set up bpf_iter_link_info and
>       libbpf just passes the data to the kernel, simplifying libbpf design.
>       (Andrii)
>
> Yonghong Song (2):
>   bpf: change uapi for bpf iterator map elements
>   tools/bpf: support new uapi for map element bpf iterator
>
>  include/linux/bpf.h                           | 10 ++--
>  include/uapi/linux/bpf.h                      | 15 ++---
>  kernel/bpf/bpf_iter.c                         | 58 +++++++++----------
>  kernel/bpf/map_iter.c                         | 37 +++++++++---
>  kernel/bpf/syscall.c                          |  2 +-
>  net/core/bpf_sk_storage.c                     | 37 +++++++++---
>  tools/bpf/bpftool/iter.c                      |  9 ++-
>  tools/include/uapi/linux/bpf.h                | 15 ++---
>  tools/lib/bpf/bpf.c                           |  3 +
>  tools/lib/bpf/bpf.h                           |  4 +-
>  tools/lib/bpf/libbpf.c                        |  6 +-
>  tools/lib/bpf/libbpf.h                        |  5 +-
>  .../selftests/bpf/prog_tests/bpf_iter.c       | 40 ++++++++++---
>  13 files changed, 159 insertions(+), 82 deletions(-)
>
> --
> 2.24.1
>


Looks great, thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>
