Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23472FFEC8
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbhAVIy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:54:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbhAVIyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 03:54:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 576F220739;
        Fri, 22 Jan 2021 08:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611305631;
        bh=Fz2SdsRmzyg/R2X1FlxG9bQZ+ajptlq0wR7ERPzwqDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ddZNA3M6UjNKCbv2ln05xi74+gg8RxPyfmTwHQ4mUmmkjwJ9S9/sn0rRIy3ApJYra
         ofdkWNtzHT0/iNjwUZK2whof89UzJC4pL+jhDlg2zofzNVukbVCGpITfv4dRSH/NP+
         Vljz4p4ya+TFxfBBgfNn7l16vKcvpy85i80JNbTCcKiLpQnkq2hhXjk5a4bFmW6INV
         djOy8m4qPjMvnzIVJvaQcwI+tPU6Vw+ZXR4jezPjuaA6S/H0iY30pf7MLs8p7yjxK+
         R37SCiknKGV/Du5Z6/rAraxkbZZzlhu5BiY1umPObLP6MEingJjnI2C2JBYNfkRqlq
         PS2UjRs5P+fWQ==
Date:   Fri, 22 Jan 2021 09:53:48 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
Cc:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pau Oliva Fora <pof@eslack.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v1 2/2] isa: Make the remove callback for isa drivers
 return void
Message-ID: <20210122085348.GB858@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pau Oliva Fora <pof@eslack.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <20210121204812.402589-1-uwe@kleine-koenig.org>
 <20210121204812.402589-3-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20210121204812.402589-3-uwe@kleine-koenig.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 09:48:12PM +0100, Uwe Kleine-K=C3=B6nig wrote:
> The driver core ignores the return value of the remove callback, so
> don't give isa drivers the chance to provide a value.
>=20
> Adapt all isa_drivers with a remove callbacks accordingly; they all
> return 0 unconditionally anyhow.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <uwe@kleine-koenig.org>

Acked-by: Wolfram Sang <wsa@kernel.org> # for I2C


--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmAKkpwACgkQFA3kzBSg
KbYioA//frCM2vGMNRb9m2Wz+bP5qkNSp3R5QbWC14WxE8ZsbjcOun8Op9VX023l
cmNSjxAFJ7nXTQgZYnrdfSo5+ZegXPapPa6zwpSF29HDrvoDmo7yHCVnrhSp+ko2
nauFE8d5U2LLJftrZ29QteTfvmBQn0RFdsO2NFFwCo9bVZd5UfwxinwQk3ncG4Fs
7th2N/Hwnb0Xb5NswrpHEeknQCVuYZdOx3bo21TQ/eImBBwT6iKExwzBYN+YX/Uw
AckTF0es+DatjTNiFBLvNHSDf0/bjroW+oIsZeu6Wz5G73yBqWiJmyhNLR4XxRJf
RgkOj9UvQsNAZhA/hKbFjtT0sv9yXYm4pe76+47Aw5YxnN5WQIAtBV0tsd5Dfs4Q
FCOIHYbsR8lchLm/HGG4D9L0w5fUgQ3TzaOUaWUQ3sjeHvpTGSH7JJCblU3FXlFB
N3Cn6HcfRTe7Izg9jH6lkYmaDvwsshB3VjK/uiegjLZPkN/EPGkNdwRnDId4zk/7
/Zgb5gYeLzQzXlxJM+WFgTS4aLLGg6UGxgl6PUHeSUXKdxoo9pjk7LtfRVpb+mHu
LHt7KzZLjCHrntyYHaXrxSHcjQZzxr8pGnPl+bfMjlpKpkbMBIyfncncJUiDz6cy
DuITnJtHM/j/zc6ciV1UPNWiF9bIu1ga6GdKu9/UEMlvE7xkgXs=
=0OvQ
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
