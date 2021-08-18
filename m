Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D5F3F0119
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhHRJ61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhHRJ6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 05:58:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F7FC0617AE
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 02:57:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGIJV-0003Ak-CF; Wed, 18 Aug 2021 11:56:49 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:ed04:8488:5061:54d4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 08E5E669A16;
        Wed, 18 Aug 2021 09:56:36 +0000 (UTC)
Date:   Wed, 18 Aug 2021 11:56:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Luca Coelho <luciano.coelho@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-crypto@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-can@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/5] treewide: Replace open-coded flex arrays in unions
Message-ID: <20210818095635.tm42ctkm6aydjr6g@pengutronix.de>
References: <20210818081118.1667663-1-keescook@chromium.org>
 <20210818081118.1667663-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="h4irlmrxob7c5btq"
Content-Disposition: inline
In-Reply-To: <20210818081118.1667663-3-keescook@chromium.org>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--h4irlmrxob7c5btq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.08.2021 01:11:15, Kees Cook wrote:
> diff --git a/drivers/net/can/usb/etas_es58x/es581_4.h b/drivers/net/can/u=
sb/etas_es58x/es581_4.h
> index 4bc60a6df697..8657145dc2a9 100644
> --- a/drivers/net/can/usb/etas_es58x/es581_4.h
> +++ b/drivers/net/can/usb/etas_es58x/es581_4.h
> @@ -192,7 +192,7 @@ struct es581_4_urb_cmd {
>  		struct es581_4_rx_cmd_ret rx_cmd_ret;
>  		__le64 timestamp;
>  		u8 rx_cmd_ret_u8;
> -		u8 raw_msg[0];
> +		flex_array(u8 raw_msg);
>  	} __packed;
> =20
>  	__le16 reserved_for_crc16_do_not_use;
> diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.h b/drivers/net/can/=
usb/etas_es58x/es58x_fd.h
> index ee18a87e40c0..3053e0958132 100644
> --- a/drivers/net/can/usb/etas_es58x/es58x_fd.h
> +++ b/drivers/net/can/usb/etas_es58x/es58x_fd.h
> @@ -228,7 +228,7 @@ struct es58x_fd_urb_cmd {
>  		struct es58x_fd_tx_ack_msg tx_ack_msg;
>  		__le64 timestamp;
>  		__le32 rx_cmd_ret_le32;
> -		u8 raw_msg[0];
> +		flex_array(u8 raw_msg[]);
>  	} __packed;

This doesn't look consistent, what's preferred?

u8 raw_msg[0];  -> flex_array(u8 raw_msg);
 - or-
                -> flex_array(u8 raw_msg[]);

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--h4irlmrxob7c5btq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEc2VEACgkQqclaivrt
76kXUQf/cn+R4mRgon+iBBoNOjSG6Xpa5C1kWsnyfyJAQq9geHgAtcyoTTot+9QH
bjo6l3vIxXSY85B6NbV+TQFuedtSpFYkRQJgWzMG/eIuwHZ7Buuf8uK5C5MESqwm
PJDEl2lZpKA7MtM2gMtvmhElNsv1Nr4FqMEOmCHs5LeQQ8ddsbJ0Ab7X7ffQ4SRu
UgMoqqUUFxReCmF+pmoxDC5uHBbovnw/hYPulDH6AN7jj8ml9/lPLuJKfBnyYGI5
jYTHTlc4+VnN6a7NJ7V9DhTCncLaFjXVFFxoQBWYgpetIV/eWwu2WwrrYhyrvEK0
cORmz7LG97TWWd3NSNNy9j7XKs0y+Q==
=UYoj
-----END PGP SIGNATURE-----

--h4irlmrxob7c5btq--
