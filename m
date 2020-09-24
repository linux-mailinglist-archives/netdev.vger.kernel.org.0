Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F400276F78
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 13:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgIXLJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 07:09:47 -0400
Received: from mail.interlinx.bc.ca ([69.165.217.196]:59848 "EHLO
        server.interlinx.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgIXLJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 07:09:47 -0400
Received: from pc.interlinx.bc.ca (pc.interlinx.bc.ca [IPv6:fd31:aeb1:48df:0:3b14:e643:83d8:7017])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by server.interlinx.bc.ca (Postfix) with ESMTPSA id B4303259BD
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 07:09:43 -0400 (EDT)
Message-ID: <a4b94cd7c1e3231ba8ea03e2e2b4a19c08033947.camel@interlinx.bc.ca>
Subject: Re: RTNETLINK answers: Permission denied
From:   "Brian J. Murrell" <brian@interlinx.bc.ca>
To:     netdev@vger.kernel.org
Date:   Thu, 24 Sep 2020 07:09:42 -0400
In-Reply-To: <fe60df0562f7822027f253527aef2187afdfe583.camel@interlinx.bc.ca>
References: <fe60df0562f7822027f253527aef2187afdfe583.camel@interlinx.bc.ca>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-hx3GwdUD+BbwRd1dXGIa"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-hx3GwdUD+BbwRd1dXGIa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-09-22 at 15:04 -0400, Brian J. Murrell wrote:
> What are the possible causes of:
>=20
> # ip route get 2001:4860:4860::8844
> RTNETLINK answers: Permission denied
>=20
> when
>=20
> # ip route get fd31:aeb1:48df::99
> fd31:aeb1:48df::99 from :: dev br-lan proto static src
> fd31:aeb1:48df::1 metric 1024 pref medium
>=20
> works just fine?
>=20
> Using iproute2 5.0.0.

No-one with any thoughts on this?  Is there a better place I should be
asking?

Cheers,
b.


--=-hx3GwdUD+BbwRd1dXGIa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEE8B/A+mOVz5cTNBuZ2sHQNBbLyKAFAl9sfnYACgkQ2sHQNBbL
yKD/2wf/R7k+2Vx5bIrWIP9Li+eM7pTJHKAu+dgizp7ZNgOXXE6UkuBxTMO7kEpI
PpI+6GfjeJfPVoh6hlS1txrlCliuy6SZxyFlnITSRkVdWD0QMYhxJ999fvRSAJRj
0ixTVW1//VgRiyZoALzwt6oPnoY0AhBcxK2GGvG2F6iklVX3MWkqKJaLHasFVcmZ
TZnk/KPrPiQcz/4WO5WTZC+p9Zd+YaggTjZ2z0unwD1/z9bnskBdeBJLFHtSOVrb
T4oBHrkaZyQDa7iOci7idtx5oxQNzaafCoGQF8Tnm3XnSd+zfDaAGQ9UEe+XvYIx
bBdJrWjwkTLjcgDviHLY3++oUHOnsg==
=Jt1I
-----END PGP SIGNATURE-----

--=-hx3GwdUD+BbwRd1dXGIa--

