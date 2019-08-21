Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDBB097DB2
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfHUOxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:53:43 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:39456 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfHUOxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 10:53:42 -0400
Received: by mail-oi1-f194.google.com with SMTP id 16so1785058oiq.6
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 07:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rO+5NEt3nR8ktHaacgIDCDxYKXIBGiI9k8t7bKOcqjg=;
        b=ebdPX07QormWL+eP3g9/A+ehRSKWumEmhUA+UmhhuR0nRI38FNeL7m8t92OD66EfVl
         xfMU0qxqci2WAtd6BIQt7LulCkVG9RYz/oehoUh52TxRd/2HLBbpev1YJRr4mMIQcW/A
         RooYycfeJVbO/PO5LA1mxawRF7KktdMuVTABdQARPmeyNFQqH1O3qfrzAaN4ZsqIjykf
         NTb5xxCkoU53hcvVlZidAs+xCpLFc16Dv1DxS0/viYKqujVuq0vrUyLv2OL3G2+pFgqP
         GQcZTL4bXgRPWZHKtSNsCQECnwpbFE9J7eL7C3F4eCQbH9+p4EC1GwDJScONFGyy1KfG
         jPwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rO+5NEt3nR8ktHaacgIDCDxYKXIBGiI9k8t7bKOcqjg=;
        b=VTdcdeV6gDtMdAP5UFcHxr8qw2xOA82lrd65r5z5a45rk/VHT0/85GePGHirD+9E9L
         gRKWkMoL6MXC1R4Sq51QSnF/p42F4uupaer3+d4v3pgnlelJcpZpzwJzWjYYE0ZivtZI
         rB++qEQsouQQWSkKXGBsjxGf6P4lYMNbn5wA617pY5yzpNZelrexQXdtKyaSoi1muF8N
         euw58o0XXd9pIGydUaRW4hbgLmeBOPM4a2dM2sLsNXg2wfsW5yR5ML0NQqvnrlM/UB9P
         bF2gnyaHPqg+ZYXjbMG4e2mOXRXihL0efWzSSp+WmIHBEoSkUIiZzfCgE9XDFuiaVmFK
         yQdA==
X-Gm-Message-State: APjAAAUyUco6/e4wegBIkhar+nPBNmv4Ad//ll+vcYT/J4f6ni5VSccJ
        hxudIIEMT/4dra0t+V6M2Fa0Mc6ti9zGKrfAQH9S7xAKhNc=
X-Google-Smtp-Source: APXvYqwW/UsUMpwt+ipxJgFE9sJQF5j4UPiUeg1zA8yIedKwl5LBzXWM0A8XEsl3PQzvkr+wcFB07lU8J4793urYggc=
X-Received: by 2002:aca:fcc4:: with SMTP id a187mr306296oii.126.1566399221257;
 Wed, 21 Aug 2019 07:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <d1773613833e2824f95c3adbe46bff757280c16e.1565790591.git.echaudro@redhat.com>
 <CAJ8uoz3MszznV7McpttcVauQ5vgSiOpfT7J=63BNbruVwjFQBQ@mail.gmail.com>
 <BC1D077F-1601-451D-A396-1C129B185DD3@redhat.com> <CAJ8uoz2v_48F6BuMkG7RPUymjQ2XL4hdPbeZu2R6SoarHSP47A@mail.gmail.com>
In-Reply-To: <CAJ8uoz2v_48F6BuMkG7RPUymjQ2XL4hdPbeZu2R6SoarHSP47A@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 21 Aug 2019 16:53:29 +0200
Message-ID: <CAJ8uoz1kQXgMUydktY3ci=8fjneUDW9B=qOGHzEQY1MvBThu8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] libbpf: add xsk_ring_prod__nb_free() function
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 4:14 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Aug 21, 2019 at 3:46 PM Eelco Chaudron <echaudro@redhat.com> wrote:
> >
> >
> >
> > On 21 Aug 2019, at 15:11, Magnus Karlsson wrote:
> >
> > > On Wed, Aug 14, 2019 at 3:51 PM Eelco Chaudron <echaudro@redhat.com>
> > > wrote:
> > >>
> > >> When an AF_XDP application received X packets, it does not mean X
> > >> frames can be stuffed into the producer ring. To make it easier for
> > >> AF_XDP applications this API allows them to check how many frames can
> > >> be added into the ring.
> > >>
> > >> The patch below looks like a name change only, but the xsk_prod__
> > >> prefix denotes that this API is exposed to be used by applications.
> > >>
> > >> Besides, if you set the nb value to the size of the ring, you will
> > >> get the exact amount of slots available, at the cost of performance
> > >> (you touch shared state for sure). nb is there to limit the
> > >> touching of the shared state.
> > >>
> > >> Also the example xdpsock application has been modified to use this
> > >> new API, so it's also able to process flows at a 1pps rate on veth
> > >> interfaces.

1 pps! That is not that impressive ;-).

> > > My apologies for the late reply and thank you for working on this. So
> > > what kind of performance difference do you see with your modified
> > > xdpsock application on a regular NIC for txpush and l2fwd? If there is
> > > basically no difference or it is faster, we can go ahead and accept
> > > this. But if the difference is large, we might consider to have two
> > > versions of txpush and l2fwd as the regular NICs do not need this. Or
> > > we optimize your code so that it becomes as fast as the previous
> > > version.
> >
> > For both operation modes, I ran 5 test with and without the changes
> > applied using an iexgb connecting to a XENA tester. The throughput
> > numbers were within the standard deviation, so no noticeable performance
> > gain or drop.
>
> Sounds good, but let me take your patches for a run on something
> faster, just to make sure we are CPU bound. Will get back.

I ran some experiments and with two cores (app on one, softirq on
another) there is no impact since the application core has cycles to
spare. But if you run it on a single core the drop is 1- 2% for l2fwd.
I think this is ok since your version is a better example and more
correct. Just note that your patch did not apply cleanly to bpf-next,
so please rebase it, resubmit and I will ack it.

Thanks: Magnus

> /Magnus
>
> > Let me know if this is enough, if not I can rebuild the setup and do
> > some more tests.
> >
> > > /Magnus
> > >
> > >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > >> ---
> > >>
> > >> v3 -> v4
> > >>   - Cleanedup commit message
> > >>   - Updated AF_XDP sample application to use this new API
> > >>
> > >> v2 -> v3
> > >>   - Removed cache by pass option
> > >>
> > >> v1 -> v2
> > >>   - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
> > >>   - Add caching so it will only touch global state when needed
> > >>
> > >>  samples/bpf/xdpsock_user.c | 109
> > >> ++++++++++++++++++++++++++++---------
> > >>  tools/lib/bpf/xsk.h        |   4 +-
> > >>  2 files changed, 86 insertions(+), 27 deletions(-)
> > >>
> > >> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> > >> index 93eaaf7239b2..87115e233b54 100644
> > >> --- a/samples/bpf/xdpsock_user.c
> > >> +++ b/samples/bpf/xdpsock_user.c
> > >> @@ -461,9 +461,13 @@ static void kick_tx(struct xsk_socket_info *xsk)
> > >>
> > >>  static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
> > >>  {
> > >> -       u32 idx_cq = 0, idx_fq = 0;
> > >> -       unsigned int rcvd;
> > >> +       static u64 free_frames[NUM_FRAMES];
> > >> +       static size_t nr_free_frames;
> > >> +
> > >> +       u32 idx_cq = 0, idx_fq = 0, free_slots;
> > >> +       unsigned int rcvd, i;
> > >>         size_t ndescs;
> > >> +       int ret;
> > >>
> > >>         if (!xsk->outstanding_tx)
> > >>                 return;
> > >> @@ -474,27 +478,52 @@ static inline void complete_tx_l2fwd(struct
> > >> xsk_socket_info *xsk)
> > >>
> > >>         /* re-add completed Tx buffers */
> > >>         rcvd = xsk_ring_cons__peek(&xsk->umem->cq, ndescs, &idx_cq);
> > >> -       if (rcvd > 0) {
> > >> -               unsigned int i;
> > >> -               int ret;
> > >> +       if (!rcvd)
> > >> +               return;
> > >>
> > >> -               ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
> > >> &idx_fq);
> > >> -               while (ret != rcvd) {
> > >> -                       if (ret < 0)
> > >> -                               exit_with_error(-ret);
> > >> -                       ret = xsk_ring_prod__reserve(&xsk->umem->fq,
> > >> rcvd,
> > >> -                                                    &idx_fq);
> > >> -               }
> > >> -               for (i = 0; i < rcvd; i++)
> > >> +       /* When xsk_ring_cons__peek() for example returns that 5
> > >> packets
> > >> +        * have been received, it does not automatically mean that
> > >> +        * xsk_ring_prod__reserve() will have 5 slots available. You
> > >> will
> > >> +        * see this, for example, when using a veth interface due to
> > >> the
> > >> +        * RX_BATCH_SIZE used by the generic driver.
> > >> +        *
> > >> +        * In this example we store unused buffers and try to
> > >> re-stock
> > >> +        * them the next iteration.
> > >> +        */
> > >> +
> > >> +       free_slots = xsk_prod__nb_free(&xsk->umem->fq, rcvd +
> > >> nr_free_frames);
> > >> +       if (free_slots > rcvd + nr_free_frames)
> > >> +               free_slots = rcvd + nr_free_frames;
> > >> +
> > >> +       ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots,
> > >> &idx_fq);
> > >> +       while (ret != free_slots) {
> > >> +               if (ret < 0)
> > >> +                       exit_with_error(-ret);
> > >> +               ret = xsk_ring_prod__reserve(&xsk->umem->fq,
> > >> free_slots,
> > >> +                                            &idx_fq);
> > >> +       }
> > >> +       for (i = 0; i < rcvd; i++) {
> > >> +               u64 addr = *xsk_ring_cons__comp_addr(&xsk->umem->cq,
> > >> idx_cq++);
> > >> +
> > >> +               if (i < free_slots)
> > >>                         *xsk_ring_prod__fill_addr(&xsk->umem->fq,
> > >> idx_fq++) =
> > >> -
> > >> *xsk_ring_cons__comp_addr(&xsk->umem->cq,
> > >> -                                                         idx_cq++);
> > >> +                               addr;
> > >> +               else
> > >> +                       free_frames[nr_free_frames++] = addr;
> > >> +       }
> > >>
> > >> -               xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
> > >> -               xsk_ring_cons__release(&xsk->umem->cq, rcvd);
> > >> -               xsk->outstanding_tx -= rcvd;
> > >> -               xsk->tx_npkts += rcvd;
> > >> +       if (free_slots > rcvd) {
> > >> +               for (i = 0; i < (free_slots - rcvd); i++) {
> > >> +                       u64 addr = free_frames[--nr_free_frames];
> > >> +                       *xsk_ring_prod__fill_addr(&xsk->umem->fq,
> > >> idx_fq++) =
> > >> +                               addr;
> > >> +               }
> > >>         }
> > >> +
> > >> +       xsk_ring_prod__submit(&xsk->umem->fq, free_slots);
> > >> +       xsk_ring_cons__release(&xsk->umem->cq, rcvd);
> > >> +       xsk->outstanding_tx -= rcvd;
> > >> +       xsk->tx_npkts += rcvd;
> > >>  }
> > >>
> > >>  static inline void complete_tx_only(struct xsk_socket_info *xsk)
> > >> @@ -517,19 +546,37 @@ static inline void complete_tx_only(struct
> > >> xsk_socket_info *xsk)
> > >>
> > >>  static void rx_drop(struct xsk_socket_info *xsk)
> > >>  {
> > >> +       static u64 free_frames[NUM_FRAMES];
> > >> +       static size_t nr_free_frames;
> > >> +
> > >>         unsigned int rcvd, i;
> > >> -       u32 idx_rx = 0, idx_fq = 0;
> > >> +       u32 idx_rx = 0, idx_fq = 0, free_slots;
> > >>         int ret;
> > >>
> > >>         rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> > >>         if (!rcvd)
> > >>                 return;
> > >>
> > >> -       ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> > >> -       while (ret != rcvd) {
> > >> +       /* When xsk_ring_cons__peek() for example returns that 5
> > >> packets
> > >> +        * have been received, it does not automatically mean that
> > >> +        * xsk_ring_prod__reserve() will have 5 slots available. You
> > >> will
> > >> +        * see this, for example, when using a veth interface due to
> > >> the
> > >> +        * RX_BATCH_SIZE used by the generic driver.
> > >> +        *
> > >> +        * In this example we store unused buffers and try to
> > >> re-stock
> > >> +        * them the next iteration.
> > >> +        */
> > >> +
> > >> +       free_slots = xsk_prod__nb_free(&xsk->umem->fq, rcvd +
> > >> nr_free_frames);
> > >> +       if (free_slots > rcvd + nr_free_frames)
> > >> +               free_slots = rcvd + nr_free_frames;
> > >> +
> > >> +       ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots,
> > >> &idx_fq);
> > >> +       while (ret != free_slots) {
> > >>                 if (ret < 0)
> > >>                         exit_with_error(-ret);
> > >> -               ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
> > >> &idx_fq);
> > >> +               ret = xsk_ring_prod__reserve(&xsk->umem->fq,
> > >> free_slots,
> > >> +                                            &idx_fq);
> > >>         }
> > >>
> > >>         for (i = 0; i < rcvd; i++) {
> > >> @@ -538,10 +585,22 @@ static void rx_drop(struct xsk_socket_info
> > >> *xsk)
> > >>                 char *pkt = xsk_umem__get_data(xsk->umem->buffer,
> > >> addr);
> > >>
> > >>                 hex_dump(pkt, len, addr);
> > >> -               *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
> > >> addr;
> > >> +               if (i < free_slots)
> > >> +                       *xsk_ring_prod__fill_addr(&xsk->umem->fq,
> > >> idx_fq++) =
> > >> +                               addr;
> > >> +               else
> > >> +                       free_frames[nr_free_frames++] = addr;
> > >> +       }
> > >> +
> > >> +       if (free_slots > rcvd) {
> > >> +               for (i = 0; i < (free_slots - rcvd); i++) {
> > >> +                       u64 addr = free_frames[--nr_free_frames];
> > >> +                       *xsk_ring_prod__fill_addr(&xsk->umem->fq,
> > >> idx_fq++) =
> > >> +                               addr;
> > >> +               }
> > >>         }
> > >>
> > >> -       xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
> > >> +       xsk_ring_prod__submit(&xsk->umem->fq, free_slots);
> > >>         xsk_ring_cons__release(&xsk->rx, rcvd);
> > >>         xsk->rx_npkts += rcvd;
> > >>  }
> > >> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > >> index 833a6e60d065..cae506ab3f3c 100644
> > >> --- a/tools/lib/bpf/xsk.h
> > >> +++ b/tools/lib/bpf/xsk.h
> > >> @@ -76,7 +76,7 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons
> > >> *rx, __u32 idx)
> > >>         return &descs[idx & rx->mask];
> > >>  }
> > >>
> > >> -static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32
> > >> nb)
> > >> +static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32
> > >> nb)
> > >>  {
> > >>         __u32 free_entries = r->cached_cons - r->cached_prod;
> > >>
> > >> @@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct
> > >> xsk_ring_cons *r, __u32 nb)
> > >>  static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod
> > >> *prod,
> > >>                                             size_t nb, __u32 *idx)
> > >>  {
> > >> -       if (xsk_prod_nb_free(prod, nb) < nb)
> > >> +       if (xsk_prod__nb_free(prod, nb) < nb)
> > >>                 return 0;
> > >>
> > >>         *idx = prod->cached_prod;
> > >> --
> > >> 2.18.1
> > >>
