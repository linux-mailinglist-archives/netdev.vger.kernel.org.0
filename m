Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A72735FBA7
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353388AbhDNTaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:30:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57034 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbhDNTaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:30:21 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C5C931C0B7C; Wed, 14 Apr 2021 21:29:58 +0200 (CEST)
Date:   Wed, 14 Apr 2021 21:29:58 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Chris Talbot <chris@talbothome.com>
Cc:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm, 982250@bugs.debian.org,
        985893@bugs.debian.org
Subject: Re: Forking on MMSD
Message-ID: <20210414192958.GA4539@duo.ucw.cz>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
 <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> In talking to the Debian Developer Mr. Federico Ceratto, since I have
> been unable to get a hold of the Ofono Maintainers, the best course of
> action for packaging mmsd into Debian is to simply fork the project and
> submit my version upstream for packaging in Debian. My repository is
> here: https://source.puri.sm/kop316/mmsd/

Ofono maintainers are normally pretty responsive, and yes, you seem to
be cc-ing the right list.

I don't think forking ofono is good idea.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYHdCtgAKCRAw5/Bqldv6
8lK7AJ9HYOutfhxq94P4FvSQmUVQ6tyy1gCfa0g0nWLAT0fwCpCafglM5GQ5EUw=
=fKja
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
