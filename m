Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE9547BEBE
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 12:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbhLULR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 06:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhLULR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 06:17:28 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7EDC061574;
        Tue, 21 Dec 2021 03:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Content-Transfer-Encoding:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=gRG6JY48L9ROunICAHJ4xCJZ15g9dEgpL3TQjx//E5g=; t=1640085448; x=1641295048; 
        b=EEwiqd5jqdbAkbm74PAPiJtqoGWj3rukvo3XFMp8lA2iFGNBilAJwzes9w6Lm9nR+MgZTbkRsgb
        V2sMtJiLD+sfetdrdW0gRuV2lfkGXNcBhvaAFapxQpoa2HUnGGG2KiOjujVCum1+YBynRhRtJbFHZ
        rk705+H0U3tiPLRSND2wYxFm0GFci9M0T/7+vtqDMvYWs2KWfFXkhBahBnI2gNpIXgw8ecVbfk1x+
        Tef/hMXHbyQUpoWT0gE/WMGIJrGdmIofHOAvCtP5m+UrlYNVyBQv4BQLFthD9o1EC8U084Qk3BNAb
        IPbxJtPSEotKm/OiGS/b1qtoyT5AMrmc7igg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mzd8w-00EXWu-6S;
        Tue, 21 Dec 2021 12:17:18 +0100
Message-ID: <13ca3acf1107cd08b87f5d6adf93a06b5f9663f2.camel@sipsolutions.net>
Subject: Re: linux-next: build failure after merge of the mac80211-next tree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Date:   Tue, 21 Dec 2021 12:17:12 +0100
In-Reply-To: <20211221221519.75dff443@canb.auug.org.au>
References: <20211221115004.1cd6b262@canb.auug.org.au>
         <82d41a8b2c236fa40697094a3d4a325865bde2b2.camel@sipsolutions.net>
         <20211221221519.75dff443@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ZVfJ6yLK0Qqn2YWp4vgG"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-malware-bazaar-2: OK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-ZVfJ6yLK0Qqn2YWp4vgG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-12-21 at 22:15 +1100, Stephen Rothwell wrote:
> Hi Johannes,
>=20
> On Tue, 21 Dec 2021 12:02:57 +0100 Johannes Berg <johannes@sipsolutions.n=
et> wrote:
> >=20
> > Thanks for the heads-up, also on the merge issue.
> >=20
> > I'll pull back net-next and fix this.
>=20
> Or just let Dave know when you ask him to merge your tree ...
>=20

Yeah, I guess I can do that too.

Maybe I'll do that and link to both of your resolutions, they both look
good :)

johannes

--=-ZVfJ6yLK0Qqn2YWp4vgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEH1e1rEeCd0AIMq6MB8qZga/fl8QFAmHBt7gACgkQB8qZga/f
l8Rhig//XH2Dd8PYtvFdzwZzlxoo/xWQEpGrC4WSLgjiv4Xg3mno66CQtgmTOfEg
SPl+NLDlrWYVHcuYfDMxY1abQQR5mCMtTMv7l2a5s4zuA5KBbDHH8bGhF5AGbcDT
sT6tgzWcsk1nw5i+1qeYZF/U0JWY8Hq7HG0xADayQMsoQIewEustVNl4yGHJLXeF
uVgJ/uxCto2wHRUgWSrLD25TFn+NorxvAwoOmUETFD4V51YA3vhanoHVp1Fl6oWa
nbc20sSCHJQEYYxK/jH0w+Hxbn878vHCb7lTUhb7+JoccgRZ4VuGZyzZkbgfwkUj
QarY196zrH+IyW8nauF7qvjqiFbAN3zJHorj/IbGgxGCHjTTzL2sq2kgbpS89LEa
a9FTovnMI39qginbsi1rGKoen/b8eQvnpK8tTaKF2J7IAECR71t8BHQRvLE1mF8o
L9RxuzQVc4GXP9KGEj9//seKcw6ApB1w4oCO6p2MFmg6aX1eH11ogsZhHQxoDDMH
ez8Te1dyrU8YqQDvMi/WSU5xA17403J31X5d7fgzEXUOD99lV7ZXtoGcr1vuLThv
R0hOMZgT3SH/f2C0zYvGGpoU/qvXZgPEgWPp7YMRSCqnzeziDlbaWhjGfHAfGz9V
iQRPAMz0iX2pXssw4GM8feXWdJQiX3heBov+MfWkrbUnkylbnZw=
=fzz/
-----END PGP SIGNATURE-----

--=-ZVfJ6yLK0Qqn2YWp4vgG--
