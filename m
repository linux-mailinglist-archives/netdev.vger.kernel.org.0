Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9E335FDF8
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhDNWl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 18:41:29 -0400
Received: from cheddar.halon.org.uk ([93.93.131.118]:39588 "EHLO
        cheddar.halon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhDNWl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:41:29 -0400
X-Greylist: delayed 1873 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2021 18:41:29 EDT
Received: from wookey by cheddar.halon.org.uk with local (Exim 4.92)
        (envelope-from <wookey@wookware.org>)
        id 1lWnhk-00044b-Mt; Wed, 14 Apr 2021 23:09:48 +0100
Date:   Wed, 14 Apr 2021 23:09:48 +0100
From:   Wookey <wookey@wookware.org>
To:     Marius Gripsgard <marius@ubports.com>, 985893@bugs.debian.org
Cc:     Chris Talbot <chris@talbothome.com>, ofono@ofono.org,
        netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm, 982250@bugs.debian.org
Subject: Re: Bug#985893: Forking on MMSD
Message-ID: <20210414220948.GL11215@mail.wookware.org>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com>
 <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com>
 <d01f59bbfdc3c8d5d33fa7fca12ec5e8fe74b837.camel@talbothome.com>
 <9acefe05-29ab-4cb9-8fef-982eb9deb79a@ubports.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z4rh66uIX5MfNyUL"
Content-Disposition: inline
In-Reply-To: <9acefe05-29ab-4cb9-8fef-982eb9deb79a@ubports.com>
Organization: Wookware          
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--z4rh66uIX5MfNyUL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021-04-14 18:39 +0000, Marius Gripsgard wrote:

> I would really like to avoid a fork, it's not worth doing dual
> work. Did you ping ofono devs at irc?=A0 Also have you sent upstream
> patches? If a fork is the way you want to go, you will need to
> rename it as the existing packages need to follow upstream, we can't
> just rip an existing packages away from upstream.

Debian can package mmsd with whatever set of patches it sees fit. If
the end result is ChrisT's version, with Modem Manager support, then I
think that's reasonable. mmsd is not currently packaged in debian so I
don't think a rename is required. Ultimately it's up to maintainers to
choose which upstream is most appropriate. There used to be only one,
but increasingly one gets a choice of varying degrees of active
maintenance. (This can be a huge pain making life quite awkward for
maintainers, and I find Debian is the only org trying to unify a
diverse set of versions where a load of people have scratched their
own itch and then just left it like that.)

Ultimately we want the best functionality for our users, and if the
old upstream has been inactive for years then using this new,
maintained version of mmsd may well be the best course. Efforts should
continue to either give Chris access to the original repo or
officially declare it 'under new management' so that there is a
canonical place for the codebase, but in the meantime it's OK for
debian to have a big patch.

Versioning could be tricky in some situations, but SFACT the ofono
mmsd is just 0.0 so the debian version can be 0.0.something and remain
compatible with a shift back to that repo at some point.

Wookey
--=20
Principal hats:  Linaro, Debian, Wookware, ARM
http://wookware.org/

--z4rh66uIX5MfNyUL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEER4nvI8Pe/wVWh5yq+4YyUahvnkcFAmB3aBcACgkQ+4YyUahv
nkc1XhAAv9QOT953MAIDdjjGM4mkZaDNe7H3r4G66R+4TvGmuZADpsOvs08Sizzn
3+zXzekYZXk0eNEugoC3irBILeuDb2rHjDuBM5PZd6eUpzPXDPNE80QmCRq5vOsa
+A9xpHFDYWwC8khxgSJl4fCl+YUQks9S0Q5uaxpNdo/T5GuPA6iDxSpDirR3wqrT
eJ9So0swDX21QfyYnYt5Uc20ILk26QXl79YrOj744KSjdUveDgk09q0OFJisKvka
tNKpIFQM7HgpyWcW3aRHJ8fMn3I8ZW9rzYNA9mwIuVRp1IbOpDfs7bVoMkjYeWb4
OwL6LKiBFKiFcnYAZrKP6LVXjdeV9V59zG17Ds/fP/xp295fQdVSoDMVtGj9q/G0
o/Bj/ZX4DN8GbLmISmcrJL60ZrHrwHN7oGPtNJu5ly4vd2EwATvH+9+ZNe5DfOoL
BijZDsvA2WKl1YiWGIdf4UsQrI6c9t+MLcKHIsfbV1DrIY+icQX5jribS+7g/j38
1Q62YwrPpYfTNjGIgVLo+wSnpFZsvHcyhVExHFx/UDodO7Eae9tOIQP9sS+J0Vqo
cSY7VesyfN0NsKBazQ3g/+bpwvemXS629nKD4M0Wgza0C2Y8ors2B+ZD/vSjuvTC
gfV3JkLBHSnZeVZfpcJDT25GdulAYWEg+AHlk+r6oLhlRpAMRik=
=4N/3
-----END PGP SIGNATURE-----

--z4rh66uIX5MfNyUL--
