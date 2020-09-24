Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598012776AC
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgIXQ0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:26:43 -0400
Received: from mail.interlinx.bc.ca ([69.165.217.196]:50432 "EHLO
        server.interlinx.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgIXQ0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 12:26:43 -0400
Received: from pc.interlinx.bc.ca (pc.interlinx.bc.ca [IPv6:fd31:aeb1:48df:0:3b14:e643:83d8:7017])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by server.interlinx.bc.ca (Postfix) with ESMTPSA id 3E270259FE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 12:26:12 -0400 (EDT)
Message-ID: <9fade563b86195869cba0ab9652c0a9e2ee8e2d3.camel@interlinx.bc.ca>
Subject: Re: RTNETLINK answers: Permission denied
From:   "Brian J. Murrell" <brian@interlinx.bc.ca>
To:     netdev@vger.kernel.org
Date:   Thu, 24 Sep 2020 12:26:11 -0400
In-Reply-To: <5accdc00-3106-4670-d6f1-7118cae5ef9e@gmail.com>
References: <fe60df0562f7822027f253527aef2187afdfe583.camel@interlinx.bc.ca>
         <a4b94cd7c1e3231ba8ea03e2e2b4a19c08033947.camel@interlinx.bc.ca>
         <5accdc00-3106-4670-d6f1-7118cae5ef9e@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-vd9OUmnZM6Jnqjep+sn3"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-vd9OUmnZM6Jnqjep+sn3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-09-24 at 10:15 -0600, David Ahern wrote:
>=20
> check your routes for a prohibit entry:

I don't have any prohibit entries

# ip -6 route ls table 5 | grep prohib
# ip -6 rule ls
0:	from all lookup local=20
1003:	from all iif 6in4-henet lookup 3=20
1005:	from all iif pppoe-wan1 lookup 5=20
2003:	from all fwmark 0x300/0x3f00 lookup 3=20
2005:	from all fwmark 0x500/0x3f00 lookup 5=20
2061:	from all fwmark 0x3d00/0x3f00 blackhole
2062:	from all fwmark 0x3e00/0x3f00 unreachable
32766:	from all lookup main=20
32767:	from all lookup default=20
4200000000:	from 2001:123:ab:123::1/64 iif br-lan unreachable
4200000000:	from 2607:abcd:9876:5432::1/60 iif br-lan unreachable
4200000001:	from all iif lo failed_policy
4200000006:	from all iif br-guest failed_policy
4200000008:	from all iif br-lan failed_policy
4200000008:	from all iif br-lan failed_policy
4200000008:	from all iif br-lan failed_policy
4200000010:	from all iif eth0.3 failed_policy
4200000091:	from all iif eth0.2 failed_policy
4200000097:	from all iif pppoe-wan1 failed_policy
4200000097:	from all iif pppoe-wan1 failed_policy
4200000098:	from all iif 6in4-henet failed_policy
# ip -6 route ls table local | grep prohib
# ip -6 route ls table 3 | grep prohib
# ip -6 route ls table 5 | grep prohib

Cheers,
b.


--=-vd9OUmnZM6Jnqjep+sn3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8B/A+mOVz5cTNBuZ2sHQNBbLyKAFAl9syKMACgkQ2sHQNBbL
yKB7Bgf+KAm0/tcnTnLTbYYWGF6MemFQVwGFRLEd9za1SrbmTYUokyawWEkg+2my
/2FYXojNzk2DcsmHSIp/tGQmmEAcMfEuUMhFju5ADqcWFNhVdx6WqComnNobDiOI
0wLyUleDGqtyi55ic9mqa5CVvq3wP5f7lyH3uh2LFs+wccjeZXEDU0GzAoE7whrM
aer2KK8cARUFOrlhk/Dd8cQmUGFePHlC0/RSI1yEWPYiZTZwoqh4Jsxa75Lu21E9
cZXu8AB5NTPXef1CI3whh3LjWyXNMjAMZD7kqdVQHo+KsEXRKFvcgo/+0h4u1DSA
sPg/Awe5tZWUu3mJGcp+GRUkvywsDg==
=CbK/
-----END PGP SIGNATURE-----

--=-vd9OUmnZM6Jnqjep+sn3--

