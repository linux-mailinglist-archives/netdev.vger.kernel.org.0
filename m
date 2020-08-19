Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3AE249795
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgHSHjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgHSHjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:39:08 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E96C061389;
        Wed, 19 Aug 2020 00:39:07 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id b17so23751390ion.7;
        Wed, 19 Aug 2020 00:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8v7x6IOn333yPhRdoFI5SCrzReSkQTcm7K4YrEpFEBA=;
        b=Grv6DZoBH91z1nfQ1nvkNHocRmVDPaW63xN71hqeYCYPlEhyIkJFS4GfIGNTFQ3vKE
         9DAK9KYUBFIeM77M0+UIm0atCbMH1uMMfmZ+tSv4J0Fe0xiVdhSBfQRcAHHTg1HqQq89
         Vct7mkLIQ4RE7iC7VtyJHpXPcA+hCKLIRk9+87Ak//jDs01eDQXtcMWpI16+78lTiK4o
         kInWzYBvvn2J3cLERbI2be3hqOf2XGBTDroDZ8NgTtfd6fPHx7lNCNv++En0pIQEDjp1
         gm1Bai1vLy37EfiaS9nWETsjZmnxDqs2RWtms3RoooO7A6xlonNo/OQzb8KWBK2zlYKW
         oR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8v7x6IOn333yPhRdoFI5SCrzReSkQTcm7K4YrEpFEBA=;
        b=WGq6z/pNfSLMF63TbNP6SMoP53+A5UL62bDpngfcUzkZkl6S3QEjEnNIhaK+bGIJ7u
         3JMfnUzc5QLSFtU2rQhqAWvUyLphh3YoY30Bpz31I91MIVbKmWjHT59CDO4oExHKsLWh
         ciEwTJjAYBzevxSo0fsHU3GePY312v51aTyJVhqCDxQg2a7UWvlKQNsi+4oBjVU7qGkO
         GdCcblA6z3QiBU3TuQPHjKmTCQi8pr5DBuq28mbwumy0h15gf3zWe3qyVQYPIs4BRd/1
         EFCnePafIk0dEvKF8/NOg6639qIpa80DuSnIp/NvkMI3yAnDVG8i0yqQHcreYl1xLbl5
         MMTg==
X-Gm-Message-State: AOAM530NTuTt/fJMFdzKqXpvg8DHvZJzehw1DVa6FH1ACn+rvYBtPK1X
        H0i3e7Jmb/Gc7WZhCjdePoWyU6L4JZOZENrPTQA=
X-Google-Smtp-Source: ABdhPJyLHtqcpAQnWdt0JzqGAGPzOOODIJw2TbTHevPEDtMgnnYOnwAUAI/bToGHrYQolVMZ6j1lGFf9rnA6PRSVw00=
X-Received: by 2002:a6b:b888:: with SMTP id i130mr19403919iof.182.1597822747082;
 Wed, 19 Aug 2020 00:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200818122637.21449-1-linmiaohe@huawei.com> <d713ae02fc02ec4cf5edf1a6d0e9be49f00d5371.camel@kernel.org>
In-Reply-To: <d713ae02fc02ec4cf5edf1a6d0e9be49f00d5371.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 19 Aug 2020 09:39:14 +0200
Message-ID: <CAOi1vP82zHH3YbyvQujmqzFFtXzwoRn2bvR6z8KBSsMoJwreQg@mail.gmail.com>
Subject: Re: [PATCH] libceph: Convert to use the preferred fallthrough macro
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 9:56 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-08-18 at 08:26 -0400, Miaohe Lin wrote:
> > Convert the uses of fallthrough comments to fallthrough macro.
> >
> > Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> > ---
> >  net/ceph/ceph_hash.c    | 20 ++++++++++----------
> >  net/ceph/crush/mapper.c |  2 +-
> >  net/ceph/messenger.c    |  4 ++--
> >  net/ceph/mon_client.c   |  2 +-
> >  net/ceph/osd_client.c   |  4 ++--
> >  5 files changed, 16 insertions(+), 16 deletions(-)
> >
> > diff --git a/net/ceph/ceph_hash.c b/net/ceph/ceph_hash.c
> > index 81e1e006c540..16a47c0eef37 100644
> > --- a/net/ceph/ceph_hash.c
> > +++ b/net/ceph/ceph_hash.c
> > @@ -50,35 +50,35 @@ unsigned int ceph_str_hash_rjenkins(const char *str, unsigned int length)
> >       switch (len) {
> >       case 11:
> >               c = c + ((__u32)k[10] << 24);
> > -             /* fall through */
> > +             fallthrough;
> >       case 10:
> >               c = c + ((__u32)k[9] << 16);
> > -             /* fall through */
> > +             fallthrough;
> >       case 9:
> >               c = c + ((__u32)k[8] << 8);
> >               /* the first byte of c is reserved for the length */
> > -             /* fall through */
> > +             fallthrough;
> >       case 8:
> >               b = b + ((__u32)k[7] << 24);
> > -             /* fall through */
> > +             fallthrough;
> >       case 7:
> >               b = b + ((__u32)k[6] << 16);
> > -             /* fall through */
> > +             fallthrough;
> >       case 6:
> >               b = b + ((__u32)k[5] << 8);
> > -             /* fall through */
> > +             fallthrough;
> >       case 5:
> >               b = b + k[4];
> > -             /* fall through */
> > +             fallthrough;
> >       case 4:
> >               a = a + ((__u32)k[3] << 24);
> > -             /* fall through */
> > +             fallthrough;
> >       case 3:
> >               a = a + ((__u32)k[2] << 16);
> > -             /* fall through */
> > +             fallthrough;
> >       case 2:
> >               a = a + ((__u32)k[1] << 8);
> > -             /* fall through */
> > +             fallthrough;
> >       case 1:
> >               a = a + k[0];
> >               /* case 0: nothing left to add */
> > diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
> > index 07e5614eb3f1..7057f8db4f99 100644
> > --- a/net/ceph/crush/mapper.c
> > +++ b/net/ceph/crush/mapper.c
> > @@ -987,7 +987,7 @@ int crush_do_rule(const struct crush_map *map,
> >               case CRUSH_RULE_CHOOSELEAF_FIRSTN:
> >               case CRUSH_RULE_CHOOSE_FIRSTN:
> >                       firstn = 1;
> > -                     /* fall through */
> > +                     fallthrough;
> >               case CRUSH_RULE_CHOOSELEAF_INDEP:
> >               case CRUSH_RULE_CHOOSE_INDEP:
> >                       if (wsize == 0)
> > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> > index 27d6ab11f9ee..bdfd66ba3843 100644
> > --- a/net/ceph/messenger.c
> > +++ b/net/ceph/messenger.c
> > @@ -412,7 +412,7 @@ static void ceph_sock_state_change(struct sock *sk)
> >       switch (sk->sk_state) {
> >       case TCP_CLOSE:
> >               dout("%s TCP_CLOSE\n", __func__);
> > -             /* fall through */
> > +             fallthrough;
> >       case TCP_CLOSE_WAIT:
> >               dout("%s TCP_CLOSE_WAIT\n", __func__);
> >               con_sock_state_closing(con);
> > @@ -2751,7 +2751,7 @@ static int try_read(struct ceph_connection *con)
> >                       switch (ret) {
> >                       case -EBADMSG:
> >                               con->error_msg = "bad crc/signature";
> > -                             /* fall through */
> > +                             fallthrough;
> >                       case -EBADE:
> >                               ret = -EIO;
> >                               break;
> > diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> > index 3d8c8015e976..d633a0aeaa55 100644
> > --- a/net/ceph/mon_client.c
> > +++ b/net/ceph/mon_client.c
> > @@ -1307,7 +1307,7 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
> >                * request had a non-zero tid.  Work around this weirdness
> >                * by allocating a new message.
> >                */
> > -             /* fall through */
> > +             fallthrough;
> >       case CEPH_MSG_MON_MAP:
> >       case CEPH_MSG_MDS_MAP:
> >       case CEPH_MSG_OSD_MAP:
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index e4fbcad6e7d8..7901ab6c79fd 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -3854,7 +3854,7 @@ static void scan_requests(struct ceph_osd *osd,
> >                       if (!force_resend && !force_resend_writes)
> >                               break;
> >
> > -                     /* fall through */
> > +                     fallthrough;
> >               case CALC_TARGET_NEED_RESEND:
> >                       cancel_linger_map_check(lreq);
> >                       /*
> > @@ -3891,7 +3891,7 @@ static void scan_requests(struct ceph_osd *osd,
> >                            !force_resend_writes))
> >                               break;
> >
> > -                     /* fall through */
> > +                     fallthrough;
> >               case CALC_TARGET_NEED_RESEND:
> >                       cancel_map_check(req);
> >                       unlink_request(osd, req);
>
>
> Looks sane. Merged into ceph-client/testing branch.

I amended this to also cover fs/ceph and rbd.

Thanks,

                Ilya
