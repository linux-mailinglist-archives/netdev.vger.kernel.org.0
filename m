Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26CC2C818C
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 11:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgK3KAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 05:00:09 -0500
Received: from mail.katalix.com ([3.9.82.81]:53302 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgK3KAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 05:00:09 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8B0DC9700B;
        Mon, 30 Nov 2020 09:59:27 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1606730367; bh=HkistHrtY52xD0bjfDJuMl28/4XdgawgJh9AqdU/5eQ=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=2030=20Nov=202020=2009:59:27=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Sub
         ject:=20Re:=20[PATCH=20net-next=201/2]=20ppp:=20add=20PPPIOCBRIDGE
         CHAN=20and=0D=0A=20PPPIOCUNBRIDGECHAN=20ioctls|Message-ID:=20<2020
         1130095926.GA4543@katalix.com>|References:=20<20201126122426.25243
         -1-tparkin@katalix.com>=0D=0A=20<20201126122426.25243-2-tparkin@ka
         talix.com>=0D=0A=20<20201127193134.GA23450@linux.home>|MIME-Versio
         n:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<20201127193
         134.GA23450@linux.home>;
        b=zCIlY22OsvlPVfqmOd2QwuCQEvYpXG3pgwt+7+qKcsqoPBU1vWEKZ1+LhtqOAOBoR
         DjRR/h86Fz3HcRBZ2UOhYjnWCeFxkdsBBfvHrEHiOpq/UzN4sL/L3I+qNCjsasCNmY
         f2Qto+4awrspGE8N/IEnbyFqVC5isp/UVfOd+tOMQjgY+On0DGewS0g93/E8CjIqem
         3FT1LhIHTEyWC2pLn7j8lWV11mzB6F8EyAvjeQRG5biZaqnfKIB8faAVFlJNdNsF3q
         AG4wgloDd8+t1F+Pa1eSgS3sKQgGwGJZ8+XEUeee3/QS+vzpTFlnCxxSUyPDIJU9hB
         0XKtfeO4PFFJg==
Date:   Mon, 30 Nov 2020 09:59:27 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
Message-ID: <20201130095926.GA4543@katalix.com>
References: <20201126122426.25243-1-tparkin@katalix.com>
 <20201126122426.25243-2-tparkin@katalix.com>
 <20201127193134.GA23450@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20201127193134.GA23450@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Nov 27, 2020 at 20:31:34 +0100, Guillaume Nault wrote:
> On Thu, Nov 26, 2020 at 12:24:25PM +0000, Tom Parkin wrote:
> > This new ioctl pair allows two ppp channels to be bridged together:
> > frames arriving in one channel are transmitted in the other channel
> > and vice versa.
>=20
> Thanks!
> Some comments below (mostly about locking).

Thanks for your review Guillaume.  I'll work on integrating your
comments (and a fix for the build test robot warning) into a v2 series.

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl/EwnoACgkQlIwGZQq6
i9CKTAf/ZSFEaHqRkMF3u/UxJavjMPWKGzIRn9kb9LtvXFB+LAS2po3faxvL6hre
cuckzin4dB8C+U73oQoabGOgG4Kb8mhuynpE+PJV8V7lUQADEuJXu7LbU7/VEXJk
A+OvWhe0Ak8VckA1IRGTTBLGcuwK8ekorPfljkg2plowGhmnh999hO2OZnIhRcfB
bbWG9cn82N0JQN/DXnhkDJdU7rxKjzqrKTzcPegyAUFYs3zR0g++9I6VAI96qKTM
Eemf6GtE/bsaGNiPa0aU/wGlmlM80OVnQskXsC/c1zaKxWe+a8KIiBAewi1WvX+3
Lws/OTlSJyUagjer+HZtaRRK9qqNLg==
=8kEf
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
