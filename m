Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC0EDEB86
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbfJUMDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:03:01 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38767 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbfJUMDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 08:03:01 -0400
Received: by mail-qt1-f194.google.com with SMTP id o25so7178159qtr.5;
        Mon, 21 Oct 2019 05:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U8/udOB8d8afVM4Oiil7MLLGJE7IR3ULS8cNM3yTwf0=;
        b=O7qeHzritrAi5ln2djGB8me2A+mzu/G9YX49BXe973qpSe6aX5iPKqgS7kPuRn09Lb
         WpZxlZBZksbh36YHRGRmqm3c4uIca0X0idD58m8l+rMtCJE3yFR2iLd3uctah8IAQAvX
         GeS4+k81nijouRRLwoXDDkEY0cyPuqdPZNDKLi+J2KkPn+rectQ1xfn13yeAnQnq60Hi
         1xQiuzY8jiKK9VrfBngn4XFbzj6f/j2asczOtEZcz//iU/arLWtcFUUVyw0oDhNiFnnR
         0gOkf6rSZ4NTNK/x3+Mv7+kBR7N3Ex4sFZj3uYFj26nAAhmiRMRRfrhWeV+w8EPKJAQr
         GSYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U8/udOB8d8afVM4Oiil7MLLGJE7IR3ULS8cNM3yTwf0=;
        b=OQebzz3pUKeqMCw46hWNbd4fd2tZk2qJdnPXvIb9zzGdP4N4qa3Lt67kl4TuXyBNWW
         BM1kP++QfxH9BbncaRjjIii/NQHXAPIqfCB1C3r57698i1MI1Ns6y7ISlsVx+7KCJ8Qc
         0DXAINOE6vt7tPrOit0/UAGh7Z21EHuTo2nfDYw6UTAju5NE0qK4e9R/VaGUTC36YU6t
         W9B6u0h23iPKpMCmbGmdt8eYSQhDz12mPFLRxBOkkZwGn/pCicqI66nNr/mZ5UVIhWQV
         TSkLxDyzvZYscTSGE8NS334sK6n5o6bwFL7ZJROyq/CdpGJI+m+DRzQgi3a7MBIr04I8
         oYZQ==
X-Gm-Message-State: APjAAAWEC92s3bWwD5V+dHyM75MXBqQunWqCg/G7WEwKYWi4fOkfn68f
        x5Lb/HiWC/hp69fzMUIHP1jfHzLA2mMDgAgPgS4=
X-Google-Smtp-Source: APXvYqwvV7DDvA6kJfv6a1UGR14BZ1tIjEvbM4WA/A6SnKgUEMc5M/4aiHb5ZPKpJGN4LRbB1/Bl9rtPlDK+lGjymCI=
X-Received: by 2002:a05:6214:2c:: with SMTP id b12mr22998689qvr.10.1571659379702;
 Mon, 21 Oct 2019 05:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20191021105938.11820-1-bjorn.topel@gmail.com> <87h842qpvi.fsf@toke.dk>
In-Reply-To: <87h842qpvi.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 21 Oct 2019 14:02:48 +0200
Message-ID: <CAJ+HfNiNwTbER1NfaKamx0p1VcBHjHSXb4_66+2eBff95pmNFg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: use implicit XSKMAP lookup from
 AF_XDP XDP program
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 at 13:50, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > In commit 43e74c0267a3 ("bpf_xdp_redirect_map: Perform map lookup in
> > eBPF helper") the bpf_redirect_map() helper learned to do map lookup,
> > which means that the explicit lookup in the XDP program for AF_XDP is
> > not needed for post-5.3 kernels.
> >
> > This commit adds the implicit map lookup with default action, which
> > improves the performance for the "rx_drop" [1] scenario with ~4%.
> >
> > For pre-5.3 kernels, the bpf_redirect_map() returns XDP_ABORTED, and a
> > fallback path for backward compatibility is entered, where explicit
> > lookup is still performed. This means a slight regression for older
> > kernels (an additional bpf_redirect_map() call), but I consider that a
> > fair punishment for users not upgrading their kernels. ;-)
> >
> > v1->v2: Backward compatibility (Toke) [2]
> >
> > [1] # xdpsock -i eth0 -z -r
> > [2] https://lore.kernel.org/bpf/87pnirb3dc.fsf@toke.dk/
> >
> > Suggested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >  tools/lib/bpf/xsk.c | 45 +++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 35 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index b0f532544c91..391a126b3fd8 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -274,33 +274,58 @@ static int xsk_load_xdp_prog(struct xsk_socket *x=
sk)
> >       /* This is the C-program:
> >        * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> >        * {
> > -      *     int index =3D ctx->rx_queue_index;
> > +      *     int ret, index =3D ctx->rx_queue_index;
> >        *
> >        *     // A set entry here means that the correspnding queue_id
> >        *     // has an active AF_XDP socket bound to it.
> > +      *     ret =3D bpf_redirect_map(&xsks_map, index, XDP_PASS);
> > +      *     ret &=3D XDP_PASS | XDP_REDIRECT;
>
> Why the masking? Looks a bit weird (XDP return codes are not defined as
> bitmask values), and it's not really needed, is it?
>

bpf_redirect_map() returns a 32-bit signed int, so the upper 32-bit
will need to be cleared. Having an explicit AND is one instruction
less than two shifts. So, it's an optimization (every instruction is
sacred).

Compare these two:

0000000000000000 xdp_sock_prog:
;     int ret, index =3D ctx->rx_queue_index;
       0:       61 12 10 00 00 00 00 00 r2 =3D *(u32 *)(r1 + 16)
       1:       63 2a fc ff 00 00 00 00 *(u32 *)(r10 - 4) =3D r2
;     ret =3D bpf_redirect_map(&xsks_map, index, XDP_PASS);
       2:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 =3D 0 ll
       4:       b7 03 00 00 02 00 00 00 r3 =3D 2
       5:       85 00 00 00 33 00 00 00 call 51
;     ret &=3D XDP_PASS | XDP_REDIRECT;
       6:       57 00 00 00 06 00 00 00 r0 &=3D 6
;     if (ret)
       7:       55 00 0d 00 00 00 00 00 if r0 !=3D 0 goto +13 <LBB0_3>
       8:       bf a2 00 00 00 00 00 00 r2 =3D r10
;     if (bpf_map_lookup_elem(&xsks_map, &index))
       9:       07 02 00 00 fc ff ff ff r2 +=3D -4
      10:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 =3D 0 ll
      12:       85 00 00 00 01 00 00 00 call 1
      13:       bf 01 00 00 00 00 00 00 r1 =3D r0
      14:       b7 00 00 00 02 00 00 00 r0 =3D 2
      15:       15 01 05 00 00 00 00 00 if r1 =3D=3D 0 goto +5 <LBB0_3>
;         return bpf_redirect_map(&xsks_map, index, 0);
      16:       61 a2 fc ff 00 00 00 00 r2 =3D *(u32 *)(r10 - 4)
      17:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 =3D 0 ll
      19:       b7 03 00 00 00 00 00 00 r3 =3D 0
      20:       85 00 00 00 33 00 00 00 call 51

00000000000000a8 LBB0_3:
; }
      21:       95 00 00 00 00 00 00 00 exit


Disassembly of section xdp_sock:

0000000000000000 xdp_sock_prog:
;     int ret, index =3D ctx->rx_queue_index;
       0:       61 12 10 00 00 00 00 00 r2 =3D *(u32 *)(r1 + 16)
       1:       63 2a fc ff 00 00 00 00 *(u32 *)(r10 - 4) =3D r2
;     ret =3D bpf_redirect_map(&xsks_map, index, XDP_PASS);
       2:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 =3D 0 ll
       4:       b7 03 00 00 02 00 00 00 r3 =3D 2
       5:       85 00 00 00 33 00 00 00 call 51
       6:       67 00 00 00 20 00 00 00 r0 <<=3D 32
       7:       c7 00 00 00 20 00 00 00 r0 s>>=3D 32
;     if (ret > 0)
       8:       65 00 0d 00 00 00 00 00 if r0 s> 0 goto +13 <LBB0_3>
       9:       bf a2 00 00 00 00 00 00 r2 =3D r10
;     if (bpf_map_lookup_elem(&xsks_map, &index))
      10:       07 02 00 00 fc ff ff ff r2 +=3D -4
      11:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 =3D 0 ll
      13:       85 00 00 00 01 00 00 00 call 1
      14:       bf 01 00 00 00 00 00 00 r1 =3D r0
      15:       b7 00 00 00 02 00 00 00 r0 =3D 2
      16:       15 01 05 00 00 00 00 00 if r1 =3D=3D 0 goto +5 <LBB0_3>
;         return bpf_redirect_map(&xsks_map, index, 0);
      17:       61 a2 fc ff 00 00 00 00 r2 =3D *(u32 *)(r10 - 4)
      18:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 =3D 0 ll
      20:       b7 03 00 00 00 00 00 00 r3 =3D 0
      21:       85 00 00 00 33 00 00 00 call 51

00000000000000b0 LBB0_3:
; }
      22:       95 00 00 00 00 00 00 00 exit


Bj=C3=B6rn

> -Toke
>
