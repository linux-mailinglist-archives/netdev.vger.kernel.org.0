Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9095E466BC2
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377151AbhLBVso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:48:44 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39934 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377128AbhLBVsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:48:43 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E12CC1FC9E;
        Thu,  2 Dec 2021 21:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1638481519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j2DnTWp7hSyJVr2OsPZMHDP0+c+zaKi0mJP2lumqW0Y=;
        b=lWh5B2gOebFNnwwg1piYMwFa3W+5w9/OGrDGSg6JA6ef5hAKAMaDXZP4xRywJvz7NpwIZQ
        xzjJ4JyqxDfFHuTCKT7hC6w2bOTQKDVNpAjFpf3gobxUB9kQrdSFCRvqVQ16ACZwNT+WMG
        CJ9AIiS1R/IPst9kJiQ7nL5HLRnsDXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1638481519;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j2DnTWp7hSyJVr2OsPZMHDP0+c+zaKi0mJP2lumqW0Y=;
        b=wshWrkKTXOMbASY2ym8iiQ2mMUNBq3YtPHPxOLsO9t+VMAWd6hhMoiFr/ILGL3kaZm/ZK/
        15ShkdBFCdacZZBg==
Received: from lion.mk-sys.cz (unknown [10.100.225.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D161EA3B84;
        Thu,  2 Dec 2021 21:45:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B5E50607CC; Thu,  2 Dec 2021 22:45:18 +0100 (CET)
Date:   Thu, 2 Dec 2021 22:45:18 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 0/8] ethtool: Add support for CMIS
 diagnostic information
Message-ID: <20211202214518.rwhrmzwhdmzs3kue@lion.mk-sys.cz>
References: <20211123174102.3242294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lux2x4vyqlzdd4ov"
Content-Disposition: inline
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lux2x4vyqlzdd4ov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 23, 2021 at 07:40:54PM +0200, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
>=20
> This patchset extends ethtool(8) to retrieve, parse and print CMIS
> diagnostic information. This information includes module-level monitors
> (e.g., temperature, voltage), channel-level monitors (e.g., Tx optical
> power) and related thresholds and flags.
>=20
> ethtool(8) already supports SFF-8636 (e.g., QSFP) and SFF-8472 (e.g.,
> SFP) diagnostic information, but until recently CMIS diagnostic
> information was unavailable to ethtool(8) as it resides in optional and
> banked pages.
>=20
> Testing
> =3D=3D=3D=3D=3D=3D=3D
>=20
> Build tested each patch with the following configuration options:
>=20
> netlink | pretty-dump
> --------|------------
> v       | v
> x       | x
> v       | x
> x       | v
>=20
> Except fields that were added, no difference in output before and after
> the patchset. Tested with both PC and AOC QSFP-DD modules.
>=20
> No reports from AddressSanitizer / valgrind.
>=20
> Patchset overview
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Patches #1-#2 are small preparations.
>=20
> Patches #3-#4 retrieve (over netlink) and initialize the optional and
> banked pages in the CMIS memory map. These pages contain the previously
> mentioned diagnostic information.
>=20
> Patch #5 parses and prints the CMIS diagnostic information in a similar
> fashion to the way it is done for SFF-8636.
>=20
> Patches #6-#7 print a few additional fields from the CMIS EEPROM dump.
> The examples contain an ethtool command that is supported by the kernel,
> but not yet by ethtool(8). It will be sent as a follow-up patchset.
>=20
> Patch #8 prints the equivalent module-level fields for SFF-8636.

The series looks good to me and I'm ready to merge it but as it is
marked "ethtool-next", I better make sure: is it OK to merge it into
master branch (targeting ethtool 5.16)? In other words, do I see
correctly that it does not depend on any features that would be missing
in 5.16 kernel?

Michal

--lux2x4vyqlzdd4ov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmGpPmgACgkQ538sG/LR
dpUuCwf9FPOYihMMKAvkh4KfI8b7gFyW4QQKFbP7qXsv1zqcGs9/8ol1THRYg2Zb
6H+/FXNojLHBbODq6smlSga2aVP7lPyCB35HTgorby7fL+z2N6YQzT+gViqS6i4g
nyyH9ortqbpLu/rlaUMKVY4k/gpOnViphMZzj6rdi5i1KV1XC6E5m6Il5p+ksjov
0vZsSlWg/k4BVnGYf65GlIpQh+B98ZAH74d6B2iyYgo6EjxfzYKYzpb0jX/5Badt
tRFWKwO6Il0hbc4ywZPDcQCmQaOQpUPtjMIKALqr9Jg7KrBh+TsUhVpmtfNLtGxT
RqWRR9n3132buSNhef5HtYcLJfkNog==
=oo00
-----END PGP SIGNATURE-----

--lux2x4vyqlzdd4ov--
