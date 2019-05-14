Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA3531CE69
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 19:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfENR4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 13:56:19 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36134 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfENR4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 13:56:19 -0400
Received: by mail-lf1-f65.google.com with SMTP id y10so12594241lfl.3;
        Tue, 14 May 2019 10:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8jK8TdbJwPrf/QIXl7BYQvUmbQF/qisC1t8x+FQM900=;
        b=SW7QhFUFPDaHZwYu6sofLvZpQX3mbBw3E3t3NP4MoF4p0Jp5OzO1qA3nZKycNaFiRv
         /380bNKJuw1A8Ck28TQINUEtfTLJGb7D2l4Zy4O5W+cRhEgum73OEqa4AHlnm1yEpXi0
         A2FDJLKNbYeCrnHB9PJCUMSsSgVlPdkxMTwr97TtHs4tEJX+1w3GMQdahkaa4eh3ORx1
         +HM0+2MpTf8DwZbOGNiiSMgM+2Atz2YA+OwlAxI+BcnlpwpV+uZq787gan8mo1FN0IvJ
         AWZ1W2Z4pKMUEdDBdn8tiDeIj3JqOGscY3HFZ7ChKaqXXRggMGtrEjhpPcoGrC+FugMy
         q2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8jK8TdbJwPrf/QIXl7BYQvUmbQF/qisC1t8x+FQM900=;
        b=ko5Dn1KbDHAkwwvv7tZS/NhGWCoIjKC61FGG41XvKxCegikP+k6sXCQ5d3MT7f5nlz
         Daxr0U0k7BuMCP8e9UzdSLk3/33/CVjEFoIEUDrPfTuLtG9BH4XlbQNaFgh01Ck4sdXr
         UUhDXsdedYIAaIn7RKcTQG1qSBMahf2n5vTNyS47pSabLJZMsrdqbvT+5zylCMLuLea4
         aDfQx10aI6vML62ZDTKgQ5VHJpYIOlkMRsmNW3JkvmDUMz5tHsRcowkvdpYN843QFqJI
         FSMELO8UqkE6L1pBofoOokEjuJx2dewI5cJ2X32DDXZUyS3FfXyeOdO55pzcDE7X+cvF
         JDBw==
X-Gm-Message-State: APjAAAXLzZxWB4Kbc30fD4poaSIKNT9517sNJhhWZzlSG0y5rshE9iMS
        Ez71pNeH0rC9jynq6jNXhsmf4/B9Ub21Q5xwZs+n0Q==
X-Google-Smtp-Source: APXvYqwp35U0FzpnU3cI7vFV4hrlhu28vz4J3r1WLM8M7WiTpktkSoHQbrpHU1fITL4JOzPhqoY+z0r8v6ak7XtKFFQ=
X-Received: by 2002:ac2:5a04:: with SMTP id q4mr6100227lfn.90.1557856577478;
 Tue, 14 May 2019 10:56:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1557789256.git.daniel@iogearbox.net> <CAEf4BzaSj9Nh+2gcEJyBDzwgbaYWAUiQ7JWAez9+jDneCA6ZFQ@mail.gmail.com>
In-Reply-To: <CAEf4BzaSj9Nh+2gcEJyBDzwgbaYWAUiQ7JWAez9+jDneCA6ZFQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 May 2019 10:56:06 -0700
Message-ID: <CAADnVQLHjQUZuv0tym4usZ3iqpRZQpbMfcj_x9OXhsN70h=fHg@mail.gmail.com>
Subject: Re: [PATCH bpf 0/3] BPF LRU map fix
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 10:24 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, May 13, 2019 at 4:19 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > This set fixes LRU map eviction in combination with map lookups out
> > of system call side from user space. Main patch is the second one and
> > test cases are adapted and added in the last one. Thanks!
> >
> > Daniel Borkmann (3):
> >   bpf: add map_lookup_elem_sys_only for lookups from syscall side
> >   bpf, lru: avoid messing with eviction heuristics upon syscall lookup
> >   bpf: test ref bit from data path and add new tests for syscall path
> >
> >  include/linux/bpf.h                        |   1 +
> >  kernel/bpf/hashtab.c                       |  23 ++-
> >  kernel/bpf/syscall.c                       |   5 +-
> >  tools/testing/selftests/bpf/test_lru_map.c | 288 +++++++++++++++++++++++++++--
> >  4 files changed, 297 insertions(+), 20 deletions(-)
> >
> > --
> > 2.9.5
> >
>
> For the series:
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
