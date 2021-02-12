Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5531A5B0
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhBLT5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhBLT5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 14:57:22 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2679BC061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 11:56:42 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id r77so725486qka.12
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 11:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IXt5ciLrUUvEJH/4xof0aDAc/KZXvWIDjL5YLY99kQ0=;
        b=KMj8hrmoG132nTe23ssqEg1452k6K/K0PMlD1X/nBmeD2PQSoLAeHYryW6uYav+tal
         ovrvvt5rRtu7TcQSDbtzSnxcSiE/HxudrS6IblkgLFRCNi/4WEILXNL15JIcXGj4WW3q
         QgQ9KqBpB4482Y6qtCA3TwdBg6ApxsPY1R7JJqP2wJNH3DnucFsKuVwOQhxZZs2dJxR7
         56bacOnKEBJZ0J4QGckpMTW9tPebLtl/SvizUncXydPJVqwNgWXCvTUd6WHf0k3h/TDw
         hwB49jHSGM5FAN+iLtlmyzeGEK3S770r7bOdvnqx6ty22v9vIkeFDvems9D3cqM1Ha9m
         atwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IXt5ciLrUUvEJH/4xof0aDAc/KZXvWIDjL5YLY99kQ0=;
        b=GHTE0NbZMN5qnIhvoW2iyomkdacfmIsQ6Mp/acDQnzGmKX78/ujiR+R79yFCRRLQc8
         jwgG+49SXMp8ESH5kBUOHiRPKXVE3I1UWsXAI2X1nzn2Iq7tLMgjoAkRRueE4vs7xfad
         5+LzO51j0oIYlwNNt0hbOG5A/Hx3TAciJ4dt9xxZ8R4yxMYhcv0gbsuLIv+AsqQdnp9S
         yo9fXUBlsOzlLL7/JBVhXWOlQ3cLDfk8qvLWFesLj7n1kTWyODP0YdwLi7h4Y50DDG/T
         EQASdo1u3Ys9volWg12UsedClK6oYKmufRr1xbZpp2JA5XLoUk+zzaUSgXSZDQeY2LOb
         QCXQ==
X-Gm-Message-State: AOAM532xJK0cLrdnR616eDvvl65llMNq0XWNnntw2/9ngbQMqih2UGtf
        LTIkeBmKpxVnHGC/Udm2TXPwvOI9okj/HZS7FAyCQ1rlWdO9fw==
X-Google-Smtp-Source: ABdhPJxBZRarA5VB1ZMFowGx8zq2TZPO2J+oxPmzF2a07WrwVq6H2BZSBDxUx2ZaQN05CvfB3DwEgq1b0+lOBudO1Ww=
X-Received: by 2002:a37:381:: with SMTP id 123mr2866543qkd.448.1613159800967;
 Fri, 12 Feb 2021 11:56:40 -0800 (PST)
MIME-Version: 1.0
References: <20210212010053.668700-1-sdf@google.com> <CAEf4BzZ60LNPpWL6z566hCCF1JkJC=-nZpqg7JQGaHp0rJYGhg@mail.gmail.com>
In-Reply-To: <CAEf4BzZ60LNPpWL6z566hCCF1JkJC=-nZpqg7JQGaHp0rJYGhg@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 12 Feb 2021 11:56:29 -0800
Message-ID: <CAKH8qBuRvmW6wyGR4_8xRNY9Bhm-eMN-duKGp14X8ejk1gvsDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: add /libbpf to .gitignore
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, jolsa@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 11:48 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Feb 11, 2021 at 5:07 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > There is what I see after compiling the kernel:
>
> typo: This?
Yes, sure.


> >  # bpf-next...bpf-next/master
> >  ?? tools/bpf/resolve_btfids/libbpf/
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
>
> Jiri,
>
> Is this
>
> Fixes: fc6b48f692f8 ("tools/resolve_btfids: Build libbpf and libsubcmd
> in separate directories")
>
> ?
>
> Do we need similar stuff for libsubcmd (what's that, btw?)
It's probably not needed because it has only .o files in there (.o are
ignored in the root .gitignore).
I assume libbpf/ has an issue because there is bpf_helper_defs.h in
that libbpf/ directory.
Not sure why it was removed in fc6b48f692f8 rather than being prefixed
with libbpf/ directory.
I'll leave it up to Jiri to comment.


> >  tools/bpf/resolve_btfids/.gitignore | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
> > index 25f308c933cc..16913fffc985 100644
> > --- a/tools/bpf/resolve_btfids/.gitignore
> > +++ b/tools/bpf/resolve_btfids/.gitignore
> > @@ -1,2 +1,3 @@
> >  /fixdep
> >  /resolve_btfids
> > +/libbpf/
> > --
> > 2.30.0.478.g8a0d178c01-goog
> >
