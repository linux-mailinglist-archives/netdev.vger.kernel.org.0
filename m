Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72323123B4E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLRAHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:07:07 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:42951 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfLRAHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:07:07 -0500
Received: by mail-vk1-f196.google.com with SMTP id s142so131398vkd.9;
        Tue, 17 Dec 2019 16:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m7MxXC2pZXTopVEKyn3QOOr+0E+eVw8yt2yJTPdUk8E=;
        b=dFvADV6gwv9SU+PbX8TMy6wwxOI7i6x5ywWAs6HZ/WI+N+TrNDvuBO6qGmy1RNnIOA
         19MlcvNMCV0/Yq/lONXQV5JYmZ2/DqDE6fqmEbVE1LgrblyYFVC9kXIsOsLrdygwdEKq
         ByLeZR3Muk67Z7Qd2J0tGkIX0uZp4GhI4QZp5DPKDWahtfdgVZs1ctQvV0faDHmXojQM
         ovXFQJP+lKkohdKd63IP6zI3hv2cH5ijBs9hGNLKCwrqBBVW/kle7A15nPSAzzpsKC+V
         shOKc/cPdHC/JK5lvrUosttQp69KXO7ji7a7C5mNvwzaCLoCt2hXZwEbPpwJP8qFSU6d
         ozDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m7MxXC2pZXTopVEKyn3QOOr+0E+eVw8yt2yJTPdUk8E=;
        b=ugheoCebjUvpI3QHcGqigkmE4vUU/uGIh9BjGgN6+VpDb3q3CyJvNPKkNYeOOHwwH1
         LxoAu9jen0p55g3FHCJEVK3GDuaS+aTDiyeiyjD5CdBQtBUxCjZBCvPep2RdN9bivGWz
         H6cY4FWi0uCBaI+BDRBNtmwFfWtkDyetuYphdSBSPcVyHiAnJS9i0z3aMTaX4uv9gOdy
         GIIS4QgS25vNkWrou1GaMXhnr77Bc5JZhOBMAri+a9VLYnhmnheTpVBcuHd0zTJaG077
         Sr0tCF6CWzoAavITYfY2T7MqwZ/183FXRDzqOZZfl9NRtxRq8Wdy8ordTg+uzsMgz931
         xVKg==
X-Gm-Message-State: APjAAAXfDkCBPubrA5wp16o/H2b+Ys4gegQIV97vH6eIvMavb7Id8Zu7
        UsTciX49lOCLG+CVhdZG+sr1updORrqPRCcaMwQ=
X-Google-Smtp-Source: APXvYqxMOHXc8NGFeJ+ja7rYfB4kXh/OugCGAoLJdeA7RUtVM836lMFfVrDIm7ufDJ6wqWDEh0nLbVli0MCD4OPvuH8=
X-Received: by 2002:a1f:8cd5:: with SMTP id o204mr189605vkd.66.1576627625646;
 Tue, 17 Dec 2019 16:07:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576575253.git.ethercflow@gmail.com> <8f6b8979fb64bedf5cb406ba29146c5fa2539267.1576575253.git.ethercflow@gmail.com>
 <f54e3df6-626f-e9c4-f2c2-a63fb9953944@fb.com>
In-Reply-To: <f54e3df6-626f-e9c4-f2c2-a63fb9953944@fb.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Wed, 18 Dec 2019 08:06:54 +0800
Message-ID: <CABtjQmbVJrQSd-0ZP0vtkEO=F4EVjSikptAEMQJ-RD7xhNaKOA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v13 1/2] bpf: add new helper get_fd_path for
 mapping a file descriptor to a pathname
To:     Yonghong Song <yhs@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bgregg@netflix.com" <bgregg@netflix.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Sorry about a little pedantic. In d_path() function comments, we have:
> * Convert a dentry into an ASCII path name. If the entry has been deleted
>  * the string " (deleted)" is appended. Note that this is ambiguous.

> Note that there is a space before "(deleted)". I would like to the above
> changed to
> - a regular full path with " (deleted)" is appended.

Ah, so sorry about this, I should be more preciseness and thanks again for =
your
preciseness and patience.I'll submit another revision to fix this.

Yonghong Song <yhs@fb.com> =E4=BA=8E2019=E5=B9=B412=E6=9C=8818=E6=97=A5=E5=
=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=8812:29=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> On 12/17/19 1:47 AM, Wenbo Zhang wrote:
> > When people want to identify which file system files are being opened,
> > read, and written to, they can use this helper with file descriptor as
> > input to achieve this goal. Other pseudo filesystems are also supported=
.
> >
> > This requirement is mainly discussed here:
> >
> >    https://github.com/iovisor/bcc/issues/237
> >
> > v12->v13: addressed Gregg and Yonghong's feedback
> > - rename to get_fd_path
> > - refactor code & comment to be clearer and more compliant
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
>
> Ack with still the minor issue below, not sure whether another revision
> will be needed or not or the maintainer can just fix up before merging.
>
> Acked-by: Yonghong Song <yhs@fb.com>
>
>
> > ---
> >   include/uapi/linux/bpf.h       | 29 +++++++++++++-
> >   kernel/trace/bpf_trace.c       | 69 +++++++++++++++++++++++++++++++++=
+
> >   tools/include/uapi/linux/bpf.h | 29 +++++++++++++-
> >   3 files changed, 125 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index dbbcf0b02970..c1e4fd286614 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2821,6 +2821,32 @@ union bpf_attr {
> >    *  Return
> >    *          On success, the strictly positive length of the string, i=
ncluding
> >    *          the trailing NUL character. On error, a negative value.
> > + *
> > + * int bpf_get_fd_path(char *path, u32 size, int fd)
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
> > + *           - a regular full path with "(deleted)" is appended.
>
> Sorry about a little pedantic. In d_path() function comments, we have:
>   * Convert a dentry into an ASCII path name. If the entry has been delet=
ed
>   * the string " (deleted)" is appended. Note that this is ambiguous.
>
> Note that there is a space before "(deleted)". I would like to the above
> changed to
>     - a regular full path with " (deleted)" is appended.
>
> > + *           On failure, it is filled with zeroes.
> > + *   Return
> > + *           On success, returns the length of the copied string INCLU=
DING
> > + *           the trailing '\0'.
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
> > +     FN(get_fd_path),
> >
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which=
 helper
> >    * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index e5ef4ae9edb5..43a6aa6ad967 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -762,6 +762,71 @@ static const struct bpf_func_proto bpf_send_signal=
_proto =3D {
> >       .arg1_type      =3D ARG_ANYTHING,
> >   };
> >
> > +BPF_CALL_3(bpf_get_fd_path, char *, dst, u32, size, int, fd)
> > +{
> > +     int ret =3D -EBADF;
> > +     struct file *f;
> > +     char *p;
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
> > +     ret =3D strlen(p) + 1;
> > +     memmove(dst, p, ret);
> > +     fput(f);
> > +     return ret;
> > +
> > +error:
> > +     memset(dst, '0', size);
> > +     return ret;
> > +}
> > +
> > +static const struct bpf_func_proto bpf_get_fd_path_proto =3D {
> > +     .func       =3D bpf_get_fd_path,
> > +     .gpl_only   =3D true,
> > +     .ret_type   =3D RET_INTEGER,
> > +     .arg1_type  =3D ARG_PTR_TO_UNINIT_MEM,
> > +     .arg2_type  =3D ARG_CONST_SIZE,
> > +     .arg3_type  =3D ARG_ANYTHING,
> > +};
> > +
> >   static const struct bpf_func_proto *
> >   tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *p=
rog)
> >   {
> > @@ -953,6 +1018,8 @@ tp_prog_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
> >               return &bpf_get_stackid_proto_tp;
> >       case BPF_FUNC_get_stack:
> >               return &bpf_get_stack_proto_tp;
> > +     case BPF_FUNC_get_fd_path:
> > +             return &bpf_get_fd_path_proto;
> >       default:
> >               return tracing_func_proto(func_id, prog);
> >       }
> > @@ -1146,6 +1213,8 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, =
const struct bpf_prog *prog)
> >               return &bpf_get_stackid_proto_raw_tp;
> >       case BPF_FUNC_get_stack:
> >               return &bpf_get_stack_proto_raw_tp;
> > +     case BPF_FUNC_get_fd_path:
> > +             return &bpf_get_fd_path_proto;
> >       default:
> >               return tracing_func_proto(func_id, prog);
> >       }
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/=
bpf.h
> > index dbbcf0b02970..c1e4fd286614 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -2821,6 +2821,32 @@ union bpf_attr {
> >    *  Return
> >    *          On success, the strictly positive length of the string, i=
ncluding
> >    *          the trailing NUL character. On error, a negative value.
> > + *
> > + * int bpf_get_fd_path(char *path, u32 size, int fd)
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
> > + *           - a regular full path with "(deleted)" is appended.
> > + *           On failure, it is filled with zeroes.
> > + *   Return
> > + *           On success, returns the length of the copied string INCLU=
DING
> > + *           the trailing '\0'.
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
> > +     FN(get_fd_path),
> >
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which=
 helper
> >    * function eBPF program intends to call
> >
