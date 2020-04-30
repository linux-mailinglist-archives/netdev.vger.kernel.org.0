Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A40B1BEE2B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 04:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgD3COE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 22:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726466AbgD3COE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 22:14:04 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FE5C035494;
        Wed, 29 Apr 2020 19:14:04 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v26so3817232qto.0;
        Wed, 29 Apr 2020 19:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IA09hOzMAHkJRvllet4AvB2XY+2Smn/LClqtzr7ZIF0=;
        b=tS0E6Fw3h4p09M4txtt5yNPvOH/zSS8E6Ndadr55LnlkzjR70uAcyqOHpXGfGa+6aO
         jGlR7Lht+jPXL7H6qao6hTi4nQUlN9tqQYTuM+bK2QvSsH7vF/c334MV8z7vTXCi8UQn
         wZJ/sPuYF7WcmEybVxLGJR6xcgdjl6BwVczBIdFjuPDOphJ5CykX0ZBJFaz55hIP07J8
         7/YdYGmlBpPjetCV/L7o4HYiCcrx62t7z4dgkEtuh7LF4g/Pr+4Dr+Uh5VQTmqojhGBZ
         6ueRSQrPA6yRgfPkorEIcAYnT6or/Fn5FS5fimU77JLkQ1J6rG6zOVpQXtdBjZ72Mbkc
         1XZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IA09hOzMAHkJRvllet4AvB2XY+2Smn/LClqtzr7ZIF0=;
        b=X6AKbhiCpfR30GyU+TITOF7Yd0HbCRBihVUV7k2jCz6rgHVp41aYFWFZQsQO3/sPMU
         hWKj3rs2XTePPdws1Dwoh4RagtKOrTbm2HDEG4FPTP1YqLfIkM73O0NqnvDd/93anDmD
         ibM6dGWyqAJS26fN22DHSKdZHneQOqm3lH2cgfQU8+j5OlROjkIcgaEZXfJTcRd2ASzC
         4ilNY8ne0u/45bhflqRClMLchqhccU2bV09f5FdmtttAmvfi3XNgVCZWv+5/qDWKJJsO
         AFF172CxYYq0h4+IHnDbwC+PdH+ryA4ZONqboLOd6TXLkZAZzVMLsf22BjfrulE44ppi
         naew==
X-Gm-Message-State: AGi0PuYsCxu6hLAbMdXhTMM+5He7OlyiCcwEheMN/DL4j2caMj+n8gpa
        YGNWSGMXWwnDZa9MZ/uOcAq/nc0Wo7FOChu8924=
X-Google-Smtp-Source: APiQypKuaq0RGtIVtZtej6nK/1+r5AU0BbOVfdNVdbzqusfM11SM8k/OG193UaxzJpj8jtom1yFNbt+D0BBuRCPkzK0=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr1357295qto.59.1588212843761;
 Wed, 29 Apr 2020 19:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200430012544.1347275-1-andriin@fb.com> <64bf530d-1fe7-415d-6f18-37c95d1e9dea@huawei.com>
In-Reply-To: <64bf530d-1fe7-415d-6f18-37c95d1e9dea@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 19:13:52 -0700
Message-ID: <CAEf4BzbYv7Yr79KgbO2fXffDpiYa5-Nq1_1CnKoXbKTF_yJ75g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix false unused variable warning
To:     Yuehaibing <yuehaibing@huawei.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 6:52 PM Yuehaibing <yuehaibing@huawei.com> wrote:
>
> On 2020/4/30 9:25, Andrii Nakryiko wrote:
> > Some versions of GCC falsely detect that vi might not be initialized. That's
> > not true, but let's silence it with NULL initialization.
> >
>
> Title should be fixed 'unused' --> 'uninitialized' ?

Yep, my bad, will send v2 with correction.

>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index d86ff8214b96..977add1b73e2 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -5003,8 +5003,8 @@ static int bpf_object__collect_map_relos(struct bpf_object *obj,
> >                                        GElf_Shdr *shdr, Elf_Data *data)
> >  {
> >       int i, j, nrels, new_sz, ptr_sz = sizeof(void *);
> > +     const struct btf_var_secinfo *vi = NULL;
> >       const struct btf_type *sec, *var, *def;
> > -     const struct btf_var_secinfo *vi;
> >       const struct btf_member *member;
> >       struct bpf_map *map, *targ_map;
> >       const char *name, *mname;
> >
>
