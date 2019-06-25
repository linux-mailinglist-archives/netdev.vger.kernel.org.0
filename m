Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8537E52621
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfFYIMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:12:03 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:45851 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfFYIMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:12:03 -0400
Received: by mail-lj1-f182.google.com with SMTP id m23so15249875lje.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 01:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=TssOUjbGd5SYsb/yN6BqO3kY0oJLgMIeiNuXJ4cyD0k=;
        b=o4neqAjDlr8FYHVYXZILGQkzpsL8XjC6wzX4fIz+dRwFZ4DmXsBQzvdIYYOtIInk4w
         qw9fHrWxOpjVFp/Nh38LpcBLWFGtzB8DC/1bWVuDiAYXnFOwyPq9Vr6ACUNJJ5YUtadQ
         gWimyQuIdpr3QzzM2dC8VnTOfNOyEBZQ7GJD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=TssOUjbGd5SYsb/yN6BqO3kY0oJLgMIeiNuXJ4cyD0k=;
        b=TnsyDPYOkyK4N7zjVzLftLkRuUM6jzKZTUwr2VdjyPL4hj46/ERtLsTS4BXFaSM6Le
         dTZ8qyDrkyddGVtNk6EBVKPk2iwWQ2M71Z/uilPHB3w/KrPbBhfyl/AnH6IMcJkHLxuQ
         exlhw/rfB6GJLT/nqb44uif0SOOXYLJrdiQ1JDbMp839+i5QxKNDrC0ZKoayFlk7PH2i
         coAzbbX7N7SuS+OL/hw9lHiiGQ3McXh1mT8esSWtyzkM3G59/ZAQhkaVbCpocsQNUFks
         FaRvq/FoZnvxKn8xRk8zFXMR+AjQ/wKHfFejExJZaHXg0ZA4dh9mtmaGwFrWSVRz5NmA
         M9cQ==
X-Gm-Message-State: APjAAAWEg99VI0+MYt7rrHSjlGStzLcmqiN5ee3sKIJBHm7r8q1PBlmP
        ciN5o/VudsZvObrG07JZ9UbGZ5RZQpIH9Q==
X-Google-Smtp-Source: APXvYqyxu+O3OcdM8vwr3n8onQ4EyvySdbslZdkKIxtcVW6ejHEZOM2qMcit4+niHinuRKs6FY65JQ==
X-Received: by 2002:a2e:890a:: with SMTP id d10mr41312773lji.145.1561450320764;
        Tue, 25 Jun 2019 01:12:00 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id c12sm1826055lfj.58.2019.06.25.01.11.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 01:12:00 -0700 (PDT)
References: <20190618130050.8344-1-jakub@cloudflare.com> <20190618135258.spo6c457h6dfknt2@breakpoint.cc> <87sgs6ey43.fsf@cloudflare.com> <CAOftzPj6NWyWnz4JL-mXBaQUKAvQDtKJTrjZmrN4W5rqoy-W0A@mail.gmail.com> <CAGn+7TUmgsA8oKw-mM6S5iR4rmNt6sWxjUgw8=qSCHb=m0ROyg@mail.gmail.com> <CAOftzPhGVeLpqbffLwBP8JCvY1t65-uXztEsZV0qJEQapywRgg@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Florian Westphal <fw@strlen.de>, netdev <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [RFC bpf-next 0/7] Programming socket lookup with BPF
In-reply-to: <CAOftzPhGVeLpqbffLwBP8JCvY1t65-uXztEsZV0qJEQapywRgg@mail.gmail.com>
Date:   Tue, 25 Jun 2019 10:11:59 +0200
Message-ID: <875zouccds.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 06:50 PM CEST, Joe Stringer wrote:
> On Fri, Jun 21, 2019 at 1:44 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Fri, Jun 21, 2019, 00:20 Joe Stringer <joe@wand.net.nz> wrote:
>>>
>>> On Wed, Jun 19, 2019 at 2:14 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>> >
>>> > Hey Florian,
>>> >
>>> > Thanks for taking a look at it.
>>> >
>>> > On Tue, Jun 18, 2019 at 03:52 PM CEST, Florian Westphal wrote:
>>> > > Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>> > >>  - XDP programs using bpf_sk_lookup helpers, like load balancers, can't
>>> > >>    find the listening socket to check for SYN cookies with TPROXY redirect.
>>> > >
>>> > > Sorry for the question, but where is the problem?
>>> > > (i.e., is it with TPROXY or bpf side)?
>>> >
>>> > The way I see it is that the problem is that we have mappings for
>>> > steering traffic into sockets split between two places: (1) the socket
>>> > lookup tables, and (2) the TPROXY rules.
>>> >
>>> > BPF programs that need to check if there is a socket the packet is
>>> > destined for have access to the socket lookup tables, via the mentioned
>>> > bpf_sk_lookup helper, but are unaware of TPROXY redirects.
>>> >
>>> > For TCP we're able to look up from BPF if there are any established,
>>> > request, and "normal" listening sockets. The listening sockets that
>>> > receive connections via TPROXY are invisible to BPF progs.
>>> >
>>> > Why are we interested in finding all listening sockets? To check if any
>>> > of them had SYN queue overflow recently and if we should honor SYN
>>> > cookies.
>>>
>>> Why are they invisible? Can't you look them up with bpf_skc_lookup_tcp()?
>>
>>
>> They are invisible in that sense that you can't look them up using the packet 4-tuple. You have to somehow make the XDP/TC progs aware of the TPROXY redirects to find the target sockets.
>
> Isn't that what you're doing in the example from the cover letter
> (reincluded below for reference), except with the new program type
> rather than XDP/TC progs?
>
>        switch (bpf_ntohl(ctx->local_ip4) >> 8) {
>         case NET1:
>                 ctx->local_ip4 = bpf_htonl(IP4(127, 0, 0, 1));
>                 ctx->local_port = 81;
>                 return BPF_REDIRECT;
>         case NET2:
>                 ctx->local_ip4 = bpf_htonl(IP4(127, 0, 0, 1));
>                 ctx->local_port = 82;
>                 return BPF_REDIRECT;
>         }
>
> That said, I appreciate that even if you find the sockets from XDP,
> you'd presumably need some way to retain the socket reference beyond
> XDP execution to convince the stack to guide the traffic into that
> socket, which would be a whole other effort. For your use case it may
> or may not make the most sense.

Granted we're just moving steering logic from one place to another, that
is from TPROXY rules to a BPF program.

The key here is that the BPF prog runs during inet_lookup.  This let's
"lower level" BPF progs like XDP or TC check if there is a destination
socket, without having to know about steering rules.

If there is a local socket, we don't need to do socket dispatch from
BPF. Just pass the packet up the stack.

-Jakub
