Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AB9AF91A
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfIKJis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:38:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40549 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKJir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:38:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id t9so2655118wmi.5;
        Wed, 11 Sep 2019 02:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0VSq6wzpqVphAUFzEFjRzbUISsot67T98l5ng0C/wE=;
        b=U5KknNKvccQJYVw1LQE4PChuTukeCSmWPnsQljIKSLDmQYYmQZgBZlunmQmqlMWyEw
         KMoSTCCYhEOt/+6e+cVUdk5q4MtpW4SCFQr5CqFP2++mzKBLmUdDS4EZAbH/L/ce+3bJ
         LQkQlpSFm9RZQUMdzoo3DkaHWBzcQDBmBTri0Xd4sjdhsiv5xTpWvbghkBn6xzlVwe1l
         xPmTk37mMxzdhGkn/C+GuLJnpFGCq1Fke4X159Y9k02bWNgIgI0bxlqPt/snuD9o4PZl
         Erk3ReX0BECbbqT0JmX+I/SDhN9RmI0fdfqCK14OvUDPa3NjO7jMJePajJ50HSvT4sUJ
         dSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0VSq6wzpqVphAUFzEFjRzbUISsot67T98l5ng0C/wE=;
        b=sQXx7SspZattXfheSSMxuj83KNJY5adkdX89MP0QxC6H0lK0YahtqY3Ft3fNpvJt/r
         UOE4XsQkhdc0m20IHvR/8yzlNj336Z9eOpmwDnazq30J7VBSpklZaDkdHw0aPwoskN5x
         Kz0KrGBJ/OGijzuF6tQZithoYb6ta6uk3cmd+Kd3QlJ+8Ik4fpFsjWJHjwuAHb26xN3G
         V2zroJjt0gxUcJ4on3GRFVfD7Ls00ovcQKSYsuu0VJk8URgLsXozyUQlOMfal+wKDve0
         NAU+9sLZsdgUCNsV/7rRp9hlBMnOLIhSROy4JfPdO2Q5X3kz8oeZt8SP/jJx/7lO8Ves
         pZgw==
X-Gm-Message-State: APjAAAUp4Q1x+1R51Y3ZIjb5e4GlRUXF0xPqT0TsUyQaa3b9hIehXuAi
        4qxKyTy360Kyk6asF3C95/lN6htpYQ82xZ93ETk=
X-Google-Smtp-Source: APXvYqyXKK7x+Ht8Y1eaFKpgp6nxeUR1UIrsAGVqupzqtGBh4a3rNdkoc/BslgYbNEF6Pe9qMrtL5UtJceuub+xc13k=
X-Received: by 2002:a1c:a74f:: with SMTP id q76mr3278586wme.16.1568194724725;
 Wed, 11 Sep 2019 02:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568015756.git.lucien.xin@gmail.com> <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com> <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com> <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
In-Reply-To: <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 11 Sep 2019 17:38:33 +0800
Message-ID: <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
To:     David Laight <David.Laight@aculab.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 5:21 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Wed, Sep 11, 2019 at 5:03 PM David Laight <David.Laight@aculab.com> wrote:
> >
> > From: Xin Long [mailto:lucien.xin@gmail.com]
> > > Sent: 11 September 2019 09:52
> > > On Tue, Sep 10, 2019 at 9:19 PM David Laight <David.Laight@aculab.com> wrote:
> > > >
> > > > From: Xin Long
> > > > > Sent: 09 September 2019 08:57
> > > > > Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
> > > > > Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
> > > > > added to allow a user to change ps_retrans per sock/asoc/transport, as
> > > > > other 2 paddrthlds: pf_retrans, pathmaxrxt.
> > > > >
> > > > > Note that ps_retrans is not allowed to be greater than pf_retrans.
> > > > >
> > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > ---
> > > > >  include/uapi/linux/sctp.h |  1 +
> > > > >  net/sctp/socket.c         | 10 ++++++++++
> > > > >  2 files changed, 11 insertions(+)
> > > > >
> > > > > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > > > > index a15cc28..dfd81e1 100644
> > > > > --- a/include/uapi/linux/sctp.h
> > > > > +++ b/include/uapi/linux/sctp.h
> > > > > @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
> > > > >       struct sockaddr_storage spt_address;
> > > > >       __u16 spt_pathmaxrxt;
> > > > >       __u16 spt_pathpfthld;
> > > > > +     __u16 spt_pathcpthld;
> > > > >  };
> > > > >
> > > > >  /*
> > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > index 5e2098b..5b9774d 100644
> > > > > --- a/net/sctp/socket.c
> > > > > +++ b/net/sctp/socket.c
> > > > > @@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
> > > >
> > > > This code does:
> > > >         if (optlen < sizeof(struct sctp_paddrthlds))
> > > >                 return -EINVAL;
> > > here will become:
> > >
> > >         if (optlen >= sizeof(struct sctp_paddrthlds)) {
> > >                 optlen = sizeof(struct sctp_paddrthlds);
> > >         } else if (optlen >= ALIGN(offsetof(struct sctp_paddrthlds,
> > >                                             spt_pathcpthld), 4))
> > >                 optlen = ALIGN(offsetof(struct sctp_paddrthlds,
> > >                                         spt_pathcpthld), 4);
> > >                 val.spt_pathcpthld = 0xffff;
> > >         else {
> > >                 return -EINVAL;
> > >         }
> >
> > Hmmm...
> > If the kernel has to default 'val.spt_pathcpthld = 0xffff'
> > then recompiling an existing application with the new uapi
> > header is going to lead to very unexpected behaviour.
> >
> > The best you can hope for is that the application memset the
> > structure to zero.
> > But more likely it is 'random' on-stack data.
> 0xffff is a value to disable the feature 'Primary Path Switchover'.
> you're right that user might set it to zero unexpectly with their
> old application rebuilt.
>
> A safer way is to introduce "sysctl net.sctp.ps_retrans", it won't
> matter if users set spt_pathcpthld properly when they're not aware
> of this feature, like "sysctl net.sctp.pF_retrans". Looks better?
Sorry for confusing,  "sysctl net.sctp.ps_retrans" is already there
(its value is 0xffff by default),
we just need to do this in sctp_setsockopt_paddr_thresholds():

        if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
                           optlen))
                return -EFAULT;

        if (sock_net(sk)->sctp.ps_retrans == 0xffff)
                val.spt_pathcpthld = 0xffff;

        if (val.spt_pathpfthld > val.spt_pathcpthld)
                return -EINVAL;

>
> >
> >         David
> >
> > -
> > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > Registration No: 1397386 (Wales)
