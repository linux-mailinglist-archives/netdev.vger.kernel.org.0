Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D81966606A
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbjAKQ1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbjAKQ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:26:43 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DBA2AEE;
        Wed, 11 Jan 2023 08:24:27 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w14so5767060edi.5;
        Wed, 11 Jan 2023 08:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eh6GB0V1vZRNeqrtmEtzH6ek7Uuv3cp/k0Tfk0gfKxI=;
        b=mXwMlJwxOfbif3wBY1uQQz0wrWO/yf2TY2Gv0GOigNN4NLdnXqACwAswXOJBfOSOqA
         iYhcgS91+8aApSo+zWuXJPvermwRvBSdW4e5kl/ZUCs+SfhVftootWw3bbs967tk0OZ2
         DfcExcW/Cc0I4R8kcnOlKt92fWpyZGsmfm7PRe4K+ZJmRD/Rhl1M/7xuelWp70Q1xmbK
         fK1DcprSdxSjFpigRWPx/8NU5DII64vvBryttVURRoqaw4r7hQFQINM1q321JQRzpuTc
         wmF5K0mxWjs+6EDhnvgf8bqqXxYTcIJSLBTHb01qc4wmXTWFJmaHLN1U/jda24KX0LBc
         PeZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eh6GB0V1vZRNeqrtmEtzH6ek7Uuv3cp/k0Tfk0gfKxI=;
        b=RNqbkHKyWSihl9Ozv+xtqFfv1gEyhAzKyLLVo2tSeBIrGQ3jQM6cVRVu5haJ3MlHpi
         Sa+GXFNHmDLfdSDIhuVZCkqLl2C47t5DKzRXnxnEpC/WEzf7Kpk1sA5dCQkP9/v+QmBw
         zJEm6sqZiMO8J91VAInclO5d3BtYaYzPOEba/33ZIpGt8mzsfzd46yD7h3P0wVtGJc0+
         ADV+wTJFXhqbZAmNN6l+B/PuJrqBv8A3pu/RjOGhOwsNTyGCP4dUpd8SZM+OJD8yOZQ1
         s8fK3ATzkE85VWtNZONAKXZxwK0StOd/luMB0Hf383O6h4tdDSJS7nIq3v7IGFOFnR+4
         WEgw==
X-Gm-Message-State: AFqh2ko2rzgamf9DTVWVhJ4O8IlZcFXAHYNvKD5najSCE5iVsQbUSrPU
        GQXhnv4SiKknLpF6fopfkPXKpyiErs+fcT8FQYs=
X-Google-Smtp-Source: AMrXdXuI/NDKFhXKtLE1fvHUHaVV0neK59mZ/hcYzaMh3Pc/IKVG7Qsnrt1oHxmk31+i6N3ccAtQGciIZ3QP5J7Te6E=
X-Received: by 2002:a05:6402:1614:b0:492:7e5f:2b59 with SMTP id
 f20-20020a056402161400b004927e5f2b59mr2421677edv.414.1673454265742; Wed, 11
 Jan 2023 08:24:25 -0800 (PST)
MIME-Version: 1.0
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell> <20221220185903.1105011-1-sbohrer@cloudflare.com>
 <e6b0414dbc7e97857fee5936ed04efca81b1d472.camel@redhat.com>
 <CAJ8uoz2ZL54EbZw+jTCQowjmC=MBzdpVzn=uQNcM7K+sCH7K5Q@mail.gmail.com> <877cxtgnjh.fsf@toke.dk>
In-Reply-To: <877cxtgnjh.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 11 Jan 2023 17:24:14 +0100
Message-ID: <CAJ8uoz3Yqqaxmj2x+mXhS9UhSZr-UGh8-Njmk9wB9ceC4cYn1g@mail.gmail.com>
Subject: Re: [PATCH] veth: Fix race with AF_XDP exposing old or uninitialized descriptors
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Shawn Bohrer <sbohrer@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 3:21 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Magnus Karlsson <magnus.karlsson@gmail.com> writes:
>
> > On Thu, Dec 22, 2022 at 11:18 AM Paolo Abeni <pabeni@redhat.com> wrote:
> >>
> >> On Tue, 2022-12-20 at 12:59 -0600, Shawn Bohrer wrote:
> >> > When AF_XDP is used on on a veth interface the RX ring is updated in=
 two
> >> > steps.  veth_xdp_rcv() removes packet descriptors from the FILL ring
> >> > fills them and places them in the RX ring updating the cached_prod
> >> > pointer.  Later xdp_do_flush() syncs the RX ring prod pointer with t=
he
> >> > cached_prod pointer allowing user-space to see the recently filled i=
n
> >> > descriptors.  The rings are intended to be SPSC, however the existin=
g
> >> > order in veth_poll allows the xdp_do_flush() to run concurrently wit=
h
> >> > another CPU creating a race condition that allows user-space to see =
old
> >> > or uninitialized descriptors in the RX ring.  This bug has been obse=
rved
> >> > in production systems.
> >> >
> >> > To summarize, we are expecting this ordering:
> >> >
> >> > CPU 0 __xsk_rcv_zc()
> >> > CPU 0 __xsk_map_flush()
> >> > CPU 2 __xsk_rcv_zc()
> >> > CPU 2 __xsk_map_flush()
> >> >
> >> > But we are seeing this order:
> >> >
> >> > CPU 0 __xsk_rcv_zc()
> >> > CPU 2 __xsk_rcv_zc()
> >> > CPU 0 __xsk_map_flush()
> >> > CPU 2 __xsk_map_flush()
> >> >
> >> > This occurs because we rely on NAPI to ensure that only one napi_pol=
l
> >> > handler is running at a time for the given veth receive queue.
> >> > napi_schedule_prep() will prevent multiple instances from getting
> >> > scheduled. However calling napi_complete_done() signals that this
> >> > napi_poll is complete and allows subsequent calls to
> >> > napi_schedule_prep() and __napi_schedule() to succeed in scheduling =
a
> >> > concurrent napi_poll before the xdp_do_flush() has been called.  For=
 the
> >> > veth driver a concurrent call to napi_schedule_prep() and
> >> > __napi_schedule() can occur on a different CPU because the veth xmit
> >> > path can additionally schedule a napi_poll creating the race.
> >>
> >> The above looks like a generic problem that other drivers could hit.
> >> Perhaps it could be worthy updating the xdp_do_flush() doc text to
> >> explicitly mention it must be called before napi_complete_done().
> >
> > Good observation. I took a quick peek at this and it seems there are
> > at least 5 more drivers that can call napi_complete_done() before
> > xdp_do_flush():
> >
> > drivers/net/ethernet/qlogic/qede/
> > drivers/net/ethernet/freescale/dpaa2
> > drivers/net/ethernet/freescale/dpaa
> > drivers/net/ethernet/microchip/lan966x
> > drivers/net/virtio_net.c
> >
> > The question is then if this race can occur on these five drivers.
> > Dpaa2 has AF_XDP zero-copy support implemented, so it can suffer from
> > this race as the Tx zero-copy path is basically just a napi_schedule()
> > and it can be called/invoked from multiple processes at the same time.
> > In regards to the others, I do not know.
> >
> > Would it be prudent to just switch the order of xdp_do_flush() and
> > napi_complete_done() in all these drivers, or would that be too
> > defensive?
>
> We rely on being inside a single NAPI instance trough to the
> xdp_do_flush() call for RCU protection of all in-kernel data structures
> as well[0]. Not sure if this leads to actual real-world bugs for the
> in-kernel path, but conceptually it's wrong at least. So yeah, I think
> we should definitely swap the order everywhere and document this!

OK, let me take a stab at it. For at least the first four, it will be
compilation tested only from my side since I do not own any of those
SoCs/cards. Will need the help of those maintainers for sure.

> -Toke
>
> [0] See https://lore.kernel.org/r/20210624160609.292325-1-toke@redhat.com
>
