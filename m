Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565AC24DB1B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 18:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgHUQeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 12:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728580AbgHUQdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 12:33:47 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43814C061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 09:33:47 -0700 (PDT)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id BDE4586B8E;
        Fri, 21 Aug 2020 17:33:39 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1598027619; bh=9RfgqFA84TAIrh9nXg8ia1otkH9uJE6w2KA0neSBJhQ=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Fri,=2021=20Aug=202020=2017:33:39=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20kernel=20test=20robot=20<lkp@i
         ntel.com>|Cc:=20netdev@vger.kernel.org,=20kbuild-all@lists.01.org,
         =20jchapman@katalix.com|Subject:=20Re:=20[PATCH=201/9]=20l2tp:=20d
         on't=20log=20data=20frames|Message-ID:=20<20200821163339.GA7948@ka
         talix.com>|References:=20<20200821104728.23530-2-tparkin@katalix.c
         om>=0D=0A=20<202008212019.nMaa8rae%lkp@intel.com>|MIME-Version:=20
         1.0|Content-Disposition:=20inline|In-Reply-To:=20<202008212019.nMa
         a8rae%lkp@intel.com>;
        b=cXdzRFwg5YN25/wm7dKYYlx3VNYTDh602sAt86ZKaQMe16JyrxueIri73EIuJ+w1F
         FWxT35tVFTt0fm2QeTjSrOkQPB/BUNf2ER82qSJkJsfLOaUmezRI0T2XUWYiD2vfRT
         CG5EJf66OrMHncISQLibX5Q1P5n4lWSruo0N6W2HhDjM8OzfVMs6E9LZ44ImJKoG1A
         9lEy7/I5/CHURIVxfMRdhaeXM9/Pme2Mp/j4/53zX5PHpnd0Fqliz0AHU7m7nGpQSf
         C36HFETx7J5WKrje5p/pfWvByf5lx2VCi3cSgGcXvZ0kwIlOsY5rWNxqO8i1jcfinT
         Cvf43i2Lr5UQA==
Date:   Fri, 21 Aug 2020 17:33:39 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     kernel test robot <lkp@intel.com>
Cc:     netdev@vger.kernel.org, kbuild-all@lists.01.org,
        jchapman@katalix.com
Subject: Re: [PATCH 1/9] l2tp: don't log data frames
Message-ID: <20200821163339.GA7948@katalix.com>
References: <20200821104728.23530-2-tparkin@katalix.com>
 <202008212019.nMaa8rae%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <202008212019.nMaa8rae%lkp@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Aug 21, 2020 at 20:28:59 +0800, kernel test robot wrote:
> Hi Tom,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
[snip]
>=20
>    net/l2tp/l2tp_core.c: In function 'l2tp_recv_common':
> >> net/l2tp/l2tp_core.c:663:14: warning: variable 'nr' set but not used [=
-Wunused-but-set-variable]
>      663 |  u32 ns =3D 0, nr =3D 0;
>          |              ^

Thank you kernel test robot!

I will incorporate a fix for this in a v2 patchset, but I'll wait a
little while for any further review comments.

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl8/910ACgkQlIwGZQq6
i9AJoAf9EuPVTbhkiZAx7VchLMbe67laascCkPrNCRgz8S4e61WmZKtyWa8OI2D7
dL/G59VUCA0L0ifPoYDapOhgpiLniVOoZi6vic9tCak6OiSNBVoGnl9LCH6L7YUC
2gSa7ME+pkh6OpV+hCKiNJ7krj+wA6+ZhuMPM7bdUdZiKy7lkHsmpQ8YJo5jWnt3
OQbppGpC9wh38EE0Z/hywL/QIfgxDzKVa7lT0iG8W9bmeZfqDDnKgjdOFWBrUgE3
DiNisJ3oxx6i8mbNw833RMPBd0etkjSuV/6i4KiufshITJni7f8epmhRs9sdWuWE
Olt/KWGH9HRjHDkchQgCN0964zH2fg==
=Dbng
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
