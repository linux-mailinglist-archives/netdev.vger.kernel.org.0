Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2391390313
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfHPNcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:32:48 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38629 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfHPNcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 09:32:48 -0400
Received: by mail-qt1-f194.google.com with SMTP id x4so6080721qts.5;
        Fri, 16 Aug 2019 06:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0e6H1mVDGcteN8O3sdbpdKixfBl9m12Tdmf4rJdw3h0=;
        b=FRJ8oFqRX/iXeU40p/WN8pLima0BJ8nMY1o0/NkjmDWm/CUYyzFFpra/GMRSusXVZa
         FBNKI/9x8BYFysdAd5k4czgLzDclVf7iMh/j8SgvxBsHeEbvt1sXqi+B8iXBH6x5wPiZ
         1hIYJQI/DLwiuzFaw1m9TZC3CRRqr6MXp2IDIPmx8ySR3vLSCHoRh2TqiWKCTd+rqWa3
         0KWS5Md3AbbtP6h7qsqQczhGYmVypAFQ5YDKSGIGd4Ha1mR/0rEJ0s6s3n3ZNPZjoKll
         sIyK9i483sINZknyjdqArkqunLrVlt7ik+sXWKIqHeolyO/bwgd2UJ+CV0jD6qOSKZcN
         bHbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0e6H1mVDGcteN8O3sdbpdKixfBl9m12Tdmf4rJdw3h0=;
        b=GBQ/Uv8j+EAEufn1XJU3Hwrpm28ta/yeughmZQ4ZLgiPE8xcZ10IuhvuZAk+aKrmz+
         CQiYUqMMRLdoyQZ5dr3WhCixIURMykWyv/Q304EN/vp/TuI01VJGr8pZIEiDlazPdZ5h
         ERglulxVA1xOxZmM8ZO/oywI3QS8Uo51WjP+pTGOUyb8S6F6z3LNbAGQXMy3c+0VOxIN
         j9xwOEb9RV415z4OgrdZolrDbZDzJ2epgO2XrVvmyz9d3Ywpah6GBK87K7UD0aZyO6/d
         mb+YwTI9naOSMVjVzQz2a8+zoaX5r5V+wozh0DRTjNDI+Q35MXX39vYuaBHF+DCpw3IU
         Koew==
X-Gm-Message-State: APjAAAXzECQFm82F4c5HnTP//Zej1Va7forydG0qRPubj3MdCkcggEwO
        30AsIDcJ+K2AEovr0PoZKp6LVtdK81hGsZtZ/p3OOpqFwGU=
X-Google-Smtp-Source: APXvYqzmXZzYlT/I4GKEZ894UnXy1EkgOziuwe+v3m+Gh16Hlpn3njLFnZyrk2x0BS4LqvBzEyW4yJIRwiYwGlTxHrM=
X-Received: by 2002:ac8:4a83:: with SMTP id l3mr8456346qtq.46.1565962366959;
 Fri, 16 Aug 2019 06:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
 <bebfb097-5357-91d8-ebc7-2f8ede392ad7@intel.com> <cc3a09eb-bcb8-a6e1-7175-77bddaf10c11@intel.com>
In-Reply-To: <cc3a09eb-bcb8-a6e1-7175-77bddaf10c11@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 16 Aug 2019 15:32:35 +0200
Message-ID: <CAJ+HfNj=devuEky3VwbibA-j+o=bKi4Gg=MeHsuuDGAKc9p2Vw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next 0/5] Add support for SKIP_BPF
 flag for AF_XDP sockets
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 at 18:46, Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
> On 8/15/2019 5:51 AM, Bj=C3=B6rn T=C3=B6pel wrote:
> > On 2019-08-15 05:46, Sridhar Samudrala wrote:
> >> This patch series introduces XDP_SKIP_BPF flag that can be specified
> >> during the bind() call of an AF_XDP socket to skip calling the BPF
> >> program in the receive path and pass the buffer directly to the socket=
.
> >>
> >> When a single AF_XDP socket is associated with a queue and a HW
> >> filter is used to redirect the packets and the app is interested in
> >> receiving all the packets on that queue, we don't need an additional
> >> BPF program to do further filtering or lookup/redirect to a socket.
> >>
> >> Here are some performance numbers collected on
> >>    - 2 socket 28 core Intel(R) Xeon(R) Platinum 8180 CPU @ 2.50GHz
> >>    - Intel 40Gb Ethernet NIC (i40e)
> >>
> >> All tests use 2 cores and the results are in Mpps.
> >>
> >> turbo on (default)
> >> ---------------------------------------------
> >>                        no-skip-bpf    skip-bpf
> >> ---------------------------------------------
> >> rxdrop zerocopy           21.9         38.5
> >> l2fwd  zerocopy           17.0         20.5
> >> rxdrop copy               11.1         13.3
> >> l2fwd  copy                1.9          2.0
> >>
> >> no turbo :  echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
> >> ---------------------------------------------
> >>                        no-skip-bpf    skip-bpf
> >> ---------------------------------------------
> >> rxdrop zerocopy           15.4         29.0
> >> l2fwd  zerocopy           11.8         18.2
> >> rxdrop copy                8.2         10.5
> >> l2fwd  copy                1.7          1.7
> >> ---------------------------------------------
> >>
> >
> > This work is somewhat similar to the XDP_ATTACH work [1]. Avoiding the
> > retpoline in the XDP program call is a nice performance boost! I like
> > the numbers! :-) I also like the idea of adding a flag that just does
> > what most AF_XDP Rx users want -- just getting all packets of a
> > certain queue into the XDP sockets.
> >
> > In addition to Toke's mail, I have some more concerns with the series:
> >
> > * AFAIU the SKIP_BPF only works for zero-copy enabled sockets. IMO, it
> >    should work for all modes (including XDP_SKB).
>
> This patch enables SKIP_BPF for AF_XDP sockets where an XDP program is
> attached at driver level (both zerocopy and copy modes)
> I tried a quick hack to see the perf benefit with generic XDP mode, but
> i didn't see any significant improvement in performance in that
> scenario. so i didn't include that mode.
>
> >
> > * In order to work, a user still needs an XDP program running. That's
> >    clunky. I'd like the behavior that if no XDP program is attached,
> >    and the option is set, the packets for a that queue end up in the
> >    socket. If there's an XDP program attached, the program has
> >    precedence.
>
> I think this would require more changes in the drivers to take XDP
> datapath even when there is no XDP program loaded.
>

Today, from a driver perspective, to enable XDP you pass a struct
bpf_prog pointer via the ndo_bpf. The program get executed in
BPF_PROG_RUN (via bpf_prog_run_xdp) from include/linux/filter.h.

I think it's possible to achieve what you're doing w/o *any* driver
modification. Pass a special, invalid, pointer to the driver (say
(void *)0x1 or smth more elegant), which has a special handling in
BPF_RUN_PROG e.g. setting a per-cpu state and return XDP_REDIRECT. The
per-cpu state is picked up in xdp_do_redirect and xdp_flush.

An approach like this would be general, and apply to all modes
automatically.

Thoughts?


> >
> > * It requires changes in all drivers. Not nice, and scales badly. Try
> >    making it generic (xdp_do_redirect/xdp_flush), so it Just Works for
> >    all XDP capable drivers.
>
> I tried to make this as generic as possible and make the changes to the
> driver very minimal, but could not find a way to avoid any changes at
> all to the driver. xdp_do_direct() gets called based after the call to
> bpf_prog_run_xdp() in the drivers.
>
> >
> > Thanks for working on this!
> >
> >
> > Bj=C3=B6rn
> >
> > [1]
> > https://lore.kernel.org/netdev/20181207114431.18038-1-bjorn.topel@gmail=
.com/
> >
> >
> >
> >> Sridhar Samudrala (5):
> >>    xsk: Convert bool 'zc' field in struct xdp_umem to a u32 bitmap
> >>    xsk: Introduce XDP_SKIP_BPF bind option
> >>    i40e: Enable XDP_SKIP_BPF option for AF_XDP sockets
> >>    ixgbe: Enable XDP_SKIP_BPF option for AF_XDP sockets
> >>    xdpsock_user: Add skip_bpf option
> >>
> >>   drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 22 +++++++++-
> >>   drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  6 +++
> >>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 ++++++++-
> >>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 16 ++++++-
> >>   include/net/xdp_sock.h                        | 21 ++++++++-
> >>   include/uapi/linux/if_xdp.h                   |  1 +
> >>   include/uapi/linux/xdp_diag.h                 |  1 +
> >>   net/xdp/xdp_umem.c                            |  9 ++--
> >>   net/xdp/xsk.c                                 | 43 ++++++++++++++++-=
--
> >>   net/xdp/xsk_diag.c                            |  5 ++-
> >>   samples/bpf/xdpsock_user.c                    |  8 ++++
> >>   11 files changed, 135 insertions(+), 17 deletions(-)
> >>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
