Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9A4B02E9
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 19:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbfIKRrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 13:47:23 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34730 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729683AbfIKRrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 13:47:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id a11so15806594wrx.1;
        Wed, 11 Sep 2019 10:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=za5dLNsyd8cO0/LWjl+4GZ/KbGfFV7E0+6wSG+4LWkk=;
        b=iiNPN2Ai9y+GirwE9t7qJoUI//aSPubMbgHAjaoyu311cDmcvJcleIdfrAIGcbFvn7
         9/MF6u85fcNYE6uSjhTj+6VATv1d90FR/mr2dhFCrX5Pn4xQXjy6twcPxF/fhfExTa4K
         LYQTecvTYjvIQ44/az3IzkKwj47aTFJfiUyVOk4/fFI+SIYKyPeMN2m6t7vUbqxgFGFh
         mw3H/OO2fZUmf0tlf4wlmZ/Z7lhc/hz8rIt/6u/NXWEdMkS0wVUfEyponAar9XM7fyE0
         4kivPefiGnyrahppnTKzWbxXJ1pxxBIwf+/U/gjUrF0LOUqruR0CseQsBVtRJqv1C8wt
         MvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=za5dLNsyd8cO0/LWjl+4GZ/KbGfFV7E0+6wSG+4LWkk=;
        b=ShBE11xQvtwLP3sSab1pqKN22L9QbvuCoDsUrY0DNyDKgms9IeQmydGOmEJBKkvK1+
         8zwf82B5wMMEYXUOMn5gowOdPDEHavLSKtjUKFVm4KfDof2fZPY00q4vCzLBiE8EUtR/
         claAh5DEvFWkNgEmCHHrd8QEDDlZCjnl2trfbURIL5+WTSIvU9gUXcUNN32OeAW08C0i
         DpKdfyrhpxpaCBxGTCtnHGxWa7ucJGCF16jwQKte3VfTI5WeP25Ubo/qcBTwmrizdKka
         HXtlF4umQ3wjLlEVv3Lgf7D7P8yh14Oo6m/X1nvEC2svwWnT/y2JKfmwa4zJWMaLKAKX
         vxng==
X-Gm-Message-State: APjAAAWMZKN7//ylIQij0getmUYTva3hamjEHNK4T5a4mDZj9Cy4Xr52
        zjm4syr2+jTpAOBh/RE5gcsvOvsq+EdvXuHNA8E=
X-Google-Smtp-Source: APXvYqxkwdBPzuoHNJ68DYYOxhywTzPsN5U8p7jUqjtEsPzdTDNNUoI6UE3KyActllWj7Mhqsxo60XmSGPYce/3vITE=
X-Received: by 2002:a5d:628f:: with SMTP id k15mr16507858wru.124.1568224039920;
 Wed, 11 Sep 2019 10:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568015756.git.lucien.xin@gmail.com> <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com> <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com> <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
 <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com> <20190911125609.GC3499@localhost.localdomain>
In-Reply-To: <20190911125609.GC3499@localhost.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 12 Sep 2019 01:47:08 +0800
Message-ID: <CADvbK_e=4Fo7dmM=4QTZHtNDtsrDVe_VtyG2NVqt_3r9z7R=PA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 8:56 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Sep 11, 2019 at 05:38:33PM +0800, Xin Long wrote:
> > On Wed, Sep 11, 2019 at 5:21 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Wed, Sep 11, 2019 at 5:03 PM David Laight <David.Laight@aculab.com> wrote:
> > > >
> > > > From: Xin Long [mailto:lucien.xin@gmail.com]
> > > > > Sent: 11 September 2019 09:52
> > > > > On Tue, Sep 10, 2019 at 9:19 PM David Laight <David.Laight@aculab.com> wrote:
> > > > > >
> > > > > > From: Xin Long
> > > > > > > Sent: 09 September 2019 08:57
> > > > > > > Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
> > > > > > > Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
> > > > > > > added to allow a user to change ps_retrans per sock/asoc/transport, as
> > > > > > > other 2 paddrthlds: pf_retrans, pathmaxrxt.
> > > > > > >
> > > > > > > Note that ps_retrans is not allowed to be greater than pf_retrans.
> > > > > > >
> > > > > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > > > > > ---
> > > > > > >  include/uapi/linux/sctp.h |  1 +
> > > > > > >  net/sctp/socket.c         | 10 ++++++++++
> > > > > > >  2 files changed, 11 insertions(+)
> > > > > > >
> > > > > > > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > > > > > > index a15cc28..dfd81e1 100644
> > > > > > > --- a/include/uapi/linux/sctp.h
> > > > > > > +++ b/include/uapi/linux/sctp.h
> > > > > > > @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
> > > > > > >       struct sockaddr_storage spt_address;
> > > > > > >       __u16 spt_pathmaxrxt;
> > > > > > >       __u16 spt_pathpfthld;
> > > > > > > +     __u16 spt_pathcpthld;
> > > > > > >  };
> > > > > > >
> > > > > > >  /*
> > > > > > > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > > > > > > index 5e2098b..5b9774d 100644
> > > > > > > --- a/net/sctp/socket.c
> > > > > > > +++ b/net/sctp/socket.c
> > > > > > > @@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
> > > > > >
> > > > > > This code does:
> > > > > >         if (optlen < sizeof(struct sctp_paddrthlds))
> > > > > >                 return -EINVAL;
> > > > > here will become:
> > > > >
> > > > >         if (optlen >= sizeof(struct sctp_paddrthlds)) {
> > > > >                 optlen = sizeof(struct sctp_paddrthlds);
> > > > >         } else if (optlen >= ALIGN(offsetof(struct sctp_paddrthlds,
> > > > >                                             spt_pathcpthld), 4))
> > > > >                 optlen = ALIGN(offsetof(struct sctp_paddrthlds,
> > > > >                                         spt_pathcpthld), 4);
> > > > >                 val.spt_pathcpthld = 0xffff;
> > > > >         else {
> > > > >                 return -EINVAL;
> > > > >         }
> > > >
> > > > Hmmm...
> > > > If the kernel has to default 'val.spt_pathcpthld = 0xffff'
> > > > then recompiling an existing application with the new uapi
> > > > header is going to lead to very unexpected behaviour.
> > > >
> > > > The best you can hope for is that the application memset the
> > > > structure to zero.
> > > > But more likely it is 'random' on-stack data.
> > > 0xffff is a value to disable the feature 'Primary Path Switchover'.
> > > you're right that user might set it to zero unexpectly with their
> > > old application rebuilt.
> > >
> > > A safer way is to introduce "sysctl net.sctp.ps_retrans", it won't
> > > matter if users set spt_pathcpthld properly when they're not aware
> > > of this feature, like "sysctl net.sctp.pF_retrans". Looks better?
> > Sorry for confusing,  "sysctl net.sctp.ps_retrans" is already there
> > (its value is 0xffff by default),
> > we just need to do this in sctp_setsockopt_paddr_thresholds():
> >
> >         if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
> >                            optlen))
> >                 return -EFAULT;
> >
> >         if (sock_net(sk)->sctp.ps_retrans == 0xffff)
> >                 val.spt_pathcpthld = 0xffff;
>
> I'm confused with the snippets, but if I got them right, this is after
> dealing with proper len and could leave val.spt_pathcpthld
> uninitialized if the application used the old format and sysctl is !=
> 0xffff.
right, how about this in sctp_setsockopt_paddr_thresholds():

        offset = ALIGN(offsetof(struct sctp_paddrthlds, spt_pathcpthld), 4);
        if (optlen < offset)
                return -EINVAL;
        if (optlen < sizeof(val) || sock_net(sk)->sctp.ps_retrans == 0xffff) {
                optlen = offset;
                val.spt_pathcpthld = 0xffff;
        } else {
                optlen = sizeof(val);
        }

        if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
                           optlen))
                return -EFAULT;

        if (val.spt_pathpfthld > val.spt_pathcpthld)
                return -EINVAL;

Which means we will 'skip' spt_pathcpthld if (it's using old format) or
(ps_retrans is disabled and it's using new format).
Note that  ps_retrans < pf_retrans is not allowed in rfc7829.

and in sctp_getsockopt_paddr_thresholds():

        offset = ALIGN(offsetof(struct sctp_paddrthlds, spt_pathcpthld), 4);
        if (len < offset)
                return -EINVAL;
        if (len < sizeof(val) || sock_net(sk)->sctp.ps_retrans == 0xffff)
                len = offset;
        else
                len = sizeof(val);

        if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval, len))
                return -EFAULT;


>
> >
> >         if (val.spt_pathpfthld > val.spt_pathcpthld)
> >                 return -EINVAL;
> >
> > >
> > > >
> > > >         David
> > > >
> > > > -
> > > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > > Registration No: 1397386 (Wales)
> >
