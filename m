Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE4FF34AF
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbfKGQfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:35:47 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42924 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729775AbfKGQfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:35:47 -0500
Received: by mail-ed1-f65.google.com with SMTP id m13so2403545edv.9
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SIvI27LhyhKETmiiueSBzxEo0JDGLhFf3krhpNog1Kw=;
        b=BcDg6v5A9keZXzQvMLjpZlpZ7JhDq7XYIOy12HrCgKWbFep56tAQ80qZ2zjdVQoWkK
         pCgTM28UhoaeiwRSY12EtdDqA9jkWfqzpAQpgEZYqsVaQPvl77bmzRs9MuhmkDL7aB2b
         hoqI57/uMnqwrEU33LVzxocbJrfQCAcUeTeHHxVzJe2t/OmZxwb13OVV9IkAYkwI+QGp
         sKfMf54pgC66AL4gMDekGRnCUdPgn9cKwxlRIjotD7sVQFm9tktAhGlqDLpk0MPUsS6i
         5lqGEzQSCtGafvW+h0q5GxrVLZ1yjUN/LYQ5dyItUrhE/+56SKa9eQBjscYW+pbAGI5R
         FOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SIvI27LhyhKETmiiueSBzxEo0JDGLhFf3krhpNog1Kw=;
        b=pAu26Ekn6QMUSWVed7Vm9qjcngNlEk5MDQcmccDbo+LP20NWREzf7aE8t9JLaZ5zxZ
         gC1mil71JjlPT7B+Jdj9tN4wwaycxfdJkdJr50aEAyTM432JO6Ks2WohDOD24jSUURC9
         6Jw1Wvt3qRI/i9zn0doTGbxft5aCf3LRaUbwMly/5SSg60IWx8i7nSJ2JbJao0VgFKQz
         jR9HX4OEPO4LW3eVjIQxgXrM8FMJpNyTmhP6gtn4h8KY1MfmQe1JpA1UGyVa4JZSVQuG
         kl3GrDmPosqMpvbWEWHaAYp/YH5ialHWemrPINyESBWiWWNQJ07k7nQ1dBitCc0mKP7C
         kkvQ==
X-Gm-Message-State: APjAAAVTtJ0O9XnGgaGX4bm2SXu+ztr4UG0fbK6U1Ue4PDhwpI0btv52
        LKj5ybwTlK73yUH7VJVCE//7rg4Rc17wZpALndg=
X-Google-Smtp-Source: APXvYqxmDmtamjL8+oiv4RkDpx2v/8K3rgfdEEqWyyuZIW+3ISjxWJXB5VzG3ZrRwjDkUfKffYxhVZ3rg74JcZmHP/M=
X-Received: by 2002:a05:6402:134f:: with SMTP id y15mr4692043edw.147.1573144543773;
 Thu, 07 Nov 2019 08:35:43 -0800 (PST)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191017132029.GA9982@martin-VirtualBox> <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
 <20191018082029.GA11876@martin-VirtualBox> <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
 <20191107133819.GA10201@martin-VirtualBox> <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
 <20191107161238.GA10727@martin-VirtualBox>
In-Reply-To: <20191107161238.GA10727@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 Nov 2019 11:35:07 -0500
Message-ID: <CAF=yD-JeCV-AW2HO9inJt-yePUrBGQ9=M58fYr8f2CDHdNNpaA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>, martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 11:12 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Thu, Nov 07, 2019 at 10:53:47AM -0500, Willem de Bruijn wrote:
> > > > I do think that with close scrutiny there is a lot more room for code
> > > > deduplication. Just look at the lower half of geneve_rx and
> > > > bareudp_udp_encap_recv, for instance. This, too, is identical down to
> > > > the comments. Indeed, is it fair to say that geneve was taken as the
> > > > basis for this device?
> > > >
> > > > That said, even just avoiding duplicating those routing functions
> > > > would be a good start.
> > > >
> > > > I'm harping on this because in other examples in the past where a new
> > > > device was created by duplicating instead of factoring out code
> > > > implementations diverge over time in bad ways due to optimizations,
> > > > features and most importantly bugfixes being applied only to one
> > > > instance or the other. See for instance tun.c and tap.c.
> > > >
> > > > Unrelated, an ipv6 socket can receive both ipv4 and ipv6 traffic if
> > > > not setting the v6only bit, so does the device need to have separate
> > > > sock4 and sock6 members? Both sockets currently lead to the same
> > > > bareudp_udp_encap_recv callback function.
> > >
> > > I was checking this.AF_INET6 allows v6 and v4 mapped v6 address.
> > > And it doesnot allow both at the same time.So we need both
> > > sockets to support v4 and v6 at the same time.correct ?
> >
> > bareudp_create_sock currently creates an inet socket listening on
> > INADDR_ANY and an inet6 socket listening on in6addr_any with v6only.
> > If so, just the latter without v6only should offer the same.
>
> To receive and ipv4 packet in AF_INET6 packet we need to pass v4 address
> in v6 format( v4 mapped v6 address). Is it not ?

If the bareudp device binds to a specific port on all local addresses,
which I think it's doing judging from what it passes to udp_sock_create
(but I may very well be missing something), then in6addr_any alone will
suffice to receive both v6 and v4 packets.
