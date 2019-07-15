Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72BD7699B3
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 19:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731648AbfGOR2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 13:28:18 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44353 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731244AbfGOR2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 13:28:18 -0400
Received: by mail-ot1-f65.google.com with SMTP id b7so17813593otl.11;
        Mon, 15 Jul 2019 10:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HnnOnZBQP1Cav/Lz0tbA/DG3A9QQlkvslSRS75Fhsp8=;
        b=OhdNkyY8F0PXWv8P8vpcWJ1/uZjniPOJJO12nWFstF1crz+Go6ZWpzhmhsqGqgMI7H
         GBbRrLzsr1K6JootoUSnz9ALtYvHGWNc1uDqSbOxj+XzbsoSBaxRXnC7oohtIZ+eUMtL
         sxTrX0lHSd1txyA4gVJe+lZs9Mbre+AfuUDBdxda7/DnqrYb/eFP8T33gVIlTVuC/g3D
         r1MdgWrUJ0UB2HC3dCENzq+hBIzWWrmAIpAxbECVS7OVCMCbp4A/8SSSKy8xgd+UD7qH
         5ygpFKVYzehTLvfJr5dxc8mEdmeuJy7eWQHqyPG+swLpm2FS9YyE2YXfpLgRmcD/cyYW
         zkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HnnOnZBQP1Cav/Lz0tbA/DG3A9QQlkvslSRS75Fhsp8=;
        b=cjTS9V4HD+EscteRgcM9WkK7AQIfFNA38xgodD1vaJ149vS1BM3m7AxuLudKrFB5f7
         OR71Il+ckHdzqPGi2vMWz3EdMYrIIkaXRiXOLGNWe2yNFfM4RWxrZNt8/mHvNQdcuxXG
         PA1VIyMb2BpT8lRcSardRerycqyfWCQix7pBSheD+zi0HgSC2StQ2sLv66oXcIp9IByl
         05N1woo/ziKqq5odH6akll501kNsWxyW7et3KHmHqxICNzFuYV85fgfGqrndZEw2+ktk
         cnAP5ZdZEkwA1R5n5gtW7rhHc5SewB/+Lu+BMoWs1Z6t5Eti1E1cFLS9RHDK4Tarodxa
         HHMA==
X-Gm-Message-State: APjAAAX+7hoPo/1AGXHuKTmTFZulTu2Z0YBcbJ19xi+pZ+VKaKoEeKTz
        p7qc45hpi6OsBoWtvwTuzewQNvOJcGI8XrYUW50kBA==
X-Google-Smtp-Source: APXvYqw8ll09WKFXUcoLvj+kqijbMcBE40SbDOOHBrCFaNGDKzQpjnlCkR0xQKyZyyMOqdqLLBFmiPBnH4g0HsOcTa0=
X-Received: by 2002:a9d:222c:: with SMTP id o41mr21287254ota.278.1563211695910;
 Mon, 15 Jul 2019 10:28:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190715144848.4cc41e07@canb.auug.org.au> <ccb5b818-c191-2d9e-311f-b2c79b7f6823@infradead.org>
In-Reply-To: <ccb5b818-c191-2d9e-311f-b2c79b7f6823@infradead.org>
From:   Laura Garcia <nevola@gmail.com>
Date:   Mon, 15 Jul 2019 19:28:04 +0200
Message-ID: <CAF90-WirEMg7arNOTmo+tyJ20rt_zeN=nr0OO6Qk0Ss8J4QrUA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 15 (HEADERS_TEST w/ netfilter tables offload)
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'ing netfilter.

On Mon, Jul 15, 2019 at 6:45 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 7/14/19 9:48 PM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Please do not add v5.4 material to your linux-next included branches
> > until after v5.3-rc1 has been released.
> >
> > Changes since 20190712:
> >
>
> Hi,
>
> I am seeing these build errors from HEADERS_TEST (or KERNEL_HEADERS_TEST)
> for include/net/netfilter/nf_tables_offload.h.s:
>
>   CC      include/net/netfilter/nf_tables_offload.h.s
> In file included from ./../include/net/netfilter/nf_tables_offload.h:5:0,
>                  from <command-line>:0:
> ../include/net/netfilter/nf_tables.h: In function =E2=80=98nft_gencursor_=
next=E2=80=99:
> ../include/net/netfilter/nf_tables.h:1223:14: error: =E2=80=98const struc=
t net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
>   return net->nft.gencursor + 1 =3D=3D 1 ? 1 : 0;
>               ^~~
>               nf
> In file included from ../include/linux/kernel.h:11:0,
>                  from ../include/net/flow_offload.h:4,
>                  from ./../include/net/netfilter/nf_tables_offload.h:4,
>                  from <command-line>:0:
> ../include/net/netfilter/nf_tables.h: In function =E2=80=98nft_genmask_cu=
r=E2=80=99:
> ../include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struc=
t net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
>   return 1 << READ_ONCE(net->nft.gencursor);
>                              ^
> ../include/linux/compiler.h:261:17: note: in definition of macro =E2=80=
=98__READ_ONCE=E2=80=99
>   union { typeof(x) __val; char __c[1]; } __u;   \
>                  ^
> ../include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro=
 =E2=80=98READ_ONCE=E2=80=99
>   return 1 << READ_ONCE(net->nft.gencursor);
>               ^~~~~~~~~
> ../include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struc=
t net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
>   return 1 << READ_ONCE(net->nft.gencursor);
>                              ^
> ../include/linux/compiler.h:263:22: note: in definition of macro =E2=80=
=98__READ_ONCE=E2=80=99
>    __read_once_size(&(x), __u.__c, sizeof(x));  \
>                       ^
> ../include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro=
 =E2=80=98READ_ONCE=E2=80=99
>   return 1 << READ_ONCE(net->nft.gencursor);
>               ^~~~~~~~~
> ../include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struc=
t net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
>   return 1 << READ_ONCE(net->nft.gencursor);
>                              ^
> ../include/linux/compiler.h:263:42: note: in definition of macro =E2=80=
=98__READ_ONCE=E2=80=99
>    __read_once_size(&(x), __u.__c, sizeof(x));  \
>                                           ^
> ../include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro=
 =E2=80=98READ_ONCE=E2=80=99
>   return 1 << READ_ONCE(net->nft.gencursor);
>               ^~~~~~~~~
> ../include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struc=
t net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
>   return 1 << READ_ONCE(net->nft.gencursor);
>                              ^
> ../include/linux/compiler.h:265:30: note: in definition of macro =E2=80=
=98__READ_ONCE=E2=80=99
>    __read_once_size_nocheck(&(x), __u.__c, sizeof(x)); \
>                               ^
> ../include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro=
 =E2=80=98READ_ONCE=E2=80=99
>   return 1 << READ_ONCE(net->nft.gencursor);
>               ^~~~~~~~~
> ../include/net/netfilter/nf_tables.h:1234:29: error: =E2=80=98const struc=
t net=E2=80=99 has no member named =E2=80=98nft=E2=80=99; did you mean =E2=
=80=98nf=E2=80=99?
>   return 1 << READ_ONCE(net->nft.gencursor);
>                              ^
> ../include/linux/compiler.h:265:50: note: in definition of macro =E2=80=
=98__READ_ONCE=E2=80=99
>    __read_once_size_nocheck(&(x), __u.__c, sizeof(x)); \
>                                                   ^
> ../include/net/netfilter/nf_tables.h:1234:14: note: in expansion of macro=
 =E2=80=98READ_ONCE=E2=80=99
>   return 1 << READ_ONCE(net->nft.gencursor);
>               ^~~~~~~~~
> make[2]: *** [../scripts/Makefile.build:304: include/net/netfilter/nf_tab=
les_offload.h.s] Error 1
>
>
> Should this header file not be tested?
>
> thanks.
> --
> ~Randy
