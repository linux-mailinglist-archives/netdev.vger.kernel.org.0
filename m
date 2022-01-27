Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5926649D9F0
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 06:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiA0FWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 00:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiA0FWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 00:22:15 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF2CC06161C;
        Wed, 26 Jan 2022 21:22:15 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id f8so1287615pgf.8;
        Wed, 26 Jan 2022 21:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e8DGiYEjVgGtuhn/o4jRZapOl1uwC4X5UKRJiu5FmMQ=;
        b=mJVyDldnI2g0d6dnQFdUa0gz3JmtX+XNk8UL1y/W3Smj9vE7SxEQ86IB8mPppYf+iw
         BUS9zto66TBUTUwGcnSfsmYdW8C1c4I4/6w4jLKef6C7vsCEmO2vfvRoJy0uNt/sfU3o
         wALh/msvFhnVbtj9YEtQsxJ0WJSiN5/14Xd6DOMgK32K+nxdl3a5KMPsXAfpqJSc7nh9
         wmDYgtdBWFQNh1mXpERIpJSwV07WIOyXCNLngFcmy3n3jm1Jv2WbwchcBVtQDCzHAwe/
         L35eWS2q3X8qjbIZFjIi8lPuJe6EtKUguVoX+y1VKILOHc72zPnLicuHhE0TIHgCnCYv
         Qr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e8DGiYEjVgGtuhn/o4jRZapOl1uwC4X5UKRJiu5FmMQ=;
        b=CXhtF69hiVjYXjFADUKqV5UOCkgQc8wivhi3xra58VKvKWP7TDbjx0IY1vC0DW4TTE
         9Kn1ZpC8X9SqaXpdo9QkurYNwJThdGbTkc6DoHcZTyokQWC5tWSnzDwfzz3NKcdCxqaC
         QLNyNh0eBlMuwSErPKovnmAuQHj8AHeXZY3cxMchvNHOxKy0C4fT1Cg97JfV6Gf1t3vk
         bVyrsoEifTUzFI1Ih2/bKfKwc7trE7WkDBtN8LVO7LnCJZKfRmFqZkvTJzm50eFAunMW
         1h2Bb6PHZcvmUy4zchMMm2+zz9Rc9Npusd8hsTMZAPFiiudklOl7NOH3rzH0j+Us/9UR
         66gw==
X-Gm-Message-State: AOAM531qk8SRMafVrezjg2BExFlGKQXc0BHcReqH/nfKMc5g6yI+hdnP
        T1lT+K8zj2/PhYaPUh5wERoCgJXdejTUQeWO5arP3jGV
X-Google-Smtp-Source: ABdhPJySRJXUlobXXYb33H/6/6WG79jbr1r1vwCirqbYeIykv//CJ5QtneaosvHTuLp+PTn/2hqX6XxRje686CP4/cM=
X-Received: by 2002:a62:15c3:: with SMTP id 186mr1667041pfv.59.1643260934891;
 Wed, 26 Jan 2022 21:22:14 -0800 (PST)
MIME-Version: 1.0
References: <20220126185412.2776254-1-kuba@kernel.org> <61f22a5863695_57f03208a8@john.notmuch>
In-Reply-To: <61f22a5863695_57f03208a8@john.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 26 Jan 2022 21:22:03 -0800
Message-ID: <CAADnVQ+nn4m8HWpBM0KNC5Z6tpc_QCLk0SjpYKWyQNfTCmLndA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: remove unused static inlines
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 9:15 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Jakub Kicinski wrote:
> > Remove two dead stubs, sk_msg_clear_meta() was never
> > used, use of xskq_cons_is_full() got replaced by
> > xsk_tx_writeable() in v5.10.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied.
How did you find them?
