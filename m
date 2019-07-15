Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1AE269A45
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 19:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbfGOR4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 13:56:52 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:49401 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbfGOR4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 13:56:52 -0400
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id x6FHuk49009352;
        Tue, 16 Jul 2019 02:56:47 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com x6FHuk49009352
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1563213407;
        bh=9DNdwAOMrDNMDhRKaR9DRzklJ+6WxesMxATv1pupRXY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EcNZEZAI9Rws1hjnvr2rW+x4gunjiHVPkw6eIpV1JeJv3/M1US0vh157JziyNrTdB
         LRl4f8fObAyYijVUasxdWUPMMS3PiysrZw+oqbas4N09O9O53MYnFbAaTedAjOwIJ6
         7ZntQU4UJMr4qyp/VYhIOlHoEJvbnCTSKQDB+ae2RWIfg3I25ixgFQTK0N6MO9lP9u
         OyO45kbhpkUxozHktKYjzTFyIx3Whqpph5SGxB0GEJQNKV24Mf8JuAq/phkkx8u6xo
         WL0mKiEitoUPdrqgSVNmwyMIogql3qw6DkzPE0LNSDsmz6AQLT5YH0lZIgmEpP0sR1
         qxdLVmCC4v6Bg==
X-Nifty-SrcIP: [209.85.217.51]
Received: by mail-vs1-f51.google.com with SMTP id y16so11994093vsc.3;
        Mon, 15 Jul 2019 10:56:47 -0700 (PDT)
X-Gm-Message-State: APjAAAXzGlfG6/dKR41YHZC9dYklF1ubuKwLnBPoAFk0U8tUR9bh5BNJ
        g50otexA6is0IdWHimXPGgQZe23kRsjZelJAcF8=
X-Google-Smtp-Source: APXvYqzjIu0ZLvWAf2ZU5pOylmcgyKILZfFZ//irLAErTz0kjJcm+rkHjWiOwvjlXfyDX9t3Pi5gvy0kXQ+8Zjk3Koc=
X-Received: by 2002:a67:d46:: with SMTP id 67mr17319200vsn.181.1563213406027;
 Mon, 15 Jul 2019 10:56:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190715144848.4cc41e07@canb.auug.org.au> <ccb5b818-c191-2d9e-311f-b2c79b7f6823@infradead.org>
 <CAF90-WirEMg7arNOTmo+tyJ20rt_zeN=nr0OO6Qk0Ss8J4QrUA@mail.gmail.com> <20190715173341.zth4na7zekjsesaa@salvia>
In-Reply-To: <20190715173341.zth4na7zekjsesaa@salvia>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Tue, 16 Jul 2019 02:56:09 +0900
X-Gmail-Original-Message-ID: <CAK7LNAS0rX_SRXqb=N=Td-DFNWd=PytDFje12gYh2pYNRBVAJA@mail.gmail.com>
Message-ID: <CAK7LNAS0rX_SRXqb=N=Td-DFNWd=PytDFje12gYh2pYNRBVAJA@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 15 (HEADERS_TEST w/ netfilter tables offload)
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Laura Garcia <nevola@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 2:33 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Mon, Jul 15, 2019 at 07:28:04PM +0200, Laura Garcia wrote:
> > CC'ing netfilter.
> >
> > On Mon, Jul 15, 2019 at 6:45 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> > >
> > > On 7/14/19 9:48 PM, Stephen Rothwell wrote:
> > > > Hi all,
> > > >
> > > > Please do not add v5.4 material to your linux-next included branches
> > > > until after v5.3-rc1 has been released.
> > > >
> > > > Changes since 20190712:
> > > >
> > >
> > > Hi,
> > >
> > > I am seeing these build errors from HEADERS_TEST (or KERNEL_HEADERS_TEST)
> > > for include/net/netfilter/nf_tables_offload.h.s:
> > >
> > >   CC      include/net/netfilter/nf_tables_offload.h.s
> [...]
> > > Should this header file not be tested?

This means you must endlessly exclude
headers that include nf_tables.h


> Yes, it should indeed be added.

Adding 'header-test-' is the last resort.


I had already queued a patch:

git clone -b build-test
git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git

commit 9dae5c5fc798e0e970cca4cd1b224dece3ad4766
Author: Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon Jul 15 00:42:56 2019 +0900

    netfilter: nf_tables: split local helpers out to nft_internals.h



If it is OK, I will send it out.



-- 
Best Regards
Masahiro Yamada
