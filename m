Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCF326E5F0
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 21:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgIQT6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 15:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgIQT57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 15:57:59 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51D4C0611C3;
        Thu, 17 Sep 2020 12:52:44 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id u18so3446673iln.13;
        Thu, 17 Sep 2020 12:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V8vmq5V6kxX7SFyjUH93d+10+n1COuPc3VLs9cGSZh4=;
        b=blEBjv5XPevr8kXz0RXht7oiKhmdZ9iemyt6IWI5W2V/OaJM/xMEZibpwmdrYcrHAk
         Q/Kz3F8Dv/cHKOPllymJvYazjiyJ77Xdgdin7Oq9ktnk/HZTVWt+8f5Aufww4/nm8OS7
         bBetggUZ+2QL1/YTrYNiuJWT6YdDof1zJlbHjAsW0BycertlbDtgtTa+pGzGYOZemljR
         F4hDIQUwaoZ/IuEKXf0p+kEHsu5pMUPC4ss5qr8kj2xvTByDcZDZqmygWWs5kncGAjVb
         YFTum1SlMU/KWYEC5Kx/mbGYOvRj8lKkFck3V/goYW4NtQWB8X4reFl1lShuiaQkvzD1
         at5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V8vmq5V6kxX7SFyjUH93d+10+n1COuPc3VLs9cGSZh4=;
        b=Y56fnjfipnPnzkFk/I+bZ/E4q4mwMT/Ex1IzzKEE29muKy7yK3V091ZJFwrc2V2dAk
         kLp5cSFkE6V1UmM+NLJf3QbUv+OnIk47wpTCTwLgqnkzBl14wbsLwbqCYhsMYYL7uS+/
         EkFYlnTTqV2PlWftbZCFOoE92XAzUuVRxv+TeGu9KU4PZqdW8vXvwxrSY87FHXvg4C2L
         6cFvq8WHl205wSjkHGBSnD4ts1tJS3X3PX3LvJqQT/CZfrv6366Io4qQreOW4zBvVtO2
         7YbiTefiRS27ZCR9wQENVMxjIxdgev+I7JTgKbH94G29ijM76HNmY+2x3qSJjsDmQrup
         TzxQ==
X-Gm-Message-State: AOAM530P6JtQnUGEVKZHIjpEKWDTwCwIMHWHqTk4I7PajB5zTBlBSlEO
        3O1YZg/WnxXdiJglsiAx4XR76Q1afXYwZL18CoQ=
X-Google-Smtp-Source: ABdhPJzVfFmFHyFDyrzoEwG6qbDO2JrQi85Qrvh0iz4GRy6pxkgRQRi5Ag07cyir2a0FgAmNsdZru5r4FZmfV0akpq0=
X-Received: by 2002:a92:dad1:: with SMTP id o17mr26400856ilq.22.1600372363985;
 Thu, 17 Sep 2020 12:52:43 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AM7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com> <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <20200903101957.428-1-hdanton@sina.com> <CACS=qqLKSpnRrgROm8jzzFid3MH97phPXWsk28b371dfu0mnVA@mail.gmail.com>
 <CAM_iQpUq9-wja3JHz9+TMeXGyAOmJfZDxWUZJ9v25i7vd0Z-Wg@mail.gmail.com> <c97908eb-5a0b-363c-93fd-59c037bbd9f0@huawei.com>
In-Reply-To: <c97908eb-5a0b-363c-93fd-59c037bbd9f0@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 17 Sep 2020 12:52:32 -0700
Message-ID: <CAM_iQpXiNaushoWjma44X_agPosg9AKk4RzFTX93MSVTM6z3Uw@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Kehuan Feng <kehuan.feng@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 7:10 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2020/9/11 4:19, Cong Wang wrote:
> > On Thu, Sep 3, 2020 at 8:21 PM Kehuan Feng <kehuan.feng@gmail.com> wrote:
> >> I also tried Cong's patch (shown below on my tree) and it could avoid
> >> the issue (stressing for 30 minutus for three times and not jitter
> >> observed).
> >
> > Thanks for verifying it!
> >
> >>
> >> --- ./include/net/sch_generic.h.orig 2020-08-21 15:13:51.787952710 +0800
> >> +++ ./include/net/sch_generic.h 2020-09-03 21:36:11.468383738 +0800
> >> @@ -127,8 +127,7 @@
> >>  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
> >>  {
> >>   if (qdisc->flags & TCQ_F_NOLOCK) {
> >> - if (!spin_trylock(&qdisc->seqlock))
> >> - return false;
> >> + spin_lock(&qdisc->seqlock);
> >>   } else if (qdisc_is_running(qdisc)) {
> >>   return false;
> >>   }
> >>
> >> I am not actually know what you are discussing above. It seems to me
> >> that Cong's patch is similar as disabling lockless feature.
> >
> >>From performance's perspective, yeah. Did you see any performance
> > downgrade with my patch applied? It would be great if you can compare
> > it with removing NOLOCK. And if the performance is as bad as no
> > NOLOCK, then we can remove the NOLOCK bit for pfifo_fast, at least
> > for now.
>
> It seems the lockless qdisc may have below concurrent problem:
>   cpu0:                                                           cpu1:
> q->enqueue                                                          .
> qdisc_run_begin(q)                                                  .
> __qdisc_run(q) ->qdisc_restart() -> dequeue_skb()                   .
>                                  -> sch_direct_xmit()               .
>                                                                     .
>                                                                 q->enqueue
>                                                              qdisc_run_begin(q)
> qdisc_run_end(q)
>
>
> cpu1 enqueue a skb without calling __qdisc_run(), and cpu0 did not see the
> enqueued skb when calling __qdisc_run(q) because cpu1 may enqueue the skb
> after cpu0 called __qdisc_run(q) and before cpu0 called qdisc_run_end(q).

This is the same problem that my patch fixes, I do not know
why you are suggesting another patch despite quoting mine.
Please read the whole thread if you want to participate.

Thanks.
