Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBC647F0B2
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 20:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353494AbhLXT0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 14:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344259AbhLXT0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 14:26:43 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D565C061757
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 11:26:43 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id d1so4996886ybh.6
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 11:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UPZ09ax0oqHtuCTkKigM6Cv0cITf2FpSplnw6FQSvhA=;
        b=eV3I1OE6yc0Vmb+TL4dAlm6VCYtzsj0UkCPsn917Rtn7ve6R1qffQilLYO/OwR9sxq
         JDbWiTsyKWGqKEZEL0p1IcOmCO1CkjbVqN5jwjHXsEHv0sKaE3S0LbnuhEWwmsZ8xLPt
         EfDmUxMuHhEJcoNpsfbdnrHJHyUpGS6UiQN/8RYi0xgtd+xfu+3yJBBf1ZlXk/l4siD5
         H+cfMKEb/ZGCED090yXK9g290G1+ovUrNZ7CQOCj4rpdX9vVzIKTujzZpnT7OSiM6Dg4
         LvTq2FboIplPmpEddAaULakkse5l8D50pjLcrylJFRAePpZC7mV82wE9SjsN+/nQKLJI
         I4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UPZ09ax0oqHtuCTkKigM6Cv0cITf2FpSplnw6FQSvhA=;
        b=Aozue7zyaopsMBwhfjMLI5GTI9HL9TIr5Z0CNuKq65fipylXs59cuotvrzNqSwenez
         LIVSfUZRC1NPMVjKRhGAHKA1T2H77INqdANfDC0IzsgdSNdtPFWvsAp118l5Ixvq8vVO
         6HhGV5Elrj9RcftFFSCvRB3n+BOU8+piqT6OlLuL419eC8JTU8aEH8ZDBK/Sm3+PTj9T
         vzu+7sTf+MsGQ48K3VaDfDP9mYc7wGdCegGl/go8X5UElvko9Ti4zRZGj98dC567oiJY
         zZ4VECfvOQk8T5LgCeJWn3t89Yt3FB0OpW8sbtvnKWH09A/oziYLdnOdl4mW0z3UuYzc
         q23Q==
X-Gm-Message-State: AOAM5317DHdN4QfzXN78AbxFX7GdcIwcOd7jcymAN1aet7ZDjAvjKbeI
        d8jUBaN2HHI953ZOwPabQhrDmKhpgIPf8ysKmDA=
X-Google-Smtp-Source: ABdhPJz4S6i6heXcQPzaxgxIwDuPue7F7oqK2sarAf3Xgkn5GW/Z392BKwKJ5KYGoZGpXvOGxj0OxNUNMdPjIye7zQ4=
X-Received: by 2002:a25:c203:: with SMTP id s3mr6179715ybf.285.1640374002108;
 Fri, 24 Dec 2021 11:26:42 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-3-xiangxia.m.yue@gmail.com> <CAM_iQpXfZq--ZCUQvggtqE7bEpZFRVcLTqN_R5kLiZj4Y75VAA@mail.gmail.com>
 <CAMDZJNVNKP1cgHJKUtPwWUdPR5cZ=v8+t9X6AgHw9FPLi4CmYg@mail.gmail.com>
In-Reply-To: <CAMDZJNVNKP1cgHJKUtPwWUdPR5cZ=v8+t9X6AgHw9FPLi4CmYg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 24 Dec 2021 11:26:31 -0800
Message-ID: <CAM_iQpULb_+whVGsEv+BD09MBOdvpT-3C8WmiuBSSCbT9Yrw3Q@mail.gmail.com>
Subject: Re: [net-next v5 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 5:24 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Tue, Dec 21, 2021 at 1:57 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Dec 20, 2021 at 4:39 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > This patch allows user to select queue_mapping, range
> > > from A to B. And user can use skbhash, cgroup classid
> > > and cpuid to select Tx queues. Then we can load balance
> > > packets from A to B queue. The range is an unsigned 16bit
> > > value in decimal format.
> > >
> > > $ tc filter ... action skbedit queue_mapping skbhash A B
> > >
> > > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> > > is enhanced with flags:
> > > * SKBEDIT_F_TXQ_SKBHASH
> > > * SKBEDIT_F_TXQ_CLASSID
> > > * SKBEDIT_F_TXQ_CPUID
> >
> > Once again, you are enforcing policies in kernel, which is not good.
> > Kernel should just set whatever you give to it, not selecting policies
> > like a menu.
> I agree that, but for tc/net-sched layer, there are a lot of

If you agree, why still move on with this patch? Apparently
you don't. ;)

> networking policies, for example , cls_A, act_B, sch_C.

You are justifying your logic by shifting the topics here.

The qdisc algorithm is very different from your case, it is essentially
hard, if not impossible, to completely move to user-space. Even if we
had eBPF based Qdisc, its programmablility is still very limited.
Your code is much much much easier, which is essentially one-line,
hence you have to reason to compare it with this, nor you can even
justify it.

> > Any reason why you can't obtain these values in user-space?
> Did you mean that we add this flags to iproute2 tools? This patch for
> iproute2, is not post. If the kerenl patches are accepted, I will send
> them.

Nope, I mean you can for example, obtain the CPU ID in user-space
and pass it directly to _current_ act_skbedit as it is.

Thanks.
