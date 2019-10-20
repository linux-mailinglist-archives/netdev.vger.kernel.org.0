Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8D4DDFAB
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 19:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfJTRMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 13:12:14 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:32954 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfJTRMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 13:12:13 -0400
Received: by mail-qk1-f196.google.com with SMTP id 71so6253657qkl.0;
        Sun, 20 Oct 2019 10:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2Ecj+ZeIjMcfOAEbWP79WcTG1YfBKfhdkoV2tlBJo1E=;
        b=KTozHMaa+35EIR5XwvZMw+HxT2PHwk7CcsqrROaXUidYHIYzlBwP4Uf9vlTlTdohyh
         chlNCvVQk2CdcKv1fZU3G7hNWksTyU5h9iw/B6A/MCxSW+FApwAsNyIDxujHZw50eMmP
         fUwSly17X3lSTfpIzi919UHtZFjIhBZIq781760TGzqjQQHM0z7ukud+zvkByvtnaX53
         HWBeJJoVCKKsh0dUzY4LzgRsGu3CORW+x03dKeusQ2cXfhSuK8vts03jX6H/MY4zY607
         gEzvhn6HukYcfZ1uTdI82kO0Yl+0wYlNT3IG1Xf4nYmIvhUyy7bb9koFdFBAZYFnDNaJ
         nt0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2Ecj+ZeIjMcfOAEbWP79WcTG1YfBKfhdkoV2tlBJo1E=;
        b=meWaPXEtoNtH6W3/kn/6AGgFucB741i6tEDTZwDvAhfxdwN0POQkkuLuZ0bv/x3FxX
         zL0aaX2BsjAla5JWLbYDOPNUx6i5yLVKk8WdBSeXz5U/MhAHLF0HSiGO1iSiptlYP0W7
         hRdWOJfjHqasV8EvSJkghHpkT6OiVfzLU6SrWZSrkUqSy6hjxRCoNi0E3H9pEqkbmGNQ
         +wJ1Q83lv8Vk9XSXSUSLfZg61WHcf1SQMC+3Fc7E+aCfI0aK5OvizfqkKtELmq5iY4jM
         5aIDPBG71Hv0SrhjsoD4caHy4V07azAc0hvjOLDGd4x05KFo5ZaOIdcIc95ZmwlfPDYa
         IMMA==
X-Gm-Message-State: APjAAAWfIoC/leOSZgEyPgAM4sHdaaqHtyaakPdXkuRaP0v9SoWDV/kc
        1qSC2m1TgTmVRRdZBph0qogMeGjGJfF0zdeVNss=
X-Google-Smtp-Source: APXvYqxCfkppJLJ0//IChvnQN8ymatTMeJGgQLEey36Vm3Kn79me+a9Ns4Z32lYbaBdKZvr6NydxcGoMZs+xg5I2vgI=
X-Received: by 2002:a05:620a:132b:: with SMTP id p11mr8552225qkj.232.1571591532355;
 Sun, 20 Oct 2019 10:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
 <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com>
 <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com>
 <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com> <CAADnVQ+qq6RLMjh5bB1ugXP5p7vYM2F1fLGFQ2pL=2vhCLiBdA@mail.gmail.com>
 <2032d58c-916f-d26a-db14-bd5ba6ad92b9@intel.com> <CAADnVQ+CH1YM52+LfybLS+NK16414Exrvk1QpYOF=HaT4KRaxg@mail.gmail.com>
 <acf69635-5868-f876-f7da-08954d1f690e@intel.com> <20191019001449.fk3gnhih4nx724pm@ast-mbp>
 <6f281517-3785-ce46-65de-e2f78576783b@intel.com> <20191019022525.w5xbwkav2cpqkfwi@ast-mbp>
 <877e4zd8py.fsf@toke.dk>
In-Reply-To: <877e4zd8py.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sun, 20 Oct 2019 19:12:01 +0200
Message-ID: <CAJ+HfNj07FwmU2GGpUYw56PRwu4pHyHNSkbCOogbMB5zB2QqWA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Herbert, Tom" <tom.herbert@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Oct 2019 at 12:15, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Fri, Oct 18, 2019 at 05:45:26PM -0700, Samudrala, Sridhar wrote:
> >> On 10/18/2019 5:14 PM, Alexei Starovoitov wrote:
> >> > On Fri, Oct 18, 2019 at 11:40:07AM -0700, Samudrala, Sridhar wrote:
> >> > >
> >> > > Perf report for "AF_XDP default rxdrop" with patched kernel - miti=
gations ON
> >> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >> > > Samples: 44K of event 'cycles', Event count (approx.): 38532389541
> >> > > Overhead  Command          Shared Object              Symbol
> >> > >    15.31%  ksoftirqd/28     [i40e]                     [k] i40e_cl=
ean_rx_irq_zc
> >> > >    10.50%  ksoftirqd/28     bpf_prog_80b55d8a76303785  [k] bpf_pro=
g_80b55d8a76303785
> >> > >     9.48%  xdpsock          [i40e]                     [k] i40e_cl=
ean_rx_irq_zc
> >> > >     8.62%  xdpsock          xdpsock                    [.] main
> >> > >     7.11%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_rcv
> >> > >     5.81%  ksoftirqd/28     [kernel.vmlinux]           [k] xdp_do_=
redirect
> >> > >     4.46%  xdpsock          bpf_prog_80b55d8a76303785  [k] bpf_pro=
g_80b55d8a76303785
> >> > >     3.83%  xdpsock          [kernel.vmlinux]           [k] xsk_rcv
> >> >
> >> > why everything is duplicated?
> >> > Same code runs in different tasks ?
> >>
> >> Yes. looks like these functions run from both the app(xdpsock) context=
 and ksoftirqd context.
> >>
> >> >
> >> > >     2.81%  ksoftirqd/28     [kernel.vmlinux]           [k] bpf_xdp=
_redirect_map
> >> > >     2.78%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_map=
_lookup_elem
> >> > >     2.44%  xdpsock          [kernel.vmlinux]           [k] xdp_do_=
redirect
> >> > >     2.19%  ksoftirqd/28     [kernel.vmlinux]           [k] __xsk_m=
ap_redirect
> >> > >     1.62%  ksoftirqd/28     [kernel.vmlinux]           [k] xsk_ume=
m_peek_addr
> >> > >     1.57%  xdpsock          [kernel.vmlinux]           [k] xsk_ume=
m_peek_addr
> >> > >     1.32%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_dir=
ect_sync_single_for_cpu
> >> > >     1.28%  xdpsock          [kernel.vmlinux]           [k] bpf_xdp=
_redirect_map
> >> > >     1.15%  xdpsock          [kernel.vmlinux]           [k] dma_dir=
ect_sync_single_for_device
> >> > >     1.12%  xdpsock          [kernel.vmlinux]           [k] xsk_map=
_lookup_elem
> >> > >     1.06%  xdpsock          [kernel.vmlinux]           [k] __xsk_m=
ap_redirect
> >> > >     0.94%  ksoftirqd/28     [kernel.vmlinux]           [k] dma_dir=
ect_sync_single_for_device
> >> > >     0.75%  ksoftirqd/28     [kernel.vmlinux]           [k] __x86_i=
ndirect_thunk_rax
> >> > >     0.66%  ksoftirqd/28     [i40e]                     [k] i40e_cl=
ean_programming_status
> >> > >     0.64%  ksoftirqd/28     [kernel.vmlinux]           [k] net_rx_=
action
> >> > >     0.64%  swapper          [kernel.vmlinux]           [k] intel_i=
dle
> >> > >     0.62%  ksoftirqd/28     [i40e]                     [k] i40e_na=
pi_poll
> >> > >     0.57%  xdpsock          [kernel.vmlinux]           [k] dma_dir=
ect_sync_single_for_cpu
> >> > >
> >> > > Perf report for "AF_XDP direct rxdrop" with patched kernel - mitig=
ations ON
> >> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >> > > Samples: 46K of event 'cycles', Event count (approx.): 38387018585
> >> > > Overhead  Command          Shared Object             Symbol
> >> > >    21.94%  ksoftirqd/28     [i40e]                    [k] i40e_cle=
an_rx_irq_zc
> >> > >    14.36%  xdpsock          xdpsock                   [.] main
> >> > >    11.53%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_rcv
> >> > >    11.32%  xdpsock          [i40e]                    [k] i40e_cle=
an_rx_irq_zc
> >> > >     4.02%  xdpsock          [kernel.vmlinux]          [k] xsk_rcv
> >> > >     2.91%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_do_r=
edirect
> >> > >     2.45%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem=
_peek_addr
> >> > >     2.19%  xdpsock          [kernel.vmlinux]          [k] xsk_umem=
_peek_addr
> >> > >     2.08%  ksoftirqd/28     [kernel.vmlinux]          [k] bpf_dire=
ct_xsk
> >> > >     2.07%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_dire=
ct_sync_single_for_cpu
> >> > >     1.53%  ksoftirqd/28     [kernel.vmlinux]          [k] dma_dire=
ct_sync_single_for_device
> >> > >     1.39%  xdpsock          [kernel.vmlinux]          [k] dma_dire=
ct_sync_single_for_device
> >> > >     1.22%  ksoftirqd/28     [kernel.vmlinux]          [k] xdp_get_=
xsk_from_qid
> >> > >     1.12%  ksoftirqd/28     [i40e]                    [k] i40e_cle=
an_programming_status
> >> > >     0.96%  ksoftirqd/28     [i40e]                    [k] i40e_nap=
i_poll
> >> > >     0.95%  ksoftirqd/28     [kernel.vmlinux]          [k] net_rx_a=
ction
> >> > >     0.89%  xdpsock          [kernel.vmlinux]          [k] xdp_do_r=
edirect
> >> > >     0.83%  swapper          [i40e]                    [k] i40e_cle=
an_rx_irq_zc
> >> > >     0.70%  swapper          [kernel.vmlinux]          [k] intel_id=
le
> >> > >     0.66%  xdpsock          [kernel.vmlinux]          [k] dma_dire=
ct_sync_single_for_cpu
> >> > >     0.60%  xdpsock          [kernel.vmlinux]          [k] bpf_dire=
ct_xsk
> >> > >     0.50%  ksoftirqd/28     [kernel.vmlinux]          [k] xsk_umem=
_discard_addr
> >> > >
> >> > > Based on the perf reports comparing AF_XDP default and direct rxdr=
op, we can say that
> >> > > AF_XDP direct rxdrop codepath is avoiding the overhead of going th=
rough these functions
> >> > >  bpf_prog_xxx
> >> > >          bpf_xdp_redirect_map
> >> > >  xsk_map_lookup_elem
> >> > >          __xsk_map_redirect
> >> > > With AF_XDP direct, xsk_rcv() is directly called via bpf_direct_xs=
k() in xdp_do_redirect()
> >> >
> >> > I don't think you're identifying the overhead correctly.
> >> > xsk_map_lookup_elem is 1%
> >> > but bpf_xdp_redirect_map() suppose to call __xsk_map_lookup_elem()
> >> > which is a different function:
> >> > ffffffff81493fe0 T __xsk_map_lookup_elem
> >> > ffffffff81492e80 t xsk_map_lookup_elem
> >> >
> >> > 10% for bpf_prog_80b55d8a76303785 is huge.
> >> > It's the actual code of the program _without_ any helpers.
> >> > How does the program actually look?
> >>
> >> It is the xdp program that is loaded via xsk_load_xdp_prog() in tools/=
lib/bpf/xsk.c
> >> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/=
tools/lib/bpf/xsk.c#n268
> >
> > I see. Looks like map_gen_lookup was never implemented for xskmap.
> > How about adding it first the way array_map_gen_lookup() is implemented=
?
> > This will easily give 2x perf gain.
>
> I guess we should implement this for devmaps as well now that we allow
> lookups into those.
>
> However, in this particular example, the lookup from BPF is not actually
> needed, since bpf_redirect_map() will return a configurable error value
> when the map lookup fails (for exactly this use case).
>
> So replacing:
>
> if (bpf_map_lookup_elem(&xsks_map, &index))
>     return bpf_redirect_map(&xsks_map, index, 0);
>
> with simply
>
> return bpf_redirect_map(&xsks_map, index, XDP_PASS);
>
> would save the call to xsk_map_lookup_elem().
>

Thanks for the reminder! I just submitted a patch. Still, doing the
map_gen_lookup()  for xsk/devmaps still makes sense!


Bj=C3=B6rn


> -Toke
>
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
