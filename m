Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FCB2EC652
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 23:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbhAFWo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 17:44:59 -0500
Received: from ozlabs.org ([203.11.71.1]:49293 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbhAFWo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 17:44:58 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DB4DH3q1Wz9sS8;
        Thu,  7 Jan 2021 09:44:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1609973056;
        bh=BII4NeFlP5QX3mrFUpM78ThhM6BSRvYy1FcJVnFDvWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S7olAoJfSeOtLCEFKAJTrkK2kYt+N/0GqRVY0F1aHySK9kuF6AerExt2iA/akwBaS
         XyVFKNVG5++iXt6U1DsHzlFG3YOx5G712t451dp2GVAdHkxp4PedxfPBfubhE+bOeI
         41zj6JKA3Nt83RGBKCTYmpIJYvvqzhOEniQjUbImrL5fFymUOXm3RXO+kFcQLyTrzt
         PzN+72FG22pz5O+PsfatWvutOFIgNaOMJWHolOPK88Ma8BeAn12NQGvvX9KV/at9wS
         FQJ3yXOBQ8ZOGE/dqn1KOBJaJKta+j5craNlwGYiIPci38kHTKsjhcvvvOhbjM3cvp
         mYbRS68CrLiPg==
Date:   Thu, 7 Jan 2021 09:44:14 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the origin tree
Message-ID: <20210107094414.607e884e@canb.auug.org.au>
In-Reply-To: <220ccdfe5f7fad6483816cf470a506d250277a1a.camel@sipsolutions.net>
References: <20210107090550.725f9dc9@canb.auug.org.au>
        <220ccdfe5f7fad6483816cf470a506d250277a1a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wiDvQ1M5_px0be3UULZ5Hot";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/wiDvQ1M5_px0be3UULZ5Hot
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Wed, 06 Jan 2021 23:23:42 +0100 Johannes Berg <johannes@sipsolutions.net=
> wrote:
>
> On Thu, 2021-01-07 at 09:05 +1100, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Building Linus' tree, today's linux-next build (htmldocs) produced
> > this warning:
> >=20
> > include/net/mac80211.h:4200: warning: Function parameter or member 'set=
_sar_specs' not described in 'ieee80211_ops'
> >=20
> > Introduced by commit
> >=20
> >   c534e093d865 ("mac80211: add ieee80211_set_sar_specs")
> >=20
> > Sorry, I missed this earlier. =20
>=20
> Right, thanks. I believe I also fixed it in the patch I sent a few days
> ago that fixed the other documentation warning related to SAR that you
> reported.

I don't think so :-(  I did a htmldocs build with your patch ([PATCH
v2] cfg80211/mac80211: fix kernel-doc for SAR APIs) on top of Linus'
tree and still got this warning.  That patch did not touch
include/net/mac80211.h ...

Or is there another patch?
--=20
Cheers,
Stephen Rothwell

--Sig_/wiDvQ1M5_px0be3UULZ5Hot
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/2PT4ACgkQAVBC80lX
0Gyt/Af9HiJVWVbRAmi6breKnJTaOC4LZOq+ZzrMJqqzYGCsCDG+Qv+WkNT6WAGF
PbpYvMejWpq4uCmRzPzejByIouDCGEutTbIFwlfmzRwhm4vYbDQIRTAohX39IqCE
JJYlYu69CdIH2+paPS3s8nXG0GOl7xpI4fCaGONIakHM5bt7RL70z8P57yQVLeTH
ERcFBcYYd2bgfrcsRnr3d65ObV9qH19RJinKn8m54FXRZca2jt5A1Cwizjnuav9x
Axm6WR/xaL7jtdGsL7dSzB9mmvClZxHErdRF0FJuPgsIxzMEPQVMh+Cir5NPKd6o
sCnCgkPR5ahJ2dwradH2WlO0PctaNw==
=ETdk
-----END PGP SIGNATURE-----

--Sig_/wiDvQ1M5_px0be3UULZ5Hot--
