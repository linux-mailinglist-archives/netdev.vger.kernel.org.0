Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E7D2A515
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 17:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfEYPU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 11:20:59 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:38133 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbfEYPU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 11:20:59 -0400
Received: by mail-yb1-f193.google.com with SMTP id x7so4843542ybg.5
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 08:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SFixVte+KRZ0eDi2dM904QnB5LrKYVziMe7pK+9vKpA=;
        b=uS7W7fBCo8MN4KH49ynbBJFE22ReYcNJXR65W82MPwze63XpTnI1Jl/vuoRl4hPLTr
         YmDDJj+vlCp92KxAOZuN01blzuOusbBGeYPQ17ubOS6S/2KYA3DDu5dvsSjb1v1lvnbH
         VCvbxa5V4BszgCANSd1SXNWKDbhS7sGlzvrPSoDcqGHgVA4QQT+cdZo0q1e4nk+Elo1P
         dNDYfMsvWWaPskxYOvhoOtnB8WifeIEaQYde27cdX3HIxt0KTnrgVHVGQCdXLnw5w0dR
         YmDG0PjAq3c4aQj0f3vfwdVnQDP7nWIXq/3qBfQ8IKmsaki1eGDldE6d/SOalLcg0J00
         ZXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SFixVte+KRZ0eDi2dM904QnB5LrKYVziMe7pK+9vKpA=;
        b=fqVMmzFhvE2CwSTFAv5jVSHEj4+VEjuMakkrHArcHWjS5fnFc5JJkSh/yRBkZvyh3C
         79Kyjc+52jBZSY5FVI+eYxqLINkGI5WyMz426fMZKtshO7BjzIv83esdRZNa2S/IjVGn
         xDweQWG3txPzTxy2RDump4A8iIAStiw9nstNDkeq688xM5A1PCArHLFxIHDyRfOjNMIH
         ycVwnED39Fay4PedbIlRtUdiHio0YhoL5wMijvzwsq7TIJ7A0T/2T75Dh48r/1Epl7pj
         QuXw9OEl+To6JYXTaLUqotJkyauI0LQm54+gUP89PXqgIQePZro1/PHcVxo4U3KZZxKG
         jflg==
X-Gm-Message-State: APjAAAW0uXxYp8T3DrEiQ7Ms4G1r+RIpIWE3+xON4+SJ7S+5YHRBz+PS
        3aPzXPcTHlx2x4Y7tUrX5nN1PP8+
X-Google-Smtp-Source: APXvYqzfEMoYruCFSo/wDGFmXL7leftIj1KRbOIWm/08+aI2KxkwDuASav380VK8509nhSf9I8GY/w==
X-Received: by 2002:a25:c58b:: with SMTP id v133mr17464768ybe.182.1558797657749;
        Sat, 25 May 2019 08:20:57 -0700 (PDT)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id b132sm1542280ywb.87.2019.05.25.08.20.56
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 08:20:56 -0700 (PDT)
Received: by mail-yb1-f179.google.com with SMTP id g62so4838603ybg.7
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 08:20:56 -0700 (PDT)
X-Received: by 2002:a25:f509:: with SMTP id a9mr50352842ybe.391.1558797656141;
 Sat, 25 May 2019 08:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190523210651.80902-1-fklassen@appneta.com> <20190523210651.80902-2-fklassen@appneta.com>
 <CAF=yD-Jf95De=z_nx9WFkGDa6+nRUqM_1PqGkjwaFPzOe+PfXg@mail.gmail.com>
 <AE8E0772-7256-4B9C-A990-96930E834AEE@appneta.com> <CAF=yD-LtAKpND601LQrC1+=iF6spSUXVdUapcsbJdv5FYa=5Jg@mail.gmail.com>
 <AFC1ECC8-BFAC-4718-B0C9-97CC4BD1F397@appneta.com> <CAF=yD-Le-eTadOi7PL8WFEQCG=yLqb5gvKiks+s5Akeq8TenBQ@mail.gmail.com>
 <90E3853F-107D-45BA-93DC-D0BE8AC6FCBB@appneta.com>
In-Reply-To: <90E3853F-107D-45BA-93DC-D0BE8AC6FCBB@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 25 May 2019 11:20:16 -0400
X-Gmail-Original-Message-ID: <CA+FuTScNr9Srsn9QFBSj=oT4TnMh1QuOZ2h40g=joNjSwccqMg@mail.gmail.com>
Message-ID: <CA+FuTScNr9Srsn9QFBSj=oT4TnMh1QuOZ2h40g=joNjSwccqMg@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 6:01 PM Fred Klassen <fklassen@appneta.com> wrote:
>
>
>
> > On May 24, 2019, at 12:29 PM, Willem de Bruijn <willemdebruijn.kernel@g=
mail.com> wrote:
> >
> > It is the last moment that a timestamp can be generated for the last
> > byte, I don't see how that is "neither the start nor the end of a GSO
> > packet=E2=80=9D.
>
> My misunderstanding. I thought TCP did last segment timestamping, not
> last byte. In that case, your statements make sense.
>
> >> It would be interesting if a practical case can be made for timestampi=
ng
> >> the last segment. In my mind, I don=E2=80=99t see how that would be va=
luable.
> >
> > It depends whether you are interested in measuring network latency or
> > host transmit path latency.
> >
> > For the latter, knowing the time from the start of the sendmsg call to
> > the moment the last byte hits the wire is most relevant. Or in absence
> > of (well defined) hardware support, the last byte being queued to the
> > device is the next best thing.

Sounds to me like both cases have a legitimate use case, and we want
to support both.

Implementation constraints are that storage for this timestamp
information is scarce and we cannot add new cold cacheline accesses in
the datapath.

The simplest approach would be to unconditionally timestamp both the
first and last segment. With the same ID. Not terribly elegant. But it
works.

If conditional, tx_flags has only one bit left. I think we can harvest
some, as not all defined bits are in use at the same stages in the
datapath, but that is not a trivial change. Some might also better be
set in the skb, instead of skb_shinfo. Which would also avoids
touching that cacheline. We could possibly repurpose bits from u32
tskey.

All that can come later. Initially, unless we can come up with
something more elegant, I would suggest that UDP follows the rule
established by TCP and timestamps the last byte. And we add an
explicit SOF_TIMESTAMPING_OPT_FIRSTBYTE that is initially only
supported for UDP, sets a new SKBTX_TX_FB_TSTAMP bit in
__sock_tx_timestamp and is interpreted in __udp_gso_segment.

> >
> > It would make sense for this software implementation to follow
> > established hardware behavior. But as far as I know, the exact time a
> > hardware timestamp is taken is not consistent across devices, either.
> >
> > For fine grained timestamped data, perhaps GSO is simply not a good
> > mechanism. That said, it still has to queue a timestamp if requested.
>
> I see your point. Makes sense to me.
>
> >> When using hardware timestamping, I think you will find that nearly al=
l
> >> adapters only allow one timestamp at a time. Therefore only one
> >> packet in a burst would get timestamped.
> >
> > Can you elaborate? When the host queues N packets all with hardware
> > timestamps requested, all N completions will have a timestamp? Or is
> > that not guaranteed?
> >
>
> It is not guaranteed. The best example is in ixgbe_main.c and search for
> =E2=80=98SKBTX_HW_TSTAMP=E2=80=99.  If there is a PTP TX timestamp in pro=
gress,
> =E2=80=98__IXGBE_PTP_TX_IN_PROGRESS=E2=80=99 is set and no other timestam=
ps
> are possible. The flag is cleared after transmit softirq, and only then
> can another TX timestamp be taken.

Interesting, thanks. I had no idea.
