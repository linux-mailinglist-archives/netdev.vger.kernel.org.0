Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F921B5F23
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgDWP22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:28:28 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:33431 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgDWP21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:28:27 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MXH3e-1jiiIB0GPm-00YlvZ; Thu, 23 Apr 2020 17:28:25 +0200
Received: by mail-lj1-f179.google.com with SMTP id j3so6626065ljg.8;
        Thu, 23 Apr 2020 08:28:24 -0700 (PDT)
X-Gm-Message-State: AGi0PuZUU0SgLRsgYacVk2JXjaYAMeu6r00aDjYVvoGo1i9IfilFXY8n
        sO8fqQ4igkpA/IZdFn8cizzTV+CGcQgbKAQe6Qw=
X-Google-Smtp-Source: APiQypINcNdjhLpMjI8cph0tTGcFMHFZDQLmojF6lZ/7qKWwhCKDNWXB8vz+MSiiUAkbnxZQLkqoMfC3KKw5YDYcM+w=
X-Received: by 2002:a2e:6a08:: with SMTP id f8mr2858238ljc.8.1587655704471;
 Thu, 23 Apr 2020 08:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com>
 <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr> <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com>
 <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr> <871rofdhtg.fsf@intel.com>
 <nycvar.YSQ.7.76.2004221649480.2671@knanqh.ubzr> <940d3add-4d12-56ed-617a-8b3bf8ef3a0f@infradead.org>
 <nycvar.YSQ.7.76.2004231059170.2671@knanqh.ubzr> <20200423150556.GZ26002@ziepe.ca>
 <nycvar.YSQ.7.76.2004231109500.2671@knanqh.ubzr> <20200423151624.GA26002@ziepe.ca>
In-Reply-To: <20200423151624.GA26002@ziepe.ca>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 23 Apr 2020 17:28:08 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0ydfp79Us-WhwwHOB2MGgtj=ovfYa_g8qhazA4gmv8eg@mail.gmail.com>
Message-ID: <CAK8P3a0ydfp79Us-WhwwHOB2MGgtj=ovfYa_g8qhazA4gmv8eg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Nicolas Pitre <nico@fluxnic.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "leon@kernel.org" <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:2iQTX2VsakGHk54BTB9WVoqR/JzU2kdpHG5qlk7OzErzbDjBSFJ
 cw4+bPaHDdKsw3pJ2bgD5MLFptdhCXGqhbySx9hQn24n/AWHnU+wNuuNihTQrmvZZ4B/Pt+
 AWOp/GpqTWV+iiRpnOyNcvnyxixueiY7CyokX7afxwIn3Oo659/VkB51cMdLTfUJsSsU/2q
 DEUtJ0DJw15QT/HVKXuDA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:yXYeGGUUVu4=:KOVIF5il65qxHEA6pI+gSc
 aAfwOmhprWnuOPz+7W+rziPQkbN0ejmKpA4BZqkwFCnaDPPv7pDgfS3i5nu1MHtQqUHYLQCG8
 /0/DYe+pZDRflErTRstkLc/IRW6TS+/l/iyKITt18tPZnbzW/jegLplN2RzgUawwvLkWtfsSx
 mBZ5tDr4b2JwBPF9NuSmg0xXGO8Z1SRzrpsQEsCduQOpduc9DKk/I6ccsitsv6ARTH1ep4Gm5
 PvSruZGSuG8hiDOrcOg8YLEhGjymwtvh46Og2gaoJ5pgWaJuMI1hUmi73TAijEyKklEMK4uQv
 uDS3kvyT9NMDg4BCjl7w62Xeox4SgGhYWn2EPcebRaDpt2bup9zhTIkBunkTJPNjvgLhoc5TQ
 j/uKFI4UpYjPkea32bJHAifAmObWP8ih2wSfQOvPXd+wybbLdkT6KPOCHbNrSwXDTq3HhPpq3
 E0rqwicYUJmeGJXz+X5opr7Nq1Es7a1wFdoCSIoYaNczaTzaWFoEb3k+Ock7t94wG9cqgvLJb
 rtKzCn+CLRWE5O0an+1PLcyrYMQivB8BvJnh6PbBUkeNn9aYNrLLsDc4IA9I71NgqYFLmZ04j
 WZspW8jH2Jj/fCdMO8BeWLSeeKlvDuNmslBxld9UBF1+6u6fQe2cpnNG9ML+LG1cCVDeQAwGo
 cNFoheYAQWKdFlfDfBGmZX85lY+R5FqbwyoXKKBMiPvBIX3uERVe/KQOoRTuJxZ+C9keneMli
 qAgmg8+fmD19nRdG2zAS3M8tk/7b+xVM3Cp7pJJvbfr6f3nwjSrzf+eeXSlq6D/B71YcgPJJJ
 MMtB/aDDv0NNGi9TzKBToxRdsVO8sFxz0P65s1gRPBNm6MAcKs=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 5:16 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Thu, Apr 23, 2020 at 11:11:46AM -0400, Nicolas Pitre wrote:

> > > > I don't see how that one can be helped. The MTD dependency is not
> > > > optional.
> > >
> > > Could it be done as
> > >
> > > config MTD
> > >    depends on CRAMFS if CRAMFS_MTD
> > >
> > > ?
> >
> > No. There is no logic in restricting MTD usage based on CRAMFS or
> > CRAMFS_MTD.
>
> Ah, I got it backwards, maybe this:
>
> config CRAMFS
>    depends on MTD if CRAMFS_MTD

I'm not sure this can work if you also have the requirement that 'CRAMFS_MTD
depends on CRAMFS': dependencies in Kconfig generally cannot have
loops in them.

       Arnd
