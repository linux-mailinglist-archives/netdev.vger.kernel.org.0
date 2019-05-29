Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97462E2E8
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfE2RL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:11:27 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35985 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfE2RL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:11:26 -0400
Received: by mail-qk1-f195.google.com with SMTP id g18so1994918qkl.3;
        Wed, 29 May 2019 10:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=21W2J2rIqBer6vBuEtZ4XuFJ+nNx9cPkB5zp7ANoRAM=;
        b=I6qu+nb9wvSJAPx2Wbw4pXRxHpbsA/HfmIMEnyrqC/oA3PjWdXCTSM7Db7IMtEe0nA
         xttCG66sYMS8E1ExKQOq6FI52zYSQdWXxEFchD8sSilaPi3LmW6I+F4Tsge6vLxcnmRN
         84j8mb5pN5KofR3rSUs/EqlWI/kGTzrh8I6S/jH0+c5KWkk6kY4scV9/WVDZWSSCbcCw
         cEeCQA9u+oKYbqsIARyTSH//gmhYPbgOp97DfqwCk0UtvnKAUIDBiV+aNbqQPYNaGhZh
         Tzq4a5RVypUlCGD42zVQdEmvvc1wvjDEcIGXv0IxybduyfLCfnSgwtErWaZYacuKKc6g
         0pYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=21W2J2rIqBer6vBuEtZ4XuFJ+nNx9cPkB5zp7ANoRAM=;
        b=r7hkj+0XoldsxnPsfN6wsD428WK0OYul8s5GVm/vbjjPUN5htdi/LZhwgwOFPSp9Za
         5r6OtAUZa6C9H5AOSyqo3m59dl4L+60iYCkC771OqJ+G7Qv79Rar6IkPUElVNT6iHQpi
         BiCpIWBjnep1jhrwVMM7jhYz6CgGdTOfeqelO2lKmdlPSRkNNZtvdPiIwjjtHGaOUjAt
         eAXM3OewJ/pzaDvt08aewsOq6wyATS2LyzJ/YF7Z5MyED1qa+O8jSPE0AXNAWFq8Fg/D
         obsXmYIS5IPyyzP00gBGkxAo76uKkuhoHiKPfr1QM4pMoFzGqOLLy5EzdvYl9RDML99J
         vtlQ==
X-Gm-Message-State: APjAAAUSuIrVJFpBDYXts8aDvzUGjIv+OovBNkuTb8lQMt3QdNuhQJxw
        nRXhJbI/nm3MAJCtIFXQaqcQGqtsm30wItScqT8=
X-Google-Smtp-Source: APXvYqylq2+nuheVMUWJeeYz/Fuw2k9OUOYwWvQ3Ms4G0B6z04fuhmrNvOvBpHLOJQL8FCKM5SU2R9Xr8MbAjzY+NQk=
X-Received: by 2002:ae9:e8c2:: with SMTP id a185mr9321306qkg.358.1559149885879;
 Wed, 29 May 2019 10:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190529011426.1328736-1-andriin@fb.com> <20190529011426.1328736-5-andriin@fb.com>
In-Reply-To: <20190529011426.1328736-5-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 29 May 2019 10:11:14 -0700
Message-ID: <CAPhsuW4aBGtsmq3wKyk1rsBPAkFAQPyMU5gTxoNTNmK42CFs_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/9] libbpf: check map name retrieved from ELF
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 6:15 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Validate there was no error retrieving symbol name corresponding to
> a BPF map.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
>  tools/lib/bpf/libbpf.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index c98f9942fba4..7abe71ee507a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -920,6 +920,11 @@ bpf_object__init_maps(struct bpf_object *obj, int flags)
>                 map_name = elf_strptr(obj->efile.elf,
>                                       obj->efile.strtabidx,
>                                       sym.st_name);
> +               if (!map_name) {
> +                       pr_warning("failed to get map #%d name sym string for obj %s\n",
> +                                  map_idx, obj->path);
> +                       return -LIBBPF_ERRNO__FORMAT;
> +               }
>
>                 obj->maps[map_idx].libbpf_type = LIBBPF_MAP_UNSPEC;
>                 obj->maps[map_idx].offset = sym.st_value;
> --
> 2.17.1
>
