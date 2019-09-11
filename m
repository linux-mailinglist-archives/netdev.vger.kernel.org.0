Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31662AF845
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfIKIvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:51:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40387 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfIKIvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:51:55 -0400
Received: by mail-wm1-f67.google.com with SMTP id t9so2478522wmi.5;
        Wed, 11 Sep 2019 01:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E+/DGXbVrLX6/o3Z+0QWOppZIz2ScohlKNgb4cxgMyI=;
        b=CpM7kjzcF6EZFViKRJtsyAL+pCAoLLYDnoObbmFGKpcEGEy2h9H5m3Dw4QSU8HAUHu
         m1rbQ2Pzzut4rYuwIOg3YMMxv5PZF2Z/K2fUTUWmc7PvpXUUIhCQuEcIG3j9fdmiAGAQ
         46uRY4ObSuyhq8iG7Z4rSu/m8j7EFAGxx4GdXkNgap/FaYAd/1AhUUJLwbmhN+K7OptH
         5Vk9G/3VRMZ8aVqLNTNrZ7X6T0aXgG3lHhEaW0adB+0zMcJQOX5nLQywM9bdHsoo8BjJ
         2Wk7Ry3Gfn+XfPMMOwsdrqDZzmT65o7Yp0rt1NB6+yqd6F2P+M3geZ+hCpENfQg8XOYf
         eaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E+/DGXbVrLX6/o3Z+0QWOppZIz2ScohlKNgb4cxgMyI=;
        b=NpgDyyHo/1aIXHp0LcD0Jx/opC/ZJ4UNzTXPOsNeGDNSlYtSDEJIBwjuY7e+aHyPS4
         MlSHoDhZCxKmG6ql01vdr8nJapNOM3r+tQKA6tTkgK8dkjY0BHvV75Jsxjei4S+5S75A
         4nXZlkojq4WOhvTkdDJEZqQzsoBJ5gSZRkvrGT2Vafneu0DTA/qnLTcOaur2g8nVMYWi
         pRfzw7ScOnjP24kHRr0Bt4ZcWOuprhBLqj0IQO7vDmKdrWLefM+y31TCkT0VyjNUsKL0
         aSGFT0xTte1ObV+ir1Zg3G/XVy/+WZpo0QzBC+9g0Cj/kcE/nGlDIZpGbLX7UQVofNv+
         gALw==
X-Gm-Message-State: APjAAAXOEDNc382CjCkhXWB6yDdsQtuXTlT8srOS703NrFELwadesOrX
        t//nBvt9w2xOaKFCabWwBcJa4p0LBKwSkyXGhUo=
X-Google-Smtp-Source: APXvYqx9AdHMLesSk0CiYNN9p5dtwLOY4JHJHd0AKT6l5AuHOXyqpiX84WMX+73yr2Zo1mgQcqZobItuIPFRKBJKDaA=
X-Received: by 2002:a05:600c:24e:: with SMTP id 14mr3015661wmj.140.1568191912625;
 Wed, 11 Sep 2019 01:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568015756.git.lucien.xin@gmail.com> <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
In-Reply-To: <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 11 Sep 2019 16:51:41 +0800
Message-ID: <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
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

On Tue, Sep 10, 2019 at 9:19 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Xin Long
> > Sent: 09 September 2019 08:57
> > Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
> > Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
> > added to allow a user to change ps_retrans per sock/asoc/transport, as
> > other 2 paddrthlds: pf_retrans, pathmaxrxt.
> >
> > Note that ps_retrans is not allowed to be greater than pf_retrans.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/uapi/linux/sctp.h |  1 +
> >  net/sctp/socket.c         | 10 ++++++++++
> >  2 files changed, 11 insertions(+)
> >
> > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > index a15cc28..dfd81e1 100644
> > --- a/include/uapi/linux/sctp.h
> > +++ b/include/uapi/linux/sctp.h
> > @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
> >       struct sockaddr_storage spt_address;
> >       __u16 spt_pathmaxrxt;
> >       __u16 spt_pathpfthld;
> > +     __u16 spt_pathcpthld;
> >  };
> >
> >  /*
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 5e2098b..5b9774d 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -3954,6 +3954,9 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
>
> This code does:
>         if (optlen < sizeof(struct sctp_paddrthlds))
>                 return -EINVAL;
here will become:

        if (optlen >= sizeof(struct sctp_paddrthlds)) {
                optlen = sizeof(struct sctp_paddrthlds);
        } else if (optlen >= ALIGN(offsetof(struct sctp_paddrthlds,
                                            spt_pathcpthld), 4))
                optlen = ALIGN(offsetof(struct sctp_paddrthlds,
                                        spt_pathcpthld), 4);
                val.spt_pathcpthld = 0xffff;
        else {
                return -EINVAL;
        }

        if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
                           optlen))
                return -EFAULT;

in sctp_getsockopt_paddr_thresholds():

        if (len >= sizeof(struct sctp_paddrthlds))
                len = sizeof(struct sctp_paddrthlds);
        else if (len >= ALIGN(offsetof(struct sctp_paddrthlds,
                                       spt_pathcpthld), 4))
                len = ALIGN(offsetof(struct sctp_paddrthlds,
                                     spt_pathcpthld), 4);
        else
                return -EINVAL;

        if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval, len))
                return -EFAULT;

>
> So adding an extra field breaks existing application binaries
> that use this option.
>
> I've not checked the other patches or similar fubar.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
