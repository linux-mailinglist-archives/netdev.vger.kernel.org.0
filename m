Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8903F91E0C
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfHSHjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:39:41 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33363 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHSHjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 03:39:41 -0400
Received: by mail-qt1-f196.google.com with SMTP id v38so918421qtb.0;
        Mon, 19 Aug 2019 00:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pX5vzrCrWspkDa0PwEU135ZuQd7KwdNzkE2O8jHiKBs=;
        b=iSJxQNALgQU3Ul2Q56P4y4rASj+dQUEc1gDUuOD7I3Ff1j9edsP+30/F9pCmFWN9SD
         dwRjZJYm+dsXJNH2hp5ZDLHt8aAy2FHzD60JoemZLNp6xMBIre3P6NAGVR7tadIVwATj
         BWh85aCEY1L+brMunAzqMQFtGT0GQLXcE3sm0EP5Cyjf2kVZWFGa069HFlYO3VjLZOQf
         IoiczLGg1uE8VZ/Lzvq50iGuhzwspZYMEfGHOYYhYl4FcDQJnIouYPz2n7xRSPzchozN
         kMd58bQ0vaNjpmO2HcntLdyf3WSxvLL8zx+/C/0I6cd+DQvR8sMP9hi99U9jEfq4JAWa
         YcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pX5vzrCrWspkDa0PwEU135ZuQd7KwdNzkE2O8jHiKBs=;
        b=p08MGZoPafS01VzJsmpNaJi3BfPEjLR0YVMV2eN5DFjcktM+MJgO4ETynr9igyDW8q
         EmZJDrOIbGu3d2qE3USojJPavPlaxJ1mmYFI59HMk0anRInpjZ9AU/3W2Cl19GcHuByI
         uMY9vPrCLoHqXU4WSHxRLPIi5/Pb4310ItNEPogxPY6jnzwfTgCOML46OI0g6Vlrkhtp
         uytEw7v5nbBEJ9jAm4mx1Kdo3DQOcr8W6LYyhvqHyuWU/tChP1WgS7Cj7XGzh1I5D15J
         cupHk08P45Ohqniy3l8Rb8isOcKHGAe2ERUY2V3ndCbCp3cuOqt7PNfaWGzjwKYMKFTN
         rN/A==
X-Gm-Message-State: APjAAAWG/yQA5m0t/qBSpd1VSXOR98Is4zhD8LgKqdtcWQeuT5E22G09
        pr3cqPxLw5WcEv+okLrqTyBzbAfhiuHUdZBp55g=
X-Google-Smtp-Source: APXvYqwZd0Zy2/2KscKfhkCmVEkfVWBj1p7q1DV4+0rtdAwNPScBEsILu18gDy5NMadWD6yYSABKvDxK/2lL1ro6nwo=
X-Received: by 2002:ad4:50d1:: with SMTP id e17mr9993601qvq.9.1566200379933;
 Mon, 19 Aug 2019 00:39:39 -0700 (PDT)
MIME-Version: 1.0
References: <1565840783-8269-1-git-send-email-sridhar.samudrala@intel.com>
 <bebfb097-5357-91d8-ebc7-2f8ede392ad7@intel.com> <cc3a09eb-bcb8-a6e1-7175-77bddaf10c11@intel.com>
 <CAJ+HfNj=devuEky3VwbibA-j+o=bKi4Gg=MeHsuuDGAKc9p2Vw@mail.gmail.com> <331CAEDB-776A-4928-93EF-F45F1339848F@gmail.com>
In-Reply-To: <331CAEDB-776A-4928-93EF-F45F1339848F@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 19 Aug 2019 09:39:28 +0200
Message-ID: <CAJ+HfNgeSYRuQ8+80zepsAj8f+gdXEqsnbebuvmJggYOBUsj9w@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next 0/5] Add support for SKIP_BPF
 flag for AF_XDP sockets
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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

On Sat, 17 Aug 2019 at 00:08, Jonathan Lemon <jonathan.lemon@gmail.com> wro=
te:
> On 16 Aug 2019, at 6:32, Bj=C3=B6rn T=C3=B6pel wrote:
[...]
> >
> > Today, from a driver perspective, to enable XDP you pass a struct
> > bpf_prog pointer via the ndo_bpf. The program get executed in
> > BPF_PROG_RUN (via bpf_prog_run_xdp) from include/linux/filter.h.
> >
> > I think it's possible to achieve what you're doing w/o *any* driver
> > modification. Pass a special, invalid, pointer to the driver (say
> > (void *)0x1 or smth more elegant), which has a special handling in
> > BPF_RUN_PROG e.g. setting a per-cpu state and return XDP_REDIRECT. The
> > per-cpu state is picked up in xdp_do_redirect and xdp_flush.
> >
> > An approach like this would be general, and apply to all modes
> > automatically.
> >
> > Thoughts?
>
> All the default program does is check that the map entry contains a xsk,
> and call bpf_redirect_map().  So this is pretty much the same as above,
> without any special case handling.
>
> Why would this be so expensive?  Is the JIT compilation time being
> counted?

No, not the JIT compilation time, only the fast-path. The gain is from
removing the indirect call (hitting a retpoline) when calling the XDP
program, and reducing code from xdp_do_redirect/xdp_flush.

But, as Jakub pointed out, the XDP batching work by Maciej, might
reduce the retpoline impact quite a bit.


Bj=C3=B6rn
