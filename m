Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E6E4BEBE7
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 21:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiBUUeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 15:34:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiBUUeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 15:34:18 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B62D237CC;
        Mon, 21 Feb 2022 12:33:54 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id e17so16334799ljk.5;
        Mon, 21 Feb 2022 12:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7itRkysVUTevMA0bL5e/DENphNPAShUbszmIAUM1SpU=;
        b=nc08u9b9M2EHDFcUzsTFBIbe2yEtQXgB5H/IWKMAy9WuinW6gmBN4qidlfR481nS3n
         iFGpqA0dVkX6xi0g0KTZJFLv/GmbAVPzr3RqVm571+P4YeA4E+ZXY3iGEyND+P8pJ7pW
         X/bDj9XEe35dxDErsR80OQoMMC6bfD4LKQlKZ3px3wZwjmWeZqT0112j2W3E8KxXWfmd
         3NtC35nMzB6Wn2nLmI30KTLQ9aXQk1eGHo+8AvAA/48+tCoAyNZKgzP0uAqGtr5w6xd6
         j0N5f9AdtSRA1QuPZUMqTGOmb3pbVxgqbicxdpyFB/BRIvbFKtET4Cdc3KkKM6Tk/9IE
         itCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7itRkysVUTevMA0bL5e/DENphNPAShUbszmIAUM1SpU=;
        b=29CYXTC+gEaxxvDdCe1/iJu87jWXsnHYM34NBgqyOAkNIMnzv3vWodmjZyxph3HmQG
         U3kVY2vYGH8XmnivREXqyWLHwkbS+9jkrZHEa2g9IJDvBrjPD5kBTAvipdN716+yInqR
         IKLHFkyBItbBLBVZMtGT/Ej6iiCCcWswjeUWabXvFX6nbCP5HvhQKsdhbvfbFd0jUUnP
         j/9rEZGSKEy2SBaeVhkWw8D3Hab/NpwqnE1G2ddwNAEL+NEhQk91T267a0ChgU6g57li
         y/rAR7YZuprY2I0c5s10vJd2m3x29sTBIYSMRqRLCu4b1sEQdHk3xt3Ses2yV0UBaprG
         r9EQ==
X-Gm-Message-State: AOAM5326U9Npbipi7hFTBdjF65Emvp1DqToBtUsmBtPFRqbMqmtjAVWa
        +KFWkzjDEEA/4EPVFDOf39TPnuLvDrXb4jvbpnM=
X-Google-Smtp-Source: ABdhPJwMZlyKwsHT6K1DSDZkb8SwWUJY/HAxdT6bTiVWouEyJKwWkp36mVruE/18Hd9n6iTmhD/whA5ULN/KtjSHu5M=
X-Received: by 2002:a2e:7007:0:b0:246:2b76:31a with SMTP id
 l7-20020a2e7007000000b002462b76031amr10941520ljc.397.1645475632996; Mon, 21
 Feb 2022 12:33:52 -0800 (PST)
MIME-Version: 1.0
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
 <20220207144804.708118-15-miquel.raynal@bootlin.com> <CAB_54W45p6e5sY6O=yHq39vsN+h_Yi6e9=GGky+1vO_H3oUj9A@mail.gmail.com>
 <CAB_54W5YHhcOtZ6D7cgSvDb0cakoL5tJjrN7fX9jiK6x=gOTVQ@mail.gmail.com>
In-Reply-To: <CAB_54W5YHhcOtZ6D7cgSvDb0cakoL5tJjrN7fX9jiK6x=gOTVQ@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 21 Feb 2022 15:33:41 -0500
Message-ID: <CAB_54W6M+AhrB5mT0Lhm2XoKvxgXTowExiF33uzJdXd_KoQhRQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 14/14] net: mac802154: Introduce a
 synchronous API for MLME commands
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
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

On Mon, Feb 21, 2022 at 3:33 PM Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Sun, Feb 20, 2022 at 6:52 PM Alexander Aring <alex.aring@gmail.com> wrote:
> >
> > Hi,
> >
> > On Mon, Feb 7, 2022 at 9:48 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > This is the slow path, we need to wait for each command to be processed
> > > before continuing so let's introduce an helper which does the
> > > transmission and blocks until it gets notified of its asynchronous
> > > completion. This helper is going to be used when introducing scan
> > > support.
> > >
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  net/mac802154/ieee802154_i.h | 1 +
> > >  net/mac802154/tx.c           | 6 ++++++
> > >  2 files changed, 7 insertions(+)
> > >
> > > diff --git a/net/mac802154/ieee802154_i.h b/net/mac802154/ieee802154_i.h
> > > index 295c9ce091e1..ad76a60af087 100644
> > > --- a/net/mac802154/ieee802154_i.h
> > > +++ b/net/mac802154/ieee802154_i.h
> > > @@ -123,6 +123,7 @@ extern struct ieee802154_mlme_ops mac802154_mlme_wpan;
> > >  void ieee802154_rx(struct ieee802154_local *local, struct sk_buff *skb);
> > >  void ieee802154_xmit_sync_worker(struct work_struct *work);
> > >  void ieee802154_sync_and_stop_tx(struct ieee802154_local *local);
> > > +void ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb);
> > >  netdev_tx_t
> > >  ieee802154_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
> > >  netdev_tx_t
> > > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > > index 06ae2e6cea43..7c281458942e 100644
> > > --- a/net/mac802154/tx.c
> > > +++ b/net/mac802154/tx.c
> > > @@ -126,6 +126,12 @@ void ieee802154_sync_and_stop_tx(struct ieee802154_local *local)
> > >         atomic_dec(&local->phy->hold_txs);
> > >  }
> > >
> > > +void ieee802154_mlme_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > +{
> > > +       ieee802154_tx(local, skb);
> > > +       ieee802154_sync_and_stop_tx(local);
> >
> > Some of those functions can fail, in async case we can do some stats
> > but here we can deliver the caller an error. Please do so.
> >
>
> to more specify what I mean here is also to get an error if the async
> transmit path ends with the error case and not success. You need to

s/not success/success/

- Alex
