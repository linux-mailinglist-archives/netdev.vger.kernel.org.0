Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7479FC42B2
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbfJAV2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:28:23 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39056 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfJAV2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:28:23 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so12789555qki.6;
        Tue, 01 Oct 2019 14:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m788TzaW3lTt2qveERkXsEu3Dbp7t1XTD2e9ldYS4vg=;
        b=dr7jH38OjXx19xmlb8OkXnxbu0239eKx/VkYdBy8WMOOFw9bAx6JnhwlI/TA9VO6jz
         9OlM6TBURXfCTD8QWMKlZtHNB4ZzeoXKyuaZy+0DqiuJDwFhPVsHSz3zy17MIPLcvsk6
         NgvJjalWDBKpCrNACuGCXnSOr9QyVpOfE0k6spo9I162LuCqp07gjeC/kFP4zpoCYprV
         pmZawcwd6kxmF1qmeUtA8bR/Gu17AXiNwLcmzctgs9VdRReg3b6xHrACgGL+zQBofiqj
         AjbcSDs5gK3murGoN3NcHIAy0xILZ4xStvAYvbQG5mrl035PdzXfFW9FZMjOxSB0heF+
         iP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m788TzaW3lTt2qveERkXsEu3Dbp7t1XTD2e9ldYS4vg=;
        b=XFbMFXZwVNSP0IQwR10m2Z+xtPp/rhUJaE+deUl6xLFn7yO6qxNZ7kslISYUPBNecw
         O7hofcc0JCX5mKl85XgTl0mJcFYZ2luz/bVcQTBhM2xx9SOMCy6dOsGPaP4IcuvZ/tq1
         s5Ikwq9ecb2MvBMailyndJZ88o+3SzozKX3MOjapDmLKdyu/bePegcUejVfuKzNp5Gee
         QCHlJr7IjGzVyXjdjeD+pLZSoolRrgiziAu3HOhDmH4jL5uuQAY+1pu73eK6fyuCcWHd
         EY1C5fZjFic699/jsEfcElJb4aN/Xrh35WEd6GCgvsUzxUvvCudoVDTX/HIej1WPRAc9
         coUw==
X-Gm-Message-State: APjAAAURyaeGnOEILcKgP1+Mi7BxX8vdMflED3aF9RVeA1nHFlok6vkQ
        /Lneb8swTKSK3rQCPTzpupfY9eTozC5vQ2AljII=
X-Google-Smtp-Source: APXvYqzEslv0Je9r2688d8Etv/XPLQxMoAoxxX0zAzebX51PO3vnJGNjA3AFFr0/xMrZFodatiC+NbftSoDwMlCKhkk=
X-Received: by 2002:a37:98f:: with SMTP id 137mr208661qkj.449.1569965302510;
 Tue, 01 Oct 2019 14:28:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com>
 <E0A2B793-7660-481B-9ADB-6B544518865A@fb.com>
In-Reply-To: <E0A2B793-7660-481B-9ADB-6B544518865A@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 14:28:11 -0700
Message-ID: <CAEf4BzZdjFotwX-ngjBCr+2mc4XOsYAxBe8rUBbw7mgQMMdc1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 2:19 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Sep 30, 2019, at 11:58 AM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> > are installed along the other libbpf headers.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > tools/lib/bpf/Makefile      |   4 +-
> > tools/lib/bpf/bpf_endian.h  |  72 +++++
> > tools/lib/bpf/bpf_helpers.h | 527 ++++++++++++++++++++++++++++++++++++
> > 3 files changed, 602 insertions(+), 1 deletion(-)
> > create mode 100644 tools/lib/bpf/bpf_endian.h
> > create mode 100644 tools/lib/bpf/bpf_helpers.h
> >

[...]

> > +#endif /* __BPF_ENDIAN__ */
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > new file mode 100644
> > index 000000000000..a1d9b97b8e15
> > --- /dev/null
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -0,0 +1,527 @@
> > +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> > +#ifndef __BPF_HELPERS__
> > +#define __BPF_HELPERS__
> > +
> > +#define __uint(name, val) int (*name)[val]
> > +#define __type(name, val) val *name
>
> Similar to the concern with 4/6, maybe we should rename/prefix/postfix
> these two macros?

Those were specifically named so they are as clear and clean in user
code as possible, it was an explicit goal. Ideally they would be
"uint" and "type", but that's pushing it too far :)

>
> Thanks,
> Song
>
