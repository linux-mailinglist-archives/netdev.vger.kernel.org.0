Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D37B50E22A
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbiDYNrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiDYNrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:47:10 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5046F49915;
        Mon, 25 Apr 2022 06:44:06 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id v1so14489712ljv.3;
        Mon, 25 Apr 2022 06:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pX5FU7nH8Cktg9SVTz2EEKRaDhLkaaoRknJtj2hRc4o=;
        b=pP41tske//BbPiNGqTIDXnsEK3DkdOTezs194O5QCZc5XQDbGVRk8m5N3g2vySesZ1
         sohA9fehceYS+BpnRE9PMQL2xZhRLpCnGitolR3gQGyaSE5CtRPwKDmIK3sx1vD95MIN
         l6jGjMDDP9ev7BAozbSarsCM48ZtjdJvCc12OVni6Cu0ATgW9qu50wGbSgyLYEiPwong
         EsRqlLjm65p/SbOBYHK4rlQVv1KNdtvOmi34a3bCyenmE7gmdMk8EuS4GnaRXBi9zcU8
         3ICJ1ySpBXMtBcIWhha/aJ2uusECXcWPFOzEZo6uVDPoRhdwyByZishYs/JChairoIPQ
         Zn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pX5FU7nH8Cktg9SVTz2EEKRaDhLkaaoRknJtj2hRc4o=;
        b=mjnOdieQo5uyS3RegfEHbUaDI8Ng1KiNsXu7p7LYgBmv3cABDXp6bTNWQkGpe9Z8sa
         j38LSKCGuP2hFwDZHeMfsNd+jPFgkf29vLJnw1oma1OwPV+kvfmTx5VBxWgCINDQid+D
         kfwWnePhpsh/DTCMs8NxKiLBRMNWHDog/2ZSF73mkh6KRHea2MTROAmespA+IKLBpDSH
         0ZraCcdo4zAcwlnNTKWySuFFE1qknLddXau/gZmlpFMnGNO6ty1fbOuNBPgY0sB/gv6t
         IL7S35kno+IUFtQC0lkSa1fTiRv4TUMy+lIE+Xr9dEVLhwodTdXxC1xsntnar47A9tXC
         F7UA==
X-Gm-Message-State: AOAM5337eAWsb0U8rIrjIDGJTSW78dGeoIngFfBScjOYfwzzt4swuFmg
        NB4HoO9LO2kGMLFOeML4TlGz4uDW8cAHSaCXMcg=
X-Google-Smtp-Source: ABdhPJzHmDVimnYLsaNe39Yj6PZWNajugT0sZt8nIm+YN7JQgSMmPuz61MCuoXfHi+Szp/CY82qOQlpAZmpl4BkAVc0=
X-Received: by 2002:a2e:b888:0:b0:24e:f423:93de with SMTP id
 r8-20020a2eb888000000b0024ef42393demr10049380ljp.193.1650894244572; Mon, 25
 Apr 2022 06:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220406153441.1667375-1-miquel.raynal@bootlin.com>
 <20220406153441.1667375-10-miquel.raynal@bootlin.com> <CAB_54W4epiqcATJhLB9JDZPKGZTj_jbmVwDHRZT9MxtXY6g-QA@mail.gmail.com>
 <20220407100646.049467af@xps13> <CAB_54W5ovb9=rWB-H9oZygWuQpLSG58XFtgniNn9eDh51BBQNw@mail.gmail.com>
 <CAB_54W4X4--=kmXW-xtV5WiawP0s0UWSCZWb4U8wOR-xhhgR9g@mail.gmail.com> <20220425151644.01dd47f4@xps13>
In-Reply-To: <20220425151644.01dd47f4@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 25 Apr 2022 09:43:53 -0400
Message-ID: <CAB_54W6Oa9_Td_GPJDRzskTRXEkNU=DtJ+d1+t9niGnOyoW68Q@mail.gmail.com>
Subject: Re: [PATCH v5 09/11] net: ieee802154: atusb: Call _xmit_error() when
 a transmission fails
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Apr 25, 2022 at 9:16 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Mon, 25 Apr 2022 09:05:49 -0400:
>
> > Hi,
> >
> > On Mon, Apr 25, 2022 at 8:35 AM Alexander Aring <alex.aring@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > On Thu, Apr 7, 2022 at 4:06 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > Hi Alexander,
> > > >
> > > > alex.aring@gmail.com wrote on Wed, 6 Apr 2022 17:58:59 -0400:
> > > >
> > > > > Hi,
> > > > >
> > > > > On Wed, Apr 6, 2022 at 11:34 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > > >
> > > > > > ieee802154_xmit_error() is the right helper to call when a transmission
> > > > > > has failed. Let's use it instead of open-coding it.
> > > > > >
> > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > > ---
> > > > > >  drivers/net/ieee802154/atusb.c | 5 ++---
> > > > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> > > > > > index f27a5f535808..d04db4d07a64 100644
> > > > > > --- a/drivers/net/ieee802154/atusb.c
> > > > > > +++ b/drivers/net/ieee802154/atusb.c
> > > > > > @@ -271,9 +271,8 @@ static void atusb_tx_done(struct atusb *atusb, u8 seq)
> > > > > >                  * unlikely case now that seq == expect is then true, but can
> > > > > >                  * happen and fail with a tx_skb = NULL;
> > > > > >                  */
> > > > > > -               ieee802154_wake_queue(atusb->hw);
> > > > > > -               if (atusb->tx_skb)
> > > > > > -                       dev_kfree_skb_irq(atusb->tx_skb);
> > > > > > +               ieee802154_xmit_error(atusb->hw, atusb->tx_skb,
> > > > > > +                                     IEEE802154_SYSTEM_ERROR);
> > > > >
> > > > > That should then call the xmit_error for ANY other reason which is not
> > > > > 802.15.4 specific which is the bus_error() function?
> > > >
> > > > I'll drop the bus error function so we can stick to a regular
> > > > _xmit_error() call.
> > > >
> > >
> > > Okay, this error is only hardware related.
> > >
> > > > Besides, we do not have any trac information nor any easy access to
> > > > what failed exactly, so it's probably best anyway.
> > >
> > > This is correct, Somebody needs to write support for it for atusb firmware. [0]
> > > However some transceivers can't yet or will never (because lack of
> > > functionality?) report such errors back... they will act a little bit
> > > weird.
> > >
> > > However, this return value is a BIG step moving into the right
> > > direction that other drivers can follow.
> > >
> > > I think for MLME ops we can definitely handle some transmit errors now
> > > and retry so that we don't wait for anything when we know the
> > > transceiver was never submitting.
> > >
> >
> > s/submitting/transmitted/
> >
> > I could more deeper into that topic:
> >
> > 1.
> >
> > In my opinion this result value was especially necessary for MLME-ops,
> > for others which do not directly work with MAC... they provide an
> > upper layer protocol if they want something reliable.
> >
> > 2.
> >
> > Later on we can do statistics like what was already going around in
> > the linux-wpan community to have something like whatever dump to see
> > all neighbors and see how many ack failures there, etc. Some people
> > want to make some predictions about link quality here. The kernel
> > should therefore only capture some stats and the $WHATEVER userspace
> > capable netlink monitor daemon should make some heuristic by dumping
> > those stats.
>
> I like the idea of having a per-device dump of the stats. It would be
> really straightforward to implement with the current scan
> implementation that I am about to share. We already have a per PAN
> structure (with information like ID, channel, last time it was seen,
> strength, etc). We might improve this structure with counters for all
> the common mac errors. Maybe an option to the "pans dump" command
> (again, in the pipe) might be a good start to get all the stats, like
> "pans dump [stats]". I'll keep this in mind.
>

sounds to me like a per pan filtering use case... which can be
implemented in the kernel, but nowadays there might be more generic
ways of filtering out dumps in the kernel (eBPF?). However we need to
talk about this again if there are some patches. But yes there should
be plenty of information about neighbors whichever frame was received
(which also includes transmission case in that way if an ACK was
received or not if ack request bit was set, channel access failures,
etc?). There exists a difference between if we know some address
information (MAC) or it's PHY related like channel access failure.
Most people are interested in per node information (we have address
information).

> > 3.
> >
> > Sometimes even IP capable protocols (using 6LoWPAN) want to know if
> > ack was received or not, as mentioned. But this required additional
> > handling in the socket layers... I didn't look into that topic yet but
> > I know wireless solved it because they have some similar problems.
>
> I did not look at the upper layers yet, but that would indeed be a nice
> use case of these MAC statuses.
>

I am a little bit worried about that, because at some point we run in
fragmentation of IPv6/6LoWPAN, and then one packet gets into several
802.15.4 frames... whereas such information is per frame. If all has
the same result - no problems. There is a special handling needed
which need to be documented well, e.g. I would say if one frame had no
ack back I would say it should report back to user space that no ack
came back... if possible provide detailed information but I think that
isn't easier to get back to user space than just a bit if ack was back
or not.

Again this is something where a socket error queue needs to be involved.

- Alex
