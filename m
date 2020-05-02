Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD191C2821
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgEBUAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 16:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728107AbgEBUAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 16:00:18 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563B6C061A0C;
        Sat,  2 May 2020 13:00:18 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 188so6414489lfa.10;
        Sat, 02 May 2020 13:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1fuetHlZxL3y2tZ9qEmdGxI1Km5DfxBd1g0XjlCyH5Q=;
        b=olCYBWju3MTiafCvFHWSzQMP7PHQOLrFmKH4W8alekcVg+INxvFfdY1ryjnDRpIzgi
         gVv1PGzc8MAa3CoyAKNo2XHBzhoCEmh3YwV0kxwAHwemjPf9L7VmkI1+FZ+WFTnERUn8
         hWk5S+OBwFTe0hqXGQMvQ9mDzCbDuyGdGJs+7+hYqfjUV0f/cOBzECmb1AYVMPGSmhR2
         ZWEdeqTU0p4ThSXMqOz3I+/VfNcaO8tbB/L8IuEmZi4UhG6MjaywB2q90oI24KXBj3x6
         kJ+x4CDOcAJ8MMTjJMOxd67vDQVsPVTjlW8ikVbIpR+eydBTauIiWlhIZUj7a7TtlwqJ
         I8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1fuetHlZxL3y2tZ9qEmdGxI1Km5DfxBd1g0XjlCyH5Q=;
        b=YAAyzGEvPRhU83l1ZMPOehSUEZGnHPg1VcAo9r1QaNzULlFcpFn1xWMxFac7IL8/Ud
         F15sN44g4FjMVyER1KLN6YNm2jHYIvEkS6T0O3jmhZt9/6AWyctrSB3fa3rMIVh96DSh
         o24PhoQmUGKgSiJDl3OACU3cUXFoybGEdkUAkAMRHAhFmDIB9wVXmkcyxpZISGBNS20M
         zLNJl8PGOMfsKOIQLaUeV1zxhn6yRozcb1arO810NI9JAgI5pacM1NXDpmyxUeSVTBTp
         LAr6pIolQfM0vj/viWeSZd6fal39LJZPAxS/UVw2JtpDy2n8I2wt/MbISeJlytpWcdaU
         mUDw==
X-Gm-Message-State: AGi0Pub3MBC9kgf0NdCB7CCozshdAyrOSoqVc68FqxG+rCqbUXOLr8q3
        Wj+YR7g8mesU8iW6lgdYpL4zfniH1mVD1bnX1c0=
X-Google-Smtp-Source: APiQypJ5A648tqnQDNQFGNgG0fRH1tO9p7S3Qf5u07Hd61HxSsdvL/DeRc4H4Zq5qApPffCls3U9hb3BlGGEThGHjJ4=
X-Received: by 2002:ac2:569b:: with SMTP id 27mr6497034lfr.134.1588449616656;
 Sat, 02 May 2020 13:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200430071506.1408910-1-songliubraving@fb.com> <20200430071506.1408910-3-songliubraving@fb.com>
In-Reply-To: <20200430071506.1408910-3-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 2 May 2020 13:00:05 -0700
Message-ID: <CAADnVQK-Zo19Z1Gdaq9MYE_9GmyrCuOFbz873D4uCvvVSp0j0w@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 2/3] libbpf: add support for command BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>, Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 12:15 AM Song Liu <songliubraving@fb.com> wrote:
>
> bpf_enable_stats() is added to enable given stats.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
...
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 335b457b3a25..1901b2777854 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -231,6 +231,7 @@ LIBBPF_API int bpf_load_btf(void *btf, __u32 btf_size=
, char *log_buf,
>  LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf=
,
>                                  __u32 *buf_len, __u32 *prog_id, __u32 *f=
d_type,
>                                  __u64 *probe_offset, __u64 *probe_addr);
> +LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);

I see odd warning here while building selftests

In file included from runqslower.c:10:
.../tools/testing/selftests/bpf/tools/include/bpf/bpf.h:234:38:
warning: =E2=80=98enum bpf_stats_type=E2=80=99 declared inside parameter li=
st will not
be visible outside of this definition or declaration
  234 | LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);

Since this warning is printed only when building runqslower
and the rest of selftests are fine, I'm guessing
it's a makefile issue with order of includes?

Andrii, could you please take a look ?
Not urgent. Just flagging for visibility.
