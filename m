Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CC222E0A6
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 17:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGZP0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 11:26:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:32794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgGZP0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 11:26:50 -0400
Received: from localhost (p5486c93f.dip0.t-ipconnect.de [84.134.201.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DE272065E;
        Sun, 26 Jul 2020 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595777209;
        bh=x6KKgIk4k329j0vVx9e+kq8JD+D+KN7RjIWWZE2Ny00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T2brAFcJpcXJLjn40fZQeBmZYlUiFmQkfeIN+wjRnSgbe7DO6eJ9YEB9zIn3/QjKN
         9bzR1QUQyBjTXfqv4P6QZtoKsAx0l3Z4bvfbNtGH2ZfDb0nwRIRoOzOUDJ5ZExrHC2
         otwRsMaX+FOYDuFx7wlTi7/pUhmV0uoWGjJyHz+E=
Date:   Sun, 26 Jul 2020 17:26:42 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] iwlwifi: yoyo: don't print failure if debug firmware
 is missing
Message-ID: <20200726152642.GA913@ninjato>
References: <20200625165210.14904-1-wsa@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20200625165210.14904-1-wsa@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2020 at 06:52:10PM +0200, Wolfram Sang wrote:
> Missing this firmware is not fatal, my wifi card still works. Even more,
> I couldn't find any documentation what it is or where to get it. So, I
> don't think the users should be notified if it is missing. If you browse
> the net, you see the message is present is in quite some logs. Better
> remove it.
>=20
> Signed-off-by: Wolfram Sang <wsa@kernel.org>
> ---

Any input on this? Or people I should add to CC?

>=20
> This is only build tested because I wanted to get your opinions first. I
> couldn't find any explanation about yoyo, so I am entering unknown
> territory here.
>=20
>  drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/n=
et/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> index 7987a288917b..f180db2936e3 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
> @@ -468,7 +468,7 @@ void iwl_dbg_tlv_load_bin(struct device *dev, struct =
iwl_trans *trans)
>  	if (!iwlwifi_mod_params.enable_ini)
>  		return;
> =20
> -	res =3D request_firmware(&fw, "iwl-debug-yoyo.bin", dev);
> +	res =3D firmware_request_nowarn(&fw, "iwl-debug-yoyo.bin", dev);
>  	if (res)
>  		return;
> =20
> --=20
> 2.20.1
>=20

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl8doK4ACgkQFA3kzBSg
KbY5xQ/+M6FCVy2ULUZt7NXzSWEg/BKoQ5/LiakrYE7NNwWV0NshwLe8GV6jsxmK
sDBc2NAODNbeFgXriTA+x+XnRFnTP440eHyszqHcjKdWf0hAbc5hn8lNqu8iZqk7
Oe2huVW2rntpe72XSDda/8RnatGJuw10F1L2WP2jkf4MOJqR9Adsmcprvt80MFT5
VXA15vCjWQ83nAUv5IH0Lwt8ERhsHti/ffmtprQ4CaDyvmF83/onHHi6EMMlyzJT
6CP6uA1nBaSViEaArnuXQVlBdzjoTIE5NZz1Iblv6kQhC4I1bHDzANTc6xVBNkP9
natYdhYWVQorDZl9dFvHywoJyMSD/LQ7QMD2YDs/18NB9TGVw7wjkEleBLuwUEHe
giUmIzJ/EA2Ys0sWFRVxgdvNq7cMZeKT8K4fseRbQxOQkJYcTXH3WRcHx08MrZq1
+Cu1OR0It/d1bcAaP+JLHVSMAxDt87AzFIx8GB7T0e9GjpBQD+fV6ArErWh7EWaC
qMHVC1/W4zjrGj6iqHC+ZJOJEKTlaAHIt6+1FAeLv38V87ZrTPQDICIa7xynl2rF
u6vMtCCEwnq1GvYyPRrqO1gIn+MCdMYcvDC2uLb2xaeITPyykPo0fA+QMWKhPxP8
1OeARpFdGdXHYDGqASOWlbsxgpVSAlxEmfp0gcbuoU+qjvacNGI=
=vWQI
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
