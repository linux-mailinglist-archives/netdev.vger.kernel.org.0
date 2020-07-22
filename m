Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B78229475
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 11:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgGVJHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 05:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgGVJHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 05:07:49 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15595C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 02:07:49 -0700 (PDT)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 714A193AEF;
        Wed, 22 Jul 2020 10:07:48 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595408868; bh=cxE14xMn/S2fCTuvSXqqjh1VcOtx0tQ9Sq4X+WtQxTc=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Wed,=2022=20Jul=202020=2010:07:48=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20David=20Miller=20<davem@daveml
         oft.net>|Cc:=20netdev@vger.kernel.org|Subject:=20Re:=20[PATCH=20ne
         t-next=2000/29]=20l2tp:=20cleanup=20checkpatch.pl=20warnings|Messa
         ge-ID:=20<20200722090748.GB4419@katalix.com>|References:=20<202007
         21173221.4681-1-tparkin@katalix.com>=0D=0A=20<20200721.161917.1352
         752521032182959.davem@davemloft.net>|MIME-Version:=201.0|Content-D
         isposition:=20inline|In-Reply-To:=20<20200721.161917.1352752521032
         182959.davem@davemloft.net>;
        b=u/gPFcOpoO61OKjWadYXW475YVYh5UwnwUmUxv8WrZpmM5Y4C0pSZM6tGcSBivHVZ
         +753TXu7Q5an3UuKIyJK8mQHQu5vUUBwjQOi9+NK+eRJwc2e1aW1CcA7nXo6Dcw0/j
         qzhB2Q9KxAUao+KOOXcaLeQQLsTdG9bxR8suqgAgyzTnZp6h/yOQU+6ozKArPMHL8h
         Im64cjojiZ5Qc0sfZbmZ5WR5M7oeZsNK0Cei1Gxw1mtvH78d07lSYfLQiXO9KWD2w0
         Tgg0SOi8YpVRDp9H0ifdDTHM+S1pKhUutZ2RcmKKzxWKLXpYl7w8Gn/2lZTHOAJlzW
         zUX1xvIYZe8tQ==
Date:   Wed, 22 Jul 2020 10:07:48 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/29] l2tp: cleanup checkpatch.pl warnings
Message-ID: <20200722090748.GB4419@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
 <20200721.161917.1352752521032182959.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <20200721.161917.1352752521032182959.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Jul 21, 2020 at 16:19:17 -0700, David Miller wrote:
>=20
> This patch set is way too large to be reasonably reviewed by other
> developers.
>=20
> Please either find a way to combine some of the patches, or submit
> this in stages of about 10 or so patches at a time.
>=20
> I am not applying this submission as submitted.
>=20
> Thank you.

I will respin as requested, probably covering the more trivial
modifications in one series and the larger changes in a second
separate series.

Thanks for looking at it.

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl8YAeMACgkQlIwGZQq6
i9AJqQf/QKWLR1C7+Ms+0njcn1uOP+vmzzJarRoqkK65T1tn9dLXy/h03WHenFSI
3D6vb+Lo3Kuq8oUq9IJQUUt3EdRsP9igg55qN7bfRSV1cAr6hifQzlX5TIhrfpps
xO/bBgURHBWT8hzDAYRjlhypV+IwjgVFu6ZWX7FHSmPfx2HcvH6VuKFiPI0/r0QZ
EMuuyA9v94n0Py2BoAWGQWwBHO8E9Kw7KcrcZeZZIDOcO17UI+J/ZOZv/jajGkNA
yxkCdd6wccnmGzndE8E4f0bvL9oyLe8gz6kTJH4JJTgg0PpmNMsfYAe7tIaCqm7c
R92JON9Ibe2q012U1gZlN+fGjuy2Pg==
=Xxkq
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
