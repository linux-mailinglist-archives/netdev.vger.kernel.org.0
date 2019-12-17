Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F178E1224A4
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfLQG12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:27:28 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:45954 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfLQG11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:27:27 -0500
Received: by mail-vk1-f195.google.com with SMTP id g7so2358663vkl.12;
        Mon, 16 Dec 2019 22:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rRT3iF8tiAD/fMzZxCKDxrX3Va8NsfDy0k2l5J1L/zo=;
        b=FoVyQ0UerMF3ZOP1WAQO1pcvKYoV4vme2H2aUcnuvDC16k6w/BrpEuTGKkLOJMGJIi
         P7m2XMcnIthociy/SwMV1uWxDEkDFw002DKDGdhwua/mbo0eyai9gdqx2nXuSanGvnjW
         Kc2GfhkdEx83pVZzbbZxQzcttiveGaQ6+gLatE0WKWoIaeXRJnOKkTQ0ZbtMgHCjOTp0
         ynLe0t7yFODBjqMyZcyz1sygTIWXcICFyJOZ93XMgzk0vKydOPugEl10/gMdsO9H2T5p
         CTrotwlgu90i1lD1TpWkVfhZyaDWF65CuEbb6GRhxH7nR62StmFb8KL5eYJjai5XQXtU
         8nTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rRT3iF8tiAD/fMzZxCKDxrX3Va8NsfDy0k2l5J1L/zo=;
        b=grJR8xxL0JJSKndQI2FJFI6Bvq4xqAUic60IGXHjTVGUcrXe/p/auX3K4gDaPIsqXi
         JUumGtwkU3amE9mUF3TNAatT2fy061ywEomxR6+pE690U6gYFh+xAtBR+e+GKCJxY1Fq
         Y6lPRgltXYWlngDd7dPyV1eoSHqPRihqJsP1xl2b171bm2enzykv68NnxLBAQ3acf9+k
         WGDOVt3yyClLLbrOcKU3S450PUDbgx2mfMftk+ZKGW3qx9ZcvOvu5dSCti1EcYoR70TO
         odF4YD2pXFTfrW9QFD3aM4XmGQF8cLTq3yytzfuyDx5HLqS4DrOS+NS5E0V4XwYglHcZ
         9vUw==
X-Gm-Message-State: APjAAAWLm+sve2sjqmWa1wGyF68gKf9DZpZuSbSLUt699ilVTu46PLmY
        1M8EWPzqdDcTXu2B13M/7B6kHnaL+S2VgyWxCSY=
X-Google-Smtp-Source: APXvYqw56F679tB9V+Jfa8kVC1fY5l77M1vbSAv6Tj846U5r9A3B0ARtsAunAOR+95rvXSq3kAwFQje7WVQFXfzq0P8=
X-Received: by 2002:a1f:2197:: with SMTP id h145mr2196283vkh.75.1576564046164;
 Mon, 16 Dec 2019 22:27:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576381511.git.ethercflow@gmail.com> <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
 <aa4bf1b3-0411-1a04-6156-3fb97add1f2c@fb.com>
In-Reply-To: <aa4bf1b3-0411-1a04-6156-3fb97add1f2c@fb.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Tue, 17 Dec 2019 14:27:15 +0800
Message-ID: <CABtjQmZF-+B=05MtyVF=7tbesMS9KJ4iQrQF8WS-E8UAG+YABg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v12 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
To:     Yonghong Song <yhs@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> > +{
> > +     struct file *f;
> > +     char *p;
> > +     int ret =3D -EBADF;

> please try to use reverse Christmas tree for declarations.

Thank you, I'll fix this.

Yonghong Song <yhs@fb.com> =E4=BA=8E2019=E5=B9=B412=E6=9C=8816=E6=97=A5=E5=
=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8812:10=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 12/14/19 8:01 PM, Wenbo Zhang wrote:
> > When people want to identify which file system files are being opened,
> > read, and written to, they can use this helper with file descriptor as
> > input to achieve this goal. Other pseudo filesystems are also supported=
.
> >
> > This requirement is mainly discussed here:
> >
> >    https://github.com/iovisor/bcc/issues/237
> >
> > v11->v12: addressed Alexei's feedback
> > - only allow tracepoints to make sure it won't dead lock
> >
> > v10->v11: addressed Al and Alexei's feedback
> > - fix missing fput()
> >
> > v9->v10: addressed Andrii's feedback
> > - send this patch together with the patch selftests as one patch series
> >
> > v8->v9:
> > - format helper description
> >
> > v7->v8: addressed Alexei's feedback
> > - use fget_raw instead of fdget_raw, as fdget_raw is only used inside f=
s/
> > - ensure we're in user context which is safe fot the help to run
> > - filter unmountable pseudo filesystem, because they don't have real pa=
th
> > - supplement the description of this helper function
> >
> > v6->v7:
> > - fix missing signed-off-by line
> >
> > v5->v6: addressed Andrii's feedback
> > - avoid unnecessary goto end by having two explicit returns
> >
> > v4->v5: addressed Andrii and Daniel's feedback
> > - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> > helper's names
> > - when fdget_raw fails, set ret to -EBADF instead of -EINVAL
> > - remove fdput from fdget_raw's error path
> > - use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointe=
r
> > into the buffer or an error code if the path was too long
> > - modify the normal path's return value to return copied string length
> > including NUL
> > - update this helper description's Return bits.
> >
> > v3->v4: addressed Daniel's feedback
> > - fix missing fdput()
> > - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> > - move fd2path's test code to another patch
> > - add comment to explain why use fdget_raw instead of fdget
> >
> > v2->v3: addressed Yonghong's feedback
> > - remove unnecessary LOCKDOWN_BPF_READ
> > - refactor error handling section for enhanced readability
> > - provide a test case in tools/testing/selftests/bpf
> >
> > v1->v2: addressed Daniel's feedback
> > - fix backward compatibility
> > - add this helper description
> > - fix signed-off name
> >
> > Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> > ---
> >   include/uapi/linux/bpf.h       | 29 +++++++++++++-
> >   kernel/trace/bpf_trace.c       | 70 +++++++++++++++++++++++++++++++++=
+
> >   tools/include/uapi/linux/bpf.h | 29 +++++++++++++-
> >   3 files changed, 126 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index dbbcf0b02970..71d9705df120 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2821,6 +2821,32 @@ union bpf_attr {
> >    *  Return
> >    *          On success, the strictly positive length of the string, i=
ncluding
> >    *          the trailing NUL character. On error, a negative value.
> > + *
> > + * int bpf_get_file_path(char *path, u32 size, int fd)
> > + *   Description
> > + *           Get **file** atrribute from the current task by *fd*, the=
n call
> > + *           **d_path** to get it's absolute path and copy it as strin=
g into
> > + *           *path* of *size*. Notice the **path** don't support unmou=
ntable
> > + *           pseudo filesystems as they don't have path (eg: SOCKFS, P=
IPEFS).
> > + *           The *size* must be strictly positive. On success, the hel=
per
> > + *           makes sure that the *path* is NUL-terminated, and the buf=
fer
> > + *           could be:
> > + *           - a regular full path (include mountable fs eg: /proc, /s=
ys)
> > + *           - a regular full path with "(deleted)" at the end.
> > + *           On failure, it is filled with zeroes.
> > + *   Return
> > + *           On success, returns the length of the copied string INCLU=
DING
> > + *           the trailing NUL.
> > + *
> > + *           On failure, the returned value is one of the following:
> > + *
> > + *           **-EPERM** if no permission to get the path (eg: in irq c=
tx).
> > + *
> > + *           **-EBADF** if *fd* is invalid.
> > + *
> > + *           **-EINVAL** if *fd* corresponds to a unmountable pseudo f=
s
> > + *
> > + *           **-ENAMETOOLONG** if full path is longer than *size*
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)               \
> >       FN(unspec),                     \
> > @@ -2938,7 +2964,8 @@ union bpf_attr {
> >       FN(probe_read_user),            \
> >       FN(probe_read_kernel),          \
> >       FN(probe_read_user_str),        \
> > -     FN(probe_read_kernel_str),
> > +     FN(probe_read_kernel_str),      \
> > +     FN(get_file_path),
> >
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which=
 helper
> >    * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index e5ef4ae9edb5..db9c0ec46a5d 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -762,6 +762,72 @@ static const struct bpf_func_proto bpf_send_signal=
_proto =3D {
> >       .arg1_type      =3D ARG_ANYTHING,
> >   };
> >
> > +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> > +{
> > +     struct file *f;
> > +     char *p;
> > +     int ret =3D -EBADF;
>
> please try to use reverse Christmas tree for declarations.
>
> > +
> > +     /* Ensure we're in user context which is safe for the helper to
> > +      * run. This helper has no business in a kthread.
> > +      */
> > +     if (unlikely(in_interrupt() ||
> > +                  current->flags & (PF_KTHREAD | PF_EXITING))) {
> > +             ret =3D -EPERM;
> > +             goto error;
> > +     }
> > +
> > +     /* Use fget_raw instead of fget to support O_PATH, and it doesn't
> > +      * have any sleepable code, so it's ok to be here.
> > +      */
> > +     f =3D fget_raw(fd);
> > +     if (!f)
> > +             goto error;
> > +
> > +     /* For unmountable pseudo filesystem, it seems to have no meaning
> > +      * to get their fake paths as they don't have path, and to be no
> > +      * way to validate this function pointer can be always safe to ca=
ll
> > +      * in the current context.
> > +      */
> > +     if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname) {
> > +             ret =3D -EINVAL;
> > +             fput(f);
> > +             goto error;
> > +     }
> > +
> > +     /* After filter unmountable pseudo filesytem, d_path won't call
> > +      * dentry->d_op->d_name(), the normally path doesn't have any
> > +      * sleepable code, and despite it uses the current macro to get
> > +      * fs_struct (current->fs), we've already ensured we're in user
> > +      * context, so it's ok to be here.
> > +      */
> > +     p =3D d_path(&f->f_path, dst, size);
> > +     if (IS_ERR(p)) {
> > +             ret =3D PTR_ERR(p);
> > +             fput(f);
> > +             goto error;
> > +     }
> > +
> > +     ret =3D strlen(p);
> > +     memmove(dst, p, ret);
> > +     dst[ret++] =3D '\0';
> > +     fput(f);
> > +     return ret;
> > +
> > +error:
> > +     memset(dst, '0', size);
> > +     return ret;
> > +}
> > +
> [...]
