Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0018E1D1D7E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390177AbgEMSaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733310AbgEMSaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:30:18 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87168C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:30:17 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id x12so639031qts.9
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZHRshdycZcrgsKSC7G/+rPgPxIFT4T/W2PZGPaf8g7Y=;
        b=e+M7d/cKDZE39K+/aMgWXcMSGZmt1uxAOYNT6hf+iiI3ljnUpkERkiR1JrjmaPk1BI
         DBnGiZNMu4j5e0MLs3cB1cil6P7AwbhyLS2N/jRgQo43eh7Whk3MGeecwIKNLWEWSxbQ
         QqYT1FK+T2aYLJuk/5v8k1hyaFrRMPuZ9XgSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZHRshdycZcrgsKSC7G/+rPgPxIFT4T/W2PZGPaf8g7Y=;
        b=G/RoyJ9HsT7txYRgn6jR+IoT0LeHfYrlolLqhSieLSFm5IoddSGd1Ps0UBHjpwkPWj
         Sj92WpZwi6bWDDOpZHYk4/r2zeeMWB9motTtoqgO0xkkx10F86uLKTALvR0kCGcol7/I
         Fowkc8/2h8DHqh6IYVheL6jk8t16e+6LB5vYE44bFuBUvAP4YRCaSWQVyAeq7X/ywrhE
         pB82pnFbWU9Gr0uOxGllzmJWKldBm2RC8oo66DKycWcwsPQxhcQROIlEjUZO4SWP9YJx
         HkpbZACux58opV548KjkQQiTWByNOJxGeKlVvpQoPbkeEoFWHk9Hx7oh5vO3B0O4bW7P
         M0hA==
X-Gm-Message-State: AOAM532BhrjZMsTnUxg5zMo6ulcFk/T5C5VTpEEfe/EkkIxE7ddibuCR
        dKsqrFYbTWSHXvEjewPa8y7KN34Ulxh95XZOMC0udQ==
X-Google-Smtp-Source: ABdhPJx0vBpemsU3aq8SJB4eiYo93tub4OTvs4jnwtPJ46YCN4afYycte2hbfyf/wqrxxmtQat2ZoQ4ja3jWYTCRTPM=
X-Received: by 2002:ac8:24e7:: with SMTP id t36mr464196qtt.98.1589394616579;
 Wed, 13 May 2020 11:30:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
 <CAJPywT+c8uvi2zgUD_jObmi9T6j50THzjQHg-mudNrEC2HuJvg@mail.gmail.com> <20200513175301.43lxbckootoefrow@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200513175301.43lxbckootoefrow@ast-mbp.dhcp.thefacebook.com>
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Wed, 13 May 2020 19:30:05 +0100
Message-ID: <CAJPywTKUmzDObSurppiH4GCJquDTnVWKLH48JNB=8RNcb5TiCQ@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 0/3] Introduce CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        network dev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com,
        Jann Horn <jannh@google.com>, kpsingh@google.com,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 6:53 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Wed, May 13, 2020 at 11:50:42AM +0100, Marek Majkowski wrote:
> > On Wed, May 13, 2020 at 4:19 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > CAP_BPF solves three main goals:
> > > 1. provides isolation to user space processes that drop CAP_SYS_ADMIN and switch to CAP_BPF.
> > >    More on this below. This is the major difference vs v4 set back from Sep 2019.
> > > 2. makes networking BPF progs more secure, since CAP_BPF + CAP_NET_ADMIN
> > >    prevents pointer leaks and arbitrary kernel memory access.
> > > 3. enables fuzzers to exercise all of the verifier logic. Eventually finding bugs
> > >    and making BPF infra more secure. Currently fuzzers run in unpriv.
> > >    They will be able to run with CAP_BPF.
> > >
> >
> > Alexei, looking at this from a user point of view, this looks fine.
> >
> > I'm slightly worried about REUSEPORT_EBPF. Currently without your
> > patch, as far as I understand it:
> >
> > - You can load SOCKET_FILTER and SO_ATTACH_REUSEPORT_EBPF without any
> > permissions
>
> correct.
>
> > - For loading BPF_PROG_TYPE_SK_REUSEPORT program and for SOCKARRAY map
> > creation CAP_SYS_ADMIN is needed. But again, no permissions check for
> > SO_ATTACH_REUSEPORT_EBPF later.
>
> correct. With clarification that attaching process needs to own
> FD of prog and FD of socket.
>
> > If I read the patchset correctly, the former SOCKET_FILTER case
> > remains as it is and is not affected in any way by presence or absence
> > of CAP_BPF.
>
> correct. As commit log says:
> "Existing unprivileged BPF operations are not affected."
>
> > The latter case is different. Presence of CAP_BPF is sufficient for
> > map creation, but not sufficient for loading SK_REUSEPORT program. It
> > still requires CAP_SYS_ADMIN.
>
> Not quite.
> The patch will allow BPF_PROG_TYPE_SK_REUSEPORT progs to be loaded
> with CAP_BPF + CAP_NET_ADMIN.
> Since this type of progs is clearly networking type I figured it's
> better to be consistent with the rest of networking types.
> Two unpriv types SOCKET_FILTER and CGROUP_SKB is the only exception.

Ok, this is the controversy. It made sense to restrict SK_REUSEPORT
programs in the past, because programs needed CAP_NET_ADMIN to create
SOCKARRAY anyway. Now we change this and CAP_BPF is sufficient for
maps - I don't see why CAP_BPF is not sufficient for SK_REUSEPORT
programs. From a user point of view I don't get why this additional
CAP_NET_ADMIN is needed.

> > I think it's a good opportunity to relax
> > this CAP_SYS_ADMIN requirement. I think the presence of CAP_BPF should
> > be sufficient for loading BPF_PROG_TYPE_SK_REUSEPORT.
> >
> > Our specific use case is simple - we want an application program -
> > like nginx - to control REUSEPORT programs. We will grant it CAP_BPF,
> > but we don't want to grant it CAP_SYS_ADMIN.
>
> You'll be able to grant nginx CAP_BPF + CAP_NET_ADMIN to load SK_REUSEPORT
> and unpriv child process will be able to attach just like before if
> it has right FDs.
> I suspect your load balancer needs CAP_NET_ADMIN already anyway due to
> use of XDP and TC progs.
> So granting CAP_BPF + CAP_NET_ADMIN should cover all bpf prog needs.
> Does it address your concern?

Load balancer (XDP+TC) is another layer and permissions there are not
a problem. The specific issue is nginx (port 443) and QUIC. QUIC is
UDP and due to the nginx design we must use REUSEPORT groups to
balance the load across workers. This is fine and could be done with a
simple SOCK_FILTER - we don't need to grant nginx any permissions,
apart from CAP_NET_BIND_SERVICE.

We would like to make the REUSEPORT program more complex to take
advantage of REUSEPORT_EBPF for stickyness (restarting server without
interfering with existing flows), we are happy to grant nginx CAP_BPF,
but we are not happy to grant it CAP_NET_ADMIN. Requiring this CAP for
REUSEPORT severely restricts the API usability for us.

In my head REUSEPORT_EBPF is much closer to SOCKET_FILTER. I
understand why it needed capabilities before (map creation) and I
argue these reasons go away in CAP_BPF world. I assume that any
service (with CAP_BPF) should be able to use reuseport to distribute
packets within its own sockets.  Let me know if I'm missing something.

Marek
