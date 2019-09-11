Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1679AF8CA
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfIKJWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:22:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51403 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfIKJWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:22:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so2540261wme.1;
        Wed, 11 Sep 2019 02:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cEOeOSd4Ik4bMNziS3DThefWVr3MCXaQq7R7Jwknde0=;
        b=UhBSwhnKAT2Yz084eoYiJzC/GgXO4jCafZJKxBXaS3Z1bsibm2x4AFmwL3QzhKkcTI
         5r7JIderxk7/eIXsX20PfyypPBTf5kbfGEZDS72WmUvM6CIE5FTseGj1CO/JS3p4e/Se
         UWSgvLlQoH9pKtEf1rQCVhnUCGt38n3r1gIpKVeVcjvDYcwshdIwYuBNCRA6q7HFFMg2
         ulinhHs71iiLNGnPS3+1ebdafCGk3AQ4WmGu1ObjcyLgiGkuEhQ5LOQqIEkae5ZFDpXr
         Wd/WmVe6GFkJCRq/XjajGWzHPQDfdI6ZZUfsf5KXVsJQEvtjCNTHRDyzRMGJKTV6AGVL
         mMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cEOeOSd4Ik4bMNziS3DThefWVr3MCXaQq7R7Jwknde0=;
        b=ChuImZY5O5exiZdrRJRf2lxBN3x5Glm2q379hPRN4WSuicBK4U/k9egB1pBgWckrzf
         t+xCeM89dB2p7y3ndpJteRcIClOnKi4LIJL+ZKUZy+tyO1uZTi5drCY6b0hycVYBTC47
         JoAdmXSTDijzqiyA7qfdfo+pWzQ8T5/h+4jBhYVjndVpSFgREsr0WP+sMxWRFgz7iti7
         jx/l5biicCV2txK16FptQQrXboKApHeHaoKG4goekqSmsz3FgWWcSbgI9nfYauxJB1T7
         ebDbw4EZCJPWR/VW5tIb4wBQ5s5gQNMqCiX8i0uIKmd1GEl2SobPsXkGBmyLdXwcJlOf
         iiiw==
X-Gm-Message-State: APjAAAXbVtkrNj7AAXWrZty6oNYGwjEdRD63fKtb5qL3v0uoIByEoRHh
        Qt7ltth0Tos3Lju1hfhsDUF20gYQm39/mwNiqWU=
X-Google-Smtp-Source: APXvYqwqWlgQsgm/1aBZDOv06MPrsq2EhgQhN22VHgwr0X1pkJWwqeu68g4q8mNJjOKjYCOWsRuRtUo2e7/0arz/PVk=
X-Received: by 2002:a1c:9a4a:: with SMTP id c71mr2849196wme.99.1568193731121;
 Wed, 11 Sep 2019 02:22:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568015756.git.lucien.xin@gmail.com> <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com> <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
In-Reply-To: <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 11 Sep 2019 17:21:59 +0800
Message-ID: <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
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

On Wed, Sep 11, 2019 at 5:03 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Xin Long [mailto:lucien.xin@gmail.com]
> > Sent: 11 September 2019 09:52
> > On Tue, Sep 10, 2019 at 9:19 PM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Xin Long
> > > > Sent: 09 September 2019 08:57
> > > > Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
> > > > Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
> > > > added to allow a user to change ps_retrans per sock/asoc/transport, as
> > > > other 2 paddrthlds: pf_retrans, pathmaxrxt.
> > > >
> > > > Note that ps_retrans is not allowed to be greater than pf_retrans.
> > > >
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > ---
> > > >  include/uapi/linux/sctp.h |  1 +
> > > >  net/sctp/socket.c         | 10 ++++++++++
> > > >  2 files changed, 11 insertions(+)
> > > >
> > > > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > > > index a15cc28..dfd81e1 100644
> > > > --- a/include/uapi/linux/sctp.h
> > > > +++ b/include/uapi/linux/sctp.h
> > > > @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
> > > >       struct sockaddr_storage spt_address;
> > > >       __u16 spt_pathmaxrxt;
> > > >       __u16 spt_pathpfthld;
> > > > +     __u16 spt_pathcpthld;
> > > >  };
> > > >
> > > >  /*
> > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > index 5e2098b..5b9774d 100644
> > > > --- a/net/sctp/socket.c
> > > > +++ b/net/sctp/socket.c
> > > > @@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
> > >
> > > This code does:
> > >         if (optlen < sizeof(struct sctp_paddrthlds))
> > >                 return -EINVAL;
> > here will become:
> >
> >         if (optlen >= sizeof(struct sctp_paddrthlds)) {
> >                 optlen = sizeof(struct sctp_paddrthlds);
> >         } else if (optlen >= ALIGN(offsetof(struct sctp_paddrthlds,
> >                                             spt_pathcpthld), 4))
> >                 optlen = ALIGN(offsetof(struct sctp_paddrthlds,
> >                                         spt_pathcpthld), 4);
> >                 val.spt_pathcpthld = 0xffff;
> >         else {
> >                 return -EINVAL;
> >         }
>
> Hmmm...
> If the kernel has to default 'val.spt_pathcpthld = 0xffff'
> then recompiling an existing application with the new uapi
> header is going to lead to very unexpected behaviour.
>
> The best you can hope for is that the application memset the
> structure to zero.
> But more likely it is 'random' on-stack data.
0xffff is a value to disable the feature 'Primary Path Switchover'.
you're right that user might set it to zero unexpectly with their
old application rebuilt.

A safer way is to introduce "sysctl net.sctp.ps_retrans", it won't
matter if users set spt_pathcpthld properly when they're not aware
of this feature, like "sysctl net.sctp.pF_retrans". Looks better?

>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
