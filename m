Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B47612C0
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 21:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfGFS71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 14:59:27 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35124 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfGFS70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 14:59:26 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so16554947ioo.2
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 11:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VyFWrFSWIJ3fj1Apm+Ffchu/OUHJJfKOc4EBRtP8b4A=;
        b=F5xBufBuKXfHf9Sv6VD8E33fQviZpXarxLeDYtXLM4su2n3cUY5MiRhUPRKyn857Tj
         Vg7P/Vw3ouTqHkwjFTEL//7IJwHDAraAFMEZ7wLHwfW4NFM8gBTOkzZSntFyYolo5Ppj
         p/DhG7FNNy5K7Dr6eU681nhXu2wbZDPl8o0hVwIjmD6bXZG5fZXe/Vj2BmQ7wbo1kd6Y
         maUfjIKSfMrJcoK05zeZ/SmI/pe8mqHyvJIcf43BLdZVOmPFMMCGOa8BsToV4H4uKxgu
         HNkvLKJflQCC1k/yBNXRBub+7OA1RkXpdkxx3fYPIc3Mp+ywgmz5D0i3IG6LSU1qYiIX
         JCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VyFWrFSWIJ3fj1Apm+Ffchu/OUHJJfKOc4EBRtP8b4A=;
        b=hGTvyLbrO48CypH76fhG2h2XgfnrvEIjaT1Q61ZiZaqrwEoWk+UcmEvOkXm6Bhm9AC
         22tjfb8UdPx7gdj4GHEMhdnvdr0Jsf3eef30NmOthc/m8wikdqcfmXAkzAg3SYfWXL/u
         xMTfgTpx7MXhREdSlLnq9gng0B+UgdW9uAfUZbsonohcmJF51V+a3MqtgmXApB+A0ave
         byJjVb0M8ZFytcUklOEgXczlQVBXblmgi/Ml8ZBZQTGu9wRpeqpvzUk9fHlH5Ko7Xb8G
         RL5Qug5bWGObeDl6T8Q9BZYqcehVQD+O2OMQC1SDrFBlGUCMimpnLDKJrbyzCti/4oPX
         S8iA==
X-Gm-Message-State: APjAAAW6Bgelsj+5AkXfG1Lij+lM+6eS6fmdmdHPp6RS0cGQTtlTGDWR
        6hS4QTijYf7Xqk2gVfB75dbpnZu4gV9FpWXdNAA=
X-Google-Smtp-Source: APXvYqxr1PFhpc9HXEAIosAUBmMShT7KuqPh7RJqLdNm+X3uwaVBJCEelptWJcuHRG+YTAMX+OnDXc9uBF32NzGCgJo=
X-Received: by 2002:a02:5a02:: with SMTP id v2mr11564075jaa.124.1562439565473;
 Sat, 06 Jul 2019 11:59:25 -0700 (PDT)
MIME-Version: 1.0
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
In-Reply-To: <156240283550.10171.1727292671613975908.stgit@alrua-x1>
From:   Y Song <ys114321@gmail.com>
Date:   Sat, 6 Jul 2019 11:58:49 -0700
Message-ID: <CAH3MdRVB5Wq7_SPShk=xQaoGBdcdzRfb-t02JWOETRxY9QrKGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/6] xdp: Add devmap_hash map type
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 6, 2019 at 1:47 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> This series adds a new map type, devmap_hash, that works like the existin=
g
> devmap type, but using a hash-based indexing scheme. This is useful for t=
he use
> case where a devmap is indexed by ifindex (for instance for use with the =
routing
> table lookup helper). For this use case, the regular devmap needs to be s=
ized
> after the maximum ifindex number, not the number of devices in it. A hash=
-based
> indexing scheme makes it possible to size the map after the number of dev=
ices it
> should contain instead.
>
> This was previously part of my patch series that also turned the regular
> bpf_redirect() helper into a map-based one; for this series I just pulled=
 out
> the patches that introduced the new map type.
>
> Changelog:
>
> v2:
>
> - Split commit adding the new map type so uapi and tools changes are sepa=
rate.
>
> Changes to these patches since the previous series:
>
> - Rebase on top of the other devmap changes (makes this one simpler!)
> - Don't enforce key=3D=3Dval, but allow arbitrary indexes.
> - Rename the type to devmap_hash to reflect the fact that it's just a has=
hmap now.
>
> ---
>
> Toke H=C3=B8iland-J=C3=B8rgensen (6):
>       include/bpf.h: Remove map_insert_ctx() stubs
>       xdp: Refactor devmap allocation code for reuse
>       uapi/bpf: Add new devmap_hash type
>       xdp: Add devmap_hash map type for looking up devices by hashed inde=
x
>       tools/libbpf_probes: Add new devmap_hash type
>       tools: Add definitions for devmap_hash map type

Thanks for re-organize the patch. I guess this can be tweaked a little more
to better suit for syncing between kernel and libbpf repo.

Let me provide a little bit background here. The below is
a sync done by Andrii from kernel/tools to libbpf repo.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
commit 39de6711795f6d1583ae96ed8d13892bc4475ac1
Author: Andrii Nakryiko <andriin@fb.com>
Date:   Tue Jun 11 09:56:11 2019 -0700

    sync: latest libbpf changes from kernel

    Syncing latest libbpf commits from kernel repository.
    Baseline commit:   e672db03ab0e43e41ab6f8b2156a10d6e40f243d
    Checkpoint commit: 5e2ac390fbd08b2a462db66cef2663e4db0d5191

    Andrii Nakryiko (9):
      libbpf: fix detection of corrupted BPF instructions section
      libbpf: preserve errno before calling into user callback
      libbpf: simplify endianness check
      libbpf: check map name retrieved from ELF
      libbpf: fix error code returned on corrupted ELF
      libbpf: use negative fd to specify missing BTF
      libbpf: simplify two pieces of logic
      libbpf: typo and formatting fixes
      libbpf: reduce unnecessary line wrapping

    Hechao Li (1):
      bpf: add a new API libbpf_num_possible_cpus()

    Jonathan Lemon (2):
      bpf/tools: sync bpf.h
      libbpf: remove qidconf and better support external bpf programs.

    Quentin Monnet (1):
      libbpf: prevent overwriting of log_level in bpf_object__load_progs()

     include/uapi/linux/bpf.h |   4 +
     src/libbpf.c             | 207 ++++++++++++++++++++++-----------------
     src/libbpf.h             |  16 +++
     src/libbpf.map           |   1 +
     src/xsk.c                | 103 ++++++-------------
     5 files changed, 167 insertions(+), 164 deletions(-)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

You can see the commits at tools/lib/bpf and
commits at tools/include/uapi/{linux/[bpf.h, btf.h], ...}
are sync'ed to libbpf repo.

So we would like kernel commits to be aligned that way for better
automatic syncing.

Therefore, your current patch set could be changed from
   >       include/bpf.h: Remove map_insert_ctx() stubs
   >       xdp: Refactor devmap allocation code for reuse
   >       uapi/bpf: Add new devmap_hash type
   >       xdp: Add devmap_hash map type for looking up devices by hashed i=
ndex
   >       tools/libbpf_probes: Add new devmap_hash type
   >       tools: Add definitions for devmap_hash map type
to
      1. include/bpf.h: Remove map_insert_ctx() stubs
      2. xdp: Refactor devmap allocation code for reuse
      3. kernel non-tools changes (the above patch #3 and #4)
      4. tools/include/uapi change (part of the above patch #6)
      5. tools/libbpf_probes change
      6. other tools/ change (the above patch #6 - new patch #4).

Thanks!

Yonghong

>
>
>  include/linux/bpf.h                     |   11 -
>  include/linux/bpf_types.h               |    1
>  include/trace/events/xdp.h              |    3
>  include/uapi/linux/bpf.h                |    1
>  kernel/bpf/devmap.c                     |  325 +++++++++++++++++++++++++=
+-----
>  kernel/bpf/verifier.c                   |    2
>  net/core/filter.c                       |    9 +
>  tools/bpf/bpftool/map.c                 |    1
>  tools/include/uapi/linux/bpf.h          |    1
>  tools/lib/bpf/libbpf_probes.c           |    1
>  tools/testing/selftests/bpf/test_maps.c |   16 ++
>  11 files changed, 310 insertions(+), 61 deletions(-)
>
