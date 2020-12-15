Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DE12DA5AF
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 02:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730363AbgLOBiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 20:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbgLOBiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 20:38:50 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B498DC061793;
        Mon, 14 Dec 2020 17:38:10 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id j17so17391809ybt.9;
        Mon, 14 Dec 2020 17:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fE0GqyQBmzYNdu6X0dMOp9E9OSEGXp7Fwlt0pZDcZ1Y=;
        b=N3pa8hh/QnWRG/TQBwSWSvoc5QVHOwYSlOozqCa3zDXVgdJdjFgKviKYWTTBYf+ThC
         07e7cBOjoDEq+/Sp6OmbMwy8jc9ktQrUJ+2g4S6CLwKUD/y0xOz3fcmTAcyPW0X8l3rf
         Iy9VeRkzfwJNrozxTmb2q96gY+WAuOD71kzqLYNimZG9AAs11ahPew+23vK9DSifb7EM
         Wsn5Auu3a+r6wxxiev72lyyeAo+jRPNqLvplP/2gl1yCqv3D1zhP8cb9dV79BgS/qy2j
         f6VVeeI9DA0Up0cUlQ6V45QmCdTBFGuTNDLrwCT007ecbCovfMpS8xpVp8V3qvpLecGh
         CXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fE0GqyQBmzYNdu6X0dMOp9E9OSEGXp7Fwlt0pZDcZ1Y=;
        b=ZPHBBAT6wG9lKzhbrw2ehg3//FnVoyWZ9pPE3m0PiUM7P/8W5u3XOHMzCOxskYbfzB
         lLDcmm18kjj+1O+e/94u/hM7MF9NibNfWzmqaeHdqLsf8KA+QN5Rf+lgLIcEEuiN99nt
         AbrRftLO6XpqUKFbCjDoZh52eEeXdLcxyz03smC+bdsQZYR/VLrRi4UgHQkaWvMuDt+L
         oZWDyJSfUv0WA3d9Db+63LRw5a+FxLmUBxq+qhGow63esR+9RxDBizidw75Cmin8Jw2e
         zyU2niNi/gKbb/wMge0sq8oiCIDeQ5nf7B/QYgeAIaBG/I6FHCPfOkr4H2wGMjsFXT/R
         la7Q==
X-Gm-Message-State: AOAM533XUFk8XNVWP1CC8qti8e1TCmHHTZCpeH92UIktCZOlvggnLbjr
        8uTihT5wTjtQE7gzw94/bQeQWuTiVuBlDY2A/lU=
X-Google-Smtp-Source: ABdhPJwpMUKye5wrCubUW3R52+iNOsNLqGnERDWWc9CnBY84MXkNbn1GCjNanvc2TR9n/326GPOA2mRYcrg4NDYiVZo=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr38281859ybg.27.1607996290073;
 Mon, 14 Dec 2020 17:38:10 -0800 (PST)
MIME-Version: 1.0
References: <20201214202049.7205-1-kamal@canonical.com>
In-Reply-To: <20201214202049.7205-1-kamal@canonical.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Dec 2020 17:37:59 -0800
Message-ID: <CAEf4BzYBvz4TDayTE=Bc_bjqvOGaavmmw1sJhOCKhq9DwUpd4A@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: clarify build error if no vmlinux
To:     Kamal Mostafa <kamal@canonical.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:21 PM Kamal Mostafa <kamal@canonical.com> wrote:
>
> If Makefile cannot find any of the vmlinux's in its VMLINUX_BTF_PATHS list,
> it tries to run btftool incorrectly, with VMLINUX_BTF unset:
>
>     bpftool btf dump file $(VMLINUX_BTF) format c
>
> Such that the keyword 'format' is misinterpreted as the path to vmlinux.
> The resulting build error message is fairly cryptic:
>
>       GEN      vmlinux.h
>     Error: failed to load BTF from format: No such file or directory
>
> This patch makes the failure reason clearer by yielding this instead:
>
>     Makefile:...: *** cannot find a vmlinux for VMLINUX_BTF at any of
>     "{paths}".  Stop.
>
> Fixes: acbd06206bbb ("selftests/bpf: Add vmlinux.h selftest exercising tracing of syscalls")
> Cc: stable@vger.kernel.org # 5.7+
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  tools/testing/selftests/bpf/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 542768f5195b..93ed34ef6e3f 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -196,6 +196,9 @@ $(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(BUILD_DIR)/resolve_btfids $(INCLUDE_D
>  $(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) | $(BPFTOOL) $(INCLUDE_DIR)
>  ifeq ($(VMLINUX_H),)
>         $(call msg,GEN,,$@)
> +ifeq ($(VMLINUX_BTF),)
> +$(error cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
> +endif
>         $(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
>  else
>         $(call msg,CP,,$@)

This handles only one possible case where $(VMLINUX_BTF) is expected.

Given $(VMLINUX_BTF) is now almost mandatory to have (bpf_testmod.ko
is dependent on it, for instance), I think it's acceptable to just add
such a check right after VMLINUX_BTF definition, outside of any
specific rule. The downside is that some unrelated targets (e.g.,
non-test_progs tests) will fail if VMLINUX_BTF is not found, even if
they don't need it, but the most common use case us to build
test_progs, as well as bpf_testmod.ko and runqslower, so I think it's
an OK trade off. Worst case, one can work around such with
VMLINUX_BTF=whatever command-line overload.

> --
> 2.17.1
>
