Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14ED32A8DBB
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 04:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgKFDs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 22:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKFDs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 22:48:59 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8B8C0613CF;
        Thu,  5 Nov 2020 19:48:59 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id f6so3319326ybr.0;
        Thu, 05 Nov 2020 19:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZ45rvP8wup8PY3/tIl9Kg0r32ehp33pZjMKLY62c5I=;
        b=AMtGFbOGJsW7sBvljfwu8L3ynwu4hkFJUujeThMpr+alF/5zE2zztmETreJwQvS3W/
         GgAfpxtbaxxzIB0DLimJt3+++r5A1RQRxjP1/3cEpZBP5ePrRnHBRHvH/D39Gi4EZBVw
         FGNYypwdt2e48D/eTVeVyxfrOs2CqNZpl4+NbgWvqbhTtgjNAjcxkMqzUplR5tPFX4Oq
         +04rSA2bObje/vCYE+qRzd824B3D1R1mYHOfhBWyezhIMTk+HsiE7OjlySb4o0YI19iO
         PENLcmmFrxbg6D4BOhQL86uFvLuqnfINJTLAT92bsRZFosdUf/ggG6But+K2pErMhusf
         ABLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZ45rvP8wup8PY3/tIl9Kg0r32ehp33pZjMKLY62c5I=;
        b=fEpZSx/mlCNY+JRqx1tjV8iWsKQj7PuIvLH4alWkbz5bvnSXfbYQ76MLijbURgAInE
         44QNDdvDVGUcqLJh4o+e+1J7cf7PwXcZ9S616pO5JO8ybTzoaIOfbJ0iLHM15VWd/zmS
         SGHdQ0O+Gcmq2BgUxSNH3NPEJlZNe9LV4SCATdBfr6MgjaUt77XfVcLaQabld4fUxf+N
         wn55usrxLUAcBKzxJvAk7yoTX7psriajN5Xak+/QJpXwLjnGO83szPynM8T6N74oY0ry
         lW++kZep5UUtoo2Jia7XBrWMRqtO9hxF31BDxSNKaoMH3mMoqyFDyhbn5lPoTmiyrx5D
         lSDQ==
X-Gm-Message-State: AOAM530xzR8uVJy5rSkymurk8CqZtL5cL0SeESmGW42tnsTky9OYPojw
        o2V5bzhjncNTohRSnthUvpMrBGJrI8vDAvlyR4k=
X-Google-Smtp-Source: ABdhPJySqMago37h3P1cr98LDDRN/nIqAYpALz/6LDfrXCrK/KftMR3roYl7ac2qKJDvHy62bK8gJDYAWLtZMMP3SoA=
X-Received: by 2002:a05:6902:72e:: with SMTP id l14mr244888ybt.230.1604634538723;
 Thu, 05 Nov 2020 19:48:58 -0800 (PST)
MIME-Version: 1.0
References: <20201105045140.2589346-1-andrii@kernel.org> <20201105045140.2589346-4-andrii@kernel.org>
 <20201106031336.b2cufwpncvft2hs7@ast-mbp>
In-Reply-To: <20201106031336.b2cufwpncvft2hs7@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 19:48:47 -0800
Message-ID: <CAEf4BzbRqmKL3=q+GB=7JvWNxEaOz4CVAcbLQKBxoHF-Gfpv=g@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/5] kbuild: Add CONFIG_DEBUG_INFO_BTF_MODULES
 option or module BTFs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 7:13 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Nov 04, 2020 at 08:51:38PM -0800, Andrii Nakryiko wrote:
> >
> > +config DEBUG_INFO_BTF_MODULES
> > +     bool "Generate BTF for kernel modules"
> > +     def_bool y
> > +     depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
>
> Does it need to be a new config ?
> Can the build ran pahole if DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF ?

It probably doesn't. If I drop the "bool" line, it will become
non-configurable calculated Kconfig value, convenient to use
everywhere. All the rest will stay exactly the same. It's nice to not
have to do "if defined(DEBUG_INFO_BTF) && defined(MODULES) &&
defined(PAHOLE_HAS_SPLIT_BTF)" checks, but rather a simple "ifdef
CONFIG_DEBUG_INFO_BTF_MODULES". Does that work?
