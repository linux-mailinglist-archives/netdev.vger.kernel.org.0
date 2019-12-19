Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6F3126F63
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfLSVHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:07:51 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40357 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbfLSVHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:07:50 -0500
Received: by mail-qk1-f194.google.com with SMTP id c17so5840672qkg.7;
        Thu, 19 Dec 2019 13:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gw2cUT0gO+tOSfarptnq9Cj/zfsTvMJWTDDp9AgTfKg=;
        b=IAxPQKZDbH2iBDyiiI4yRwD92LDcYxduJI9DpRpYcmKHSYcqpeSYPlOu7Yp7V7D2hA
         xD4PkdsESXFlF4TEhb/Vsz0Dbxi8rhFY54Fmz8+abl6Z1HtLxwYUWXisvgUdamWIEZVs
         QuSf8rQ6nRiUkPGzQ6kNJTqDzlIKGVK6ywknYKwOk7XWTNELh4i+loXHAwdlS6JSl4pM
         930kyXumwp3J7fOOquPPHp2byuCib/KfxQp+xHTiJhHHJ9pGMM4QqqaOnbL6BZCDKbLe
         DF9mfnbzMLec3hK7Nnlyt+vJZvjutOFVFtXJWxqtxfW6V3jUVn7my1S+Cx8dnTHMoY3w
         MhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gw2cUT0gO+tOSfarptnq9Cj/zfsTvMJWTDDp9AgTfKg=;
        b=Kn2IdnhHia4+eukGhZH/Ldn4OTPUGyHblzDMe1Wg4QMlWukI/+XAMZJldZPe84rLLH
         +ohvafVCyfkBi1RI2XTZhBvDemznFnbYY/X+G3WTNLlzuAuE8ic4GPCQBlvpeHDQPYMa
         MpHec7ios35oZq7q6vU7DAggWIlJpSO6i5IsQL8WAfXdNX0JuIQ0y5CWvEQL5+2kD9uK
         xKUCb3jzCiUfU60LMI9RzOyK67n9N9fOWKsF0JbeKyG0a6RVh6m6eARFgKQRGcu8qzV8
         vNfT7hf1NG8zfDU5VxnrRTgfObMWTZsnLIdlBOMgXPgXthQoU8l9ILWDgwBnSphCoeUu
         Dd9g==
X-Gm-Message-State: APjAAAU/SVS9KbYXp+UIaB2B9dKZRFB/CsTQCI6/SYG7ue8tprdxu8lx
        CLh3CWD7pFuOcboepI/L90mwW153Z8WAYC5pc6Q=
X-Google-Smtp-Source: APXvYqzt9DHABWv+HAjEa9rncnVBXlyD8m5l7IFIqf94FA06fmGYaLmbvCH2D0TThzKubch8QBJneS74MYwlBc8aRs4=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr10479524qkq.437.1576789669239;
 Thu, 19 Dec 2019 13:07:49 -0800 (PST)
MIME-Version: 1.0
References: <20191219070659.424273-1-andriin@fb.com> <20191219070659.424273-2-andriin@fb.com>
 <20191219170602.4xkljpjowi4i2e3q@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191219170602.4xkljpjowi4i2e3q@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Dec 2019 13:07:38 -0800
Message-ID: <CAEf4BzYKf=+WNZv5HMv=W8robWWTab1L5NURAT=N7LQNW4oeGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpftool: add extra CO-RE mode to btf dump command
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Thu, Dec 19, 2019 at 9:06 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Dec 18, 2019 at 11:06:56PM -0800, Andrii Nakryiko wrote:
> > +     if (core_mode) {
> > +             printf("#if defined(__has_attribute) && __has_attribute(preserve_access_index)\n");
> > +             printf("#define __CLANG_BPF_CORE_SUPPORTED\n");
> > +             printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
> > +             printf("#endif\n\n");
>
> I think it's dangerous to automatically opt-out when clang is not new enough.
> bpf prog will compile fine, but it will be missing co-re relocations.
> How about doing something like:
>   printf("#ifdef NEEDS_CO_RE\n");
>   printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
>   printf("#endif\n\n");
> and emit it always when 'format c'.
> Then on the program side it will look:
> #define NEEDS_CO_RE
> #include "vmlinux.h"
> If clang is too old there will be a compile time error which is a good thing.
> Future features will have different NEEDS_ macros.

Wouldn't it be cleaner to separate vanilla C types dump vs
CO-RE-specific one? I'd prefer to have them separate and not require
every application to specify this #define NEEDS_CO_RE macro.
Furthermore, later we probably are going to add some additional
auto-generated types, definitions, etc, so plain C types dump and
CO-RE-specific one will deviate quite a bit. So it feels cleaner to
separate them now instead of polluting `format c` with irrelevant
noise.

I can unconditionally assume preserve_access_index availability,
though, because Clang 10 release is going to have all those features
needed for BPF CO-RE. I can also add nicer compiler error, if this
feature is not detected. Ok?

BTW, the reason I added this opt-out is because if you use
bpf_core_read() and BPF_CORE_READ() macros, you don't really need
those structs marked as relocatable. But again, I think it's fine to
just assume it has to be supported by compiler.
