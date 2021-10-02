Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739CF41FE04
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 22:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhJBU3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 16:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhJBU3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 16:29:09 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB6EC061714
        for <netdev@vger.kernel.org>; Sat,  2 Oct 2021 13:27:23 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id y3so3905354uar.5
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 13:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yBEvAC7tytvPNoNntMpfQQJzo7nKUOYCQrVYj2r104U=;
        b=o9eUq9nuapn89HcZb81sAOQsrhggxsUh3cy6Qnwn86QpjH6U5W31FkeB7KXzzTv332
         fcCXaVelp2BChJQKEQK9M7mS9zM/KWq+LiepW3HoLmxvCLQiUrVf169f1idq5rMWjjxI
         0TdBitShr/NufyNVwnce6KU9x8T8rQ4nHIbxUiR9qFq720MgXUti+7lfYTQa0wBoKDSY
         TdF/hmuEeb51lVjnfVOsq4yn3F0dAnXIVlTvJWpcJBcXYk6YpgSoJP4bVfrXFjMFAZZp
         wL4q+OOfYMLjgHY+KjLZOxfALegLJXV4zFHd6Nfuygv99dWeqIgi7iPZZbUe8cJRKvcx
         0gFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yBEvAC7tytvPNoNntMpfQQJzo7nKUOYCQrVYj2r104U=;
        b=QU5FvXi+PDNw2RwVOElxn72jDxkrY/Pldj1WkZEEI4AuT6tXf3dibAjqdEBQLMJyRX
         /29d+zQ0Oo+RlFzuyUadWHoX2i/jVc7ELWBT36ciw/VUoOxQcOl+bBqG2NYJdFhLLyAn
         WIIWLBsdwxLkZyXy7DHiDKLkcF0MSKm7lIxExgt2K0Fxfk1fs/iZ/jvxXLQ08TK8hdx3
         0mgpoMilqhYPrZiJOsfsgHLMqPGUx5kSCbAbprCah8mYwcCS/us1PjHheqlOEUEnLrfN
         RjbQl+Ekocwz0I3MmKORfHPbN/PepW4vE1vqCsO0UgBzTePVUideQVjdx8L9J9eL/Yg+
         MAJA==
X-Gm-Message-State: AOAM532YWeMMlfIEvPIc3Lw8IXON3RBT+Ju3tZbRHZXBHEJDs2PHx2az
        MVMZyISfcvTNmNymIp1ML+cHcn+jFtx93bW4rQb7Ng==
X-Google-Smtp-Source: ABdhPJzgelWYeQD2lUxqsGxAlCUh1fxLZCc4twOwsrJgQW41zotY5EJqnhtnVCdwjcrWawrJV1D390YSM1ufCIiGKEg=
X-Received: by 2002:ab0:31d6:: with SMTP id e22mr2503667uan.99.1633206442853;
 Sat, 02 Oct 2021 13:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211001110856.14730-1-quentin@isovalent.com> <20211001110856.14730-7-quentin@isovalent.com>
 <CAEf4BzYm_QTq+u5tUp71+wY+JAaiUApv35tSqFUEyc81yOeUzw@mail.gmail.com>
In-Reply-To: <CAEf4BzYm_QTq+u5tUp71+wY+JAaiUApv35tSqFUEyc81yOeUzw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Sat, 2 Oct 2021 21:27:11 +0100
Message-ID: <CACdoK4LL91u-JK1fZ3XvkrTXsKBVsN-y1Js4QSPkWyS51KPB8Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/9] bpf: iterators: install libbpf headers
 when building
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2 Oct 2021 at 00:20, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > API headers from libbpf should not be accessed directly from the
> > library's source directory. Instead, they should be exported with "make
> > install_headers". Let's make sure that bpf/preload/iterators/Makefile
> > installs the headers properly when building.

> >
> > -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> > +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile)            \
> > +          | $(LIBBPF_OUTPUT) $(LIBBPF_INCLUDE)
>
> Would it make sense for libbpf's Makefile to create include and output
> directories on its own? We wouldn't need to have these order-only
> dependencies everywhere, right?

Good point, I'll have a look at it.
Quentin
