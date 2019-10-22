Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71907E028E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 13:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731911AbfJVLM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 07:12:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50646 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730450AbfJVLM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 07:12:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id q13so6709160wmj.0;
        Tue, 22 Oct 2019 04:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SMzoWL9AphNI7KM02mxmhPfWRC6wxhYzK4GYu+S5uwY=;
        b=ZcWDaZ2H+n2YEiPwR/IDkZJq4uFG+ZHdMkuXXFTgio7b8/ZN0HPTP4nsqv632B0e81
         6fFqJkkwBS7TbrLcQFzrWsNMnYZ+5mREZKdntCAx8vVGFOLOea4L8i+U+4AzjfYNhsI3
         BnBCgyl+CoxDcsZVHNeUCKslA2L3zKWupw3hUG1b1ML2Xv2WFTeqnZOFVV1UOF/B2ez2
         D29yscVjrU1tueAoVZy1hnok0AcWcq5B2+CZQG1uRtnR9TEUI4O5E9ehWRVIU2tcj+F1
         qRLONRP0DJO7dbSatjiJVAK6Dp2wLES6n+4h+4mcczy8uS0NnfgmSOx2ylFTqv+l7X7f
         zj6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SMzoWL9AphNI7KM02mxmhPfWRC6wxhYzK4GYu+S5uwY=;
        b=LvY8DJ0dszhZIyJw5/EwjagCEPUWbmin9L5zi9yuI1ymUyXNVgj4juvFmJlHiV5nVt
         9JjwEfz6KdvJzoHFKqhwd+Ksn01kZKzKLd1UhoCnsqrnEiIlxFD9HqLRbJjI/3afwIJG
         mqQ4EX+wFh1HU8wsWqepuAphHrCWmo2mzfCgM110vJVHPyciUFEGeV+kjCgMLqD/PEJ2
         BmP1Ty8uS0tfTBTZKx8gI4mxXasW1GMkTOOpGAGxxg7gXdwaFHmy9MOwdt+wlCCEMtvm
         IXrVb/r6FFc7MyJXPj+Jo1bDHYbZjWkoxtkTHiXNlrpbZM5dMFx+Y8pUzQ1DGGCjmCEF
         8aAQ==
X-Gm-Message-State: APjAAAWkbk96hAprKqpMDVMvfBZmauUjxYsMLsknRPa0I2BCY0k8hxKI
        k1/aTHK5qHXEsNtu1C0fhT0n7asJc4wzs4dRn/MAWwvG
X-Google-Smtp-Source: APXvYqwzGWXk/AxeGIj8soVELpjgfwGzG4c+Mk7jQCAtzETPH7TAg88biB39pVxx+ESgoYdKZ00DqHNzgU4xtRP3yHc=
X-Received: by 2002:a7b:c3cf:: with SMTP id t15mr2415366wmj.85.1571742774835;
 Tue, 22 Oct 2019 04:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571033544.git.lucien.xin@gmail.com> <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <fb115b1444764b3eacdf69ebd9cf9681@AcuMS.aculab.com> <CADvbK_eQrXs4VC+OgsLibA-q2VkkdKXTK+meaRGbxJDK41aLKg@mail.gmail.com>
In-Reply-To: <CADvbK_eQrXs4VC+OgsLibA-q2VkkdKXTK+meaRGbxJDK41aLKg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 22 Oct 2019 19:13:30 +0800
Message-ID: <CADvbK_cYTNupYG4rLPcTz8J7HK5DajcW=UfqNT64-vJi+9yx4w@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED notification
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

Hi, David L.

I will repost if you don't have any other dissent.

Thanks for your nice review.

On Sat, Oct 19, 2019 at 4:55 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Fri, Oct 18, 2019 at 11:56 PM David Laight <David.Laight@aculab.com> wrote:
> >
> > I've found v3 :-)
> ah okay. sorry.
>
> > But it isn't that much better than v2.
> >
> > From: Xin Long
> > > Sent: 14 October 2019 07:15
> > > SCTP Quick failover draft section 5.1, point 5 has been removed
> > > from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
> > > Layer Protocol (ULP) about this state transition", as said in
> > > section 3.2, point 8.
> > >
> > > So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
> > > in section 7.1, "which is reported if the affected address
> > > becomes PF". Also remove transport cwnd's update when moving
> > > from PF back to ACTIVE , which is no longer in rfc7829 either.
> > >
> > > v1->v2:
> > >   - no change
> > > v2->v3:
> > >   - define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  include/uapi/linux/sctp.h |  2 ++
> > >  net/sctp/associola.c      | 17 ++++-------------
> > >  2 files changed, 6 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > > index 6bce7f9..f4ab7bb 100644
> > > --- a/include/uapi/linux/sctp.h
> > > +++ b/include/uapi/linux/sctp.h
> > > @@ -410,6 +410,8 @@ enum sctp_spc_state {
> > >       SCTP_ADDR_ADDED,
> > >       SCTP_ADDR_MADE_PRIM,
> > >       SCTP_ADDR_CONFIRMED,
> > > +     SCTP_ADDR_POTENTIALLY_FAILED,
> > > +#define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED
> > >  };
> > >
> > >
> > > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > > index 1ba893b..4f9efba 100644
> > > --- a/net/sctp/associola.c
> > > +++ b/net/sctp/associola.c
> > > @@ -801,14 +801,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> > >                       spc_state = SCTP_ADDR_CONFIRMED;
> > >               else
> > >                       spc_state = SCTP_ADDR_AVAILABLE;
> > > -             /* Don't inform ULP about transition from PF to
> > > -              * active state and set cwnd to 1 MTU, see SCTP
> > > -              * Quick failover draft section 5.1, point 5
> > > -              */
> > > -             if (transport->state == SCTP_PF) {
> > > -                     ulp_notify = false;
> > > -                     transport->cwnd = asoc->pathmtu;
> > > -             }
> >
> > This is wrong.
> > If the old state is PF and the application hasn't exposed PF the event should be
> > ignored.
> yeps, in Patch 2/5:
> +               if (transport->state == SCTP_PF &&
> +                   asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
> +                       ulp_notify = false;
> +               else if (transport->state == SCTP_UNCONFIRMED &&
> +                        error == SCTP_HEARTBEAT_SUCCESS)
>                         spc_state = SCTP_ADDR_CONFIRMED;
>                 else
>                         spc_state = SCTP_ADDR_AVAILABLE;
>
> >
> > >               transport->state = SCTP_ACTIVE;
> > >               break;
> > >
> > > @@ -817,19 +809,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> > >                * to inactive state.  Also, release the cached route since
> > >                * there may be a better route next time.
> > >                */
> > > -             if (transport->state != SCTP_UNCONFIRMED)
> > > +             if (transport->state != SCTP_UNCONFIRMED) {
> > >                       transport->state = SCTP_INACTIVE;
> > > -             else {
> > > +                     spc_state = SCTP_ADDR_UNREACHABLE;
> > > +             } else {
> > >                       sctp_transport_dst_release(transport);
> > >                       ulp_notify = false;
> > >               }
> > > -
> > > -             spc_state = SCTP_ADDR_UNREACHABLE;
> > >               break;
> > >
> > >       case SCTP_TRANSPORT_PF:
> > >               transport->state = SCTP_PF;
> > > -             ulp_notify = false;
> >
> > Again the event should be supressed if PF isn't exposed.
> it will be suppressed after Patch 2/5:
> +               if (asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
> +                       ulp_notify = false;
> +               else
> +                       spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
>                 break;
>
> >
> > > +             spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
> > >               break;
> > >
> > >       default:
> > > --
> > > 2.1.0
> >
> > I also haven't spotted where the test that the application has actually enabled
> > state transition events is in the code.
> all events will be created, but dropped in sctp_ulpq_tail_event() when trying
> to deliver up:
>
>         /* Check if the user wishes to receive this event.  */
>         if (!sctp_ulpevent_is_enabled(event, ulpq->asoc->subscribe))
>                 goto out_free;
>
> > I'd have thought it would be anything is built and allocated.
> >
> >         David
> >
> > -
> > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > Registration No: 1397386 (Wales)
> >
