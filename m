Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B45262379
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbgIHXME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbgIHXMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:12:02 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BA9C061755;
        Tue,  8 Sep 2020 16:12:01 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id s92so556391ybi.2;
        Tue, 08 Sep 2020 16:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ZrulxVYziH0n/9DlZYvb0g5eA3miUMAhSkKu5YpHnk=;
        b=PrxrrweqNa+HGBrnAKohhGe01ypPoG/tvdwnlcY2tnRnqTupmT+fnuEWrTBJ1IDJP4
         qYCWHSCkwRa1B2eAyxyrIGGpSr/qyPYIThnN+0Q2UXCc1LrX5oOVkgIvHLVIxRbZ35mC
         5Fe682yLSG+qvrBlcpwoIVuUv1p3oiQeMTPGWAepy1ZbKEu6YZaVjmbFqGMBw0Hws9um
         zlfKWVVvkusjLRuYKVg62KZo45IdHL7pPymhPYnzcEAcXgQtI7QwKKWuL1hnPxrhlCGF
         Az67MxMuztamvTVQgoUjJxE0iqdKUHV6tSjdL6hqgMb8uf1O5rztE7U56T4kG6lelt+l
         /kOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ZrulxVYziH0n/9DlZYvb0g5eA3miUMAhSkKu5YpHnk=;
        b=OmdRR5sDc6Utd328Ee1ir3t+DkoIxMPaOC8iCOytaDklq7jxN3Ij974BE9TX1gQiOP
         G1mQART0jciqdO/qS5UJfrlCNLygiA9Ynweuva6Ac9y4lC7r06RuHtSMaHNty2Ets/CY
         yG5D3ZgGUcGBBREY3fM8lY5Iq4ZjAoaZiJFE6zb6YBIztGdSMS00ZEVXLlTuiBPMHJfZ
         P7dB/pZPrI/zqfVnShneGeMLAYUEwJ4x5cEpXy9qoyroMObLjJ4SfoQJZ7XjfHhwWVZn
         1AnyrMMVXJh2RLE/NGGcSGpgFNQkN4QpvvZZSf/7KhOHEsJ43f6QB5m6BkFSlEV3/yxA
         clFw==
X-Gm-Message-State: AOAM531lK/enCjZ43wChfr04oGRuHLfvo0NP4hstCzMT/qeZ3qYGv25c
        Ejb4PKe1FdNBG4/xI0MS///BKSbyAzKpiKdoe74=
X-Google-Smtp-Source: ABdhPJzkKvPCuU61smwN6PpwmGblvo0NT5xYEB0+nO1ypUTKr/tKak6FiMrSjnsh9d2bsksOV/ILel7j5Atw12pKkBk=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr902935ybp.510.1599606720444;
 Tue, 08 Sep 2020 16:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200908175702.2463416-1-yhs@fb.com> <20200908175702.2463625-1-yhs@fb.com>
In-Reply-To: <20200908175702.2463625-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 16:11:49 -0700
Message-ID: <CAEf4Bzabreh=x3V2_wqf59jtgrhnx+CLiqxNTTU=Kwu=z5eGYA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/2] bpf: permit map_ptr arithmetic with
 opcode add and offset 0
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

On Tue, Sep 8, 2020 at 10:58 AM Yonghong Song <yhs@fb.com> wrote:
>
> Commit 41c48f3a98231 ("bpf: Support access
> to bpf map fields") added support to access map fields
> with CORE support. For example,
>
>             struct bpf_map {
>                     __u32 max_entries;
>             } __attribute__((preserve_access_index));
>
>             struct bpf_array {
>                     struct bpf_map map;
>                     __u32 elem_size;
>             } __attribute__((preserve_access_index));
>
>             struct {
>                     __uint(type, BPF_MAP_TYPE_ARRAY);
>                     __uint(max_entries, 4);
>                     __type(key, __u32);
>                     __type(value, __u32);
>             } m_array SEC(".maps");
>
>             SEC("cgroup_skb/egress")
>             int cg_skb(void *ctx)
>             {
>                     struct bpf_array *array = (struct bpf_array *)&m_array;
>
>                     /* .. array->map.max_entries .. */
>             }
>
> In kernel, bpf_htab has similar structure,
>
>             struct bpf_htab {
>                     struct bpf_map map;
>                     ...
>             }
>
> In the above cg_skb(), to access array->map.max_entries, with CORE, the clang will
> generate two builtin's.
>             base = &m_array;
>             /* access array.map */
>             map_addr = __builtin_preserve_struct_access_info(base, 0, 0);
>             /* access array.map.max_entries */
>             max_entries_addr = __builtin_preserve_struct_access_info(map_addr, 0, 0);
>             max_entries = *max_entries_addr;
>
> In the current llvm, if two builtin's are in the same function or
> in the same function after inlining, the compiler is smart enough to chain
> them together and generates like below:
>             base = &m_array;
>             max_entries = *(base + reloc_offset); /* reloc_offset = 0 in this case */
> and we are fine.
>
> But if we force no inlining for one of functions in test_map_ptr() selftest, e.g.,
> check_default(), the above two __builtin_preserve_* will be in two different
> functions. In this case, we will have code like:
>    func check_hash():
>             reloc_offset_map = 0;
>             base = &m_array;
>             map_base = base + reloc_offset_map;
>             check_default(map_base, ...)
>    func check_default(map_base, ...):
>             max_entries = *(map_base + reloc_offset_max_entries);
>
> In kernel, map_ptr (CONST_PTR_TO_MAP) does not allow any arithmetic.
> The above "map_base = base + reloc_offset_map" will trigger a verifier failure.
>   ; VERIFY(check_default(&hash->map, map));
>   0: (18) r7 = 0xffffb4fe8018a004
>   2: (b4) w1 = 110
>   3: (63) *(u32 *)(r7 +0) = r1
>    R1_w=invP110 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
>   ; VERIFY_TYPE(BPF_MAP_TYPE_HASH, check_hash);
>   4: (18) r1 = 0xffffb4fe8018a000
>   6: (b4) w2 = 1
>   7: (63) *(u32 *)(r1 +0) = r2
>    R1_w=map_value(id=0,off=0,ks=4,vs=8,imm=0) R2_w=invP1 R7_w=map_value(id=0,off=4,ks=4,vs=8,imm=0) R10=fp0
>   8: (b7) r2 = 0
>   9: (18) r8 = 0xffff90bcb500c000
>   11: (18) r1 = 0xffff90bcb500c000
>   13: (0f) r1 += r2
>   R1 pointer arithmetic on map_ptr prohibited
>
> To fix the issue, let us permit map_ptr + 0 arithmetic which will
> result in exactly the same map_ptr.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
