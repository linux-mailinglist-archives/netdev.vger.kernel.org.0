Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C2913B318
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgANTlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:41:35 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34127 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANTlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:41:35 -0500
Received: by mail-qk1-f195.google.com with SMTP id j9so13356386qkk.1;
        Tue, 14 Jan 2020 11:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S7rRmbKYBTKOVP/BEYNggcaNgqOmcCyWlPXYhFWgXSg=;
        b=U1uFsg/yiaQ7TQYO1CaXgoN5XweP5vdNncRsnvrU6o1NkvdpvsPkPDg5UVy9tjVffJ
         fw53yHoIzr0s7aiFS+ZEsqMHson1ceyHfFk74/nd7xKnTdhwI8xL+ag32iH3x16RY49b
         G6JA+dcmRbPZMqYSzBqx+6tHqLPFzTGr2cHlMw6MDezDC4sC+LCfSWlObD7A00m4YmH5
         lv718Wz/GxehDAIzoWyAGdxEjYfN6AYpNZ5wiwOYcvEuruuGZh5o1orR0UHeeasphX65
         L+ufK5P5HKfSzCBaRdt4ue6P15oC+u5GeNepbes2swbMJrw62USEGwCkLb9MQljW+cy8
         e9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S7rRmbKYBTKOVP/BEYNggcaNgqOmcCyWlPXYhFWgXSg=;
        b=VZmxzJepmaWbY8XTF/jiReilMuPWrY7VtMFlXHkWiYZ1D/P4mXt2cTPwhZ299NGea7
         BQYieJpiYEz1kg80DBLpTP0Vwtahvk5/QWtsyPrL3xjZF7cGx3IN8ThdtFIza+Z/WxMa
         5CNZIrQbUVuYrYtUmJYmbPVY4xUgjuuaaDEpp0/ZeakxnzJsmbU+uqaybgJ5rM+//uoj
         1Eha+4oCnTUzN8HJ38u9NQfZMCZGTf6x7e4mn4NE1qcXRfux8nZpqydYQVazovUxE5oV
         GWRtWQF2DAJAutJgqTqqlcRoKywke9Ua56dw/+tMsRdCRRPNdJMXfL8znzB7bTBl58Wf
         rrkg==
X-Gm-Message-State: APjAAAWTeUkwwX7ZS7pl504aptsVfaSZ/a1XalM2JcOJQEeF3nMNJbHg
        u0RLNHhAGxet0xWg6mwnJyIAmnDAMt9cdqvY720=
X-Google-Smtp-Source: APXvYqx7BwxPAfIoI9SMzErlNfhINffaux+pD7VhpdTjW8BnVk1RQA3go18yVxatvzjL1P2tf3bORq1PyNAXowOlxqI=
X-Received: by 2002:a05:620a:14a2:: with SMTP id x2mr23692589qkj.36.1579030894546;
 Tue, 14 Jan 2020 11:41:34 -0800 (PST)
MIME-Version: 1.0
References: <20200114164250.922192-1-toke@redhat.com> <CAEf4Bzb9sTF4BWA1wyWM-3jsMUnbwYi1XtkDj8ZXdyHk7C4_mQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzb9sTF4BWA1wyWM-3jsMUnbwYi1XtkDj8ZXdyHk7C4_mQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 11:41:23 -0800
Message-ID: <CAEf4Bzaqi6Wt4oPyd=ygTwBNzczAaF-7boKB025-6H=DDtsuqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Fix include of bpf_helpers.h when libbpf
 is installed on system
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 11:07 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jan 14, 2020 at 8:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > The change to use angled includes for bpf_helper_defs.h breaks compilat=
ion
> > against libbpf when it is installed in the include path, since the file=
 is
> > installed in the bpf/ subdirectory of $INCLUDE_PATH. Fix this by adding=
 the
> > bpf/ prefix to the #include directive.
> >
> > Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken=
 from selftests dir")
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
> > Not actually sure this fix works for all the cases you originally tried=
 to
>
> This does break selftests/bpf. Have you tried building selftests, does
> it work for you? We need to fix selftests simultaneously with this
> change.
>
> > fix with the referred commit; please check. Also, could we please stop =
breaking
> > libbpf builds? :)
>
> Which libbpf build is failing right now? Both github and in-kernel
> libbpf builds are fine. You must be referring to something else. What
> exactly?

I think it's better to just ensure that when compiling BPF programs,
they have -I/usr/include/bpf specified, so that all BPF-side headers
can be simply included as #include <bpf_helpers.h>, #include
<bpf_tracing.h>, etc

>
> >
> >  tools/lib/bpf/bpf_helpers.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > index 050bb7bf5be6..fa43d649e7a2 100644
> > --- a/tools/lib/bpf/bpf_helpers.h
> > +++ b/tools/lib/bpf/bpf_helpers.h
> > @@ -2,7 +2,7 @@
> >  #ifndef __BPF_HELPERS__
> >  #define __BPF_HELPERS__
> >
> > -#include <bpf_helper_defs.h>
> > +#include <bpf/bpf_helper_defs.h>
> >
> >  #define __uint(name, val) int (*name)[val]
> >  #define __type(name, val) typeof(val) *name
> > --
> > 2.24.1
> >
