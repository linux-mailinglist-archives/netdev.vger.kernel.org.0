Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6BFC99161
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387793AbfHVKwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:52:22 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38268 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732595AbfHVKwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 06:52:21 -0400
Received: by mail-ot1-f67.google.com with SMTP id r20so5011854ota.5
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 03:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4boJiUtvSrHXh9JywZ5CdRGDgDJxZyyWykhQroJD6II=;
        b=tPwHTNaa0R5BAfELad/V7LQiBSIdBZiTR4qneJqv7cZVI9r3fNbz9AE0PUdIndmsNN
         Ky1LiXQ8xnjYu/WgdWus2EKHcFvqVmTkr0Tl4c32RjZ5dAmRHK29S2FV6bvkNlHYe3zZ
         nZC57J1QedwfnsGMibww8eRvU+DNT2Y7BplczH2bzUmLH6i7sKBa4lC6Ija2/dE/ZBTi
         LirihxHun1rh0WoDl/oOjKq24+v76NRKkmziV9ebG3nK3FJzovYNmT+5HwCG25GwE3oB
         GxLi5CzZPX0wAdVCvvgLuxeKkw1fGy4lYTAi2Bu+FqrTSYEAe6VSsjRP1Wv0coMd+Vmh
         8dlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4boJiUtvSrHXh9JywZ5CdRGDgDJxZyyWykhQroJD6II=;
        b=kpMaFZ0LxH3IyNbbJcXeZyMR6GZs+2pCLjhBC2C057J3mafDZCobOaNEn3ZK9XAQXU
         K8/nJ0gCaoLJppEoR4CXu4RLqfHQ9YiYQLEsrf0QasB93EO9W4UIoDfdC2Q+P/O6z0z4
         ahsRkn7ovjLylISh4nNZM0vCAolDe2DJFYx2rZIvHi5Zi9wJczQ/O/O+O6pD2iIGCgwl
         /y1RjXN/2fx7/RXirg3HIuVMHvMTJX6adtt9jtrPw0cIHfaoqToJoy8bHnRfC5elIh84
         6DcB3dAKq5xvUoq2dw7ziDIbz99nT3RUCkx7A4YyYiSwqmul3h4hiUHSBIa9Qds5FyoO
         nonQ==
X-Gm-Message-State: APjAAAVIzOBLC/JNIMh91p/aR2Fmr+Iif2JGVCYepe1pVcBrmdVvcMlc
        65dePR+b3Oa8cBIvzqU6zCi0gBQTpYNosS4quA4=
X-Google-Smtp-Source: APXvYqyiEZx3UrKpS2oXhl/INm34/5vtNerwqfh3ZsOlwLjJvLC66CKIIniOoLbVTLOjbFt5s/77ge0ktp6duSTigWU=
X-Received: by 2002:a9d:67cd:: with SMTP id c13mr29431849otn.196.1566471139826;
 Thu, 22 Aug 2019 03:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <86245c2d7b596f55d5ff1abeee3c3826b1b4370e.1566467579.git.echaudro@redhat.com>
In-Reply-To: <86245c2d7b596f55d5ff1abeee3c3826b1b4370e.1566467579.git.echaudro@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 22 Aug 2019 12:52:08 +0200
Message-ID: <CAJ8uoz35zcJT1_jZPs6ijvDrtQiGZvu3RnaeS9wx+Y_aU3m+fg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5] libbpf: add xsk_ring_prod__nb_free() function
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

On Thu, Aug 22, 2019 at 11:54 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> When an AF_XDP application received X packets, it does not mean X
> frames can be stuffed into the producer ring. To make it easier for
> AF_XDP applications this API allows them to check how many frames can
> be added into the ring.
>
> The patch below looks like a name change only, but the xsk_prod__
> prefix denotes that this API is exposed to be used by applications.
>
> Besides, if you set the nb value to the size of the ring, you will
> get the exact amount of slots available, at the cost of performance
> (you touch shared state for sure). nb is there to limit the
> touching of the shared state.
>
> Also the example xdpsock application has been modified to use this
> new API, so it's also able to process flows at a 1pps rate on veth
> interfaces.

Still just 1 single packet per second with veth and this optimization ;-)?

Thanks Eelco for working on this.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>
> ---
> v4 -> v5
>   - Rebase on latest bpf-next
>
> v3 -> v4
>   - Cleanedup commit message
>   - Updated AF_XDP sample application to use this new API
>
> v2 -> v3
>   - Removed cache by pass option
>
> v1 -> v2
>   - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
>   - Add caching so it will only touch global state when needed
>
>  samples/bpf/xdpsock_user.c | 119 ++++++++++++++++++++++++++++---------
>  tools/lib/bpf/xsk.h        |   4 +-
>  2 files changed, 93 insertions(+), 30 deletions(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index da84c760c094..bec0ee463184 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -470,9 +470,13 @@ static void kick_tx(struct xsk_socket_info *xsk)
>  static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
>                                      struct pollfd *fds)
>  {
> -       u32 idx_cq = 0, idx_fq = 0;
> -       unsigned int rcvd;
> +       static u64 free_frames[NUM_FRAMES];
> +       static size_t nr_free_frames;
> +
> +       u32 idx_cq = 0, idx_fq = 0, free_slots;
> +       unsigned int rcvd, i;
>         size_t ndescs;
> +       int ret;
>
>         if (!xsk->outstanding_tx)
>                 return;
> @@ -485,29 +489,56 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
>
>         /* re-add completed Tx buffers */
>         rcvd = xsk_ring_cons__peek(&xsk->umem->cq, ndescs, &idx_cq);
> -       if (rcvd > 0) {
> -               unsigned int i;
> -               int ret;
> -
> -               ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> -               while (ret != rcvd) {
> -                       if (ret < 0)
> -                               exit_with_error(-ret);
> -                       if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
> -                               ret = poll(fds, num_socks, opt_timeout);
> -                       ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
> -                                                    &idx_fq);
> -               }
> -               for (i = 0; i < rcvd; i++)
> +       if (!rcvd)
> +               return;
> +
> +       /* When xsk_ring_cons__peek() for example returns that 5 packets
> +        * have been received, it does not automatically mean that
> +        * xsk_ring_prod__reserve() will have 5 slots available. You will
> +        * see this, for example, when using a veth interface due to the
> +        * RX_BATCH_SIZE used by the generic driver.
> +        *
> +        * In this example we store unused buffers and try to re-stock
> +        * them the next iteration.
> +        */
> +
> +       free_slots = xsk_prod__nb_free(&xsk->umem->fq, rcvd + nr_free_frames);
> +       if (free_slots > rcvd + nr_free_frames)
> +               free_slots = rcvd + nr_free_frames;
> +
> +       ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots, &idx_fq);
> +       while (ret != free_slots) {
> +               if (ret < 0)
> +                       exit_with_error(-ret);
> +
> +               if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
> +                       ret = poll(fds, num_socks, opt_timeout);
> +
> +               ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots,
> +                                            &idx_fq);
> +       }
> +       for (i = 0; i < rcvd; i++) {
> +               u64 addr = *xsk_ring_cons__comp_addr(&xsk->umem->cq, idx_cq++);
> +
> +               if (i < free_slots)
>                         *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
> -                               *xsk_ring_cons__comp_addr(&xsk->umem->cq,
> -                                                         idx_cq++);
> +                               addr;
> +               else
> +                       free_frames[nr_free_frames++] = addr;
> +       }
>
> -               xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
> -               xsk_ring_cons__release(&xsk->umem->cq, rcvd);
> -               xsk->outstanding_tx -= rcvd;
> -               xsk->tx_npkts += rcvd;
> +       if (free_slots > rcvd) {
> +               for (i = 0; i < (free_slots - rcvd); i++) {
> +                       u64 addr = free_frames[--nr_free_frames];
> +                       *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
> +                               addr;
> +               }
>         }
> +
> +       xsk_ring_prod__submit(&xsk->umem->fq, free_slots);
> +       xsk_ring_cons__release(&xsk->umem->cq, rcvd);
> +       xsk->outstanding_tx -= rcvd;
> +       xsk->tx_npkts += rcvd;
>  }
>
>  static inline void complete_tx_only(struct xsk_socket_info *xsk)
> @@ -531,8 +562,11 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
>
>  static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
>  {
> +       static u64 free_frames[NUM_FRAMES];
> +       static size_t nr_free_frames;
> +
>         unsigned int rcvd, i;
> -       u32 idx_rx = 0, idx_fq = 0;
> +       u32 idx_rx = 0, idx_fq = 0, free_slots;
>         int ret;
>
>         rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> @@ -542,13 +576,30 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
>                 return;
>         }
>
> -       ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> -       while (ret != rcvd) {
> +       /* When xsk_ring_cons__peek() for example returns that 5 packets
> +        * have been received, it does not automatically mean that
> +        * xsk_ring_prod__reserve() will have 5 slots available. You will
> +        * see this, for example, when using a veth interface due to the
> +        * RX_BATCH_SIZE used by the generic driver.
> +        *
> +        * In this example we store unused buffers and try to re-stock
> +        * them the next iteration.
> +        */
> +
> +       free_slots = xsk_prod__nb_free(&xsk->umem->fq, rcvd + nr_free_frames);
> +       if (free_slots > rcvd + nr_free_frames)
> +               free_slots = rcvd + nr_free_frames;
> +
> +       ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots, &idx_fq);
> +       while (ret != free_slots) {
>                 if (ret < 0)
>                         exit_with_error(-ret);
> +
>                 if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
>                         ret = poll(fds, num_socks, opt_timeout);
> -               ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> +
> +               ret = xsk_ring_prod__reserve(&xsk->umem->fq, free_slots,
> +                                            &idx_fq);
>         }
>
>         for (i = 0; i < rcvd; i++) {
> @@ -557,10 +608,22 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
>                 char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
>
>                 hex_dump(pkt, len, addr);
> -               *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = addr;
> +               if (i < free_slots)
> +                       *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
> +                               addr;
> +               else
> +                       free_frames[nr_free_frames++] = addr;
> +       }
> +
> +       if (free_slots > rcvd) {
> +               for (i = 0; i < (free_slots - rcvd); i++) {
> +                       u64 addr = free_frames[--nr_free_frames];
> +                       *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
> +                               addr;
> +               }
>         }
>
> -       xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
> +       xsk_ring_prod__submit(&xsk->umem->fq, free_slots);
>         xsk_ring_cons__release(&xsk->rx, rcvd);
>         xsk->rx_npkts += rcvd;
>  }
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index aa1d6122b7db..520a772c882c 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -82,7 +82,7 @@ static inline int xsk_ring_prod__needs_wakeup(const struct xsk_ring_prod *r)
>         return *r->flags & XDP_RING_NEED_WAKEUP;
>  }
>
> -static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
> +static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 nb)
>  {
>         __u32 free_entries = r->cached_cons - r->cached_prod;
>
> @@ -116,7 +116,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
>  static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod,
>                                             size_t nb, __u32 *idx)
>  {
> -       if (xsk_prod_nb_free(prod, nb) < nb)
> +       if (xsk_prod__nb_free(prod, nb) < nb)
>                 return 0;
>
>         *idx = prod->cached_prod;
> --
> 2.18.1
>
