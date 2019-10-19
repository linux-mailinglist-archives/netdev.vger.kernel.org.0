Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15FDD785
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 10:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfJSIo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 04:44:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36243 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfJSIoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 04:44:55 -0400
Received: by mail-wm1-f68.google.com with SMTP id m18so8197965wmc.1;
        Sat, 19 Oct 2019 01:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TJ98sNCSxPWS9lk8egQgmOh4xP6jprZw9WTslrPxWWI=;
        b=YrKjKtOLLlroQy2A+bqt16S03zk54hw5i06d5w65gxgagOWm/3JPg5XYu2mFceFAKj
         jrBjgTkyDz/tdfqs2k9tPIreyYCU7gKqc/Deq6hoF84qCmrgc2MmeAU4+6NwkbEU9JGf
         22ienC8zO4NF7xJqk166TdcdVKhQj5k06ArigBgtK0xlPj8KapM9MrAwY0Sc8Nx+LxGd
         7EW32ER/lSGl3XKfcUJaOwuq8gOMRp28e/QvQSaAUTbtUegeFh4TqzlYshZ3/TYQASAI
         haeBqJT8sv5ReYo6NILuwu/RgpPWP37tf3myePetfN3JF296fq2MT0lmn7c807Cqe2zn
         zkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TJ98sNCSxPWS9lk8egQgmOh4xP6jprZw9WTslrPxWWI=;
        b=RwfZTQj1Y+Okk5hohwzLY22UdVhKHsM6wrak4ToAaveVG9aLWvCd+07jysKVq5eFbZ
         3/v/is8YDAlZI/CQaunOXOKWjLodRoAX40K2B2RU6ZINl8Ybb4NUvZpWy+3LhjuBSnzs
         CGwVvjZW853h+8yFM6INMmrm/J5/gMLpM7wJemrVGXFOY4Q4NfP8WR+pLVDvbIe8XjhG
         LMXfWMOzbNITLvBbpOdnpeFhg+TqLcL1CzDoAE9v7PKkgxYymIueYETDdc2dMf4U8DQ3
         kV66brknco+ht+bpfNK5O7LhJrBlf9gLi5ErKSHXLEqk7gHHbWWZHtTcQXEBp15U1FpD
         Ik1w==
X-Gm-Message-State: APjAAAUPelkR0fgwWcRQ7gtMIYz1ZNSIcN+m9eVqrGEVZ1WOtf4pXjIO
        LGMQGv1pAyJzGfuyt24O9XWTjSHRgUZ4XnC9x14=
X-Google-Smtp-Source: APXvYqyPJViBWNYjlE93y0604sZZXRpN+36gI5lbFMNzkh6bd0Tpy1DR6My0zAE4SU6Y9IJrgVZDPiGz6S4LJN3AK+I=
X-Received: by 2002:a1c:8157:: with SMTP id c84mr10625626wmd.56.1571474693292;
 Sat, 19 Oct 2019 01:44:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570533716.git.lucien.xin@gmail.com> <8fcf707443f7218d3fb131b827c679f423c5ecaf.1570533716.git.lucien.xin@gmail.com>
 <0779b5aeb9a84b4692b08be7478e0373@AcuMS.aculab.com>
In-Reply-To: <0779b5aeb9a84b4692b08be7478e0373@AcuMS.aculab.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 19 Oct 2019 16:45:20 +0800
Message-ID: <CADvbK_dd9fSbntPqx13wUu7he3ke4UK1bVNPhfhhMzT=zkGPjg@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 2/5] sctp: add pf_expose per netns and sock and asoc
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

On Fri, Oct 18, 2019 at 11:34 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Xin Long
> > Sent: 08 October 2019 12:25
> > As said in rfc7829, section 3, point 12:
> >
> >   The SCTP stack SHOULD expose the PF state of its destination
> >   addresses to the ULP as well as provide the means to notify the
> >   ULP of state transitions of its destination addresses from
> >   active to PF, and vice versa.  However, it is recommended that
> >   an SCTP stack implementing SCTP-PF also allows for the ULP to be
> >   kept ignorant of the PF state of its destinations and the
> >   associated state transitions, thus allowing for retention of the
> >   simpler state transition model of [RFC4960] in the ULP.
> >
> > Not only does it allow to expose the PF state to ULP, but also
> > allow to ignore sctp-pf to ULP.
> >
> > So this patch is to add pf_expose per netns, sock and asoc. And in
> > sctp_assoc_control_transport(), ulp_notify will be set to false if
> > asoc->expose is not set.
> >
> > It also allows a user to change pf_expose per netns by sysctl, and
> > pf_expose per sock and asoc will be initialized with it.
> >
> > Note that pf_expose also works for SCTP_GET_PEER_ADDR_INFO sockopt,
> > to not allow a user to query the state of a sctp-pf peer address
> > when pf_expose is not enabled, as said in section 7.3.
> ...
> > index 08d14d8..a303011 100644
> > --- a/net/sctp/protocol.c
> > +++ b/net/sctp/protocol.c
> > @@ -1220,6 +1220,9 @@ static int __net_init sctp_defaults_init(struct net *net)
> >       /* Enable pf state by default */
> >       net->sctp.pf_enable = 1;
> >
> > +     /* Enable pf state exposure by default */
> > +     net->sctp.pf_expose = 1;
> > +
>
> For compatibility with existing applications pf_expose MUST default to 0.
> I'm not even sure it makes sense to have a sysctl for it.
You're reivewing v2, pls go and check v3 where it's:

net->sctp.pf_expose = SCTP_PF_EXPOSE_UNUSED

>
> ...
> > @@ -5521,8 +5522,15 @@ static int sctp_getsockopt_peer_addr_info(struct sock *sk, int len,
> >
> >       transport = sctp_addr_id2transport(sk, &pinfo.spinfo_address,
> >                                          pinfo.spinfo_assoc_id);
> > -     if (!transport)
> > -             return -EINVAL;
> > +     if (!transport) {
> > +             retval = -EINVAL;
> > +             goto out;
> > +     }
> > +
> > +     if (transport->state == SCTP_PF && !transport->asoc->pf_expose) {
> > +             retval = -EACCES;
> > +             goto out;
> > +     }
>
> Ugg...
> To avoid reporting the unexpected 'SCTP_PF' state you probable need
> to lie about the state (probably reporting 'working' - or whatever state
> it would be in if PF detection wasn't enabled.
return EACCES is from RFC. see v3 where it's become:

+       if (transport->state == SCTP_PF &&
+           transport->asoc->pf_expose == SCTP_PF_EXPOSE_DISABLE) {
+               retval = -EACCES;
+               goto out;
+       }

no more compatibility issue.

>
> ...
> > --- a/net/sctp/sysctl.c
> > +++ b/net/sctp/sysctl.c
> > @@ -318,6 +318,13 @@ static struct ctl_table sctp_net_table[] = {
> >               .mode           = 0644,
> >               .proc_handler   = proc_dointvec,
> >       },
> > +     {
> > +             .procname       = "pf_expose",
> > +             .data           = &init_net.sctp.pf_expose,
> > +             .maxlen         = sizeof(int),
> > +             .mode           = 0644,
> > +             .proc_handler   = proc_dointvec,
> > +     },
>
> Setting this will break existing applications.
> So I don't think the default should be settable.
If the user sets this new sysctl, he must have realized what's going to happen.
I don't think this will cause "compatibility issue".

>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
