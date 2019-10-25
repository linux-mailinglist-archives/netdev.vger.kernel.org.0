Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CACFDE420D
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404090AbfJYDWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 23:22:12 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32778 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731941AbfJYDWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 23:22:11 -0400
Received: by mail-qt1-f193.google.com with SMTP id r5so1263851qtd.0;
        Thu, 24 Oct 2019 20:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WAR5yVIm72tEaidCOf/F74OyKIYRVIjtUzNl6qiDwz0=;
        b=kWNAedWSwT1H1V+SdxdwLFEGWgQd2pJZtEwlHbUFBd84BcemQTz4ajdgFS1w/W2Fvh
         NYVwvSwnkq8fB/Sc6biUTChysXhnehkuK0DM8JIs01wa2/9ZmaJ7XhBohiGmGtf2sRRa
         0Ive/T/2WwqwWNmPRjSVO3LDMUu5hkbD/ZSnxZD9ebiiZSJWC0Xj/RffUhbXUEjU0bf1
         BkEYfQ07gNjh5mM1WclXzFgniPqvUgXP2/ziuuij22Sbae+O9XGZhEmZqGBsmoLj9pou
         kUnV7sFRIok15JD6IdOTyFPUdwzQriQuBpIAxeVIv5yXmO6S3FXxSDfc1YdIh1KG/3+r
         CflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WAR5yVIm72tEaidCOf/F74OyKIYRVIjtUzNl6qiDwz0=;
        b=H6Vh+bsYN4DVo3vjqiZKhsQp0g8Cfh9J6RIATcOk0JpL5IbjdvkQw+g2q/dwY5lnwc
         tawYfeItR4iAGXeve3ewJFG3xE/qMoLip1BWlI6EpJkmhT68+KbteU6COyqYRTzYzE6A
         UOT0TeyXoxItRU71w0puSa/KxeJNd1UdMkWaEDcmRqht5yMn4jCuC2aXUQy3nnZ9tNVd
         ugN/hzwE/o9fKTOXjfh1+NLTJiDJed3duh1CuLNauf82pMMsIVNAWPAl++s+1vW+Leno
         FRPs/bXE9dezXW0EP0WPYhNUQ7IMd8z9o+AIhMMjdhEKM6C35H/DtocteIhFfj8Q8jeS
         eCMw==
X-Gm-Message-State: APjAAAVtEb8nh7WJImed1oHV7VRaD3ChxDn1hDqGL9fFIqo76IejGzpc
        cgQdiWcKQHrpvPwZf5G8zbY=
X-Google-Smtp-Source: APXvYqxTCPwewqMokN+niGgZhz6RWgp6tlvxkPMaiwloStsUyaTc5SfGnpDOeRDQJ50xxxpjcEjc2g==
X-Received: by 2002:ad4:4d04:: with SMTP id l4mr1228924qvl.204.1571973729179;
        Thu, 24 Oct 2019 20:22:09 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.193])
        by smtp.gmail.com with ESMTPSA id y29sm593007qtc.8.2019.10.24.20.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 20:22:08 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 116E0C0AD9; Fri, 25 Oct 2019 00:22:06 -0300 (-03)
Date:   Fri, 25 Oct 2019 00:22:06 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv3 net-next 1/5] sctp: add SCTP_ADDR_POTENTIALLY_FAILED
 notification
Message-ID: <20191025032206.GB4326@localhost.localdomain>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <fb115b1444764b3eacdf69ebd9cf9681@AcuMS.aculab.com>
 <CADvbK_eQrXs4VC+OgsLibA-q2VkkdKXTK+meaRGbxJDK41aLKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_eQrXs4VC+OgsLibA-q2VkkdKXTK+meaRGbxJDK41aLKg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 19, 2019 at 04:55:01PM +0800, Xin Long wrote:
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

Right, yet for one bisecting the kernel, a checkout on this patch will
see this change regardless of patch 2. Patches 1 and 2 could be
swapped to avoid this situation.

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

Same here.

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
> 
