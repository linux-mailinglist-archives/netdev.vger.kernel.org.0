Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F105D6F9
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 21:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfGBThA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 15:37:00 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:39748 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGBThA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 15:37:00 -0400
Received: by mail-wr1-f53.google.com with SMTP id x4so38638wrt.6
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 12:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pQ/sncn2tUcbjQuQVK66Ha5DjC6QKU7yfXiY8d8pDt8=;
        b=vKIDeHUYlEI8E37UnyQ4VoTOkXvTXgh1DJ1OFqZZ6Ie/FxOHlI5pBSO9kW/tfsFE/p
         761PoD4hcO9ESGs0Mg9/QRdv92GSBm+z9QtoR3sgIK4nmvS3gS2yUJaHvRzA4WO8G+3e
         VEAdbjiHG+Ym+ZjfoMwYJtwChCX9BvB2+GWDy/YA2HJrin4GBF5tqR0/A/l+Yg9DkWVZ
         y1XXU+YxQySZopPGeCilpsndK+ifrzL/uFqU4oM/FIaxl9Hh287rAYh8yDiWKz70rjil
         2AQeeeXYbVvzspJUUJGVy5MLOd8F0PHgpHYz/7+Q5/idgnVm654hHEeZyDip7nQgkuJ5
         Znng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pQ/sncn2tUcbjQuQVK66Ha5DjC6QKU7yfXiY8d8pDt8=;
        b=V16w5L74pmMEMHjA5LEihx2mKHx1ri/BdHQ4sN/Xg1got3wZ/0F6Qc40MUACjHgifR
         ZQPOkyAASrbG2I9OCdYm2reDn2zRQUZFz6DnLp9faf7eTsFN+8x4wHmF2nle+IJvNp0i
         ztI5WSlGdx9b4D31fbbRzOg2UrQWwAi1hev4Xhjx5l/PPzYggjdjuXC1vT1OIrRTWDBl
         tS6L0ufNXgzdUM7cIqsVr8tUI9Obh7eR/Gg9b34gUaK4O4s+4f3Xk2F2zMO+DMninBa7
         USWyv21T7As2jGPXRv+W1NLRAx5sLfImWeoCvozTs40L6LTNP5cYZL0x3S5kWdl7TKgQ
         76EQ==
X-Gm-Message-State: APjAAAX44JUbpH2BwXSWlafENGjx4KkufTC2AeIzvJj5nTf+xpzlKnDH
        9WV7V1S2nQl+sXid3f7U1lyd0QRvtiifiLitAQ==
X-Google-Smtp-Source: APXvYqzYT+UB0YkBHCFmB1qQ15LiW9TGyfQwO2sjhcBW0SRC7czYqHom2YrgODWVDLfiaIMnlGnxerzmG8CBmYWs+lE=
X-Received: by 2002:adf:92a2:: with SMTP id 31mr12011796wrn.43.1562096218090;
 Tue, 02 Jul 2019 12:36:58 -0700 (PDT)
MIME-Version: 1.0
References: <CANsP1a4HCthstZP16k-ABajni1m75+VKT+mgLPF=4yGJ-H_ONQ@mail.gmail.com>
 <20190702192122.GA16784@splinter>
In-Reply-To: <20190702192122.GA16784@splinter>
From:   =?UTF-8?B?Wm9sdMOhbiBFbGVr?= <elek.zoltan.dev@gmail.com>
Date:   Tue, 2 Jul 2019 21:36:47 +0200
Message-ID: <CANsP1a5yHvV4OzfAXYVOzcChVNGLoZfWQQwGL1=fkPP1n=__MA@mail.gmail.com>
Subject: Re: veth pair ping fail if one of them enslaved into a VRF
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, dsa@cumulusnetworks.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for the detailed answer, I tried your solution and it works
as expected.

Ido Schimmel <idosch@idosch.org> ezt =C3=ADrta (id=C5=91pont: 2019. j=C3=BA=
l. 2., K, 21:21):
>
> On Tue, Jul 02, 2019 at 08:42:15PM +0200, Zolt=C3=A1n Elek wrote:
> > Hi!
> >
> > I have a simple scenario, with a veth pair, IP addresses assigned from
> > the same subnet. They can ping eachother. But when I put one of them
> > into a VRF (in the example below, I put veth in-vrf into the test-vrf
> > VRF) the ping fails. My first question: that is the expected behavior?
> > And my second question: is there any way to overcome this?
> >
> > Here are my test commands:
> > ip link add out-of-vrf type veth peer name in-vrf
> > ip link set dev out-of-vrf up
> > ip link set dev in-vrf up
> > ip link add test-vrf type vrf table 10
> > ip link set dev test-vrf up
> > ip -4 addr add 100.127.253.2/24 dev in-vrf
> > ip -4 addr add 100.127.253.1/24 dev out-of-vrf
> >
> > Then ping works as expected:
> > ping -c1 -I 100.127.253.1 100.127.253.2
> >
> > After I put the in-vrf into test-vrf, ping fails:
> > ip link set in-vrf vrf test-vrf up
>
> You need to re-order the FIB rules so that lookup for 100.127.253.1
> happens in table 10 and not in the local table:
>
> # ip -4 rule add pref 32765 table local
> # ip -4 rule del pref 0
> # ip -4 rule show
> 1000:   from all lookup [l3mdev-table]
> 32765:  from all lookup local
> 32766:  from all lookup main
> 32767:  from all lookup default
>
> Bad:
>
> ping 16735 [001] 13726.398115: fib:fib_table_lookup: table 255 oif 0 iif
> 9 proto 0 100.127.253.2/0 -> 100.127.253.1/0 tos 0 scope 0 flags 4 =3D=3D=
>
> dev out-of-vrf gw 0.0.0.0 src 100.127.253.1 err 0
>
> Good:
>
> ping 16665 [001] 13500.937145: fib:fib_table_lookup: table 10 oif 0 iif
> 9 proto 0 100.127.253.2/0 -> 100.127.253.1/0 tos 0 scope 0 flags 4 =3D=3D=
>
> dev in-vrf gw 0.0.0.0 src 100.127.253.2 err 0
>
> >
> > Thanks,
> > Zoltan Elek,
> > VI1
