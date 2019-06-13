Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2CB4377C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732611AbfFMO70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 10:59:26 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33715 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732612AbfFMOyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 10:54:01 -0400
Received: by mail-qt1-f194.google.com with SMTP id x2so21976357qtr.0;
        Thu, 13 Jun 2019 07:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t93Vsea+mncWu5w81OgAOHS5fdn/ySDdn/QB0hnie8U=;
        b=EXawz2vZWlzFlzQyD9VZwDi3+WtUwrKm8U07fUaB2DwR7+4uVpTYLZnzCS2wgRAIj3
         u2YGaruDx+u8XGmgSiEbgOMfnJMMpuYKdYYc/jgUqoaJNafS014IqcmLVAZzHThgooer
         gmWJacZQ1lpZxVpbvhTSDvp5H8S1IBmqfIOeMMzYkJ1MAq8/Kpid0MH06l6YciBblGvN
         YWIzTIZ+CY4jVZAVCHmtaWBzYSgayoZpXajjvTSKhImYmC41NihaQFP1aqI9KeX9AzWk
         uPzuUMVtcTbCkbeRohteOEarB39rdEMW/vWAOqivpamyg+mCA/6lAlAcozgdx9ZmEoDa
         ACEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t93Vsea+mncWu5w81OgAOHS5fdn/ySDdn/QB0hnie8U=;
        b=qsmoSt8zuRZwIdWfgBY0xCelyCG0iRkebnSKsNtMdUclfWmQ1sp2vy115pfbYsTElb
         polX3ta4w8cJISWseHcujAywL8cZkVTk8MImJZF08dgTTUOeoApjbVW82BthpMGXW5Or
         zb9G0YiqskvJKvOA+TvTmQIt7tOS+YOzOy9S9c2JjRhIpkoO1JXVSirOu/hxBWH8wCPd
         UMlsthmUsWEvOYSb3qDuawsWLYPdpAi8O4/icJmpEaMJEoz/6y1aa8YBFrr3F5P4faZl
         y+tyvkyWt1fOT3ociAHo+yFqzar3dhJki2kKJwTDCmWPiwr2h7t39F6YbMwxNGvOElpp
         57rw==
X-Gm-Message-State: APjAAAUI65v4Xmn0SzKJqihviGmehCrbdqGbBO2/6AkRGZQfmtN6iC1a
        eu6qC/NWauyiMD0HRLCOLtrCnp9MEykrmLsZ7c0=
X-Google-Smtp-Source: APXvYqzX3gepabt+63Au///TfQueZRwESZe9fkZBCrUg5i4MNAbFRFc0ZBbqMJA3Nb1+zqHnyL07+K6KKMZqusv9y7E=
X-Received: by 2002:ac8:19ac:: with SMTP id u41mr58061798qtj.46.1560437640073;
 Thu, 13 Jun 2019 07:54:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190612155605.22450-1-maximmi@mellanox.com> <20190612134805.3bf4ea25@cakuba.netronome.com>
 <CAJ+HfNh3KcoZC5W6CLgnx2tzH41Kz11Zs__2QkOKF+CyEMzdMQ@mail.gmail.com>
 <65cf2b7b-79a5-c660-358c-a265fc03b495@mellanox.com> <54a8ed28-0690-565e-f470-2c81a990251e@intel.com>
In-Reply-To: <54a8ed28-0690-565e-f470-2c81a990251e@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 13 Jun 2019 16:53:47 +0200
Message-ID: <CAJ+HfNiXbPUh2zhMJN9=O2a_8nBak2yOeVvZNJaofY4S624N+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 00/17] AF_XDP infrastructure improvements and
 mlx5e support
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jun 2019 at 16:11, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>=
 wrote:
>
>
> On 2019-06-13 16:01, Maxim Mikityanskiy wrote:
> > On 2019-06-13 15:58, Bj=C3=B6rn T=C3=B6pel wrote:
> >> On Wed, 12 Jun 2019 at 22:49, Jakub Kicinski
> >> <jakub.kicinski@netronome.com> wrote:
> >>>
> >>> On Wed, 12 Jun 2019 15:56:33 +0000, Maxim Mikityanskiy wrote:
> >>>> UAPI is not changed, XSK RX queues are exposed to the kernel. The lo=
wer
> >>>> half of the available amount of RX queues are regular queues, and th=
e
> >>>> upper half are XSK RX queues.
> >>>
> >>> If I have 32 queues enabled on the NIC and I install AF_XDP socket on
> >>> queue 10, does the NIC now have 64 RQs, but only first 32 are in the
> >>> normal RSS map?
> >>>
> >>
> >> Additional, related, question to Jakub's: Say that I'd like to hijack
> >> all 32 Rx queues of the NIC. I create 32 AF_XDP socket and attach them
> >> in zero-copy mode to the device. What's the result?
> >
> > There are 32 regular RX queues (0..31) and 32 XSK RX queues (32..63). I=
f
> > you want 32 zero-copy AF_XDP sockets, you can attach them to queues
> > 32..63, and the regular traffic won't be affected at all.
> >
> Thanks for getting back! More questions!
>
> Ok, so I cannot (with zero-copy) get the regular traffic into AF_XDP
> sockets?
>
> How does qids map? Can I only bind a zero-copy socket to qid 32..63 in
> the example above?
>
> Say that I have a a copy-mode AF_XDP socket bound to queue 2. In this
> case I will receive the regular traffic from queue 2. Enabling zero-copy
> for the same queue, will this give an error, or receive AF_XDP specific
> traffic from queue 2+32? Or return an error, and require an explicit
> bind to any of the queues 32..63?
>
>

Let me expand a bit on why I'm asking these qid questions.

It's unfortunate that vendors have different view/mapping on
"qids". For Intel, we allow to bind a zero-copy socket to all Rx
qids. For Mellanox, a certain set of qids are allowed for zero-copy
sockets.

This highlights a need for a better abstraction for queues than "some
queue id from ethtool". This will take some time, and I think that we
have to accept for now that we'll have different behavior/mapping for
zero-copy sockets on different NICs.

Let's address this need for a better queue abstraction, but that
shouldn't block this series IMO. Other than patch:

"[PATCH bpf-next v4 07/17] libbpf: Support drivers with non-combined channe=
ls"

which I'd like to see a bit more discussion on, I'm OK with this
series. I haven't been able to test it (no hardware "hint, hint"), but
I know Jonathan has been running it.

Thanks for working on this, Max!

Bj=C3=B6rn
