Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E73B210F63
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731962AbgGAPeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731399AbgGAPeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:34:22 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0526C08C5C1;
        Wed,  1 Jul 2020 08:34:21 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id y13so13896331lfe.9;
        Wed, 01 Jul 2020 08:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ji/aWMKUqT6RYTQlnVH4aDe8ZxPXlTerZVcj20JTnV8=;
        b=LzeiiOnfLz5CztM3Ca002SX7hgfAQAKxFfXbtgKBSLs8e58SRqI85YT6CXCVHDQ33d
         11rRa6MazDUNzyOae1lrAOYdc1LufLM7YlqL/J1qFU+tZ9AppbywT6KphuUqgQ89VeEN
         N5va/CPu6pnHxtcUTe0A6rJV9KdPtrLGp6MFx0HTdW6l4HfmlGKEpKP77jX/u/h12OWP
         +B/V3J7gbtG/EnpdVUJ5g+H94eQA4a/adNot4SxdhdQC8nl0O7FZ685CAXXURkuM53cP
         BiOgZ4i0ecB0o56mvy8BR2F2M1z+waPBEn7+ddXGqKcHiAeK6gKTNieS59nKGSaE9inC
         rqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ji/aWMKUqT6RYTQlnVH4aDe8ZxPXlTerZVcj20JTnV8=;
        b=gorlX9CYvOtXEVCsWFejREDQcUxtpjjOeFINCh8XqadPVBR3pyrvhqdUTrlPLHVhmY
         Ojdu28zXoTiaRIl2CVA4jUVdnLSesugs8k4YY8/a+snfFoB9xE2BCtSkMcgXueieXdN3
         +K85LEEX2DMVREvQk7sV+west+TdYw8hAekkqmpim0/jpKyVcsxs7/IW8ib0UTkFGrXR
         19DFilhlNPcmXexEHnRBn25Vr0lGG7lmtQdz2WmEW4Q9Dua3dzZhdp2eC9H+oGfO9+I3
         DBMH3OoDjFZkd7OCd8c82PdE19bUXHB5Wmzqa7I9bl0oLp+BnCxG7I9uFvG61OQiDAIy
         I99w==
X-Gm-Message-State: AOAM532/RBIdr8j54VKmkR1yBN4jAw+QINc1mbE9FtXXfx7n5IRtZP4W
        yZWa5QGb8o91vxsNAag3IbIY1iGHB/aexhl8J3g=
X-Google-Smtp-Source: ABdhPJyxyTOjkX9SPrREeZQd29/XQHfd4gtioo0AtDFbHpLaA0A3CCyBUnb0iGQXuvS+QSKBwBkBKPkSH+qrPeJxa/c=
X-Received: by 2002:ac2:5e29:: with SMTP id o9mr15022359lfg.196.1593617660140;
 Wed, 01 Jul 2020 08:34:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200630062846.664389-1-songliubraving@fb.com>
In-Reply-To: <20200630062846.664389-1-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Jul 2020 08:34:09 -0700
Message-ID: <CAADnVQ+HFjn9+cXM9PRLEsopiEVfJ5vjVDBNrWUjZT8P8_kiVA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/4] bpf: introduce bpf_get_task_stack()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 11:28 PM Song Liu <songliubraving@fb.com> wrote:
>
> This set introduces a new helper bpf_get_task_stack(). The primary use case
> is to dump all /proc/*/stack to seq_file via bpf_iter__task.
>
> A few different approaches have been explored and compared:
>
>   1. A simple wrapper around stack_trace_save_tsk(), as v1 [1].
>
>      This approach introduces new syntax, which is different to existing
>      helper bpf_get_stack(). Therefore, this is not ideal.
>
>   2. Extend get_perf_callchain() to support "task" as argument.
>
>      This approach reuses most of bpf_get_stack(). However, extending
>      get_perf_callchain() requires non-trivial changes to architecture
>      specific code. Which is error prone.
>
>   3. Current (v2) approach, leverages most of existing bpf_get_stack(), and
>      uses stack_trace_save_tsk() to handle architecture specific logic.
>
> [1] https://lore.kernel.org/netdev/20200623070802.2310018-1-songliubraving@fb.com/
>
> Changes v4 => v5:
> 1. Rebase and work around git-am issue. (Alexei)
> 2. Update commit log for 4/4. (Yonghong)

Applied. Thanks
I've added /* */ tweak to BPF_FUNC_MAPPER, so we stop having
ongoing merge conflicts and preserve better 'git blame' for helpers.
