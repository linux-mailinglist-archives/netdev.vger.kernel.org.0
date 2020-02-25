Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2154516EC0D
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 18:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbgBYREt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 12:04:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56119 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbgBYREt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 12:04:49 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so3792284wmj.5
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 09:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LJtC2d8Tgl9SMIeNolxrnrmr4wVdKFfSAoQKbJsgTEs=;
        b=WvxfxrKy0JCG/DzhnfzOPifDUcoUqjDPkUB3FliVy9S/+3pac4P1vVe2YJGy2xvTpP
         X46BLpK5Asuz/3I4nTB3aOqjPGZKJ42zVFr2UIsTYPn3pUhhh76EMnMWK8a/aa3q9RnD
         D5XGNWspHeGc2MmUODPYZbEMmEh4oKQJMlmzGoWx56uE6K5fDM6TJbhEyDIGbZY8Zpgt
         asVbN220BLUge6NdCsiJxCznQ2qoqkeD/bEfHE95rlmuv0HDOlnIgVSd+gsAFcBrc/ow
         /I3WMYT7EIGeHrqbVyfbfRQPZsIZds0a9t7qOrO+2P+t7089rzOqGt58ff6Wcn9nA8yE
         6a8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LJtC2d8Tgl9SMIeNolxrnrmr4wVdKFfSAoQKbJsgTEs=;
        b=UNfzqjpChuZ21XvWMjBon0Pg7ig8X25SqaAj4StrtKm2hmNdGNMEiQuaM0WXDzqIdA
         0thbQkVQuBStB735O3qHZJ1uhfYsNAl4marroSezmPVB9oqdt+5KlmSSEv3GeDxjANEp
         62kMSVNd+hMWc85+r6DtZTq/+JbIz9TuN0nRz0DLP6H6ts/TrXqhcRw6ThstsWvlBTGC
         He0jRldoq5XadDkH/jwG7DDKk0ZlPu9Guy88z0g/2k0t7VrwKkigEk7OWRAaxxT0Buni
         gwDoYfV52ZM/wZDK5ywT7aXKqJ3QwHG3UutSSBc/1lhsNQcgw4sXFnMkla0vhSxi/UTg
         Wpiw==
X-Gm-Message-State: APjAAAXA7t2m/wybJWL9gC9SzY5uV7GDakGfoSx1UzTUmZuQApSqXCm7
        agI8E3MXBVzSR1UKJmu5EfJgxRg/yVur1zFr88btCA==
X-Google-Smtp-Source: APXvYqxpsG2JhumZdgdL/UiLMINUnYLE034HV9AwBs2b+hmlF14MNN1mzoTS/aV/yMAeom0+RzItlzTrhDz+y/X/kV8=
X-Received: by 2002:a1c:541b:: with SMTP id i27mr212660wmb.137.1582650286266;
 Tue, 25 Feb 2020 09:04:46 -0800 (PST)
MIME-Version: 1.0
References: <20200225060620.76486-1-arjunroy.kdev@gmail.com>
 <CANn89iLrOwvNSHOB2i_+gMmN29O6BpJrnd9RfNERDTayNf7qKA@mail.gmail.com> <CAOFY-A35RJOwg_4Vqc1SzeGb83OoWG-LE+dJb1maRPauaLLNwQ@mail.gmail.com>
In-Reply-To: <CAOFY-A35RJOwg_4Vqc1SzeGb83OoWG-LE+dJb1maRPauaLLNwQ@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Tue, 25 Feb 2020 09:04:34 -0800
Message-ID: <CAOFY-A0DXFse8=Mm0fx6kxAvsFZ=AzT96_P+WT=ctSESBncNjA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp-zerocopy: Update returned getsockopt() optlen.
To:     Eric Dumazet <edumazet@google.com>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 8:48 AM Arjun Roy <arjunroy@google.com> wrote:
>
> On Mon, Feb 24, 2020 at 10:28 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Feb 24, 2020 at 10:06 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> > >
> > > From: Arjun Roy <arjunroy@google.com>
> > >
> > > TCP receive zerocopy currently does not update the returned optlen for
> > > getsockopt(). Thus, userspace cannot properly determine if all the
> > > fields are set in the passed-in struct. This patch sets the optlen
> > > before return, in keeping with the expected operation of getsockopt().
> > >
> > > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive
> > > zerocopy")
> >
> >
> > OK, please note for next time :
> >
> > Fixes: tag should not wrap : It should be a single line.
> > Preferably it should be the first tag (before your Sob)
> >
> > Add v2 as in [PATCH v2 net-next]  :  so that reviewers can easily see
> > which version is the more recent one.
> >
> >
> > >
> > > +               if (!err) {
> > > +                       if (put_user(len, optlen))
> > > +                               return -EFAULT;
> >
> > Sorry for not asking this before during our internal review :
> >
> > Is the cost of the extra STAC / CLAC (on x86) being high enough that it is worth
> > trying to call put_user() only if user provided a different length ?
>
> I'll have to defer to someone with more understanding of the overheads
> involved in this case.
>

Actually, now that I think about it, the (hopefully) common case is
indeed that the kernel and userspace agree on the size of the struct,
so I think just having just that one extra branch to check before
issuing a put_user() would be well worth it compared to all the
instructions in put_user(). I'll send a v2 patch with the change.

Thanks,
-Arjun

> -Arjun
