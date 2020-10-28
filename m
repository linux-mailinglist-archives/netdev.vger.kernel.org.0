Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E4A29DB46
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389417AbgJ1WsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731686AbgJ1Wrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:47:48 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6179C0613CF;
        Wed, 28 Oct 2020 15:47:47 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 67so550914ybt.6;
        Wed, 28 Oct 2020 15:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vwgoW2TPGpunI0aTLkl3qoIbx10c+NJTmbd9MrFLM2s=;
        b=BTS8ESXBVadVHh9DO6P1aepyoWRkgvynflePGKFZrpygvM78c+SRChm5u5kVUWLt0C
         Ok2tgz6O0L43blytuad6d8HF3tyNs4jtsSQgJ+Xng1YmxtMqBB+1Gr2JhK7QLEfPI+qQ
         ywCNDX4CR6AMGTWbW6yq96Bf2CM4xv/KV+tqeHIX+bht6SOEZU+7R3DYZzqBZ7Y5lnp9
         3u4AeXWUm6aTdH/L8gByTlZcLNQAe5/qwwcP2Kx9N12Ymm5KmeKObBTYBpppVmrwHIaf
         oP5Cl3SgLOmdLHVpP7YsXt3TdNNOfjxLHg79J10Z0nZMyzL/ax+IRa4R8w/cgmUiTZJz
         mp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vwgoW2TPGpunI0aTLkl3qoIbx10c+NJTmbd9MrFLM2s=;
        b=XgRsCCafQyN3rne3OERXJKQt1kMI2+UuikGfoR/USzDA2v6xM1ou8OeuUf3HEyq656
         L2QwhbybUXcWEnAAQi5C1SirEQT7EPIj9r63eDAdBlNSdijdVWo3siCRahr3iogoamuq
         RKyXs4PSLvJmgxb/lRbeG6fOTb6pjWx6goKzGuDo7wkURd6cnrcqDIOLm/xiy2/MCb6P
         qNy0gfObfVWVejrmGMRAcnM/9hn4vBnNV37lVZltPO+Unc5en7Iz15Aexfr6GqWcpqjc
         DGpNMP1VWyCw8ZXTzdAAXyd+HFVibW8K9CIWkUmQKxMCRVOxaCG7fK9/2s7jTVDXa5T/
         kUhA==
X-Gm-Message-State: AOAM530QcSMLr/KQlF3JGLf+/IWG/CMkN5Hghi7I5wasYTE4QcUFzkHa
        f79NSW8ucyGbsURlQsjXBLvpEz3gXOSX8xAcA6KixRoLQ3IDQK8W
X-Google-Smtp-Source: ABdhPJxy/Ur2hDT/68wIG/Irz6OXDxV8Fmp4IUEF6IrTWOr+be7a0paoRJwfUOS9N26GzD7nzDbiiTy5tZijSDy+m8A=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr7830598ybe.403.1603856490277;
 Tue, 27 Oct 2020 20:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <20201027233646.3434896-1-irogers@google.com> <20201027233646.3434896-2-irogers@google.com>
In-Reply-To: <20201027233646.3434896-2-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Oct 2020 20:41:19 -0700
Message-ID: <CAEf4BzbeJqCq_OHrBQWHoXtALPSHZ7hY2OHL59BuvCcfF1nrpQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] tools, bpftool: Remove two unused variables.
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Michal Rostecki <mrostecki@opensuse.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 4:37 PM Ian Rogers <irogers@google.com> wrote:
>
> Avoid an unused variable warning.
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/bpf/bpftool/skeleton/profiler.bpf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> index 4e3512f700c0..ce5b65e07ab1 100644
> --- a/tools/bpf/bpftool/skeleton/profiler.bpf.c
> +++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> @@ -70,7 +70,7 @@ int BPF_PROG(fentry_XXX)
>  static inline void
>  fexit_update_maps(u32 id, struct bpf_perf_event_value *after)
>  {
> -       struct bpf_perf_event_value *before, diff, *accum;
> +       struct bpf_perf_event_value *before, diff;
>
>         before = bpf_map_lookup_elem(&fentry_readings, &id);
>         /* only account samples with a valid fentry_reading */
> @@ -95,7 +95,7 @@ int BPF_PROG(fexit_XXX)
>  {
>         struct bpf_perf_event_value readings[MAX_NUM_MATRICS];
>         u32 cpu = bpf_get_smp_processor_id();
> -       u32 i, one = 1, zero = 0;
> +       u32 i, zero = 0;
>         int err;
>         u64 *count;
>
> --
> 2.29.0.rc2.309.g374f81d7ae-goog
>
