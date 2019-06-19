Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D0C4B099
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 06:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfFSEOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 00:14:54 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:48715 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfFSEOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 00:14:54 -0400
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x5J4EgaU020701;
        Wed, 19 Jun 2019 13:14:43 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x5J4EgaU020701
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1560917683;
        bh=QX44iii4P2UFmWqWLSZMenrivHB0MmnMCrYU3gNIPx4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ch+ctMIkdk25F6gzZwKALUFenoSqbgauELK4ifFnyH4MQ17Sfb9nZL6//0M4Ao3gH
         v7M7zIxrIbrHcespNKYDo/hF2zYmhmWqKQCZ/eHTDpzVmMn1KCMfhm/m+aIK2DzQcK
         gk5S5c+++YAizb9zVCFQaP2zrvt9lyriCY8J16G/PghxGMAR9MyUi6ZoD0FkLNF+jL
         DmiR6d5RCGnSLlusH1zUnHO0pJygaSXvcBPY5OGqoUOkvXZgN5GDS/5/qKH2+S4qbo
         OQDLLxW2YKlRhQbbOqxfbN9JckNCtjq6LJYzP8wfAE7tlI5ZvlTGirSXX1MCwshBU1
         cLXRPqEK8rMsA==
X-Nifty-SrcIP: [209.85.222.46]
Received: by mail-ua1-f46.google.com with SMTP id f20so8409476ual.0;
        Tue, 18 Jun 2019 21:14:43 -0700 (PDT)
X-Gm-Message-State: APjAAAUJ+66aOng1LdDPmd8kiFjCBK2VXhB6zC2sAHqJSOZHNsHFNvOl
        p0mB+8QKTvdbPiQg8s5CpBEK2UcJTM0s/UTnEs8=
X-Google-Smtp-Source: APXvYqxBotwh1SQcA96UGGzZy8r+gUOgx7aQvw27NlrCOkCpgVAmjGEbonICt0MXByl4qSQeU0pO/1xGh5cwGP03Fww=
X-Received: by 2002:a9f:366b:: with SMTP id s40mr37751624uad.121.1560917682204;
 Tue, 18 Jun 2019 21:14:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190619132326.1846345b@canb.auug.org.au> <CAK7LNAQCe0APJ3ggJYRDf_DjYg=dH9+2nNsYoygiFKhTa=givg@mail.gmail.com>
In-Reply-To: <CAK7LNAQCe0APJ3ggJYRDf_DjYg=dH9+2nNsYoygiFKhTa=givg@mail.gmail.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 19 Jun 2019 13:14:06 +0900
X-Gmail-Original-Message-ID: <CAK7LNARVfXySZK_Wzmww=UeFwpWu+vjbctK33zX9KW8w_adexw@mail.gmail.com>
Message-ID: <CAK7LNARVfXySZK_Wzmww=UeFwpWu+vjbctK33zX9KW8w_adexw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 1:02 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> Hi.
>
>
> On Wed, Jun 19, 2019 at 12:23 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Hi all,
> >
> > After merging the net-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >
> > In file included from usr/include/linux/tc_act/tc_ctinfo.hdrtest.c:1:
> > ./usr/include/linux/tc_act/tc_ctinfo.h:30:21: error: implicit declaration of function 'BIT' [-Werror=implicit-function-declaration]
> >   CTINFO_MODE_DSCP = BIT(0),
> >                      ^~~
> > ./usr/include/linux/tc_act/tc_ctinfo.h:30:2: error: enumerator value for 'CTINFO_MODE_DSCP' is not an integer constant
> >   CTINFO_MODE_DSCP = BIT(0),
> >   ^~~~~~~~~~~~~~~~
> > ./usr/include/linux/tc_act/tc_ctinfo.h:32:1: error: enumerator value for 'CTINFO_MODE_CPMARK' is not an integer constant
> >  };
> >  ^
> >
> > Caused by commit
> >
> >   24ec483cec98 ("net: sched: Introduce act_ctinfo action")
> >
> > Presumably exposed by commit
> >
> >   b91976b7c0e3 ("kbuild: compile-test UAPI headers to ensure they are self-contained")
> >
> > from the kbuild tree.
>
>
> My commit correctly blocked the broken UAPI header, Hooray!
>
> People export more and more headers that
> are never able to compile in user-space.
>
> We must block new breakages from coming in.
>
>
> BIT() is not exported to user-space
> since it is not prefixed with underscore.
>
>
> You can use _BITUL() in user-space,
> which is available in include/uapi/linux/const.h
>
>


I just took a look at
include/uapi/linux/tc_act/tc_ctinfo.h


I just wondered why the following can be compiled:

struct tc_ctinfo {
        tc_gen;
};


Then, I found 'tc_gen' is a macro.

#define tc_gen \
        __u32                 index; \
        __u32                 capab; \
        int                   action; \
        int                   refcnt; \
        int                   bindcnt



What a hell.



-- 
Best Regards
Masahiro Yamada
