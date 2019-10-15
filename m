Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2E10D8363
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389259AbfJOWOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:14:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45525 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389222AbfJOWOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:14:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id c21so32991518qtj.12;
        Tue, 15 Oct 2019 15:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z3L/E9vDDIepefnGEF8oIbDF8XRmh6+3ibrNClVVbHk=;
        b=MGaySIx2CzJ8WO59mXVBFtxhR1TJWXPAGxSeWzqLgQGkiGxKVtwWZMQkeN89tmGyJ+
         MJiVbz5Z1/z9UKRmxQsJBUq2L9AlWvWSPVjP+QlE8sb6jmFQexls8vVSK6m3vgJ1xwDK
         A0KqOaVVszS7UMaZ1a0AVepgJZ/kciwsOMLGdHLsJnoc2oY/IBe/NOlOryIIA11W4dua
         pOmdgaoIYsURtuUkZh5W/RfYYpfLh9wCJVFWlM0I63PWBJszEyWsSQJ0GwUz3LCT+cPt
         32m2BqiWVABX/f+THzfA++gc1U279DI9W4SGqeCxtVChveSprXuEGpn2P9ISFEigBMit
         5h8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z3L/E9vDDIepefnGEF8oIbDF8XRmh6+3ibrNClVVbHk=;
        b=JXZ5fuNj1smsWNqnyjhyWDmYtj5ghFABy1OakR/XmXOQdXXlxboOH+SjGI+nayGhni
         2n7rKHKeaemya1YKNhWI1TtyH4+rGV2Fmwp6imztytdqqOiEUUERCYpSFnidBJSKv7N5
         eLtFYUQpLvKQRGNu7pJ2bD6D8Us04egBgBvOAfr1s3PMR5h2BCon1LCx/qRwblH9pxiK
         Ro0mK6KiViduwhLCoxu6VGvmfCbm3ut9cdSWT22ssIucvIs2w+3WMat0c7HljSyByoWx
         h/SQOMXi/ltMxVW+0GcG/9J0aMY4TVk1VDWIAIv8gxYpHY3ehHFpubK8IPUrpNcEj2Qr
         KtQQ==
X-Gm-Message-State: APjAAAW3p9Vu2pOn/6y8yI/6k/KDK/dge/n4ZCL2AbX4JbIcX/QTDzTB
        FQ2h/Bx89gP3YshPGXDK/dviH8BGnhdv5gAD9hM=
X-Google-Smtp-Source: APXvYqzYjXhARO8+fB2927jzQbsSJiuDS16v0MWr4dKUP3fIxW9KMLmz+kVoRpX2TwYSA00GV6hvKC1drFqAxvidEoA=
X-Received: by 2002:a05:6214:5cf:: with SMTP id t15mr39432423qvz.196.1571177693281;
 Tue, 15 Oct 2019 15:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20191011162124.52982-1-sdf@google.com> <CAADnVQLKPLXej_v7ymv3yJakoFLGeQwdZOJ5cZmp7xqOxfebqg@mail.gmail.com>
 <20191012003819.GK2096@mini-arch> <CAADnVQKuysEvFAX54+f0YPJ1+cgcRJbhrpVE7xmvLqu-ADrk+Q@mail.gmail.com>
In-Reply-To: <CAADnVQKuysEvFAX54+f0YPJ1+cgcRJbhrpVE7xmvLqu-ADrk+Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Oct 2019 15:14:42 -0700
Message-ID: <CAEf4BzaKn0ztTCJq7VOsyMfCqqq1HkxXwD6xEYL_3cbYkiPEgg@mail.gmail.com>
Subject: Re: debug annotations for bpf progs. Was: [PATCH bpf-next 1/3] bpf:
 preserve command of the process that loaded the program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 2:22 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Oct 11, 2019 at 5:38 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 10/11, Alexei Starovoitov wrote:
> > > On Fri, Oct 11, 2019 at 9:21 AM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > Even though we have the pointer to user_struct and can recover
> > > > uid of the user who has created the program, it usually contains
> > > > 0 (root) which is not very informative. Let's store the comm of the
> > > > calling process and export it via bpf_prog_info. This should help
> > > > answer the question "which process loaded this particular program".
> > > >
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  include/linux/bpf.h      | 1 +
> > > >  include/uapi/linux/bpf.h | 2 ++
> > > >  kernel/bpf/syscall.c     | 4 ++++
> > > >  3 files changed, 7 insertions(+)
> > > >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index 5b9d22338606..b03ea396afe5 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -421,6 +421,7 @@ struct bpf_prog_aux {
> > > >                 struct work_struct work;
> > > >                 struct rcu_head rcu;
> > > >         };
> > > > +       char created_by_comm[BPF_CREATED_COMM_LEN];
> > > >  };
> > > >
> > > >  struct bpf_array {
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index a65c3b0c6935..4e883ecbba1e 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -326,6 +326,7 @@ enum bpf_attach_type {
> > > >  #define BPF_F_NUMA_NODE                (1U << 2)
> > > >
> > > >  #define BPF_OBJ_NAME_LEN 16U
> > > > +#define BPF_CREATED_COMM_LEN   16U
> > >
> > > Nack.
> > > 16 bytes is going to be useless.
> > > We found it the hard way with prog_name.
> > > If you want to embed additional debug information
> > > please use BTF for that.
> > BTF was my natural choice initially, but then I saw created_by_uid and
> > thought created_by_comm might have a chance :-)
> >
> > To clarify, by BTF you mean creating some unused global variable
> > and use its name as the debugging info? Or there is some better way?
>
> I was thinking about adding new section to .btf.ext with this extra data,
> but global variable is a better idea indeed.
> We'd need to standardize such variables names, so that
> bpftool can parse and print it while doing 'bpftool prog show'.
> We see more and more cases where services use more than
> one program in single .c file to accomplish their goals.
> Tying such debug info (like 'created_by_comm') to each program
> individually isn't quite right.
> In that sense global variables are better, since they cover the
> whole .c file.
> Beyond 'created_by_comm' there are others things that people
> will likely want to know.
> Like which version of llvm was used to compile this .o file.
> Which unix user name compiled it.
> The name of service/daemon that will be using this .o
> and so on.
> May be some standard prefix to such global variables will do?
> Like "bpftool prog show" can scan global data for
> "__annotate_#name" and print both name and string contents ?
> For folks who regularly ssh into servers to debug bpf progs
> that will help a lot.
> May be some annotations llvm can automatically add to .o.
> Thoughts?

We can dedicate separate ELF section for such variables, similar to
license and version today, so that libbpf will know that those
variables are not real variables and shouldn't be used from BPF
program itself. But we can have many of them in single section, unlike
version and license. :) With that, we'll have metadata and list of
variables in BTF (DATASEC + VARs). The only downside - you'll need ELF
itself to get the value of that variable, no? Is that acceptable? Do
we always know where original ELF is?

Alternatively we can have extra .BTF.ext section and re-use BTF's
string section for values.

Which one is more acceptable?
