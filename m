Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61FEA6B502
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 05:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfGQDdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 23:33:45 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42543 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfGQDdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 23:33:44 -0400
Received: by mail-ot1-f67.google.com with SMTP id l15so23460099otn.9;
        Tue, 16 Jul 2019 20:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8CPbuVPaWNtVMd3y/JSmv6sUjdPmmstC/z9yympfjeI=;
        b=grU6WYsacXhHb187CpKlP/8hysTFwBfcg6ynGWS8dBSLJz7RJWF1sS9ZAK2UOUtrk2
         RNFJXDwtf4vrQJVZyttt32JBULD939ish+FNRryhYhFET5LNt7zGdSrzjNJHEljAS/Na
         S5mdzilZoCbtsggd3xupGBVJQ2eUK8+SUPEMsjrr/UCM7KL94/JFZ2x9glfNKflCIffG
         f8MCg4xxvfW/FygT0HpgzREZJIdXwrfX27G91OID4+pnhG+EerUQo3Exsmzgl52igEJC
         WfDjyPAAUezi9gaedFCEbWQ6Pz6iX4tF2h5uw0ZWXWKRh801QldSLPAKki0ebqFUvOsn
         uwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8CPbuVPaWNtVMd3y/JSmv6sUjdPmmstC/z9yympfjeI=;
        b=DZUx111/nHdH/ZwS1eYJoHf7pJw3eX+81XsJ9ej67Lc6kvxg3SWPNLGE5ZETOfHQDC
         eI3aHKWFftiemcNzMfmiZ7PCOFikoiOuvDt04wZ4oj897omcQNBRHl6o1dL5AoEmcm1Y
         UauDuUX81DGcsRJce5OJytfXTVWOkVfQwt1GuVmdqIyxr9f+FyUDWtAuo07DWjaCwQlb
         awdPjZk63XFIVTF/HzCQs/o/9aGSMv9IyTWtyaaednx3JSx1vSBcx1KVYBHHufxx4gYL
         5Wi1EPxuPDsK0GgoDfDnJKpMbDPXug+0OWUD/8/d3NBcF9rcfVrt3nGbHxO9lWkCGHR3
         tfWw==
X-Gm-Message-State: APjAAAVPT0szJpU1B7Bp+O+04jdl71dJHcbNLBLZCpmzgsdYlRtk+ZOl
        nsaJPqnodAZo5Ek/5HriNlXDsn3fEdaCJprjdIE=
X-Google-Smtp-Source: APXvYqwlYi1tcqQhC3uyI1ElDA0bB5/l65vMF+6ijl9StNDcZcTHpm9BBM8URkLVvbSAxFUFPW9imvgMT8uJkAvYsUk=
X-Received: by 2002:a05:6830:2099:: with SMTP id y25mr3686875otq.372.1563334424046;
 Tue, 16 Jul 2019 20:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
 <20190716002650.154729-4-ppenkov.kernel@gmail.com> <b6ef24b0-0415-c67d-5a66-21f1c2530414@gmail.com>
 <20190717022635.yt7kczxa73kbi7ep@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190717022635.yt7kczxa73kbi7ep@ast-mbp.dhcp.thefacebook.com>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Tue, 16 Jul 2019 20:33:33 -0700
Message-ID: <CAGdtWsRJF+MqOw8am3OboAKbVzrUrSHycQDf+kYLPxF6ww_Zpw@mail.gmail.com>
Subject: Re: [bpf-next RFC 3/6] bpf: add bpf_tcp_gen_syncookie helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your feedback!

On Tue, Jul 16, 2019 at 7:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jul 16, 2019 at 09:59:26AM +0200, Eric Dumazet wrote:
> >
> >
> > On 7/16/19 2:26 AM, Petar Penkov wrote:
> > > From: Petar Penkov <ppenkov@google.com>
> > >
> > > This helper function allows BPF programs to try to generate SYN
> > > cookies, given a reference to a listener socket. The function works
> > > from XDP and with an skb context since bpf_skc_lookup_tcp can lookup a
> > > socket in both cases.
> > >
> > ...
> > >
> > > +BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
> > > +      struct tcphdr *, th, u32, th_len)
> > > +{
> > > +#ifdef CONFIG_SYN_COOKIES
> > > +   u32 cookie;
> > > +   u16 mss;
> > > +
> > > +   if (unlikely(th_len < sizeof(*th)))
> >
> >
> > You probably need to check that th_len == th->doff * 4
>
> +1
> that is surely necessary for safety.

I'll make sure to include this check in the next version.

>
> Considering the limitation of 5 args the api choice is good.
> struct bpf_syncookie approach doesn't look natural to me.
> And I couldn't come up with any better way to represent this helper.
> So let's go with
> return htonl(cookie) | ((u64)mss << 32);
> My only question is why htonl ?

I did it to mirror bpf_tcp_check_syncookie which sees a network order
cookie. That said, it is probably better for the caller to call
bpf_htonl() as they see fit, rather than to do it in the helper. Will
update, thanks.
>
> Independently of that...
> Since we've been hitting this 5 args limit too much,
> we need to start thinking how to extend BPF ISA to pass
> args 6,7,8 on stack.
>

Agreed, having an additional argument would have been helpful for this function.
