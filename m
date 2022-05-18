Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E9952B995
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbiERMNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbiERMND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:13:03 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6C715A3E6;
        Wed, 18 May 2022 05:13:01 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h8so2272796ljb.6;
        Wed, 18 May 2022 05:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S8xiWwLl9oglUBlJaalCDzI0dhyWrjbQSK+WdET75zs=;
        b=I6A3re+kEvltGk6iyhDEpWbfL1W6CZ75iWJ+63BgeHWgRMY6IaDnbds8iVREXdZpR4
         6y2PIuZ4YGKaexQTYQRmVgdEZsfhtkgApCNWj096602xlnjUUFvwu5JGtHxN+wqnFVqc
         5qlNSpPgnVxZ9qljMbm5xo+QRbl+AAWIDkxmwA8Rb5AK4ys0jCbVxjkBPBYkldeJ5d6T
         kiF4CaIAVaxrAyszzrZqpcx20tqSqhClnhC0rxoe3/2xS8fPlktw/2c5/zskDEaChX+z
         dbGlo/OGyekhNJnYlqWWkhZJTxor+nXedznNEjYzxyGQ/WINq48V4+17j6hT/E9nEi5L
         pOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8xiWwLl9oglUBlJaalCDzI0dhyWrjbQSK+WdET75zs=;
        b=jrm1q16ojWy8jbu66EY3Q9n7SE6oeyid7PyJvZOwU+INmK3MJqI97mMOjPEEazbAJm
         Y7X5lR7xDE+Tuqs+9OEc2FDnwwzuNAR+R1kqf380I63XHMcXikGs8Q9Skfy45Ce4w/GQ
         P5qXLxIja2X7nhr3Opy4MAQmVibjBP4dYKu2m+t1RDc/pLd9h0wwREMNmBVbVJRrMvCc
         d673IzsbfPfP9yuknTW5bePp2DlNiGCY/aG2c4BszjwviFsu69UDHKloTL0URWrNOyn0
         1ETpqNV7SivstQTL6yMlXBmGyAnbaQnSL0KAf8HfcMzkW8Qytqw5FvyRWpPZNq/Uz55h
         Tkrw==
X-Gm-Message-State: AOAM530Cq2gIvjvqbz+OzPpe014+esIhsJ4BRypT3X5TRh8Mm21WYkah
        Kk1wrQXgBF3s9WYyJymqXHGoqiGUMyON9BAyaRZVedLLoEc=
X-Google-Smtp-Source: ABdhPJx+WqCgZEJ71ncfYrbbXP4WOGAFxQqpp1BwEzfSMBfSAcPKkPVcjdIIBgSLCnYEr6YF4Lq/aWgS99gRhhkikIw=
X-Received: by 2002:a2e:b893:0:b0:250:6ab8:6e1a with SMTP id
 r19-20020a2eb893000000b002506ab86e1amr16665030ljp.193.1652875979443; Wed, 18
 May 2022 05:12:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220517163450.240299-1-miquel.raynal@bootlin.com>
 <20220517163450.240299-10-miquel.raynal@bootlin.com> <CAK-6q+jQL7cFJrL6XjuaJnNDggtO1d_sB+T+GrY9yT+Y+KC0oA@mail.gmail.com>
 <20220518104435.76f5c0d5@xps-13> <CAB_54W7bLZ8i7W-ZzQ2WXgMvywcC=tEDHZqbj1yWYuKoVgm1sw@mail.gmail.com>
In-Reply-To: <CAB_54W7bLZ8i7W-ZzQ2WXgMvywcC=tEDHZqbj1yWYuKoVgm1sw@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Wed, 18 May 2022 08:12:48 -0400
Message-ID: <CAB_54W6D-tr_c7dMbcLUO0VFfFz7vDgjjW+nRE4pWg78xqdbYg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v3 09/11] net: mac802154: Introduce a
 synchronous API for MLME commands
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, May 18, 2022 at 7:59 AM Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Wed, May 18, 2022 at 4:44 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Tue, 17 May 2022 20:41:41 -0400:
> >
> > > Hi,
> > >
> > > On Tue, May 17, 2022 at 12:35 PM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > This is the slow path, we need to wait for each command to be processed
> > > > before continuing so let's introduce an helper which does the
> > > > transmission and blocks until it gets notified of its asynchronous
> > > > completion. This helper is going to be used when introducing scan
> > > > support.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  net/mac802154/ieee802154_i.h |  1 +
> > > >  net/mac802154/tx.c           | 46 ++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 47 insertions(+)
> > > >
> > > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > > > index a057827fc48a..b42c6ac789f5 100644
> > > > --- a/net/mac802154/ieee802154_i.h
> > > > +++ b/net/mac802154/ieee802154_i.h
> > > > @@ -125,6 +125,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> > > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> > > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > > >  int ieee802154_sync_and_hold_queue(struct ieee802154_local *local);
> > > > +int ieee802154_mlme_tx_one(struct ieee802154_local *local, struct sk_buff *skb);
> > > >  netdev_tx_t
> > > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> > > >  netdev_tx_t
> > > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > > index 38f74b8b6740..6cc4e5c7ba94 100644
> > > > --- a/net/mac802154/tx.c
> > > > +++ b/net/mac802154/tx.c
> > > > @@ -128,6 +128,52 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
> > > >         return ieee802154_sync_queue(local);
> > > >  }
> > > >
> > > > +static int ieee802154_mlme_op_pre(struct ieee802154_local *local)
> > > > +{
> > > > +       return ieee802154_sync_and_hold_queue(local);
> > > > +}
> > > > +
> > > > +static int ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > +{
> > > > +       int ret;
> > > > +
> > > > +       /* Avoid possible calls to ->ndo_stop() when we asynchronously perform
> > > > +        * MLME transmissions.
> > > > +        */
> > > > +       rtnl_lock();
> > > > +
> > > > +       /* Ensure the device was not stopped, otherwise error out */
> > > > +       if (!local->open_count)
> > > > +               return -EBUSY;
> > > > +
> > >
> > > No -EBUSY here, use ?-ENETDOWN?.
> >
> > Isn't it strange to return "Network is down" while we try to stop the
> > device but fail to do so because, actually, it is still being used?
> >
>
> you are right. Maybe -EPERM, in a sense of whether the netdev state
> allows it or not.

or maybe not, if this is the error the user gets by running iwpan. The
problem I have with -EBUSY is that it indicates some resource is being
used and will be solved at some time. Especially in a transmit
function e.g. framebuffer.

- Alex
