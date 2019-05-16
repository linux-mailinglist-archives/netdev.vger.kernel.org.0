Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8316621021
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbfEPVjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:39:37 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:46580 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfEPVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:39:36 -0400
Received: by mail-vs1-f65.google.com with SMTP id e2so3269222vsc.13
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 14:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TgWGtmDjs/QmeiLS5U1Mcavr4+48FZvbfcjQbfF1144=;
        b=rWrRlQfumHECdNugPYZyq/xbVNHHHZyu4Wa8TjKbKyIyVJFfFxb7ywGXGBSLtFyRKi
         67zLNxSoMmFIStWbl3MBKXqzu+Su2cWGe32TE8T3twY/J+cgSLZ46sJ/wYbcFR4kBUY3
         +DSQNgxLl+1Z4M/omhTwRmzNN1Z5XxyBn3DtW8uvv5v91UKVZWdbVu2aGj57kGyd/Chl
         VgjknoyTBM31BdxAfq/zIpKFIaw0nhf8DBPsZeyaUtq08vNOa6o0kkQzaFR37Ar3g7to
         gDCgurdfszLApfQXKU6fOcNY2XAMw2a7uv6c14aYZ9D3KRfsbwmMa7LJJ4W3XZGwqg2V
         WS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TgWGtmDjs/QmeiLS5U1Mcavr4+48FZvbfcjQbfF1144=;
        b=RJ0UUQbgfM4F0NA3nZYlgQfx6uYkHY4SvS0WPlHwwQpQeKkD2nndda0HoM3dphk/U2
         pciYa0ItFAKKxhZE3oxnlV3MtwztXqx/R+eAY4fUxkFcg5y5+vsftWHTdWXdhUxtWdwH
         pg/SqPtu0JDbOro4X4DdaNZqDPZuN4F7/4dwsrRWG40BO05zXDbixvg0DD3rquZztfAf
         hrQaVeUzZJ64vTFW8E1jZdBJA7/ry7wAAa+SkcqXRpHBWhqMM9QQjEmr3TJJdVzxuRJ0
         XCvBOdRbYXbllJ93I01Fyyk76YJLIn7n6IfXcma6F9TrXnOzrSg6c/z8H23vJSx8Orsy
         Tqag==
X-Gm-Message-State: APjAAAVvRsd9QBDR8wKS2D5mHXIROTQaoouiO21sSN7PjVb3bj7lWZ6W
        6WVZTgW2SuDxVMM8HRCBTqSV5aVrg7qfHm8phH5cXBbR
X-Google-Smtp-Source: APXvYqyb1j1HgLg4lAOdon/zzQ9QpplkgsKN523e3NalUweG7qlYHcv7fudmZN1f2LfPvGCh1BJnJfYLt6GQ+PXZO9Y=
X-Received: by 2002:a67:dd0c:: with SMTP id y12mr16627981vsj.119.1558042775575;
 Thu, 16 May 2019 14:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190515204123.5955-1-jakub.kicinski@netronome.com>
 <20190515204123.5955-4-jakub.kicinski@netronome.com> <2ca1ad39-b2a1-7f40-4bf6-69a1c9f13cc0@mellanox.com>
 <20190516105652.36c81a1a@cakuba.netronome.com> <CAADnVQ+eFX8S2go=SeQ9kdP_3yGckHF-_Aevv7x+EbJQgsCgmw@mail.gmail.com>
 <20190516114203.6b8ca20b@cakuba.netronome.com> <20190516193257.2edzss37shzfrm6v@ast-mbp>
In-Reply-To: <20190516193257.2edzss37shzfrm6v@ast-mbp>
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Thu, 16 May 2019 14:39:03 -0700
Message-ID: <CAJpBn1xRd6mszXGQ87dYegnB530Bf3NWmmU1mYguRUAFsX7ivw@mail.gmail.com>
Subject: Re: [PATCH net 3/3] Documentation: add TLS offload documentation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "vakul.garg@nxp.com" <vakul.garg@nxp.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 12:32:59 -0700, Alexei Starovoitov wrote:
> On Thu, May 16, 2019 at 11:42:03AM -0700, Jakub Kicinski wrote:
> > On Thu, 16 May 2019 11:13:47 -0700, Alexei Starovoitov wrote:
> > > On Thu, May 16, 2019 at 10:57 AM Jakub Kicinski wrote:
> > > >
> > > >   The preferred method of reporting the Layer 4 (TCP) checksum offload
> > > >   for packets decrypted by the device is to update the checksum field
> > > >   to the correct value for clear text and report CHECKSUM_UNNECESSARY
> > > >   or CHECKSUM_COMPLETE computed over clear text. However, the exact
> > > >   semantics of RX checksum offload when NIC performs data modification
> > > >   are not clear and subject to change.
> > >
> > > when host is consuming the tcp stream I don't see the value of
> > > tcp checksum on top tls.
> > > In that sense CHECKSUM_UNNECESSARY is fine and no
> > > need to update checksum field.
> > > Even in case of sockmap and tcp stream redirect it is still fine.
> > > Only the tcp payload being redirected to a different tcp socket
> > > and the headers are gone.
> > > So imo in all cases CHECKSUM_UNNECESSARY is fine
> > > even without adjustment to checksum field.
> >
> > No question that CHECKSUM_UNNECESSARY currently works.
> > But it's not "entirely" correct without the header fixup?
> > Device modifies the data - it should fix up the checksum.
>
> I think it's an interesting angle to discuss.
> Though ktls in hw is done per packet many key fields of ip/tcp headers
> are fully processed.

Checksum has been validated, 5-tuple extracted and sequence number
confirmed.  That's not that much, aRFS will do most of it.

> socket is selected and payload is decrypted.

To be clear socket is not assigned to the skb by the offload today.

I only realized it after replying to your other statements but the key
is that the device and the kernel are still tightly coupled by the
decrypted bit set in the descriptor and then the skb.  So there is no
wire-level middlebox going on here.

> imo it is better to state that such headers have been 'consumed' by hw.
> Where 'consumed' would mean that hw did what network layering suppose to do
> and the stack should not look at them (because they can contain garbage).
> (in that sense it's fine to keep csum unadjusted. imo it's ok to zero-out IP too)
> Such decrypted skb is essentially a wrapper of payload plus
> left-over headers passed to the stack.

Expressing that cleanly in terms of sk_buff fields seems hard.  We
could add another checksum bit to denote CHECKSUM_BROKEN_BUT_OKAY,
if we really need it (today as stated for TCP streams UNNECESSARY
works with mangled csums).

> I think it makes sense to clarify which headers have been consumed/processed.
> Like: IP4/6+protocol+port+csum - processed, whereas
> tcp bits, dscp, ecn are still valid and have to be processed by the stack.

Invalidating the 5 tuple on the packet seems like a step backward,
the stack would no longer have the ability to match the packets based
on header fields for firewalling, accounting, whatnot.

> > I was trying (unsuccessfully) to hint at the fact that it's okay
> > today to leave the checksum be, but at the same time if someone
> > is designing new HW or has the ability to fix this up in microcode
> > I think the TCP csum should be fixed..
>
> I don't think so. hw should work together with the stack
> instead of being 'inline transparent decryption box'.

I'd rather not extend socket handling into the firmware.  I'm hoping
that a narrower interface (checksum bit + decrypted bit) will give more
independence to the stack, and I see no negative implications for the
the firmware (negative in the sense we don't have to trust and be bound
by it).

> If hw decrypts stuff and adjusts csum it would imply that stack
> will see completely valid headers. It would also imply that
> the stack must check csum.

What's wrong with the checksum being fixed up after data gets processed?
It's not that the stack _must_ check the checksum, it's that the stack
_may_ reasonably look at that field - CHECKSUM_UNNECESSARY.

> That doesn't seem right from trust point of view.

Please clarify where the trust problem is.  The processed packet still
has to come with a "decrypted" metadata indication (which we'll
translated into skb->decrypted), so it's still necessarily a tightly
coupled interface.


> >
> > Maybe like this?
> >
> >   The preferred method of reporting the Layer 4 (TCP) checksum offload
> >   for packets decrypted by the device is to update the checksum field
> >   to the correct value for clear text and report CHECKSUM_UNNECESSARY
> >   or CHECKSUM_COMPLETE computed over clear text.
> >
> >   Some existing devices may report CHECKSUM_UNNECESSARY without fixing
> >   the checksum field, which currently functions correctly but is not
> >   in line with the exact semantics of RX checksum offload. Such devices
> >   must make sure that RXCSUM offload is always enabled for TLS offloaded
> >   flows.
>
> I don't like it for the reasons above.
>
> > > Obviously the hw/firmware should have checked tcp csum before doing decrypt.
> >
> > Ah, that is definitely worth stating, will add!
