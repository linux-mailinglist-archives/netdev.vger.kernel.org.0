Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F45EA1A1
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfJ3QTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 12:19:24 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:42270 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3QTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 12:19:24 -0400
Received: by mail-ua1-f67.google.com with SMTP id v2so873592uam.9;
        Wed, 30 Oct 2019 09:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lnGL5M5fSCWAymH5l1Oh8Q43QFPNjJp2zZ+3UI6AZG0=;
        b=G9hmuWiCf5if5Wz6RgyTUBMpAyMnrHgc+JT1dhYZAP2ulDhUvChvkINVBjMFv3fpK6
         7KOEV8FGzHMxNSCGEtzq0IWmNIwh1lZaDYj7vQ5UQRS7KePLCkeU1S40QJrVPxJ1JNbq
         D8n9GGHWTUarE1/jkqC4oh0qitszppCyrKyXBeWdAlW8lx1XZAvl+EYftidrzaIj7Len
         9GHRSPEK0NVvxivPEj+ykfPaTmwgPitpsqwjhgbIVZdkkJQ8Mym45GGZSvw8qakDAyyn
         dkxYPspM4ip86vauXWiNyHiHVFdlnfk4Vw6pyolJUslaflLju4D8FtfjJWZlW0EeBqmo
         m4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lnGL5M5fSCWAymH5l1Oh8Q43QFPNjJp2zZ+3UI6AZG0=;
        b=KN7cyg1YeygLPMip5QL+arkV0knn03bnXECCM/IDJc03CpLSjvd9Vvc0WxvW6pNQSx
         sYFIkIGSjuumCskF3XpS0GPVZEUT4tAeMJROaPh8nSJpM0mFWD/VLq086FZ4UjNSeodK
         SE1F1qnfnD4FBaloH7tcia35MDqGWO9aLktxiC0HYF+1/2It+GYJtUCWIeFimsKYmCTn
         sT0rV4pRwxpy/q7bW29r6IcC5//n/Zq3KtOntxKnjVkGd4PH8PTmz0+5tVW+ox2FPOhf
         gzYtNCVNuQlp9QuHWNGhaMYDSeNT+C1p6ren1k7yv2DEYBA41eVE1zvUMzFgo8fgpE8V
         sglw==
X-Gm-Message-State: APjAAAU3WDi3Ztvt6qp5ZMefBAt6A4nhE0isP4kpxMdeGpKB9+91yqoT
        wPnz1UvIb7vxMricdmdMXYA5bL392mFoeQoNEoU=
X-Google-Smtp-Source: APXvYqxSzS7R7XJBRTYj3i0gKkKDByOF9kfUI8Mz9RHF/Ln+fYDL+Jh0W+wMHUiALORqI5T3zgyZOja4yoeK1DYlRAo=
X-Received: by 2002:ab0:2e9c:: with SMTP id f28mr298704uaa.20.1572452363034;
 Wed, 30 Oct 2019 09:19:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191028141053.12267-1-ethercflow@gmail.com> <CAEf4BzY5XfX1_Txomnz1G4PCq=E4JSPVD+_BQ7qwn8=WM_imVA@mail.gmail.com>
In-Reply-To: <CAEf4BzY5XfX1_Txomnz1G4PCq=E4JSPVD+_BQ7qwn8=WM_imVA@mail.gmail.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Thu, 31 Oct 2019 00:19:15 +0800
Message-ID: <CABtjQmaFrt1d=ERU7McDzGrP5vhGenNz=Gr+bVBVzThh+c6i5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpf: add new helper fd2path for mapping a
 file descriptor to a pathname
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> from what I can see, we don't have any BPF helper with this naming
> approach(2 -> to, 4 -> for, etc). How about something like
> bpf_get_file_path?

I think bpf_get_file_path is better. I'll change to it.

> > + *     Description
> > + *             Get **file** atrribute from the current task by *fd*, t=
hen call
> > + *             **d_path** to get it's absolute path and copy it as str=
ing into
> > + *             *path* of *size*. The **path** also support pseudo file=
systems
> > + *             (whether or not it can be mounted). The *size* must be =
strictly
> > + *             positive. On success, the helper makes sure that the *p=
ath* is
> > + *             NUL-terminated. On failure, it is filled with zeroes.
> > + *     Return
> > + *             0 on success, or a negative error in case of failure.

> Mention that we actually return a positive number on success, which is
> a size of the string + 1 for NUL byte (the +1 is not true right now,
> but I think should be).

I agree.

> I haven't followed previous discussions, so sorry if this was asked
> before. Can either fdget_raw or d_path sleep? Also, d_path seems to be
> relying on current, which in the interrupt context might not be what
> you really want. Have you considered these problems?

Yes, I've checked fdget_raw, it use atomic and rcu_read_lock/ruc_read_unloc=
k,
so it's not sleepable. d_path use rcu_read_lock/rcu_read_unlock too.

In my mind I think this helper won't be called in the interrupt
context (Would you
please give me an example if there's an application scene). So I think
it's ok to
use d_path here.

> > +       if (!f.file)
> > +               goto error;
> > +
> > +       p =3D d_path(&f.file->f_path, dst, size);
> > +       if (IS_ERR_OR_NULL(p)) {
> > +               ret =3D PTR_ERR(p);

if p can really be NULL, you'd get ret =3D=3D 0 here, which is probably
not what you want.
But reading d_path, it seems like it's either valid pointer or error,
so just use IS_ERR above?

Agree, I'll fix error handling code.

> > +               goto error;
> > +       }
> > +
> > +       ret =3D strlen(p);
> > +       memmove(dst, p, ret);
> > +       dst[ret] =3D '\0';

I think returning number of useful bytes (including terminating NUL)
is good and follows bpf_probe_read_str() convention. So ret++ here?

Agree. Thank you.

> +       goto end;
> +
> +error:
> +       memset(dst, '0', size);
> +end:
> +       fdput(f);
> +       return ret;
> +}
> +

[...]


Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2019=E5=B9=B410=E6=9C=
=8830=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=882:48=E5=86=99=E9=81=93=
=EF=BC=9A
>
> On Mon, Oct 28, 2019 at 1:59 PM Wenbo Zhang <ethercflow@gmail.com> wrote:
> >
> > When people want to identify which file system files are being opened,
> > read, and written to, they can use this helper with file descriptor as
> > input to achieve this goal. Other pseudo filesystems are also supported=
.
> >
> > This requirement is mainly discussed here:
> >
> >   https://github.com/iovisor/bcc/issues/237
> >
> > v3->v4:
> > - fix missing fdput()
> > - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> > - move fd2path's test code to another patch
> >
> > v2->v3:
> > - remove unnecessary LOCKDOWN_BPF_READ
> > - refactor error handling section for enhanced readability
> > - provide a test case in tools/testing/selftests/bpf
> >
> > v1->v2:
> > - fix backward compatibility
> > - add this helper description
> > - fix signed-off name
> >
> > Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> > ---
> >  include/uapi/linux/bpf.h       | 14 +++++++++++-
> >  kernel/trace/bpf_trace.c       | 40 ++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h | 14 +++++++++++-
> >  3 files changed, 66 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4af8b0819a32..124632b2a697 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2775,6 +2775,17 @@ union bpf_attr {
> >   *             restricted to raw_tracepoint bpf programs.
> >   *     Return
> >   *             0 on success, or a negative error in case of failure.
> > + *
> > + * int bpf_fd2path(char *path, u32 size, int fd)
>
> from what I can see, we don't have any BPF helper with this naming
> approach(2 -> to, 4 -> for, etc). How about something like
> bpf_get_file_path?
>
> > + *     Description
> > + *             Get **file** atrribute from the current task by *fd*, t=
hen call
> > + *             **d_path** to get it's absolute path and copy it as str=
ing into
> > + *             *path* of *size*. The **path** also support pseudo file=
systems
> > + *             (whether or not it can be mounted). The *size* must be =
strictly
> > + *             positive. On success, the helper makes sure that the *p=
ath* is
> > + *             NUL-terminated. On failure, it is filled with zeroes.
> > + *     Return
> > + *             0 on success, or a negative error in case of failure.
>
> Mention that we actually return a positive number on success, which is
> a size of the string + 1 for NUL byte (the +1 is not true right now,
> but I think should be).
>
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -2888,7 +2899,8 @@ union bpf_attr {
> >         FN(sk_storage_delete),          \
> >         FN(send_signal),                \
> >         FN(tcp_gen_syncookie),          \
> > -       FN(skb_output),
> > +       FN(skb_output),                 \
> > +       FN(fd2path),
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which =
helper
> >   * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 571c25d60710..dd7b070df3d6 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -683,6 +683,44 @@ static const struct bpf_func_proto bpf_send_signal=
_proto =3D {
> >         .arg1_type      =3D ARG_ANYTHING,
> >  };
> >
> > +BPF_CALL_3(bpf_fd2path, char *, dst, u32, size, int, fd)
> > +{
> > +       struct fd f;
> > +       char *p;
> > +       int ret =3D -EINVAL;
> > +
> > +       /* Use fdget_raw instead of fdget to support O_PATH */
> > +       f =3D fdget_raw(fd);
>
> I haven't followed previous discussions, so sorry if this was asked
> before. Can either fdget_raw or d_path sleep? Also, d_path seems to be
> relying on current, which in the interrupt context might not be what
> you really want. Have you considered these problems?
>
> > +       if (!f.file)
> > +               goto error;
> > +
> > +       p =3D d_path(&f.file->f_path, dst, size);
> > +       if (IS_ERR_OR_NULL(p)) {
> > +               ret =3D PTR_ERR(p);
>
> if p can really be NULL, you'd get ret =3D=3D 0 here, which is probably
> not what you want.
> But reading d_path, it seems like it's either valid pointer or error,
> so just use IS_ERR above?
>
> > +               goto error;
> > +       }
> > +
> > +       ret =3D strlen(p);
> > +       memmove(dst, p, ret);
> > +       dst[ret] =3D '\0';
>
> I think returning number of useful bytes (including terminating NUL)
> is good and follows bpf_probe_read_str() convention. So ret++ here?
>
> > +       goto end;
> > +
> > +error:
> > +       memset(dst, '0', size);
> > +end:
> > +       fdput(f);
> > +       return ret;
> > +}
> > +
>
> [...]
