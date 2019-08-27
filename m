Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F509F48C
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfH0UxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 16:53:13 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39576 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfH0UxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 16:53:12 -0400
Received: by mail-io1-f67.google.com with SMTP id l7so1362624ioj.6;
        Tue, 27 Aug 2019 13:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yFtdPdKB+5OFD7TerpRjOkHMWVZwIcvQtFqZgo3qk1c=;
        b=ElsjQ0VW7GupsjBGpqG2M5I3UVqv2fH20DwZEAQEOY28BIn9eYZAVw5ak/JGuUs3Jy
         0U8Pjcb5kO5FNwjxDzVWWVK8FFgwdwxQetvQMU5NQsB/fATvzU92dlK3/lEm6y7kSnPQ
         tlYtCVC7InScVlubrPNRh4Jc5Eb9dFZo7UjnSI/XcBzHgBfi8L1Wcb9nTIpjYxPeXCyM
         QqetSsbilh7JlEYn23tr8F9Lui7GuikjexgLaZO3Bl7MRb7vGSz0XWYiDzrZO4w+jLIw
         HDF9SSAdbN7jYLfZiFJZwsdWZJgGpGv+MA4bdFzDouYo+YYIFyIZOI92MVb9MZlzkZFb
         ztWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yFtdPdKB+5OFD7TerpRjOkHMWVZwIcvQtFqZgo3qk1c=;
        b=mW4XVraCA8JtUSvpiCo1T6hp17yg8EVqZfskUZIeBqUZAOYDQ04juOWAZebJz1MKjS
         vXvJkOYqU7b8+pWu7SCUeILzt9QD1/Ig5n1n3RiZLQ5B1KHBzrONLuOHouyVDaevMplI
         nmsGBnBNbSPpNp17TCy5BQ1GE7MXieuuhOqa8O1/HACpYXgdXaHIOKrTq0Owg53NuIw4
         UU9Gy+HgJ0U0yykDVHuOC0oSUWwvDh7nuJXGEQGDooqbSJN7twmtow7JXwb9ZbfPiKLH
         N7azqdVlPX8QTREncLZV7eHn7pBnWCAqi4zQBAIPfm9MRvRPCW0OG/2a88NUg+JslWYH
         so4g==
X-Gm-Message-State: APjAAAXqHbqi+C6KwUhzomjj4Z+Apv81NLJ1pwbkgWipmgT8J/mz6XJY
        SEQSESFsPt06UxnaPWQWpDxLTBvkZr5gqczjlJ4WpLrk
X-Google-Smtp-Source: APXvYqyneXeZEY6hV98mUCrnG6Ny31Of0WUmkslziPbLPuCTD2ot08eK8DoEMOKhtIGW4NcC8GdQGkRyjaRoWyxVMSE=
X-Received: by 2002:a5d:9dd8:: with SMTP id 24mr194777ioo.249.1566939191364;
 Tue, 27 Aug 2019 13:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
 <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
 <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
 <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com>
 <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com>
 <CAM_iQpVtGUH6CAAegRtTgyemLtHsO+RFP8f6LH2WtiYu9-srfw@mail.gmail.com> <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
In-Reply-To: <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 27 Aug 2019 13:53:02 -0700
Message-ID: <CAA93jw6TWUmqsvBDT4tFPgwjGxAmm_S5bUibj16nwp1F=AwyRA@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Akshat Kakkar <akshat.1984@gmail.com>,
        Anton Danilov <littlesmilingcloud@gmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 25, 2019 at 11:47 PM Eric Dumazet <eric.dumazet@gmail.com> wrot=
e:
>
>
>
> On 8/25/19 7:52 PM, Cong Wang wrote:
> > On Wed, Aug 21, 2019 at 11:00 PM Akshat Kakkar <akshat.1984@gmail.com> =
wrote:
> >>
> >> On Thu, Aug 22, 2019 at 3:37 AM Cong Wang <xiyou.wangcong@gmail.com> w=
rote:
> >>>> I am using ipset +  iptables to classify and not filters. Besides, i=
f
> >>>> tc is allowing me to define qdisc -> classes -> qdsic -> classes
> >>>> (1,2,3 ...) sort of structure (ie like the one shown in ascii tree)
> >>>> then how can those lowest child classes be actually used or consumed=
?
> >>>
> >>> Just install tc filters on the lower level too.
> >>
> >> If I understand correctly, you are saying,
> >> instead of :
> >> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> >> 0x00000001 fw flowid 1:10
> >> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> >> 0x00000002 fw flowid 1:20
> >> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> >> 0x00000003 fw flowid 2:10
> >> tc filter add dev eno2 parent 100: protocol ip prio 1 handle
> >> 0x00000004 fw flowid 2:20
> >>
> >>
> >> I should do this: (i.e. changing parent to just immediate qdisc)
> >> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000001
> >> fw flowid 1:10
> >> tc filter add dev eno2 parent 1: protocol ip prio 1 handle 0x00000002
> >> fw flowid 1:20
> >> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000003
> >> fw flowid 2:10
> >> tc filter add dev eno2 parent 2: protocol ip prio 1 handle 0x00000004
> >> fw flowid 2:20
> >
> >
> > Yes, this is what I meant.
> >
> >
> >>
> >> I tried this previously. But there is not change in the result.
> >> Behaviour is exactly same, i.e. I am still getting 100Mbps and not
> >> 100kbps or 300kbps
> >>
> >> Besides, as I mentioned previously I am using ipset + skbprio and not
> >> filters stuff. Filters I used just to test.
> >>
> >> ipset  -N foo hash:ip,mark skbinfo
> >>
> >> ipset -A foo 10.10.10.10, 0x0x00000001 skbprio 1:10
> >> ipset -A foo 10.10.10.20, 0x0x00000002 skbprio 1:20
> >> ipset -A foo 10.10.10.30, 0x0x00000003 skbprio 2:10
> >> ipset -A foo 10.10.10.40, 0x0x00000004 skbprio 2:20
> >>
> >> iptables -A POSTROUTING -j SET --map-set foo dst,dst --map-prio
> >
> > Hmm..
> >
> > I am not familiar with ipset, but it seems to save the skbprio into
> > skb->priority, so it doesn't need TC filter to classify it again.
> >
> > I guess your packets might go to the direct queue of HTB, which
> > bypasses the token bucket. Can you dump the stats and check?
>
> With more than 64K 'classes' I suggest to use a single FQ qdisc [1], and
> an eBPF program using EDT model (Earliest Departure Time)

Although this is very cool, I think in this case the OP is being
a router, not server?

> The BPF program would perform the classification, then find a data struct=
ure
> based on the 'class', and then update/maintain class virtual times and sk=
b->tstamp
>
> TBF =3D bpf_map_lookup_elem(&map, &classid);
>
> uint64_t now =3D bpf_ktime_get_ns();
> uint64_t time_to_send =3D max(TBF->time_to_send, now);
>
> time_to_send +=3D (u64)qdisc_pkt_len(skb) * NSEC_PER_SEC / TBF->rate;
> if (time_to_send > TBF->max_horizon) {
>     return TC_ACT_SHOT;
> }
> TBF->time_to_send =3D time_to_send;
> skb->tstamp =3D max(time_to_send, skb->tstamp);
> if (time_to_send - now > TBF->ecn_horizon)
>     bpf_skb_ecn_set_ce(skb);
> return TC_ACT_OK;
>
> tools/testing/selftests/bpf/progs/test_tc_edt.c shows something similar.
>
>
> [1]  MQ + FQ if the device is multi-queues.
>
>    Note that this setup scales very well on SMP, since we no longer are f=
orced
>  to use a single HTB hierarchy (protected by a single spinlock)
>


--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
