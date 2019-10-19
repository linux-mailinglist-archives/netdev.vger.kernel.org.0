Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA12DD789
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 10:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfJSIyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 04:54:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35740 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfJSIyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 04:54:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id l10so8157692wrb.2;
        Sat, 19 Oct 2019 01:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N/2vNt2a+QUukO3qnrcXgBYXNymxduC1iOpWpiOaCuM=;
        b=jaRN+sCZV17rCDUAH6IF0GohBH9spvJAEafivJU6ubA0+BWWXJis0b4NaVk1OVIbrJ
         1JHdcmmOp9ogJBvej0kyl3Ii0JlF5UYAipXmUQ7ViStRRy/HCjGxY/CR59blPj3TVn4B
         auwy9SgIbWaNZAVuauv3qJtO142lmjp92qz/uUXkgUN/UOE0YQEmJNOsj+Zb9UcxnOZw
         gSD0gQOvUPiGNz7jdpbQqzpTwICTGgOJtd9o8bREUwODu96qAQG0lci4Le4vslaaCpXv
         5uldIKklVuC4SC2kO2ZvLfzvI281s+0/0BnjwP+RyTm6LpAQcFs0JhzopC9KGbnsbKfy
         2eRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N/2vNt2a+QUukO3qnrcXgBYXNymxduC1iOpWpiOaCuM=;
        b=N3V66HyK7vrDuBcz7lExOsUaO2YLqQU7mL3r4G3VbQDet6un7a3boNkQm/NPBX7WRY
         ekeMIxTnHqLVZAai1nRHhBRYRKWVT9yEAqnqh34ze+PVfa369AVGcbkIEVouY8RXbw9y
         vVO02R3ceqYREYbWIY6qY9BsZmc5s0Ip0f0MNn+rFWluPctUKpASB1AIxEH5ss9yVRKW
         djN5OGqkUpETbu1upnTX4JGEYdPw1tRpAZmYvl2UY3dWNgTeAbzeXCqsAp4UhXbE6A81
         45Zaoh7LwB2zfyssFj1d3UJiH4HIp/U7uJP7oPxx+oo03IXVZfGWaL6hWllQDQjsOYlz
         +bwA==
X-Gm-Message-State: APjAAAU6v3qEXVpHmY1/N/xmJ8fS4gqvv4EDg8SIdHuPQYk6yrNwjSsF
        38beSHJ6uLsGtzVciBjGSVxYac2gvBfba/os0/s=
X-Google-Smtp-Source: APXvYqzlhRPF+5hys7JpaFbBP/rIJzzzNFPh02LWf/quZWdfsLuzdDEBMRO4pJji+jS1qD372TW7/H924XT7khszlws=
X-Received: by 2002:a05:6000:11c5:: with SMTP id i5mr6533160wrx.303.1571475274305;
 Sat, 19 Oct 2019 01:54:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571033544.git.lucien.xin@gmail.com> <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <fb115b1444764b3eacdf69ebd9cf9681@AcuMS.aculab.com>
In-Reply-To: <fb115b1444764b3eacdf69ebd9cf9681@AcuMS.aculab.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 19 Oct 2019 16:55:01 +0800
Message-ID: <CADvbK_eQrXs4VC+OgsLibA-q2VkkdKXTK+meaRGbxJDK41aLKg@mail.gmail.com>
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

On Fri, Oct 18, 2019 at 11:56 PM David Laight <David.Laight@aculab.com> wrote:
>
> I've found v3 :-)
ah okay. sorry.

> But it isn't that much better than v2.
>
> From: Xin Long
> > Sent: 14 October 2019 07:15
> > SCTP Quick failover draft section 5.1, point 5 has been removed
> > from rfc7829. Instead, "the sender SHOULD (i) notify the Upper
> > Layer Protocol (ULP) about this state transition", as said in
> > section 3.2, point 8.
> >
> > So this patch is to add SCTP_ADDR_POTENTIALLY_FAILED, defined
> > in section 7.1, "which is reported if the affected address
> > becomes PF". Also remove transport cwnd's update when moving
> > from PF back to ACTIVE , which is no longer in rfc7829 either.
> >
> > v1->v2:
> >   - no change
> > v2->v3:
> >   - define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/uapi/linux/sctp.h |  2 ++
> >  net/sctp/associola.c      | 17 ++++-------------
> >  2 files changed, 6 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> > index 6bce7f9..f4ab7bb 100644
> > --- a/include/uapi/linux/sctp.h
> > +++ b/include/uapi/linux/sctp.h
> > @@ -410,6 +410,8 @@ enum sctp_spc_state {
> >       SCTP_ADDR_ADDED,
> >       SCTP_ADDR_MADE_PRIM,
> >       SCTP_ADDR_CONFIRMED,
> > +     SCTP_ADDR_POTENTIALLY_FAILED,
> > +#define SCTP_ADDR_PF SCTP_ADDR_POTENTIALLY_FAILED
> >  };
> >
> >
> > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > index 1ba893b..4f9efba 100644
> > --- a/net/sctp/associola.c
> > +++ b/net/sctp/associola.c
> > @@ -801,14 +801,6 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> >                       spc_state = SCTP_ADDR_CONFIRMED;
> >               else
> >                       spc_state = SCTP_ADDR_AVAILABLE;
> > -             /* Don't inform ULP about transition from PF to
> > -              * active state and set cwnd to 1 MTU, see SCTP
> > -              * Quick failover draft section 5.1, point 5
> > -              */
> > -             if (transport->state == SCTP_PF) {
> > -                     ulp_notify = false;
> > -                     transport->cwnd = asoc->pathmtu;
> > -             }
>
> This is wrong.
> If the old state is PF and the application hasn't exposed PF the event should be
> ignored.
yeps, in Patch 2/5:
+               if (transport->state == SCTP_PF &&
+                   asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
+                       ulp_notify = false;
+               else if (transport->state == SCTP_UNCONFIRMED &&
+                        error == SCTP_HEARTBEAT_SUCCESS)
                        spc_state = SCTP_ADDR_CONFIRMED;
                else
                        spc_state = SCTP_ADDR_AVAILABLE;

>
> >               transport->state = SCTP_ACTIVE;
> >               break;
> >
> > @@ -817,19 +809,18 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
> >                * to inactive state.  Also, release the cached route since
> >                * there may be a better route next time.
> >                */
> > -             if (transport->state != SCTP_UNCONFIRMED)
> > +             if (transport->state != SCTP_UNCONFIRMED) {
> >                       transport->state = SCTP_INACTIVE;
> > -             else {
> > +                     spc_state = SCTP_ADDR_UNREACHABLE;
> > +             } else {
> >                       sctp_transport_dst_release(transport);
> >                       ulp_notify = false;
> >               }
> > -
> > -             spc_state = SCTP_ADDR_UNREACHABLE;
> >               break;
> >
> >       case SCTP_TRANSPORT_PF:
> >               transport->state = SCTP_PF;
> > -             ulp_notify = false;
>
> Again the event should be supressed if PF isn't exposed.
it will be suppressed after Patch 2/5:
+               if (asoc->pf_expose != SCTP_PF_EXPOSE_ENABLE)
+                       ulp_notify = false;
+               else
+                       spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
                break;

>
> > +             spc_state = SCTP_ADDR_POTENTIALLY_FAILED;
> >               break;
> >
> >       default:
> > --
> > 2.1.0
>
> I also haven't spotted where the test that the application has actually enabled
> state transition events is in the code.
all events will be created, but dropped in sctp_ulpq_tail_event() when trying
to deliver up:

        /* Check if the user wishes to receive this event.  */
        if (!sctp_ulpevent_is_enabled(event, ulpq->asoc->subscribe))
                goto out_free;

> I'd have thought it would be anything is built and allocated.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
