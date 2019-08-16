Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC568FD2A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfHPIHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:07:41 -0400
Received: from packetmixer.de ([79.140.42.25]:57604 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfHPIHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 04:07:41 -0400
Received: from prime.localnet (p200300C597109F0058E8B1B94AE0E6C2.dip0.t-ipconnect.de [IPv6:2003:c5:9710:9f00:58e8:b1b9:4ae0:e6c2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 9A73062053;
        Fri, 16 Aug 2019 10:07:38 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     David Miller <davem@davemloft.net>
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzkaller@googlegroups.com,
        mareklindner@neomailbox.ch, a@unstable.cc
Subject: Re: [PATCH net] batman-adv: fix uninit-value in batadv_netlink_get_ifindex()
Date:   Fri, 16 Aug 2019 10:07:38 +0200
Message-ID: <31320555.xYCAJxMVdn@prime>
In-Reply-To: <20190814.123625.170482147366456100.davem@davemloft.net>
References: <20190812115727.72149-1-edumazet@google.com> <20190814.123625.170482147366456100.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2051361.M9ZgcVIlPF"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2051361.M9ZgcVIlPF
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi David,

yes, you will get it through me. I'll schedule a pull request next week.

Cheers,
      Simon

On Wednesday, August 14, 2019 6:36:25 PM CEST David Miller wrote:
> From: Eric Dumazet <edumazet@google.com>
> Date: Mon, 12 Aug 2019 04:57:27 -0700
> 
> > batadv_netlink_get_ifindex() needs to make sure user passed
> > a correct u32 attribute.
> 
>  ...
> 
> > Fixes: b60620cf567b ("batman-adv: netlink: hardif query")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> 
> Simon, I assume I will get this ultimately from you.
> 
> Thanks.


--nextPart2051361.M9ZgcVIlPF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAl1WZEoACgkQoSvjmEKS
nqFqORAAvCf9SGzEj9doBeCk/3nDdjJhtrHfakjkDXyFATOdHaP1LT61wZcJ8/VA
azLafzkkfpr4RFpPe455O7jMCvbiCmdsXjJzuKoWtdZYBqm+24sKPU3Gw2u88Rk5
HSFyrtF7wzChEV4vXVBRmiTyyMzeqB7pD7mT2neEzipqZm7xK/PMppAZKrk6w5DI
Gm+2Yn95jXZ6thIbJ1qJfPges9m/skpFKRO2VSxl7e+0BRAMkpCR5uYWu3y5aloK
15Pc05E2+fWFBxd1dgb5vtP96E23L3hKMiV1Ic/2eLISMVNYzPNqR3ewkXgz3S9N
d1mK+2XXRBt0fmD3u0wJOA3JpHExqbUhrS7sB2ejBMW3B/4YZXlH/wLqdXEQiy+q
TW25OtSUfeLEVK5H2uZ6mblM+zkl8Y7QY/d8inqQvz6NvvZIIhxjzUJWwMWRkR9+
xqPYZPn9wPEdGp8GvXVvShP3onXtr0b8UNfX7pn1H4oGqwt5oNvwiCgEdvdrMsWD
OjPtLC5KRLBpn8iAZpEpqpMkg6ynZNfbq9AiFwciscF/Rw7e1UbS2CIyRi8wsaHN
HYzwPGc2ipRW0Ll4f+e3qy174+y36lhX2zLGJDSD8umhKLQ6jj4TJpopthGqoZ/J
GMKuS14ToS4cuaHDt/DQCW8NWd/1I/Eq/DteYqxWPofuwRL4a6A=
=xHTW
-----END PGP SIGNATURE-----

--nextPart2051361.M9ZgcVIlPF--



