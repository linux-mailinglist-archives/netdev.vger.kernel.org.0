Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63ED217C05
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 02:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgGGX76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 19:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729424AbgGGX75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 19:59:57 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C6CC08C5DC
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 16:59:57 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id h18so19687689qvl.3
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 16:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v+ahpGj2d2NwV/+i02H7iPcFunciLLEFtdB4vcJon7c=;
        b=g8c1wIvRFeRw9x5pH6sq1K+558Ys89NjQ0xUbjqF+5UULIUuJ0z3SFJGuAfYdpLaxe
         hSzfMvrkWa6+IHHKvtkkrpcjihp+FQE3AAtMvmRbWR1mxNWF1JMhXMP6Qy7Z29LYBXnR
         fFASO16V0U6xOT9Oo3OcZIov3p3RHKGRRDRa2OSjkdvrkYGVe9PA98A4sDqzt9FRP2FE
         +0W52G9Q3hQwxYq0bO4uUsXHRJq6E0BFWS7cqsMampx8uSQ3WXT+YQIVIZso1MX4Pj0E
         aHJh76xw19gxOo0A7+CqqJvkh2g06NznChYDHdX4A0pFeGBQqnPE5jijSf+4kPE8SO7l
         oQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v+ahpGj2d2NwV/+i02H7iPcFunciLLEFtdB4vcJon7c=;
        b=l4mufCgcY8hk+/O9HNEnPsKVCcg1NijdYokADI2srGhE6mppFiDQ70UK/sIaLztnRr
         NBMHb+tB74xxINTg+mG/8+B09IG+wREYBA3U7WoJf/ksYa5ilrBPoQAigLTuKoCsKkB6
         mB6Fi3qITeyBnDYSIeP7jfVR51vJpUNCd2lf+vL0M471zfoEbrI49rXWmSy+anb+fYN2
         bQVF8tOBb+pibaBn3jNzNa34o9X0bDLTE78pH7fey4F9LxvEr0SsAPlSO/covaBn03vh
         z1qLcbCSrDwjhpt1DhgGcTn6Zq5xotQziqEVUDbvENzqmwIDkqlot8nceDx3mAMRw/LY
         iskg==
X-Gm-Message-State: AOAM532RZTnCR3I8xRzZN7NVZpjD/87KWLn5wNdL+mCT9n6jMIOMrbln
        CL8EEsxf0lUtBKtizgsJ0Ol3qR4xzx23dA7PH3Z4VQ==
X-Google-Smtp-Source: ABdhPJxK14bXYoNk2815FCzW6KS2Z8gclPDDb08pQCHzAI2eb+2jOVvTeRADska1D32LUeRpEE5guDV/75aaf04xzrQ=
X-Received: by 2002:ad4:5042:: with SMTP id m2mr43238319qvq.225.1594166396461;
 Tue, 07 Jul 2020 16:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200706230128.4073544-1-sdf@google.com> <20200706230128.4073544-2-sdf@google.com>
 <CAEf4Bzb=vHUC2dgxNEE2fvCZrk9+crmZAp+6kb5U1wLF293cHQ@mail.gmail.com>
 <073ac0af-5de7-0a61-4e11-e4ca292f6456@iogearbox.net> <CAKH8qBujza3yn0+YXTV6zg7csWLUaA7RxEiompE5yz4QJsULoA@mail.gmail.com>
 <0f640b14-907a-7e44-9499-6c0e7f92358c@iogearbox.net>
In-Reply-To: <0f640b14-907a-7e44-9499-6c0e7f92358c@iogearbox.net>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 7 Jul 2020 16:59:45 -0700
Message-ID: <CAKH8qBtev58QgSNGQPaE4B7wp06W=WeH0nsiHcdeYftnmXr1Hw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/4] bpf: add BPF_CGROUP_INET_SOCK_RELEASE hook
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 4:56 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/8/20 1:43 AM, Stanislav Fomichev wrote:
> > On Tue, Jul 7, 2020 at 2:42 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> On 7/7/20 1:42 AM, Andrii Nakryiko wrote:
> >>> On Mon, Jul 6, 2020 at 4:02 PM Stanislav Fomichev <sdf@google.com> wrote:
> >>>>
> >>>> Implement BPF_CGROUP_INET_SOCK_RELEASE hook that triggers
> >>>> on inet socket release. It triggers only for userspace
> >>>> sockets, the same semantics as existing BPF_CGROUP_INET_SOCK_CREATE.
> >>>>
> >>>> The only questionable part here is the sock->sk check
> >>>> in the inet_release. Looking at the places where we
> >>>> do 'sock->sk = NULL', I don't understand how it can race
> >>>> with inet_release and why the check is there (it's been
> >>>> there since the initial git import). Otherwise, the
> >>>> change itself is pretty simple, we add a BPF hook
> >>>> to the inet_release and avoid calling it for kernel
> >>>> sockets.
> >>>>
> >>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >>>> ---
> >>>>    include/linux/bpf-cgroup.h | 4 ++++
> >>>>    include/uapi/linux/bpf.h   | 1 +
> >>>>    kernel/bpf/syscall.c       | 3 +++
> >>>>    net/core/filter.c          | 1 +
> >>>>    net/ipv4/af_inet.c         | 3 +++
> >>>>    5 files changed, 12 insertions(+)
> >>>>
> >>>
> >>> Looks good overall, but I have no idea about sock->sk NULL case.
> >>
> >> +1, looks good & very useful hook. For the sock->sk NULL case here's a related
> >> discussion on why it's needed [0].
> > Thanks for the pointer! I'll resend a v5 with s/sock/sock_create/ you
> > mentioned and will clean up the commit description a bit.
>
> Already fixed up the selftest and a typo in the commit desc there & applied it.
Oh, awesome, thanks!
