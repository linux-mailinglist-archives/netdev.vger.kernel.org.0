Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9784D101B
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344490AbiCHGVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344487AbiCHGVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:21:31 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73DA3C72D;
        Mon,  7 Mar 2022 22:20:29 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id s20so6453166iol.2;
        Mon, 07 Mar 2022 22:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=slNttked6kSmpkibNfNvk2KrF/3F8HkN9/c5yiu6Z80=;
        b=KmYJ0E7UvNT7cK+UqG1u4bxG2zK+sjQMo3mxUslTZuEdd3LEj6wNZndNGiMJCPbRj8
         XcieioDep/X6vubmYLJA0Oi3l8CpAp2vPD57Iv52l8W7gXbSEekGvTMesnUDPmnNoZ9T
         wQhqUFwxUQjf1SplbUQXomV0MwwLnj76H0cBKTro6ekz1osd/yNHTzUXK03eDMVVIMdt
         /PbGmPMpW4jxqEskuNOUD1/udNivG+h+JoVpXwFcbUKgJ9xIvCAPFIx3KF+OoPQxi5Yo
         gMRcJyAY484O1nDKva+0Vy9BNbZIvStPk/IKOjokfZ4jQp6sIRvBZejHlt9oehnrWRsD
         qrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=slNttked6kSmpkibNfNvk2KrF/3F8HkN9/c5yiu6Z80=;
        b=SsnZ2z1ue/O82SzuVsFtf12xEbNXtOAz31IGx1xuAejxcExCbeG0N0wWm3OHxlrhZ8
         +hnaQXL433eHVPJKs/MiurNJ1jVTiUugDecTGPtfdq1uvKKDf+2K/u08/x10AKaHJ2KL
         NEtmeZLkNOttRQafQ+D4TFqaIWPXJ6oj6JBvPUzC/K4XrqKq1lsWOl4vAJ9aPXknMJtH
         xVy0eID/mL/OCdRf3URxn5Gxk+ufRzqkGuUW+hqn5JNLMIruLKPkiLzqyRZUYaPfJtYU
         VqLGUSxYO9BUs23aOmfLqWDSh/9bNRnylGgd8bhzc9aYh8zKDm5idU052C6yKdgStugW
         NSaw==
X-Gm-Message-State: AOAM530/TUWtxImFa/ybP+ZFel8CB/vB4gll1TuL3sDiy4iMclaJo6vK
        c7+MkwJ8NKZDHD873RpSsx/W0PD1lbyU+kZHI4Q6Fls3Xus=
X-Google-Smtp-Source: ABdhPJyQy+lHQCqK7ux9w7AptUsSJ4i2EVy36HpWmdZ3VtiFwXFWr/LcggwQgr48RL9ooAb1EmeOew8A4TRiKtivXfU=
X-Received: by 2002:a02:a08c:0:b0:314:ede5:1461 with SMTP id
 g12-20020a02a08c000000b00314ede51461mr14506661jah.103.1646720429341; Mon, 07
 Mar 2022 22:20:29 -0800 (PST)
MIME-Version: 1.0
References: <20220305161013.361646-1-ytcoode@gmail.com> <56b9dab5-6a3d-58ff-69c9-7abaabf41d05@isovalent.com>
In-Reply-To: <56b9dab5-6a3d-58ff-69c9-7abaabf41d05@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 22:20:18 -0800
Message-ID: <CAEf4Bzb0_Tgmpu2c1a1WXZ8vcwu9OuXttWKZyFpNsnCEqkXygg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Remove redundant slash
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Yuntao Wang <ytcoode@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 7, 2022 at 9:06 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-03-06 00:10 UTC+0800 ~ Yuntao Wang <ytcoode@gmail.com>
> > The trailing slash of LIBBPF_SRCS is redundant, remove it.
> >
> > Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> > ---
> >  kernel/bpf/preload/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
> > index 167534e3b0b4..7b62b3e2bf6d 100644
> > --- a/kernel/bpf/preload/Makefile
> > +++ b/kernel/bpf/preload/Makefile
> > @@ -1,6 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >
> > -LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
> > +LIBBPF_SRCS = $(srctree)/tools/lib/bpf
> >  LIBBPF_INCLUDE = $(LIBBPF_SRCS)/..
> >
> >  obj-$(CONFIG_BPF_PRELOAD_UMD) += bpf_preload.o
>
> Looks good to me, but we could maybe just as well get rid of LIBBPF_SRCS
> in this file?:
>
>         LIBBPF_INCLUDE = $(srctree)/tools/lib

yep, I inlined this and ended up with just

LIBBPF_INCLUDE = $(srctree)/tools/lib

Applied to bpf-next, thanks.

>
> Quentin
