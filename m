Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B0A10ECCF
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 17:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfLBQDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 11:03:53 -0500
Received: from mail-yw1-f41.google.com ([209.85.161.41]:40551 "EHLO
        mail-yw1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfLBQDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 11:03:53 -0500
Received: by mail-yw1-f41.google.com with SMTP id i126so4592704ywe.7
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 08:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fgxmeklhIzZCFqVgjNfZswKO4i8uNUVrjelUbri+GBE=;
        b=sls2NW7gSoAgdJ/jdhu+wHp0GG3mEB1t8CC3N6qhwpuCM7SE5l2xho+qa8TjNOCkix
         mZYx1/9/UN6Ghbmw2Dcy3wKP+oEUH3DCa/9ggTx8rkAN9nglkG5sGjYxpQKiXgBfjBa3
         Ox0k677a2gF6GVPmu+xBNwxRpJj6qVHs4k9+MH9gtoN/F99H06nSSs6YHAUV3tqjSKmY
         7Ofq4OcKbBWKaVbZxbp6voVRTLeStAOGr6RXekR9YQiB6wg6ojJwGouwk0cENXyTfbqR
         ll2qsyLpSzVC+bk0tDNjAEUcyuPNUyCx0eeOVuDAPu0rgrglJv8tm6mLbi4APbESlJZq
         JUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fgxmeklhIzZCFqVgjNfZswKO4i8uNUVrjelUbri+GBE=;
        b=dHGCU3BrHWhMDa1+yFsXU1XN9LsvtjaRE0fwj6fVHdlArgJ7UxP1HttsGE5P+MBIqd
         DpEfWm1eCP65MpTW6iimqCF2bGqdJ+ptRIP8iS5EOIbsLelOgT76edBQuAvWppSuEUrb
         CYJHlF8VITg6uvNBTQ74wjmfyD+tp2ivVMFwq1JH+yG65Tp2EkQPcirb0WEjqOuqQS33
         1A8ZvYWNj/bvlQG9ji9f4ZP6jdiSHXS6kzLwkMLuJVtXr2jNA0FnB+1mOdzN6zMpR25X
         G7TmL+Sogo2kmHCD6mavNjn5lTJ8LAwALSUXJ+Gm4tBloGbvInawAwd64VxwAWcQrOmw
         IZNQ==
X-Gm-Message-State: APjAAAWL+pYIb4WSZsfRHdsihW/Uzrx1xhJPIg0Lz+IybJ/L7jss8LgA
        9kx3JdbFzhtb4mfcgxJKHvFJSwM8
X-Google-Smtp-Source: APXvYqzPa1g0tAD6DxmNxvqlIXqJolcTigL95ocTB2GKRk3kBUI2J4TbW4VnXti/SQneUCTFSCUZ2A==
X-Received: by 2002:a81:5583:: with SMTP id j125mr23424187ywb.497.1575302631523;
        Mon, 02 Dec 2019 08:03:51 -0800 (PST)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id u136sm14031124ywf.101.2019.12.02.08.03.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 08:03:50 -0800 (PST)
Received: by mail-yb1-f173.google.com with SMTP id q18so152523ybq.6
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 08:03:49 -0800 (PST)
X-Received: by 2002:a25:cf55:: with SMTP id f82mr51387ybg.203.1575302628959;
 Mon, 02 Dec 2019 08:03:48 -0800 (PST)
MIME-Version: 1.0
References: <CAJPywTJzpZAXGdgZLJ+y7G2JoQMyd_JG+G8kgG+xruVVmZD-OA@mail.gmail.com>
 <877e3fniep.fsf@cloudflare.com>
In-Reply-To: <877e3fniep.fsf@cloudflare.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 2 Dec 2019 11:03:12 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfA9o=yQk5EjR2hMuhwRDLXCAwYQ+eGqx2YSh=hx03c8g@mail.gmail.com>
Message-ID: <CA+FuTSfA9o=yQk5EjR2hMuhwRDLXCAwYQ+eGqx2YSh=hx03c8g@mail.gmail.com>
Subject: Re: Delayed source port allocation for connected UDP sockets
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 5:15 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Nov 27, 2019 at 03:07 PM CET, Marek Majkowski wrote:
> > In my applications I need something like a connectx()[1] syscall. On
> > Linux I can get quite far with using bind-before-connect and
> > IP_BIND_ADDRESS_NO_PORT. One corner case is missing though.
> >
> > For various UDP applications I'm establishing connected sockets from
> > specific 2-tuple. This is working fine with bind-before-connect, but
> > in UDP it creates a slight race condition. It's possible the socket
> > will receive packet from arbitrary source after bind():
> >
> > s = socket(SOCK_DGRAM)
> > s.bind((192.0.2.1, 1703))
> > # here be dragons
> > s.connect((198.18.0.1, 58910))
> >
> > For the short amount of time after bind() and before connect(), the
> > socket may receive packets from any peer. For situations when I don't
> > need to specify source port, IP_BIND_ADDRESS_NO_PORT flag solves the
> > issue. This code is fine:
> >
> > s = socket(SOCK_DGRAM)
> > s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> > s.bind((192.0.2.1, 0))
> > s.connect((198.18.0.1, 58910))
> >
> > But the IP_BIND_ADDRESS_NO_PORT doesn't work when the source port is
> > selected. It seems natural to expand the scope of
> > IP_BIND_ADDRESS_NO_PORT flag. Perhaps this could be made to work:
> >
> > s = socket(SOCK_DGRAM)
> > s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> > s.bind((192.0.2.1, 1703))
> > s.connect((198.18.0.1, 58910))
> >
> > I would like such code to delay the binding to port 1703 up until the
> > connect(). IP_BIND_ADDRESS_NO_PORT only makes sense for connected
> > sockets anyway. This raises a couple of questions though:
> >
> >  - IP_BIND_ADDRESS_NO_PORT name is confusing - we specify the port
> > number in the bind!
> >
> >  - Where to store the source port in __inet_bind. Neither
> > inet->inet_sport nor inet->inet_num seem like correct places to store
> > the user-passed source port hint. The alternative is to introduce
> > yet-another field onto inet_sock struct, but that is wasteful.
>
> We've been talking with Marek about it some more. I'll summarize for the
> sake of keeping the discussion open.
>
> 1. inet->inet_sport as storage for port hint
>
>    It seems inet->inet_sport could be used to hold the port passed to
>    bind() when we're delaying port allocation with
>    IP_BIND_ADDRESS_NO_PORT. As long as local port, inet->inet_num, is
>    not set, connect() and sendmsg() will know the socket needs to be
>    bound to a port first.

So bind might succeed, but connect fail later if the port is already
bound by another socket inbetween?

Related, I have toyed with unhashed sockets with inet_sport set in the
past for a different use-case: transmit-only sockets. If all receive
processing happens on a small set (say, per cpu) of unconnected
listening sockets. Then have unhashed transmit-only connected sockets
to transmit without route lookup. But the route caching did not
warrant the cost of maintaining a socket per connection at scale.

>
>    We didn't do a detailed audit of all access sites to
>    inet->inet_sport. Potentially we missed something.
>
>

> 4. Why connected UDP sockets?
>
>    We know that it's better to stick to receiving UDP sockets and
>    demultiplex the client requests/sessions in user-space. Being hashed
>    just by local address & port, connected UDP sockets don't scale well.
>
>    We think there is one useful application, though. Service draining
>    during restarts.
>
>    When a service is being restarted, we would like the dying process to
>    handle the ongoing L7 sessions until they come to an end. New UDP
>    flows should go to a fresh service instance.

Service hand-off is a prime use case of reuseport BPF. With UDP it is
trickier than TCP. Requires a map to store session to process affinity,
likely.

>    To achieve that, for each ongoing session we would open a connected
>    UDP socket. This way socket lookup logic would deliver just the flows
>    we care about to the old process.
>
> 5. reuseport BPF with SOCKARRAY to the rescue?
>
>    Since we're talking about opening connected UDP sockets that share
>    the local port with other receiving UDP sockets (owned by another
>    process), we would need to opt for port sharing with REUSEPORT [3].
>
>    If we don't want the connected UDP sockets to receive any traffic
>    during the short window of opportunity when the socket is bound but
>    not connected, we could exclude it from the reuseport group by
>    controlling the socket set with BPF & SOCKARRAY.
>
> Comments and thoughts more than welcome.

If CAP_NET_RAW is no issue, Maciej's suggestion of temporarily binding
to a dummy device (or even lo) might be the simplest approach?

>
> -Jakub
>
> [0] Unless we call it IP_BIND_ADDRESS_NO_PORT_FOR_REAL... ;-)
> [1] https://www.unix.com/man-page/mojave/2/connectx/
> [2] Or REUSEADDR which semantics allow it for unicast UDP.
