Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 772E2134A9
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 23:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfECVJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 17:09:58 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38798 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfECVJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 17:09:58 -0400
Received: by mail-io1-f68.google.com with SMTP id y6so6372775ior.5;
        Fri, 03 May 2019 14:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FFvu2hGcxe/+DtTskUt1uJvdyNp6xgeIDKpoYUBCG+A=;
        b=aT6r+o53RAJ9wXcexu5sg00LtkFUbbYH2e9QnYRGIaqhEMY2xL/JBEw/d/oFg89Qry
         NvwAHd3P2jxPUu9uDhAWKJMDOiWhEEw5V2ieb2j1Z764c5uiiMnG36uyg0gE3DIDg5y9
         JTwc8cV3jJ6SUsrZ2OlKEFlLCi1DCPoWxfNLTWklcnsFQMAqhsqRItyJZOWOAy1ojMgT
         N0/cmiQyT1fLqvATHEC+DiY4Y7GYzhxd28et8DycxSvzYiRT9m2TXoHO+reEBiLwikQU
         cMlyPYwiyLkQl0wDoaf/M3vTd/CLIZXUV4V0pfHvAEv7E3UhEMO63sh8u4/z3zwPyoy6
         JI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FFvu2hGcxe/+DtTskUt1uJvdyNp6xgeIDKpoYUBCG+A=;
        b=s/fQamRx0nfUblB89a0XAkKyfiVFaN0JCEelr1hhiV08QwXEHzqlqM1tEFq9jrf3Ot
         EmgGJSKmF7kxbDjJzn/PR3n0zqfJY+h0Zs0Y5zPsj9Uye8AwIHUAxrkakT/L716DNMVP
         kHkLMdvacRvJehlG91KWjEGwd8IQO1uIQfX3lG34wbWeKLsYrUVxitIwRc4Pz+3JokDC
         i8D9r+agW1LYACbKOTdWMxNzTPjGe8hKDrU8oT6CoODhkdh9E9OM4jlAhrjgg7fnOz0j
         hxtC6RefiGLER0DpcpT/QN0snJF8i3mgvf3tt8XRuw2Ul84YHH3SxxAdbLdJoBN6AEWC
         PGbg==
X-Gm-Message-State: APjAAAXfo2l9z8CR3BbNb/O1dYqK+JDzpMdqPnVP7el7KU5xAJBwStNm
        StTLdJKuAmrJvv1+kJ4SueWpF3Y5rlHQNgwzQMY=
X-Google-Smtp-Source: APXvYqxnEoaH5roxRhlXN7VA0NNt+QKcUdhjHAG9RSypT7YzuEsZf/f+3vPm62XGoj97b3LUDaUcgHFeUbYPKNWs+Bo=
X-Received: by 2002:a6b:7714:: with SMTP id n20mr759438iom.89.1556917797589;
 Fri, 03 May 2019 14:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <1556822018-75282-1-git-send-email-u9012063@gmail.com>
 <CAH3MdRVLVugbJbD4_u2bYjqitC4xFL_j8GoHUTBN77Tm9Dy3Ew@mail.gmail.com> <CALDO+SZtusQ3Zw4jT6BEgGV7poiwSwZDuhghO+6y53RBA0Mg1A@mail.gmail.com>
In-Reply-To: <CALDO+SZtusQ3Zw4jT6BEgGV7poiwSwZDuhghO+6y53RBA0Mg1A@mail.gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Fri, 3 May 2019 14:09:21 -0700
Message-ID: <CAH3MdRX2KVqC4NRyeSVgY4mxRD6X6EzVB-_h_rp_Dv6LMJe67g@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: add libbpf_util.h to header install.
To:     William Tu <u9012063@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Ben Pfaff <blp@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 3, 2019 at 12:54 PM William Tu <u9012063@gmail.com> wrote:
>
> On Thu, May 2, 2019 at 1:18 PM Y Song <ys114321@gmail.com> wrote:
> >
> > On Thu, May 2, 2019 at 11:34 AM William Tu <u9012063@gmail.com> wrote:
> > >
> > > The libbpf_util.h is used by xsk.h, so add it to
> > > the install headers.
> >
> > Can we try to change code a little bit to avoid exposing libbpf_util.h?
> > Originally libbpf_util.h is considered as libbpf internal.
> > I am not strongly against this patch. But would really like to see
> > whether we have an alternative not exposing libbpf_util.h.
> >
>
> The commit b7e3a28019c92ff ("libbpf: remove dependency on barrier.h in xsk.h")
> adds the dependency of libbpf_util.h to xsk.h.
> How about we move the libbpf_smp_* into the xsk.h, since they are
> used only by xsk.h.

Okay. Looks like the libbpf_smp_* is used in some static inline functions
which are also API functions.

Probably having libbpf_smp_* in libbpf_util.h is a better choice as these
primitives can be used by other .c files in tools/lib/bpf.

On the other hand, exposing macros pr_warning(), pr_info() and
pr_debug() may not
be a bad thing as user can use them with the same debug level used by
libbpf itself.

Ack your original patch:
Acked-by: Yonghong Song <yhs@fb.com>

>
> Regards,
> William
>
> > >
> > > Reported-by: Ben Pfaff <blp@ovn.org>
> > > Signed-off-by: William Tu <u9012063@gmail.com>
> > > ---
> > >  tools/lib/bpf/Makefile | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > > index c6c06bc6683c..f91639bf5650 100644
> > > --- a/tools/lib/bpf/Makefile
> > > +++ b/tools/lib/bpf/Makefile
> > > @@ -230,6 +230,7 @@ install_headers:
> > >                 $(call do_install,bpf.h,$(prefix)/include/bpf,644); \
> > >                 $(call do_install,libbpf.h,$(prefix)/include/bpf,644); \
> > >                 $(call do_install,btf.h,$(prefix)/include/bpf,644); \
> > > +               $(call do_install,libbpf_util.h,$(prefix)/include/bpf,644); \
> > >                 $(call do_install,xsk.h,$(prefix)/include/bpf,644);
> > >
> > >  install_pkgconfig: $(PC_FILE)
> > > --
> > > 2.7.4
> > >
