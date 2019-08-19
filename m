Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCCD9279C
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfHSOx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:53:27 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:19519 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfHSOx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:53:26 -0400
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x7JErLqi016770;
        Mon, 19 Aug 2019 23:53:22 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x7JErLqi016770
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1566226402;
        bh=jEu8aQX5I9UhJUPk3G8xxRC1ppfr3n6cyqKi0hQLb9M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u2azZPVEkmdrMqZ+df69ql2NhVZyk/amJ8yBXhENizaAp7xZAlwavoKDWOUy64j5X
         7Ol5pixAPNmMxYYFLzlRplB7MdnCh1T7QhKVx62aPwdeIsVDKdfNpW9supx5zMCsEt
         SaZE9kjWOM3HaxpfT/Tjfzj8a0B6pHALrxyJEqtPtQYSuinBcPnd+SRCVx0gLL77Yo
         SAq3f7SR+ydz/LFVfYmBs/dYk2pNe2uuozGeU/sEjXMfzTJSW/dsClcBq8p+fEgO8K
         nxbIlZHiK6Q2r7cNuV8P+KDiCAXJVZHA62HMjPNYoFDuponNDjABakVzHiiHm4y9vu
         bcKgYN7U7z1gw==
X-Nifty-SrcIP: [209.85.217.41]
Received: by mail-vs1-f41.google.com with SMTP id s5so1346835vsi.10;
        Mon, 19 Aug 2019 07:53:21 -0700 (PDT)
X-Gm-Message-State: APjAAAW6ogC0F+hwrrzceXjqVpfmQHKqoDDimGcl07AZaFM1ZpIZqTyn
        prgot42kSND7z0woze247/en3gJaunzUA1BLJto=
X-Google-Smtp-Source: APXvYqxgEC2VFMiHOd7G3mWTc+2xaLAjkP+fEtaPJ3YQKpAGfGzDTP2YAySEwmJ0lzP+zfuCSunuNfSxssKJkMtKdPw=
X-Received: by 2002:a67:8a83:: with SMTP id m125mr14427234vsd.181.1566226400699;
 Mon, 19 Aug 2019 07:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190810155307.29322-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190810155307.29322-1-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon, 19 Aug 2019 23:52:44 +0900
X-Gmail-Original-Message-ID: <CAK7LNATkeM=w2rymdvaqBuVYfRb9=US+FzVqGS6Hr81h5RAbWA@mail.gmail.com>
Message-ID: <CAK7LNATkeM=w2rymdvaqBuVYfRb9=US+FzVqGS6Hr81h5RAbWA@mail.gmail.com>
Subject: Re: [PATCH 00/11] kbuild: clean-ups and improvement of single targets
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Sam Ravnborg <sam@ravnborg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Leon Romanovsky <leon@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 12:55 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
>
> 01/11-09/11 are trivial clean-ups.
>
> 10/11 makes the single targets work more correctly.
>
> 11/11 cleans up Makefiles that have been added
> to work aroud the single target issues.
>
>
>
> Masahiro Yamada (11):
>   kbuild: move the Module.symvers check for external module build
>   kbuild: refactor part-of-module more
>   kbuild: fix modkern_aflags implementation
>   kbuild: remove 'make /' support
>   kbuild: remove meaningless 'targets' in ./Kbuild
>   kbuild: do not descend to ./Kbuild when cleaning
>   kbuild: unset variables in top Makefile instead of setting 0
>   kbuild: unify vmlinux-dirs and module-dirs rules
>   kbuild: unify clean-dirs rule for in-kernel and external module
>   kbuild: make single targets work more correctly
>   treewide: remove dummy Makefiles for single targets


Patch 01-09 applied.

10-11 have been superseded.



-- 
Best Regards
Masahiro Yamada
