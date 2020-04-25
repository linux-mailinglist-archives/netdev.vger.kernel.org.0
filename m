Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B741B8613
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 13:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgDYLOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 07:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDYLOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 07:14:53 -0400
X-Greylist: delayed 78680 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Apr 2020 04:14:52 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E1FC09B04B;
        Sat, 25 Apr 2020 04:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1587813290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KumF6kh56EN8JU+7POkgR7Y2ujlsA83xKr4QGN/daXg=;
        b=d3wmTxFC0t5ZVqdKAiC+GC/Lm6Thc6opDvrFvelDyKI1DXvCx+KpYYtcjNgP9n95smB8zi
        2N5EHiMVHUJANDnUUr77SmLF2PmdkndLm/1uNnEgso1JGbjR6n5AR5FG4LCwqBDD1I70/5
        JxLo+0k2l3VZF+8Qpj05Lsi9Wo+mU1I=
From:   Sven Eckelmann <sven@narfation.org>
To:     ath10k@lists.infradead.org
Cc:     Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linus =?ISO-8859-1?Q?L=FCssing?= <ll@simonwunderlich.de>,
        mail@adrianschmutzler.de
Subject: Re: [PATCH] ath10k: increase rx buffer size to 2048
Date:   Sat, 25 Apr 2020 13:14:42 +0200
Message-ID: <3097447.aZuNXRJysd@sven-edge>
In-Reply-To: <3300912.TRQvxCK2vZ@bentobox>
References: <20200205191043.21913-1-linus.luessing@c0d3.blue> <3300912.TRQvxCK2vZ@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9684083.LlcNlZrpYr"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart9684083.LlcNlZrpYr
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Wednesday, 1 April 2020 09:00:49 CEST Sven Eckelmann wrote:
> On Wednesday, 5 February 2020 20:10:43 CEST Linus L=FCssing wrote:
> > From: Linus L=FCssing <ll@simonwunderlich.de>
> >=20
> > Before, only frames with a maximum size of 1528 bytes could be
> > transmitted between two 802.11s nodes.
> >=20
> > For batman-adv for instance, which adds its own header to each frame,
> > we typically need an MTU of at least 1532 bytes to be able to transmit
> > without fragmentation.
> >=20
> > This patch now increases the maxmimum frame size from 1528 to 1656
> > bytes.
> [...]
>=20
> @Kalle, I saw that this patch was marked as deferred [1] but I couldn't f=
ind=20
> any mail why it was done so. It seems like this currently creates real wo=
rld=20
> problems - so would be nice if you could explain shortly what is currentl=
y=20
> blocking its acceptance.

Ping?

Kind regards,
	Sven

> [1] https://patchwork.kernel.org/patch/11367055/
--nextPart9684083.LlcNlZrpYr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl6kG6IACgkQXYcKB8Em
e0blZhAAtUz1zZuJUiX3gvEu7u03vcUEh+9wxlrnYwC+XmWyXWZ0lswqB5egTyd0
2XbsmAXldRfVz6HV/Gly3WGR2QBxVCkQPhEhDuUBDuNFnp/QL2+qnriubgRlDYSp
lIVP1REqUJcADEM92Bec8vWub35lxIwMj3j/DpR9gQ/toJu9C/1Gnuw9i40WTF3i
K+BMaPwR33aGAdTRDh1fK0zWcpuzRIOMGJf4HhoOgm3HU0K07P64UXC4x40uU1zi
G7Tn6SekHgtio5DmRRualgp28QE69XK66W25mbLxaZQcvnUHuNEoMZC+bJh+kYkN
pZiVdlUx6CM+CqSuztHCYT7Dgl3hC8KbTRAfVSY1M44NChglAIO3WXuHasyeqJHn
n9BJ+q9+AcemX1whESG16iA10KMK/8PsRF9ynzM05W+JiwvDiTB0JbEfS0h4eur0
dwiavSaAvnhoXV2bra4XxuqDxQWjagq11FCIpMg1U4WpuZSKit2K6hL31wHChsK7
O03j+un9EU/UHlDRb4G2EM1UU3t6JngjUDlzPr1lNkVFCwiFO4wh4e8nm+GiRmuc
yj1Wq7FREyBhhDbktr56SFLHoAluhshb2QRE+8yNAELZEi+mKS08kY/c6FVxPo63
elfS4ktzDlNtkQO4agAAPAmIOijysXjj7mG8a+5A8vhX4Y+s6Ck=
=2W59
-----END PGP SIGNATURE-----

--nextPart9684083.LlcNlZrpYr--



