Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB74AF346D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbfKGQMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:12:47 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45336 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbfKGQMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:12:46 -0500
Received: by mail-pg1-f195.google.com with SMTP id w11so2358082pga.12
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TpQ63ti9TON4o8cdWL6ah7I28dRiiFkoqX7ERzZp3f8=;
        b=aByvJMSmmKVpbf57KddE1jzZHTpecHQNMKm/pj8/z8ifjjGdnSKQCz0JZIJS9cLkI0
         6LP0B9cldpvYaunTj/jU/Lbv3DF/F2JvUKV3Pb9cVXHcDniaSsfobgui4wJuHCV1KqVT
         5ky26UkGb2Fh2+JyJe350FprOmvsL6EhtWdn3zBUIiBTJ1jsVValRNLbNbo+3oDEBJOQ
         KwcNdsNKwb6VBFL8vXNoVgYJCfJQS1IoWwrGkz6lev0YFv4mYIJ2syeEe4OCQNjsQbTC
         Ec0gCozUTaYTdptR1uS86upt/0ZGbXim4Gsl5Xxr8USeRAzV4+nfeH/IYC3DZpuBzxiW
         gVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TpQ63ti9TON4o8cdWL6ah7I28dRiiFkoqX7ERzZp3f8=;
        b=f27pcwoDLb9vXjBq4DQuSFTz+CIS7iRnJNWiaqEexpe/DLaRpox67kQlXXtwIyb3xA
         QEtD6Lewfz/4F/eHoGDjTY5lp9U/OwVeUUMQ+0R4JNdMkBDDXUMMX187Y/QLdsSzxoa1
         ezfklJuC3bC+W1Qm95qnZ5l9/gFl02Gn6RodfqiMxXBkGJNthdEmutPj/ros5Vj3ngbv
         K5LJBk3nDZFthfARPqjaBfGb7tDl0Et4/sRoTUj2zhSVEGLueACDb9ELBrUzpJYpqANf
         Vj/nrXc7R+546WVKPzwFnbFWvYQj922QFgQU9KBPfo1J7xU2rS64rEkipN/TtS09XmFn
         CJfg==
X-Gm-Message-State: APjAAAVyCNdu6D1v25TSPrYG3C4BZxlfqAWgjlHws9E6rTQ3GI62oxC5
        0c2o3LqowJp6/c4LRGlQPOU=
X-Google-Smtp-Source: APXvYqxJgNRAtNDlkaaP264HqpZmZtG8YJwOI5MprjI8XKtHPJFkgqAgWSQ4NKvMg/H1f4kSzelobA==
X-Received: by 2002:a63:66c1:: with SMTP id a184mr5472626pgc.164.1573143165955;
        Thu, 07 Nov 2019 08:12:45 -0800 (PST)
Received: from martin-VirtualBox ([106.201.53.22])
        by smtp.gmail.com with ESMTPSA id z62sm4366265pfz.135.2019.11.07.08.12.43
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 07 Nov 2019 08:12:44 -0800 (PST)
Date:   Thu, 7 Nov 2019 21:42:38 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>, martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191107161238.GA10727@martin-VirtualBox>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191017132029.GA9982@martin-VirtualBox>
 <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
 <20191018082029.GA11876@martin-VirtualBox>
 <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
 <20191107133819.GA10201@martin-VirtualBox>
 <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 10:53:47AM -0500, Willem de Bruijn wrote:
> > > I do think that with close scrutiny there is a lot more room for code
> > > deduplication. Just look at the lower half of geneve_rx and
> > > bareudp_udp_encap_recv, for instance. This, too, is identical down to
> > > the comments. Indeed, is it fair to say that geneve was taken as the
> > > basis for this device?
> > >
> > > That said, even just avoiding duplicating those routing functions
> > > would be a good start.
> > >
> > > I'm harping on this because in other examples in the past where a new
> > > device was created by duplicating instead of factoring out code
> > > implementations diverge over time in bad ways due to optimizations,
> > > features and most importantly bugfixes being applied only to one
> > > instance or the other. See for instance tun.c and tap.c.
> > >
> > > Unrelated, an ipv6 socket can receive both ipv4 and ipv6 traffic if
> > > not setting the v6only bit, so does the device need to have separate
> > > sock4 and sock6 members? Both sockets currently lead to the same
> > > bareudp_udp_encap_recv callback function.
> >
> > I was checking this.AF_INET6 allows v6 and v4 mapped v6 address.
> > And it doesnot allow both at the same time.So we need both
> > sockets to support v4 and v6 at the same time.correct ?
> 
> bareudp_create_sock currently creates an inet socket listening on
> INADDR_ANY and an inet6 socket listening on in6addr_any with v6only.
> If so, just the latter without v6only should offer the same.

To receive and ipv4 packet in AF_INET6 packet we need to pass v4 address 
in v6 format( v4 mapped v6 address). Is it not ?
