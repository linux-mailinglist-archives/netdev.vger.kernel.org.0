Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59D3FC72F
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKNNS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:18:27 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38751 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfKNNS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 08:18:26 -0500
Received: by mail-pf1-f195.google.com with SMTP id c13so4240558pfp.5
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 05:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mNI7IPu4979kITAsZDwXnJ4y7ka/DU4pEu/Wrjdo0Ao=;
        b=ZXtX7QElSOhlrAqB/ugMZKBEEKa3+pDMu8MhCWw01Bvy3Vx+pQ7IxZGKEM2W37a82f
         ybwt6WsY5NjjWqMqYhvQSZMcLX8X8lD1gbLquBWxNG8g8rNsBJBIdC9uJD6OfevXiqPS
         v+CWjMr/rc/d3OWp9Ujo+WqkBo5pTW9UZ7ZOal3rQhwmKpcJg7XGSvbsx8G/RuBYuGtv
         Mir9IuleopHbsjU4hC8JygL7H4h+kff/7vLm/07BUwVacP4SKd3YiSrP98C/ofEDR03e
         g0+yTAWbsaCj/Hz/7z7ioVIcd76oiH9k0Eh7LGCr1W13JCBzpVe3bURZOT666qT3f3aN
         RwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mNI7IPu4979kITAsZDwXnJ4y7ka/DU4pEu/Wrjdo0Ao=;
        b=taYkGlLUZulinrGoZqd0lySBmpybaoncq1hGZT5GCh1zIP5EAS5pOjAgSqDLp36kp4
         DcWpbXEiYcN6F/KdLKltW0jF4TRDaBGsUL8wTWKJ0pwYkt7TsKXqVz2OntLLvhfLjtPo
         0rvWDQpDpMKhcRdywCxehx3EFQ2K2LJKxCyQ6jes6r37YNbj77Q29+ueasjbZFxg9W5H
         rkKQzesORrwo8UAY8nz2pcTNgnyJ8SQZ0IzQ9+rt+Ii5fMMD1GoDDiHF7Gs7Av4Gzj/e
         XPeO/q8cpk9KO3FASdT/XtKR7DBKCANAB/6/g1AAae5MwHl3mrLFx0WFqTbgCc1+zzOs
         fJpQ==
X-Gm-Message-State: APjAAAXd4EV3yAWue2VugdkyaBw7QkhKmxOlBDaxie/IYqAl8AZ6fAt9
        bZlp+g/lLQUgUQlTdOqDROQ=
X-Google-Smtp-Source: APXvYqyqvklV60Vsv+J7+4YoptS4tGp3nrBIW2u6ujS1+NqMZYshRr8XqNOo1rd+NZDekjgAhYc2yA==
X-Received: by 2002:a17:90a:8a0c:: with SMTP id w12mr1075681pjn.63.1573737505665;
        Thu, 14 Nov 2019 05:18:25 -0800 (PST)
Received: from martin-VirtualBox ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id v3sm8528639pfi.26.2019.11.14.05.18.24
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 05:18:25 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:47:49 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>, martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191114131749.GA9443@martin-VirtualBox>
References: <20191017132029.GA9982@martin-VirtualBox>
 <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
 <20191018082029.GA11876@martin-VirtualBox>
 <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
 <20191107133819.GA10201@martin-VirtualBox>
 <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
 <20191107161238.GA10727@martin-VirtualBox>
 <CAF=yD-JeCV-AW2HO9inJt-yePUrBGQ9=M58fYr8f2CDHdNNpaA@mail.gmail.com>
 <20191111160222.GA2765@martin-VirtualBox>
 <CAF=yD-KhfRr6Qd8ZMYhKDQ6v=61mTHHXJdhCkMhahULmgcuqDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-KhfRr6Qd8ZMYhKDQ6v=61mTHHXJdhCkMhahULmgcuqDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 04:45:30PM -0500, Willem de Bruijn wrote:
> On Mon, Nov 11, 2019 at 11:02 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Thu, Nov 07, 2019 at 11:35:07AM -0500, Willem de Bruijn wrote:
> > > On Thu, Nov 7, 2019 at 11:12 AM Martin Varghese
> > > <martinvarghesenokia@gmail.com> wrote:
> > > >
> > > > On Thu, Nov 07, 2019 at 10:53:47AM -0500, Willem de Bruijn wrote:
> > > > > > > I do think that with close scrutiny there is a lot more room for code
> > > > > > > deduplication. Just look at the lower half of geneve_rx and
> > > > > > > bareudp_udp_encap_recv, for instance. This, too, is identical down to
> > > > > > > the comments. Indeed, is it fair to say that geneve was taken as the
> > > > > > > basis for this device?
> > > > > > >
> > > > > > > That said, even just avoiding duplicating those routing functions
> > > > > > > would be a good start.
> > > > > > >
> > > > > > > I'm harping on this because in other examples in the past where a new
> > > > > > > device was created by duplicating instead of factoring out code
> > > > > > > implementations diverge over time in bad ways due to optimizations,
> > > > > > > features and most importantly bugfixes being applied only to one
> > > > > > > instance or the other. See for instance tun.c and tap.c.
> > > > > > >
> > > > > > > Unrelated, an ipv6 socket can receive both ipv4 and ipv6 traffic if
> > > > > > > not setting the v6only bit, so does the device need to have separate
> > > > > > > sock4 and sock6 members? Both sockets currently lead to the same
> > > > > > > bareudp_udp_encap_recv callback function.
> > > > > >
> > > > > > I was checking this.AF_INET6 allows v6 and v4 mapped v6 address.
> > > > > > And it doesnot allow both at the same time.So we need both
> > > > > > sockets to support v4 and v6 at the same time.correct ?
> > > > >
> > > > > bareudp_create_sock currently creates an inet socket listening on
> > > > > INADDR_ANY and an inet6 socket listening on in6addr_any with v6only.
> > > > > If so, just the latter without v6only should offer the same.
> > > >
> > > > To receive and ipv4 packet in AF_INET6 packet we need to pass v4 address
> > > > in v6 format( v4 mapped v6 address). Is it not ?
> > >
> > > If the bareudp device binds to a specific port on all local addresses,
> > > which I think it's doing judging from what it passes to udp_sock_create
> > > (but I may very well be missing something), then in6addr_any alone will
> > > suffice to receive both v6 and v4 packets.
> >
> > Must invokde udp_encap_enable explicitly from baredudp module during setup time.
> > Otherwise v4 packets will not land in encap_rcv handler.
> 
> The call to setup_udp_tunnel_sock should take care of that. The issue
> is probably that in udp_tunnel_encap_enable:
> 
>   #if IS_ENABLED(CONFIG_IPV6)
>         if (sock->sk->sk_family == PF_INET6)
>                 ipv6_stub->udpv6_encap_enable();
>         else
>   #endif
>                 udp_encap_enable();
> 
> does not call udp_encap_enable for IPv6 sockets. Likely because
> existing callers like vxlan always pass v6only = 1. Due to dual stack,
> PF_INET6 should enable both static keys.

Thanks for your time.
