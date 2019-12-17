Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42EAC1224A1
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfLQG0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:26:37 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:34652 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfLQG0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:26:37 -0500
Received: by mail-vs1-f67.google.com with SMTP id g15so5804702vsf.1;
        Mon, 16 Dec 2019 22:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e7lytHAlG0jnTPcHruozsZOHMZrOkRyWxkxFk3QNFHc=;
        b=Uyw2/Hk8RZ4BC8nULcv0kXi3B2RzYvnV99mWVtnJxAYBVpV/yHrNR9PRY5H8sxucTH
         FFe93UElCYERyrkNguvW5OBfTt+e3jvSVB8eTHtu+A05wILrNnpxzw1mlk6jISUMKHKE
         EyCeJFCVR5A+fT4D5Qy98ho1L1ZZnt7SuCDmWCsmwoAVl0wuFTXqwAPxukPfQHvBGuZW
         gJSSscfaUm0MC4ibSucfxVpvQdcMI84QbKske0VufXhhime1Rcq4A+kkkaRkqYAp20KV
         RgJ/RT9E6lc0Jq5R5vV6Wko1vhT4ELJynI5LKkwouWcdMv5gn4RF1clndLXxTVgyE7t9
         rBBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e7lytHAlG0jnTPcHruozsZOHMZrOkRyWxkxFk3QNFHc=;
        b=Jxs8GrbsZoYOQbyJTEDMOxoFMk2qt0kA542gk32cXbOVMNSz28IIYFbPj2Ns/v1Iw2
         aNI7/rasXECuDBkaoMhv+4qLBtIWrgFX3hbTbMu3X9OKFWDNnsCfjmn74kgszfZab//q
         il0htBgco1W1j04u3H4xrlpfhpzI0pYOKAPY0E4IxcppuR9EgxBztWHSQk8VDo0pS9X2
         l1rdGGvkASANfNvtV5JWGU5zmYJHrFubsluRnnknp8TGDVQJ0AYza2DuVwgBtS1Jt+Q5
         kyDnzJKyURVNXwFRhCFKgiNSFQrV8rD62xqELhNKQV4IaTs1aaX6790yrFUgiW/VTnMP
         FP7w==
X-Gm-Message-State: APjAAAUbXlyMTM02wdVviJexRI9pe+eCg2wOMEKQhR+4B7cKvynIiLnS
        Pi1j9Y7881yqQG9bwsPGgUSDsoUOXHUVlSmjTZltN/TiICI=
X-Google-Smtp-Source: APXvYqynqDGPNTgRRGDCVA55955r5419FLnJ/vMwMvn6krbhQyCqUzdjC40ip54Zf2/P5ZJG6TkueqEtT/3FKk3lFKI=
X-Received: by 2002:a67:ed07:: with SMTP id l7mr1796707vsp.47.1576563995882;
 Mon, 16 Dec 2019 22:26:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1576381511.git.ethercflow@gmail.com> <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
 <e3ff90c1-6024-ec9f-061c-195e9def9c0c@fb.com>
In-Reply-To: <e3ff90c1-6024-ec9f-061c-195e9def9c0c@fb.com>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Tue, 17 Dec 2019 14:26:24 +0800
Message-ID: <CABtjQmZcbhcab0a7ksuggg3ZoDwM5s3ucjeA_baPTpAJQvKQLA@mail.gmail.com>
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

> > + *           - a regular full path (include mountable fs eg: /proc, /s=
ys)
> > + *           - a regular full path with "(deleted)" at the end.

> Let us say with " (deleted)" is appended to be consistent with comments
> in d_path() and is more clear to user what the format will looks like.

Thank you, I'll fix this.

> > +     ret =3D strlen(p);
> > +     memmove(dst, p, ret);
> > +     dst[ret++] =3D '\0';

> nit: you could do memmove(dst, p, ret + 1)?

I did with `dst[ret++]=3D'\0';`  to return value length including
trailing '\0'. as you mentioned below:

> > +     fput(f);
> > +     return ret;

> The description says the return value length including trailing '\0'.
> The above 'ret' does not include trailing '\0'.

It seems `[ret++]` not very clear to read and '\0' can be done by
`memmove`. I think I'll refactor to

```
ret =3D strlen(p) + 1;
memmove(dst, p, ret);
fput(f);
return ret;
```

Is this better?

Yonghong Song <yhs@fb.com> =E4=BA=8E2019=E5=B9=B412=E6=9C=8816=E6=97=A5=E5=
=91=A8=E4=B8=80 =E4=B8=8A=E5=8D=8812:06=E5=86=99=E9=81=93=EF=BC=9A
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
>
> Let us say with " (deleted)" is appended to be consistent with comments
> in d_path() and is more clear to user what the format will looks like.
>
> > + *           On failure, it is filled with zeroes.
> > + *   Return
> > + *           On success, returns the length of the copied string INCLU=
DING
> > + *           the trailing NUL.
>
> trailing '\0'.
>
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
>
> nit: you could do memmove(dst, p, ret + 1)?
>
> > +     fput(f);
> > +     return ret;
>
> The description says the return value length including trailing '\0'.
> The above 'ret' does not include trailing '\0'.
>
> > +
> > +error:
> > +     memset(dst, '0', size);
> > +     return ret;
> > +}
> > +
> > +static const struct bpf_func_proto bpf_get_file_path_proto =3D {
> > +     .func       =3D bpf_get_file_path,
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
> > @@ -953,6 +1019,8 @@ tp_prog_func_proto(enum bpf_func_id func_id, const=
 struct bpf_prog *prog)
> >               return &bpf_get_stackid_proto_tp;
> >       case BPF_FUNC_get_stack:
> >               return &bpf_get_stack_proto_tp;
> > +     case BPF_FUNC_get_file_path:
> > +             return &bpf_get_file_path_proto;
> >       default:
> >               return tracing_func_proto(func_id, prog);
> >       }
> > @@ -1146,6 +1214,8 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, =
const struct bpf_prog *prog)
> >               return &bpf_get_stackid_proto_raw_tp;
> >       case BPF_FUNC_get_stack:
> >               return &bpf_get_stack_proto_raw_tp;
> > +     case BPF_FUNC_get_file_path:
> > +             return &bpf_get_file_path_proto;
> >       default:
> >               return tracing_func_proto(func_id, prog);
> >       }
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/=
bpf.h
> > index dbbcf0b02970..71d9705df120 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
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
>
> ditto
>
> > + *           On failure, it is filled with zeroes.
> > + *   Return
> > + *           On success, returns the length of the copied string INCLU=
DING
> > + *           the trailing NUL.
>
> ditto
>
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
> >
