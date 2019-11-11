Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E276F7846
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKKQCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:02:35 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41062 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfKKQCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 11:02:35 -0500
Received: by mail-pf1-f195.google.com with SMTP id p26so10957912pfq.8
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 08:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3G5SbZJ8bF1iZwVPpAj6qD+Dl19dBAzdEYbjRnrJ5BM=;
        b=bM+yTm+ivH4GXmAxLZjhTnAoOBCFybJY9zeCKQ+XVR7aDwdeV0yHJq2uKKaUhFkHzF
         rfcdFZB9LjTVTq9Ot/R7GXGsvCGpfj/XlbKso9I40dPddHDnRdGwK29XefwTmglgc4oG
         s93MpfKg9/5aRoNX/dw3EllM+0DcqPNGwf6u57FXtPwvEr7FvLmIW38RKhmLQT39kEbM
         FXG8gs/ZaJh3Rjx6HpRpqTXykmby0gwEuraUBmBQ0s10bohf9zQrvjztE4PlEPyfzaYP
         iRth4M/4vS8tFOwwJ3jbX7PXXjci6Pyt+fqhCRN42hzDVZGQYl0rPb3uu4k5Wy+63uJA
         9fnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3G5SbZJ8bF1iZwVPpAj6qD+Dl19dBAzdEYbjRnrJ5BM=;
        b=cHWrgou2OUj8GrnguGfqdmWJA+DTFk3VozC1+VLGOjrapYOfiULC1P59891wqFe8uR
         IXN0fvyNk+hARCRB7sXYgjfjeIl1O3J4qsHH5lle0ueIVhgUhbTFqI7D4QZap4ufkjBc
         MXaeT4X+xscv35Wb3fJYrtycAKbKmAZWavL8NRD/f+zB9kMXG91t360RnvjMYyn1QtDX
         +nDU3qh2BBkQ8eBlJ/8ARN1mqyvKhkqh1Ck9/hqZZbM6aDOokZQvMsjzK2kXL7TZIqaO
         UQZhF9/m40q13hVLg8Ww1eYvf0BwzQOc3aQDgCVZHpjM1R4tqsSjXSi5cfdOJV8q8Wmq
         YSuw==
X-Gm-Message-State: APjAAAWyDd5Z+TjHmKFfdecWgLCKsoclWHQyR3COk+u6zAJad0+rYl3a
        TkB2vXcjyj4oJ6HMEYH4KpwYvKhi
X-Google-Smtp-Source: APXvYqysIzLP8E6EjFa6hOmKpPql5Dpvsb9629WgCCzlntR6Pn7ZWjAlsP4STJOdFTxaTDkt+kM1NA==
X-Received: by 2002:aa7:9432:: with SMTP id y18mr815808pfo.250.1573488154951;
        Mon, 11 Nov 2019 08:02:34 -0800 (PST)
Received: from martin-VirtualBox ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id p16sm17065009pfn.171.2019.11.11.08.02.33
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 08:02:34 -0800 (PST)
Date:   Mon, 11 Nov 2019 21:32:22 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>, martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191111160222.GA2765@martin-VirtualBox>
References: <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191017132029.GA9982@martin-VirtualBox>
 <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
 <20191018082029.GA11876@martin-VirtualBox>
 <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
 <20191107133819.GA10201@martin-VirtualBox>
 <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
 <20191107161238.GA10727@martin-VirtualBox>
 <CAF=yD-JeCV-AW2HO9inJt-yePUrBGQ9=M58fYr8f2CDHdNNpaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-JeCV-AW2HO9inJt-yePUrBGQ9=M58fYr8f2CDHdNNpaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 11:35:07AM -0500, Willem de Bruijn wrote:
> On Thu, Nov 7, 2019 at 11:12 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > On Thu, Nov 07, 2019 at 10:53:47AM -0500, Willem de Bruijn wrote:
> > > > > I do think that with close scrutiny there is a lot more room for code
> > > > > deduplication. Just look at the lower half of geneve_rx and
> > > > > bareudp_udp_encap_recv, for instance. This, too, is identical down to
> > > > > the comments. Indeed, is it fair to say that geneve was taken as the
> > > > > basis for this device?
> > > > >
> > > > > That said, even just avoiding duplicating those routing functions
> > > > > would be a good start.
> > > > >
> > > > > I'm harping on this because in other examples in the past where a new
> > > > > device was created by duplicating instead of factoring out code
> > > > > implementations diverge over time in bad ways due to optimizations,
> > > > > features and most importantly bugfixes being applied only to one
> > > > > instance or the other. See for instance tun.c and tap.c.
> > > > >
> > > > > Unrelated, an ipv6 socket can receive both ipv4 and ipv6 traffic if
> > > > > not setting the v6only bit, so does the device need to have separate
> > > > > sock4 and sock6 members? Both sockets currently lead to the same
> > > > > bareudp_udp_encap_recv callback function.
> > > >
> > > > I was checking this.AF_INET6 allows v6 and v4 mapped v6 address.
> > > > And it doesnot allow both at the same time.So we need both
> > > > sockets to support v4 and v6 at the same time.correct ?
> > >
> > > bareudp_create_sock currently creates an inet socket listening on
> > > INADDR_ANY and an inet6 socket listening on in6addr_any with v6only.
> > > If so, just the latter without v6only should offer the same.
> >
> > To receive and ipv4 packet in AF_INET6 packet we need to pass v4 address
> > in v6 format( v4 mapped v6 address). Is it not ?
> 
> If the bareudp device binds to a specific port on all local addresses,
> which I think it's doing judging from what it passes to udp_sock_create
> (but I may very well be missing something), then in6addr_any alone will
> suffice to receive both v6 and v4 packets.

Must invokde udp_encap_enable explicitly from baredudp module during setup time.
Otherwise v4 packets will not land in encap_rcv handler.
