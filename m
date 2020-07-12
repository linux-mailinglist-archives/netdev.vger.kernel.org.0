Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB30821C7EA
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 09:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgGLHqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 03:46:12 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48354 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgGLHqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 03:46:12 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 385BE1C0BD5; Sun, 12 Jul 2020 09:46:09 +0200 (CEST)
Date:   Sun, 12 Jul 2020 09:46:08 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Miao-chen Chou <mcchou@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1] Bluetooth: Fix kernel oops triggered by
 hci_adv_monitors_clear()
Message-ID: <20200712074608.GA8295@amd>
References: <20200629201441.v1.1.I162e3c6c4f4d963250c37733c3428329110c5989@changeid>
 <8174F3F7-52C5-4F15-8BF5-E005B44A55C0@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <8174F3F7-52C5-4F15-8BF5-E005B44A55C0@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-07-07 17:38:46, Marcel Holtmann wrote:
> Hi Miao-chen,
>=20
> > This fixes the kernel oops by removing unnecessary background scan
> > update from hci_adv_monitors_clear() which shouldn't invoke any work
> > queue.
> >=20
> > The following test was performed.
> > - Run "rmmod btusb" and verify that no kernel oops is triggered.
> >=20
> > Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > Reviewed-by: Alain Michaud <alainm@chromium.org>
> > ---
> >=20
> > net/bluetooth/hci_core.c | 2 --
> > 1 file changed, 2 deletions(-)
>=20
> patch has been applied to bluetooth-next tree.

Bluetooth no longer seems to oops for me... but there's different
showstopper in next (graphics -- i915 -- related). Oh well :-(.

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8Kv8AACgkQMOfwapXb+vJVggCgt4XZsqZWkWHltL/8Ca4hKtqg
10wAoMAfyUwKIh0H74EAgooNTS6ABM6D
=nbI4
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
