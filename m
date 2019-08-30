Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F40FFA3DFE
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 20:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfH3Sx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 14:53:27 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:40407 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbfH3Sx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 14:53:26 -0400
Received: by mail-ua1-f68.google.com with SMTP id s25so2632416uap.7;
        Fri, 30 Aug 2019 11:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xK2myEoST0Vxt1PsxBqflm07dfmYsoiLaH0chIFi/wk=;
        b=BzcdSt1Sf5kVEFD+sgdoHgEY6Da33Ty/2119/8qJWeNvJEs2sD7BW0X6xaecNtkoo8
         2EbbNGDklNxBK7DSC/heugp1WpHeMA6jzRUcgfi665NZxV13EcCerqX3SLqjr/0pBWgM
         EIOjjUOqd9HhovEkURNUsMlr45KPDxlwJaaf6rDQPobH/w2mIUOhUQPQrNZENlIxjDKd
         nY/lsWm8y5mebKb/wUXJp7hdvPTnxiv4IutUIuN/V8BtusXFoDW39y+r3+93hYu6eSMA
         x6uaMQ19dzPs3k4RkvKpeiMtxhBCmEhZFhmJ794lMYCk1eT6ec91Y4UZv1NO4eXbzJVV
         B4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xK2myEoST0Vxt1PsxBqflm07dfmYsoiLaH0chIFi/wk=;
        b=qRBDmAvKEyarsma3g5WpjIvJkvZ59M8Flx1Irzxs9H8+t/mlUvX2yacA6SGYCdFJNG
         rTM1Ys8iFFbWSrIvs3oeXqxZwy5HXolIsKtCo9VZBmKpJXt9bmhTyZvQQEHhIjMoSOz5
         si4XuTMRPrN72nwSwjizuMQczqqz9wDAQ+9xGMb3GSIodhjhKd4/VR2FfNmJLRXHQy47
         P8P1UJi/2gfSUXI+TDR8omkjJDhoH4BWHRNXOihFcp73QmjwbItnEzUBDuMWNmevHfPj
         GLMd9vY9pX3o3Vgq9FL+DLaVFBVqoV8iBm7Jy909oU8CEKRwIF+6lqjfgLhWSZed65iY
         CZWg==
X-Gm-Message-State: APjAAAUuTZ4sfoO0yy7ggQXD4DZjrLgqPfnU/Z+Rj7cJMhtZex7TZjkM
        S7cVRsVVWB5y3QCUqU7h656LdDl14hImgnLnNeE=
X-Google-Smtp-Source: APXvYqx3p0qeEiqpOfcu6rstyvxgdzKrEafJWsPlt9eD9GL04G/JeteD+Fj7gjKTG8QN2+Yt5pl+1s9+SgP2f1fyq1w=
X-Received: by 2002:ab0:630e:: with SMTP id a14mr8575342uap.37.1567191205441;
 Fri, 30 Aug 2019 11:53:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190815000330.12044-1-a.s.protopopov@gmail.com> <796E4DA8-4844-4708-866E-A8AE9477E94E@fb.com>
In-Reply-To: <796E4DA8-4844-4708-866E-A8AE9477E94E@fb.com>
From:   Anton Protopopov <a.s.protopopov@gmail.com>
Date:   Fri, 30 Aug 2019 14:53:14 -0400
Message-ID: <CAGn_itwS=bLf8NGVNbByNx8FmR_JtPWnuEnKO23ig8xnK_GYOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools: libbpf: update extended attributes
 version of bpf_object__open()
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D1=87=D1=82, 29 =D0=B0=D0=B2=D0=B3. 2019 =D0=B3. =D0=B2 16:02, Song Liu <s=
ongliubraving@fb.com>:
>
>
>
> > On Aug 14, 2019, at 5:03 PM, Anton Protopopov <a.s.protopopov@gmail.com=
> wrote:
> >
>
> [...]
>
> >
> >
> > int bpf_object__unload(struct bpf_object *obj)
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index e8f70977d137..634f278578dd 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -63,8 +63,13 @@ LIBBPF_API libbpf_print_fn_t libbpf_set_print(libbpf=
_print_fn_t fn);
> > struct bpf_object;
> >
> > struct bpf_object_open_attr {
> > -     const char *file;
> > +     union {
> > +             const char *file;
> > +             const char *obj_name;
> > +     };
> >       enum bpf_prog_type prog_type;
> > +     void *obj_buf;
> > +     size_t obj_buf_sz;
> > };
>
> I think this would break dynamically linked libbpf. No?

Ah, yes, sure. What is the right way to make changes which break ABI in lib=
bpf?

BTW, does the commit ddc7c3042614 ("libbpf: implement BPF CO-RE offset
relocation algorithm") which adds a new field to the struct
bpf_object_load_attr also break ABI?

>
> Thanks,
> Song
>
