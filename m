Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673B4AFD34
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 14:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728044AbfIKM4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 08:56:15 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35429 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727342AbfIKM4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 08:56:14 -0400
Received: by mail-qt1-f193.google.com with SMTP id k10so25113948qth.2;
        Wed, 11 Sep 2019 05:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DHid+Hq14iyHeuxYN8d4pguqYwBVr1eAD1WfWuiNqm0=;
        b=c+LV/jDrRJi6JwWqxIUyt6lq4HkqJthkrJLQPluqCce0qUXBh6GOgJlMsIwDaFXKsr
         WywxK+8+ytCROmJMXpklUW32dSAoUGtQNp/d6ZNWEB1kT21/bY4gZcQCoDatef51li40
         o6E/BGQdwcYPoa+SSbuj1eIRmBOJwFjgZS066Kn/b0hYNrqgCVzh9Jnguep2VswixAj3
         A1SaS9vqsq+jmeyReBvr+wi2+JvbyOtjZQqMYXDLWUJQexwTW5zMVblEz0fmGGzaCZia
         h90tGX9VLBEcq/Xb/8S4waeVbvm3mirDKLixDdUz3JSNoIEKSnQ1lNkbZf3lgLo2kdw+
         zSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DHid+Hq14iyHeuxYN8d4pguqYwBVr1eAD1WfWuiNqm0=;
        b=MZzXKEwb8E4Fnw6FB13JAhhqPmSfURylJR+kvtyNvE2E9wa5M3IcXmjkP/0GcB88DR
         4AnNYr1R3VBDKR5x2QECN4AEzwtdwxHl7I/RxSi3963hhBegAIVw3dTxfJttm+yUheki
         LNRb5DhMJX7259Sgg+NPcsfdDh4+qjMei61pLESRr6kfTgAgVKr6WNbBdqwoS3NFNWVs
         vAriFznkCYU2l3rG3wxGePWrrsy8aDbNdTP1DNDTDBgnxHvh/jIrETBTpDNQO/XR2v05
         gi2t2P6UCHwfsdBmjDLG74maitx2BaqkXoddw6DUbVIEfebm3XXtMl/VQziW6iV9Rh2I
         4Unw==
X-Gm-Message-State: APjAAAXV0VpaD/7k5pOlkuLV1agx5aQwjsZa+xd66EFhtIi3WahTs3kT
        /BdppybNONQ3ChAPZ+28VUbF1vDzeFQ=
X-Google-Smtp-Source: APXvYqwRdIPxNz/8I4OyD+3WqiFs6kF3EGvHbcp/oHZsG2/Bli7bI7W+n3UZ91eqW1va8Ti2O0BBWw==
X-Received: by 2002:a0c:9e20:: with SMTP id p32mr8778548qve.39.1568206573307;
        Wed, 11 Sep 2019 05:56:13 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.89])
        by smtp.gmail.com with ESMTPSA id a4sm14765215qtb.17.2019.09.11.05.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 05:56:12 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id E711BC4A64; Wed, 11 Sep 2019 09:56:09 -0300 (-03)
Date:   Wed, 11 Sep 2019 09:56:09 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Message-ID: <20190911125609.GC3499@localhost.localdomain>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
 <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
 <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
 <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 05:38:33PM +0800, Xin Long wrote:
> On Wed, Sep 11, 2019 at 5:21 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Wed, Sep 11, 2019 at 5:03 PM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Xin Long [mailto:lucien.xin@gmail.com]
> > > > Sent: 11 September 2019 09:52
> > > > On Tue, Sep 10, 2019 at 9:19 PM David Laight <David.Laight@aculab.com> wrote:
> > > > >
> > > > > From: Xin Long
> > > > > > Sent: 09 September 2019 08:57
> > > > > > Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
> > > > > > Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
> > > > > > added to allow a user to change ps_retrans per sock/asoc/transport, as
> > > > > > other 2 paddrthlds: pf_retrans, pathmaxrxt.
> > > > > >
> > > > > > Note that ps_retrans is not allowed to be greater than pf_retrans.
> > > > > >
> > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > ---
> > > > > >  include/uapi/linux/sctp.h |  1 +
> > > > > >  net/sctp/socket.c         | 10 ++++++++++
> > > > > >  2 files changed, 11 insertions(+)
> > > > > >
> > > > > > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > > > > > index a15cc28..dfd81e1 100644
> > > > > > --- a/include/uapi/linux/sctp.h
> > > > > > +++ b/include/uapi/linux/sctp.h
> > > > > > @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
> > > > > >       struct sockaddr_storage spt_address;
> > > > > >       __u16 spt_pathmaxrxt;
> > > > > >       __u16 spt_pathpfthld;
> > > > > > +     __u16 spt_pathcpthld;
> > > > > >  };
> > > > > >
> > > > > >  /*
> > > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > > index 5e2098b..5b9774d 100644
> > > > > > --- a/net/sctp/socket.c
> > > > > > +++ b/net/sctp/socket.c
> > > > > > @@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
> > > > >
> > > > > This code does:
> > > > >         if (optlen < sizeof(struct sctp_paddrthlds))
> > > > >                 return -EINVAL;
> > > > here will become:
> > > >
> > > >         if (optlen >= sizeof(struct sctp_paddrthlds)) {
> > > >                 optlen = sizeof(struct sctp_paddrthlds);
> > > >         } else if (optlen >= ALIGN(offsetof(struct sctp_paddrthlds,
> > > >                                             spt_pathcpthld), 4))
> > > >                 optlen = ALIGN(offsetof(struct sctp_paddrthlds,
> > > >                                         spt_pathcpthld), 4);
> > > >                 val.spt_pathcpthld = 0xffff;
> > > >         else {
> > > >                 return -EINVAL;
> > > >         }
> > >
> > > Hmmm...
> > > If the kernel has to default 'val.spt_pathcpthld = 0xffff'
> > > then recompiling an existing application with the new uapi
> > > header is going to lead to very unexpected behaviour.
> > >
> > > The best you can hope for is that the application memset the
> > > structure to zero.
> > > But more likely it is 'random' on-stack data.
> > 0xffff is a value to disable the feature 'Primary Path Switchover'.
> > you're right that user might set it to zero unexpectly with their
> > old application rebuilt.
> >
> > A safer way is to introduce "sysctl net.sctp.ps_retrans", it won't
> > matter if users set spt_pathcpthld properly when they're not aware
> > of this feature, like "sysctl net.sctp.pF_retrans". Looks better?
> Sorry for confusing,  "sysctl net.sctp.ps_retrans" is already there
> (its value is 0xffff by default),
> we just need to do this in sctp_setsockopt_paddr_thresholds():
> 
>         if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
>                            optlen))
>                 return -EFAULT;
> 
>         if (sock_net(sk)->sctp.ps_retrans == 0xffff)
>                 val.spt_pathcpthld = 0xffff;

I'm confused with the snippets, but if I got them right, this is after
dealing with proper len and could leave val.spt_pathcpthld
uninitialized if the application used the old format and sysctl is !=
0xffff.

> 
>         if (val.spt_pathpfthld > val.spt_pathcpthld)
>                 return -EINVAL;
> 
> >
> > >
> > >         David
> > >
> > > -
> > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > Registration No: 1397386 (Wales)
> 
