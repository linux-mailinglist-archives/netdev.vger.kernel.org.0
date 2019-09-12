Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48476B1678
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfILWwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:52:01 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37693 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfILWwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:52:00 -0400
Received: by mail-qt1-f193.google.com with SMTP id g13so31253627qtj.4;
        Thu, 12 Sep 2019 15:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xO5F5sUIfzexpW2YTsJo1bYwaF56uHZw7UiwqnxNkUg=;
        b=qHAyMSmdwt74fH8X4s1UIPGARmsebVCwJ8eQfCINMj8gluWrnm5xX7EFwSO6/Q9ZRG
         /arP+A2zb13nYgzx8gAnaStSu8UIj2V3TLZd0rVvO45TlhAEBkx8+JAn3kgCh5gvw+5n
         DsOAnkRbhXoNLO/mFsvvjh4VWID4m4m6AaccAf9nG6UpHvWU+bBQ687CgN9AJOur5AOR
         R1XZDY+Obgeyxa9m85XuhD97jjbgUwLG29KGNAk94QFlpHzJqaHVikVzPCJ4lBjUCmo/
         j5fe/KXK7UIvIR6s1iu+kh3T63iQnQ6ZD74JdFXAEJ1dDX4rz34yt98DxkKzGY3ifGXv
         036w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xO5F5sUIfzexpW2YTsJo1bYwaF56uHZw7UiwqnxNkUg=;
        b=XonUExfxXvW/tVEK3tvpQhXABmzgZUOUvvB2fmeFeHAtqJgX6dHZH1PmZjlrDwXz6v
         yVCd9pJfscekpsKDAr0dx67pRXBTJyyzHNz92mr40gpe5XVPodW8qE12n0AAWiJXLLib
         FlvUPBzpESxXu//jKKpAecN+LX6bTQPMmLj4WpqX3DDTkjBmcD93f0go35sDg+zvcqr0
         JCIjKM4n5F9Xm1BdndIIGVT49FnvoO3alp4aiDmjkYZBndxIippvo3rLVOTAmSrcdhy8
         WPVEsxTjT0A/5NcTbQ3+NP1cM67C68oJzb0vmMDir9N/OXxKNaGecRLKTuzDsuGF7FDu
         33Vw==
X-Gm-Message-State: APjAAAVxvZl1LEOhrZCOZ5Q2OXtezcveCF8OmteMIVs5skfJk8OU3wld
        9MxbwO9Xh4o71jH3OW7XOMdbkPeR0mAUCw==
X-Google-Smtp-Source: APXvYqwU3rmtgMLRQBonCrV/7ALRPG8L3BhmTh/H8QdyRUgR/7Hd0UwGOgq7d6S04qsRguY5m6iZ+w==
X-Received: by 2002:a05:6214:146:: with SMTP id x6mr29477900qvs.232.1568328718668;
        Thu, 12 Sep 2019 15:51:58 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.89])
        by smtp.gmail.com with ESMTPSA id p53sm10619276qtk.23.2019.09.12.15.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 15:51:57 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id AA06CC4A53; Thu, 12 Sep 2019 19:51:54 -0300 (-03)
Date:   Thu, 12 Sep 2019 19:51:54 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
Message-ID: <20190912225154.GF3499@localhost.localdomain>
References: <cover.1568015756.git.lucien.xin@gmail.com>
 <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
 <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
 <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
 <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com>
 <20190911125609.GC3499@localhost.localdomain>
 <CADvbK_e=4Fo7dmM=4QTZHtNDtsrDVe_VtyG2NVqt_3r9z7R=PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_e=4Fo7dmM=4QTZHtNDtsrDVe_VtyG2NVqt_3r9z7R=PA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 01:47:08AM +0800, Xin Long wrote:
> On Wed, Sep 11, 2019 at 8:56 PM Marcelo Ricardo Leitner
> <marcelo.leitner@gmail.com> wrote:
> >
> > On Wed, Sep 11, 2019 at 05:38:33PM +0800, Xin Long wrote:
> > > On Wed, Sep 11, 2019 at 5:21 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > On Wed, Sep 11, 2019 at 5:03 PM David Laight <David.Laight@aculab.com> wrote:
> > > > >
> > > > > From: Xin Long [mailto:lucien.xin@gmail.com]
> > > > > > Sent: 11 September 2019 09:52
> > > > > > On Tue, Sep 10, 2019 at 9:19 PM David Laight <David.Laight@aculab.com> wrote:
> > > > > > >
> > > > > > > From: Xin Long
> > > > > > > > Sent: 09 September 2019 08:57
> > > > > > > > Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
> > > > > > > > Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
> > > > > > > > added to allow a user to change ps_retrans per sock/asoc/transport, as
> > > > > > > > other 2 paddrthlds: pf_retrans, pathmaxrxt.
> > > > > > > >
> > > > > > > > Note that ps_retrans is not allowed to be greater than pf_retrans.
> > > > > > > >
> > > > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > > > ---
> > > > > > > >  include/uapi/linux/sctp.h |  1 +
> > > > > > > >  net/sctp/socket.c         | 10 ++++++++++
> > > > > > > >  2 files changed, 11 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > > > > > > > index a15cc28..dfd81e1 100644
> > > > > > > > --- a/include/uapi/linux/sctp.h
> > > > > > > > +++ b/include/uapi/linux/sctp.h
> > > > > > > > @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
> > > > > > > >       struct sockaddr_storage spt_address;
> > > > > > > >       __u16 spt_pathmaxrxt;
> > > > > > > >       __u16 spt_pathpfthld;
> > > > > > > > +     __u16 spt_pathcpthld;
> > > > > > > >  };
> > > > > > > >
> > > > > > > >  /*
> > > > > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > > > > index 5e2098b..5b9774d 100644
> > > > > > > > --- a/net/sctp/socket.c
> > > > > > > > +++ b/net/sctp/socket.c
> > > > > > > > @@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
> > > > > > >
> > > > > > > This code does:
> > > > > > >         if (optlen < sizeof(struct sctp_paddrthlds))
> > > > > > >                 return -EINVAL;
> > > > > > here will become:
> > > > > >
> > > > > >         if (optlen >= sizeof(struct sctp_paddrthlds)) {
> > > > > >                 optlen = sizeof(struct sctp_paddrthlds);
> > > > > >         } else if (optlen >= ALIGN(offsetof(struct sctp_paddrthlds,
> > > > > >                                             spt_pathcpthld), 4))
> > > > > >                 optlen = ALIGN(offsetof(struct sctp_paddrthlds,
> > > > > >                                         spt_pathcpthld), 4);
> > > > > >                 val.spt_pathcpthld = 0xffff;
> > > > > >         else {
> > > > > >                 return -EINVAL;
> > > > > >         }
> > > > >
> > > > > Hmmm...
> > > > > If the kernel has to default 'val.spt_pathcpthld = 0xffff'
> > > > > then recompiling an existing application with the new uapi
> > > > > header is going to lead to very unexpected behaviour.
> > > > >
> > > > > The best you can hope for is that the application memset the
> > > > > structure to zero.
> > > > > But more likely it is 'random' on-stack data.
> > > > 0xffff is a value to disable the feature 'Primary Path Switchover'.
> > > > you're right that user might set it to zero unexpectly with their
> > > > old application rebuilt.
> > > >
> > > > A safer way is to introduce "sysctl net.sctp.ps_retrans", it won't
> > > > matter if users set spt_pathcpthld properly when they're not aware
> > > > of this feature, like "sysctl net.sctp.pF_retrans". Looks better?
> > > Sorry for confusing,  "sysctl net.sctp.ps_retrans" is already there
> > > (its value is 0xffff by default),
> > > we just need to do this in sctp_setsockopt_paddr_thresholds():
> > >
> > >         if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
> > >                            optlen))
> > >                 return -EFAULT;
> > >
> > >         if (sock_net(sk)->sctp.ps_retrans == 0xffff)
> > >                 val.spt_pathcpthld = 0xffff;
> >
> > I'm confused with the snippets, but if I got them right, this is after
> > dealing with proper len and could leave val.spt_pathcpthld
> > uninitialized if the application used the old format and sysctl is !=
> > 0xffff.
> right, how about this in sctp_setsockopt_paddr_thresholds():
> 
>         offset = ALIGN(offsetof(struct sctp_paddrthlds, spt_pathcpthld), 4);
>         if (optlen < offset)
>                 return -EINVAL;
>         if (optlen < sizeof(val) || sock_net(sk)->sctp.ps_retrans == 0xffff) {
>                 optlen = offset;
>                 val.spt_pathcpthld = 0xffff;
>         } else {
>                 optlen = sizeof(val);
>         }
> 
>         if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
>                            optlen))
>                 return -EFAULT;
> 
>         if (val.spt_pathpfthld > val.spt_pathcpthld)
>                 return -EINVAL;
> 
> Which means we will 'skip' spt_pathcpthld if (it's using old format) or
> (ps_retrans is disabled and it's using new format).

This will be inconsistent if we end up having to add another field
after spt_pathcpthld, because it will get ignored if ps_retrans ==
0xffff.  Lets not optimize out the fields please. This is already very
tricky to get right.

> Note that  ps_retrans < pf_retrans is not allowed in rfc7829.
> 
> and in sctp_getsockopt_paddr_thresholds():
> 
>         offset = ALIGN(offsetof(struct sctp_paddrthlds, spt_pathcpthld), 4);
>         if (len < offset)
>                 return -EINVAL;
>         if (len < sizeof(val) || sock_net(sk)->sctp.ps_retrans == 0xffff)
>                 len = offset;
>         else
>                 len = sizeof(val);

Here it is more visible. If net->...ps_retrans is disabled, remaining
fields (currently just this one, but as we are extending it now, we
have to think about the possibility of more as well) will be ignored,
we and we may not want that.

> 
>         if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval, len))
>                 return -EFAULT;
> 
> 
> >
> > >
> > >         if (val.spt_pathpfthld > val.spt_pathcpthld)
> > >                 return -EINVAL;
> > >
> > > >
> > > > >
> > > > >         David
> > > > >
> > > > > -
> > > > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > > > Registration No: 1397386 (Wales)
> > >
> 
