Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6592B1B4BCF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 19:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDVRbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 13:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726006AbgDVRbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 13:31:01 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53993C03C1A9;
        Wed, 22 Apr 2020 10:31:01 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id p13so1267952qvt.12;
        Wed, 22 Apr 2020 10:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mczbHZj3l4mVA/2zZB1hz+aUfHOOEDjnnd6R+ZkSLec=;
        b=X7neNgYw1HQrAMYTdMeqYb6ei5i8PG0j5xk0Ey6FXdEfYnJeXOA673wdLJ3PAw3AzM
         rq/xx8J6bXho/MYm7554ACMkaXSOZQPBxCmRXcWA7aZleWqNsQ7q6m05R4jR34K5xflu
         UvSoilRseO4n7ir5aR3z1PpfOTw9wrelDZT7St+VIcNk7mtahSctNKbLs7vT0uOwCC0S
         a5D7UCoE642a44LeMwEWJuPkqdU3xuclS78FFt+SGY9cPZeR6HMABkH4L5Bat4r72StD
         jE9NtUib5qdneNQYfhrvDn2K5x0a3QCi1iPebUFSyQI5n9eUlHYyok3txTc0lIZS2hXT
         +NSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mczbHZj3l4mVA/2zZB1hz+aUfHOOEDjnnd6R+ZkSLec=;
        b=ew8v9wwezqBqTGGcFemEK6/Wyzv0s3b0DcRR9Y1qpFEizW20S2iVnUFU37FtgxZw2k
         P4rl/hsV5iAAH1Z/TtRhYx9uNlYGBOzZjVLHYQyfpFLj/MYgfTZjBzy/ioBDvsN2yGIl
         hOLqnYvlIgAjHuQXhpTHWo3MlK9za9oyjgOl925RLaogWzTT73SR1sZ8TeZOsypk5/eY
         bt1+vW/NJqbJmquFrf4uv11uO72JOFNcynI4dGYsnXGfVgr39HVHm4NFODs05L/tHPd2
         AGJ/rtG9WSIW76Lmrk3/C6WgbZwc1fooRC/UNa6DPLJewn4eARl9WkKDOwGU3KGC9HRc
         lYAg==
X-Gm-Message-State: AGi0PuaF9oWzPVUZRNssi021DEJlpXhTXG868ADbVyMg+QeMo2QsWhJi
        02qiucxEnPgxOxVo3CIa17pCv3B1VDgduQFz0+g=
X-Google-Smtp-Source: APiQypJgy8IE3SdoBu2HMy1XdzZGk1B4gLmeIQyKquZhvBrzMupzx5VQNYcttEss7wWhkwaPgXp5F6pYawzhOnTlAfo=
X-Received: by 2002:a0c:e844:: with SMTP id l4mr25445987qvo.247.1587576660396;
 Wed, 22 Apr 2020 10:31:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200422051006.1152644-1-andriin@fb.com> <87mu737op5.fsf@toke.dk>
In-Reply-To: <87mu737op5.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Apr 2020 10:30:49 -0700
Message-ID: <CAEf4BzbWBPn0pvCSh00JsK=P0GYw3oKboF-=U5CuQJM8rpF4=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add BTF-defined map-in-map support
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 4:19 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > As discussed at LPC 2019 ([0]), this patch brings (a quite belated) sup=
port
> > for declarative BTF-defined map-in-map support in libbpf. It allows to =
define
> > ARRAY_OF_MAPS and HASH_OF_MAPS BPF maps without any user-space initiali=
zation
> > code involved.
> >
> > Additionally, it allows to initialize outer map's slots with references=
 to
> > respective inner maps at load time, also completely declaratively.
> >
> > Despite a weak type system of C, the way BTF-defined map-in-map definit=
ion
> > works, it's actually quite hard to accidentally initialize outer map wi=
th
> > incompatible inner maps. This being C, of course, it's still possible, =
but
> > even that would be caught at load time and error returned with helpful =
debug
> > log pointing exactly to the slot that failed to be initialized.
> >
> > Here's the relevant part of libbpf debug log showing pretty clearly of =
what's
> > going on with map-in-map initialization:
> >
> > libbpf: .maps relo #0: for 6 value 0 rel.r_offset 96 name 260 ('inner_m=
ap1')
> > libbpf: .maps relo #0: map 'outer_arr' slot [0] points to map 'inner_ma=
p1'
> > libbpf: .maps relo #1: for 7 value 32 rel.r_offset 112 name 249 ('inner=
_map2')
> > libbpf: .maps relo #1: map 'outer_arr' slot [2] points to map 'inner_ma=
p2'
> > libbpf: .maps relo #2: for 7 value 32 rel.r_offset 144 name 249 ('inner=
_map2')
> > libbpf: .maps relo #2: map 'outer_hash' slot [0] points to map 'inner_m=
ap2'
> > libbpf: .maps relo #3: for 6 value 0 rel.r_offset 176 name 260 ('inner_=
map1')
> > libbpf: .maps relo #3: map 'outer_hash' slot [4] points to map 'inner_m=
ap1'
> > libbpf: map 'inner_map1': created successfully, fd=3D4
> > libbpf: map 'inner_map2': created successfully, fd=3D5
> > libbpf: map 'outer_arr': created successfully, fd=3D7
> > libbpf: map 'outer_arr': slot [0] set to map 'inner_map1' fd=3D4
> > libbpf: map 'outer_arr': slot [2] set to map 'inner_map2' fd=3D5
> > libbpf: map 'outer_hash': created successfully, fd=3D8
> > libbpf: map 'outer_hash': slot [0] set to map 'inner_map2' fd=3D5
> > libbpf: map 'outer_hash': slot [4] set to map 'inner_map1' fd=3D4
> >
> > See also included selftest with some extra comments explaining extra de=
tails
> > of usage.
>
> Could you please put an example of usage in the commit message as well?
> Easier to find that way, especially if the selftests are not handy (such
> as in the libbpf github repo).

Yes, good point. I will add it in v2 after I get some initial feedback on v=
1.

>
> -Toke
>
