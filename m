Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CC7ED1AD
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 05:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKCEKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 00:10:20 -0400
Received: from mail-vk1-f195.google.com ([209.85.221.195]:44144 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfKCEKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 00:10:20 -0400
Received: by mail-vk1-f195.google.com with SMTP id o198so3058059vko.11;
        Sat, 02 Nov 2019 21:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eXpTsU66lBUFg+QMEodac4wkDqyVDWl6oCipcHR7lyM=;
        b=hmTT9LS/Ibk5gPKcf+3EYrV1Q9XTupah9+UfKNDNX8I2IzzACyWbJtmn2f+WsUv4W3
         AFwj/ZljyyODN1j4NLwI2GT3xvLHzLYKsg9hFMF6lPqRKvrE2eAZG/OnbqZnA/9CG2dc
         ZeNTb7adL78o6iKZaH8FKxkstzyvUuHE6CXlYOx0kKOraLv7xhxLAK2WzJRMq30Ap/rW
         dO1/250ToiErjVPP4BXbzkQremLT8Z5v0QKqZhjkLswSpbZ0lP2+tZdKqojIcqAIlFq/
         5waOolHmVYC1CnUYVEQ4y2bXtwvE2jbq0WhxeWi2m5kuvJk7DcCO5qPzyZIPDLMkLv3h
         m+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eXpTsU66lBUFg+QMEodac4wkDqyVDWl6oCipcHR7lyM=;
        b=ksSV7aRSJJF110vaAtM1IQTelNTLHi3VFC4M1yQUCF7XGTxVo3Je/YQvJVSKjMZuNP
         LH1h/v2Xd0J34izU79LUh4SAnhE2nPHCxDliRvsHKGjiU7pXLjxHE12Kw7GYV60KC/ET
         tKC/7JNjvPDXcTia3z8a3Q5pc485zN0otVyKMS5aUbhtp8kknh3krAMYMIOKVOrZt2Qo
         dHeaz1gX8hOLG/6fRLdwVlr1Bsjx4zO6Ni8s1Tlz5hpAUevlfgg6c3VH4P3No0kz4Wzb
         aomojcqp+WDeGMux/5gU3f/sQuoZEAPUXyclc1JvejD0u82HUiNlRCu2Phv4EOugygT/
         CeBA==
X-Gm-Message-State: APjAAAUdk4q6eYiydnSnRkJv47XjquuI6dMKLaquYXskKKiUEKNUj1Ce
        dATmwt4dgOW+Cb9Ddvr2KmGcwqXX/l0fhEaJzp0=
X-Google-Smtp-Source: APXvYqyqLk93V1xrcDCv2pELafOa0yIImCfWvjPfCyzz3T6+30cdIhqMuR54sMZgDXc1hoIt6MZXrVCkjH3XBjwYrSE=
X-Received: by 2002:a1f:944a:: with SMTP id w71mr1041716vkd.60.1572754219108;
 Sat, 02 Nov 2019 21:10:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191028141053.12267-1-ethercflow@gmail.com> <CAEf4BzY5XfX1_Txomnz1G4PCq=E4JSPVD+_BQ7qwn8=WM_imVA@mail.gmail.com>
 <20191030153203.GA2675@pc-63.home>
In-Reply-To: <20191030153203.GA2675@pc-63.home>
From:   Wenbo Zhang <ethercflow@gmail.com>
Date:   Sun, 3 Nov 2019 12:10:15 +0800
Message-ID: <CABtjQmbmdDQVvLRvDQKrqpnB1ZmEGjKyyOHr1Ni_JBV1NcK3nQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpf: add new helper fd2path for mapping a
 file descriptor to a pathname
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Also I'd prefer fdget_*()'s error path not calling fdput(f).

Thank you, I've committed a new patch to fix this.

Daniel Borkmann <daniel@iogearbox.net> =E4=BA=8E2019=E5=B9=B410=E6=9C=8830=
=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8811:32=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On Tue, Oct 29, 2019 at 11:48:44AM -0700, Andrii Nakryiko wrote:
> > On Mon, Oct 28, 2019 at 1:59 PM Wenbo Zhang <ethercflow@gmail.com> wrot=
e:
> > >
> > > When people want to identify which file system files are being opened=
,
> > > read, and written to, they can use this helper with file descriptor a=
s
> > > input to achieve this goal. Other pseudo filesystems are also support=
ed.
> > >
> > > This requirement is mainly discussed here:
> > >
> > >   https://github.com/iovisor/bcc/issues/237
> > >
> > > v3->v4:
> > > - fix missing fdput()
> > > - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> > > - move fd2path's test code to another patch
> > >
> > > v2->v3:
> > > - remove unnecessary LOCKDOWN_BPF_READ
> > > - refactor error handling section for enhanced readability
> > > - provide a test case in tools/testing/selftests/bpf
> > >
> > > v1->v2:
> > > - fix backward compatibility
> > > - add this helper description
> > > - fix signed-off name
> > >
> > > Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> > > ---
> > >  include/uapi/linux/bpf.h       | 14 +++++++++++-
> > >  kernel/trace/bpf_trace.c       | 40 ++++++++++++++++++++++++++++++++=
++
> > >  tools/include/uapi/linux/bpf.h | 14 +++++++++++-
> > >  3 files changed, 66 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 4af8b0819a32..124632b2a697 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -2775,6 +2775,17 @@ union bpf_attr {
> > >   *             restricted to raw_tracepoint bpf programs.
> > >   *     Return
> > >   *             0 on success, or a negative error in case of failure.
> > > + *
> > > + * int bpf_fd2path(char *path, u32 size, int fd)
> >
> > from what I can see, we don't have any BPF helper with this naming
> > approach(2 -> to, 4 -> for, etc). How about something like
> > bpf_get_file_path?
> >
> > > + *     Description
> > > + *             Get **file** atrribute from the current task by *fd*,=
 then call
> > > + *             **d_path** to get it's absolute path and copy it as s=
tring into
> > > + *             *path* of *size*. The **path** also support pseudo fi=
lesystems
> > > + *             (whether or not it can be mounted). The *size* must b=
e strictly
> > > + *             positive. On success, the helper makes sure that the =
*path* is
> > > + *             NUL-terminated. On failure, it is filled with zeroes.
> > > + *     Return
> > > + *             0 on success, or a negative error in case of failure.
> >
> > Mention that we actually return a positive number on success, which is
> > a size of the string + 1 for NUL byte (the +1 is not true right now,
> > but I think should be).
> >
> > >   */
> > >  #define __BPF_FUNC_MAPPER(FN)          \
> > >         FN(unspec),                     \
> > > @@ -2888,7 +2899,8 @@ union bpf_attr {
> > >         FN(sk_storage_delete),          \
> > >         FN(send_signal),                \
> > >         FN(tcp_gen_syncookie),          \
> > > -       FN(skb_output),
> > > +       FN(skb_output),                 \
> > > +       FN(fd2path),
> > >
> > >  /* integer value in 'imm' field of BPF_CALL instruction selects whic=
h helper
> > >   * function eBPF program intends to call
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index 571c25d60710..dd7b070df3d6 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -683,6 +683,44 @@ static const struct bpf_func_proto bpf_send_sign=
al_proto =3D {
> > >         .arg1_type      =3D ARG_ANYTHING,
> > >  };
> > >
> > > +BPF_CALL_3(bpf_fd2path, char *, dst, u32, size, int, fd)
> > > +{
> > > +       struct fd f;
> > > +       char *p;
> > > +       int ret =3D -EINVAL;
> > > +
> > > +       /* Use fdget_raw instead of fdget to support O_PATH */
> > > +       f =3D fdget_raw(fd);
> >
> > I haven't followed previous discussions, so sorry if this was asked
> > before. Can either fdget_raw or d_path sleep? Also, d_path seems to be
> > relying on current, which in the interrupt context might not be what
> > you really want. Have you considered these problems?
> >
> > > +       if (!f.file)
> > > +               goto error;
> > > +
> > > +       p =3D d_path(&f.file->f_path, dst, size);
> > > +       if (IS_ERR_OR_NULL(p)) {
> > > +               ret =3D PTR_ERR(p);
> >
> > if p can really be NULL, you'd get ret =3D=3D 0 here, which is probably
> > not what you want.
> > But reading d_path, it seems like it's either valid pointer or error,
> > so just use IS_ERR above?
> >
> > > +               goto error;
> > > +       }
> > > +
> > > +       ret =3D strlen(p);
> > > +       memmove(dst, p, ret);
> > > +       dst[ret] =3D '\0';
> >
> > I think returning number of useful bytes (including terminating NUL)
> > is good and follows bpf_probe_read_str() convention. So ret++ here?
> >
> > > +       goto end;
> > > +
> > > +error:
> > > +       memset(dst, '0', size);
> > > +end:
> > > +       fdput(f);
>
> Also I'd prefer fdget_*()'s error path not calling fdput(f).
>
> > > +       return ret;
> > > +}
> > > +
> >
> > [...]
