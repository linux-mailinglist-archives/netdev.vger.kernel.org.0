Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EF3486077
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 07:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbiAFGCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 01:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiAFGCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 01:02:48 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3268C061245;
        Wed,  5 Jan 2022 22:02:47 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id g80so4680033ybf.0;
        Wed, 05 Jan 2022 22:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nS2yMVkGz+ps+zT6am8AF/1mxQGXi0VAWBoJudmXHPc=;
        b=HPhlvhwnoZsWjZ39b/M1Qkh2gF/e9cUKF7B/ThBVMIFie1XWAteoYg6OLDih9uZbWl
         bq5ozFyoBIUS4xvLmhqVB43gNd56C9JME8hfNh/Y17bifPQ7W1zeisEKpI3BjzJIZrxC
         TLAG5kbT13DU5uH5nJin6FGECvFm+AGSmR7i5uM/45J5LOKa6T9gnp2g7l2Knd89Gmij
         2GA8FnsNd4/mKGqr1Jy5L1faMdNyE7QFZy8BdSWSVAcD3XLKJWV9+Hyx2K6QB7MJRTKp
         CtQqKEWnVMVet0uSVgDyLmV+toll2PL26CKEwmUz4gRuzHSZP24g08WQorM5k12BA+Dw
         odpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nS2yMVkGz+ps+zT6am8AF/1mxQGXi0VAWBoJudmXHPc=;
        b=Wj9riMcA4oXAmK5vTLLkBiHd9sp76eHbTqGpsi7ImBJ7glYGM0JXwlPSPCQQji8z2n
         F0+/KJ8llsJ3IrmA0n82zhExhzI2ETKjs4ivQI2YiAep/J4FoD8+rqTWPaVmCreP9pfT
         Uy13A2X9CTShpFphAMe9oIxBfA2j8t4h3f+JlFIGPXHPX/ZdEs56hKQNK9FposcC4b80
         MafqW0gOdLtaB69omhrLTngE8WzRdNC7mNWTHz8wC3m7HwW4Dt6T5a7E29tCAyntCHmk
         grUFSCQlxFoLSFosHWRiTI7+mpkiUek7P4A2LymhvyZsMtELVzK48AMY+xHZ5xYAfOoR
         9Dkw==
X-Gm-Message-State: AOAM5318SzBxs1hV27PxAZuhUV6BU3qmVwVosmXhNuYk1wiMx15fzf4k
        FUPcSER/3hZEIYbTeRx7eQsl/egDv/5j2YRpd7w5LtP5cAA=
X-Google-Smtp-Source: ABdhPJy7iUitjcn5oppNAM26KLOKBXIs4/V+QaoDLcXzbV9JP4wn+ooEMLT/JRhoo9LdAuLJ9hjFRVfhWvvZWFHGdrk=
X-Received: by 2002:a05:6902:120d:: with SMTP id s13mr201994ybu.498.1641448967089;
 Wed, 05 Jan 2022 22:02:47 -0800 (PST)
MIME-Version: 1.0
References: <CAFcO6XMpbL4OsWy1Pmsnvf8zut7wFXdvY_KofR-m0WK1Bgutpg@mail.gmail.com>
 <CAADnVQJK5mPOB7B4KBa6q1NRYVQx1Eya5mtNb6=L0p-BaCxX=w@mail.gmail.com>
 <CAFcO6XMxZqQo4_C7s0T2dv3JRn4Vq4RDFqJO6ZQFr6kZzsnx9g@mail.gmail.com> <CAADnVQ+HJnZOqGjXKXut51BUqi=+na4cj=PFaE35u9QwZDgeVQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+HJnZOqGjXKXut51BUqi=+na4cj=PFaE35u9QwZDgeVQ@mail.gmail.com>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Thu, 6 Jan 2022 14:02:36 +0800
Message-ID: <CAFcO6XP6+=S1C_m28JF_aA5az=WiswS-J3d8X2dBsYyQ4nwzkg@mail.gmail.com>
Subject: Re: A slab-out-of-bounds Read bug in __htab_map_lookup_and_delete_batch
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >
> > Hi, the attachment is a reproducer. Enjoy it.
>
> Please do not top-post.
> Forwarding a syzbot reproducer with zero effort to analyze
> what's going on is kinda lame.

Hi, I am sorry for that.

> Maybe try harder and come up with a fix?
> Or at least try git bisect and based on a commit find and
> cc an author so it can be fixed (assuming issue still exists
> in bpf-next) ?
>

Thank you for your suggestions.
I spent a few days on git bisect and locked the bad commit, the commit
is d635a69dd4981cc51f90293f5f64268620ed1565.
The commit is a Merge tag 'net-next-5.11' and Contains multiple
commits, currently not locked to a single commit.


Regards,
 but3rflyh4ck.

--
Active Defense Lab of Venustech
