Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBC134B9F7
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 23:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhC0Wir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 18:38:47 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54198 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhC0WiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 18:38:14 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9C9231C0B78; Sat, 27 Mar 2021 23:38:11 +0100 (CET)
Date:   Sat, 27 Mar 2021 23:38:11 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Zhang Jianhua <zhangjianhua18@huawei.com>
Cc:     ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, johnny.chenyi@huawei.com
Subject: Re: [PATCH -next] drivers: net: CONFIG_ATH9K select LEDS_CLASS
Message-ID: <20210327223811.GB2875@duo.ucw.cz>
References: <20210326081351.172048-1-zhangjianhua18@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <20210326081351.172048-1-zhangjianhua18@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2021-03-26 16:13:51, Zhang Jianhua wrote:
> If CONFIG_ATH9K=3Dy, the following errors will be seen while compiling
> gpio.c
>=20
> drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_deinit_leds':
> gpio.c:(.text+0x604): undefined reference to `led_classdev_unregister'
> gpio.c:(.text+0x604): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `led_classdev_unregister'
> drivers/net/wireless/ath/ath9k/gpio.o: In function `ath_init_leds':
> gpio.c:(.text+0x708): undefined reference to `led_classdev_register_ext'
> gpio.c:(.text+0x708): relocation truncated to fit: R_AARCH64_CALL26
> against undefined symbol `led_classdev_register_ext'
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Jianhua <zhangjianhua18@huawei.com>

a) please cc led lists with led issue.

b) probably does not work as LED_CLASS depends on NEW_LEDS...?

Best regards,
									Pavel
								=09
--=20
http://www.livejournal.com/~pavelmachek

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYF+z0wAKCRAw5/Bqldv6
8mMyAJ4vxuzs1YSfqAdo8SAY07PiWm3K2gCgmcpVWI6zlQSuxeI6ZI6ItoWA0Vk=
=dpql
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
