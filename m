Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B145876BE
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 07:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235665AbiHBFeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 01:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbiHBFea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 01:34:30 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D101419BC;
        Mon,  1 Aug 2022 22:34:29 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w3so576628edc.2;
        Mon, 01 Aug 2022 22:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rGucamRXmWpvRAnvgsamciOXQg9wkA9dp4VkHmKHvYI=;
        b=olTI2BEzULUXF186MZ2ZG7CjzDRYArA/sO5eZ1b1OKwejEIc4dIbecWE5mtVehErCv
         NrmUcYrzFdK0rAh+PlOVuUUAwg0i/29V8u68jTpOsm/xJY4IRuAfLOEuev3wtypeviqp
         TTAjY0hRUolqHLMDKw2jOoBD8xUqJHOXUBjYsEveimW/TjMSuoounSL/k3oat1JenC3g
         u5f3saC2zAL48E7MSmCgMRkrE3CuyiAIs0itlyGHyZ8cktVFCGGj2mhWiSgZayw58nzZ
         7PRpX1Q/HswHyEhuqAVAcafVSazZ7Gv7gSCXR6U8h/3IBF6iDcpLmy8U56l5AelxzNRM
         S1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rGucamRXmWpvRAnvgsamciOXQg9wkA9dp4VkHmKHvYI=;
        b=NmFfHH+s3Ix64qf1fidoLmqAZt8PAhUKrFto2WtXqNyo6Pw9QWKbYibzr46krYUjs/
         YXxjRX/BmwKq7bdrnhXVrtKjVdmph9gGHWEAZzWqOsZ/4RKiUvEL1GdFDJf8/f0DVZlP
         e3f0BCS61EmNJLjuCI2WtDOTqc2vb3mnwnz7YBMBR180KU3SNAJ5iCkx8u8kvdfS294E
         ywMF7urLIqdP/CgnwwWIO7MOsSSppp6iilI4x1d0z4qDJau4iFSyAfpGI3KFvM1EohAO
         pITb7Ny/8FFrIn8b73ozlyq2MxPkJQDyX9Bx4lMyUOctqOlU+L8IPv7JWgjCRCLXVSyc
         liVA==
X-Gm-Message-State: AJIora/vIAhDlZ5z8JoinVR+TKC9E5ES7Nj9JlrKk7AlBgAhGbtOynUz
        eATl1hOiozSi4pfjhaUWWmZ0EDPQLNVejd6V8r7LLy140aU=
X-Google-Smtp-Source: AGRyM1vd7KPXWB1pY/7rkL7DQWDw6VMPzso4fhlFqqCgH4cUZvDyf4fRiDIZX6Pqt/Bza70ze3KeqjAVXPj5nTPZiuI=
X-Received: by 2002:a05:6402:28cb:b0:43b:c6d7:ef92 with SMTP id
 ef11-20020a05640228cb00b0043bc6d7ef92mr19030849edb.333.1659418467860; Mon, 01
 Aug 2022 22:34:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220722180641.2902585-1-paulmck@kernel.org> <20220722180641.2902585-2-paulmck@kernel.org>
 <d452fcee-2d15-c3b0-cc44-6b880ecc4722@iogearbox.net> <20220722212346.GD2860372@paulmck-ThinkPad-P17-Gen-1>
 <Yt6JdYSitC6e2lLk@casper.infradead.org> <20220725164005.GG2860372@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20220725164005.GG2860372@paulmck-ThinkPad-P17-Gen-1>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Aug 2022 22:34:16 -0700
Message-ID: <CAADnVQKcRv5RJh0aLEg4+xsBepf=24nyHtbN2Q1t8dgZ9U1jRQ@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] bpf: Update bpf_design_QA.rst to clarify that
 attaching to functions is not ABI
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 9:40 AM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Mon, Jul 25, 2022 at 01:15:49PM +0100, Matthew Wilcox wrote:
> > On Fri, Jul 22, 2022 at 02:23:46PM -0700, Paul E. McKenney wrote:
> > > On Fri, Jul 22, 2022 at 10:17:57PM +0200, Daniel Borkmann wrote:
> > > > Otherwise I think this could be a bit misunderstood, e.g. most of the networking
> > > > programs (e.g. XDP, tc, sock_addr) have a fixed framework around them where
> > > > attaching programs is part of ABI.
> > >
> > > Excellent point, thank you!
> > >
> > > Apologies for the newbie question, but does BTF_ID() mark a function as
> > > ABI from the viewpoing of a BPF program calling that function, attaching
> > > to that function, or both?  Either way, is it worth mentioning this
> > > in this QA entry?
> >
> > Not necessarily.  For example, __filemap_add_folio has a BTF_ID(), but
> > it is not ABI (it's error injection).
>
> OK, sounds like something to leave out of the QA, then.

Obviously, BTF_ID marking doesn't make the kernel function an abi
in any way. Just like EXPORT_SYMBOL_GPL doesn't do it.
Documentation/bpf/kfuncs.rst already explains it.
Probably worth repeating in the QA part of the doc.
