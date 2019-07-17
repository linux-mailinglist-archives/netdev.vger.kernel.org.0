Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88C56B2D5
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 02:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbfGQA1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 20:27:14 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:45720 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfGQA1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 20:27:14 -0400
Received: by mail-oi1-f179.google.com with SMTP id m206so17081304oib.12;
        Tue, 16 Jul 2019 17:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EL/6M6nABk8geR3zifY0ykcSAGPgQ2Du6hrpZZL0v08=;
        b=p3SdR+yeeUXVr/8TrpfALcVvFFbqM1x3A62KcQuN3+u1AWqMwheQSe0Bl56gSr1qyn
         7xJdNGS5vBJ8yOmMN7xh5BP9M90sEXO9KZzFIeEmD8izph0F9djKZPeqh2dSAsw9daml
         OiNwtzDQB4MlYATEn7PHEQpCMqVICAnC+5jQxGFbBtRtF/GW/gCkkkYmXR3Brjl/w2JM
         x79+fZI75ae/1MOeLmpKE8BnYNegMzLOdDtFJQK2cWuVzC0bNby0D+P3zH8VeIqAJNgf
         Cz3paVQOisFwnqI4IwhHui82O46JAPeQwlya3l2ukwdJcjkcqz617bmbVWqHJLSnH5Vc
         elmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EL/6M6nABk8geR3zifY0ykcSAGPgQ2Du6hrpZZL0v08=;
        b=IHg/G24cZfS3QtWyq3DRPOFz23bLn1Avqb0XTArCAy56JGpHHyPKLVcjmt/XVLJkSp
         XmL7xTi0ZblTK/bIjnDoHPm6/Rn2I5iLVXgmp2jyZiD6piRFAM/K6kJLGKXeKkvOKHze
         d8vv/MsKxbDgMxE1LIGeHhFow0akwtG0NSK+0UgRpC0Fq244Mp2TudFa2QziY+8vhF+W
         GtpzIaKgTFAwXqSnXaqnTaIYrskw0Xn3LOb2R8KCl+pgtzDyA2D+O0I0GcJ3fKzrwqnD
         dRLGJb63lIBUiwHAR/KRgHCW3tTvna3PW3euyPuYMHGgpwv4daRFV0Ra1BtIZZYjK19U
         IoKA==
X-Gm-Message-State: APjAAAUCJpjAkohnA1paSLGg+i1aeqB52k/bDtfVACQh4RWlNNJOZoPk
        jDrBi6qJLNsB8DF1zcMqI5l24twNTxJMTKgq5iI=
X-Google-Smtp-Source: APXvYqx987acpIBFyTRr/J+L8CxKwmY8lmBugyo27do20U+n/cTbhcj0zyf7cG0jMoWxA1KLzZ8ESMt1ksv8MspKLAE=
X-Received: by 2002:aca:bf54:: with SMTP id p81mr18008053oif.1.1563323233596;
 Tue, 16 Jul 2019 17:27:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
 <20190716002650.154729-4-ppenkov.kernel@gmail.com> <b6ef24b0-0415-c67d-5a66-21f1c2530414@gmail.com>
 <CACAyw9_5+3cznRspLJ2ZDcK22keLVtQQHbQOypSs4sx-F=ajow@mail.gmail.com>
In-Reply-To: <CACAyw9_5+3cznRspLJ2ZDcK22keLVtQQHbQOypSs4sx-F=ajow@mail.gmail.com>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Tue, 16 Jul 2019 17:27:02 -0700
Message-ID: <CAGdtWsRWAYPedUQQbx1d6PF9sCj6bAXhvhez74ujQYJ8syMvZA@mail.gmail.com>
Subject: Re: [bpf-next RFC 3/6] bpf: add bpf_tcp_gen_syncookie helper
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for the reviews!

On Tue, Jul 16, 2019 at 4:56 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Tue, 16 Jul 2019 at 08:59, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > +             return -EINVAL;
> > > +
> > > +     if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
> > > +             return -EINVAL;
> > > +
> > > +     if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> > > +             return -EINVAL;
> > > +
> > > +     if (!th->syn || th->ack || th->fin || th->rst)
> > > +             return -EINVAL;
> > > +
> > > +     switch (sk->sk_family) {
> >
> > This is strange, because a dual stack listener will have sk->sk_family set to AF_INET6.
> >
> > What really matters here is if the packet is IPv4 or IPv6.
> >
> > So you need to look at iph->version instead.
> >
> > Then look if the socket family allows this packet to be processed
> > (For example AF_INET6 sockets might prevent IPv4 packets, see sk->sk_ipv6only )

This makes a lot of sense, thanks Eric, will update!
>
> Does this apply for (the existing) tcp_check_syn_cookie as well?

I think we will probably have to update the check there, too.
>
> --
> Lorenz Bauer  |  Systems Engineer
> 6th Floor, County Hall/The Riverside Building, SE1 7PB, UK
>
> www.cloudflare.com
