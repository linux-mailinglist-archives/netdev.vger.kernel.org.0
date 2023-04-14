Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFEE6E2161
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDNK6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjDNK6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:58:00 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE84F49E7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 03:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681469879; x=1713005879;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1kJG0gDmccz3x2qof6bhigAd7wr9RkAVa1UqTH29BXo=;
  b=h4xnBv9zJ51I8jdyUlOpk4KqGqv3mooufHyY5xzklF4WFEclMjFQBv2/
   XSehbgghQV+UdXEV2tj4hIBl79atNlNK1Re2DJ/fNOU52EdMwmqFtOLQX
   VOTmmgND+sE/39Hqs9VODvMFpaUgUEzxgjqHdWJ8sNHoRkT1EpScPXYHY
   ufkUE1FABhUS3HrAwF0hVekACM4eGqYSUhCxxsmSuqE4BCJGbwLG28JJ/
   iaU4dRN2efwUKvRnAQvQHhB18ZA9OWLLQ1638iP+hSzNsYdczVl2Rf70X
   eptGckEe06As80E3EyiRdjsx1pNmxqdiSh+kIqiCs6QWjOxI3QR6uF5Oh
   A==;
X-IronPort-AV: E=Sophos;i="5.99,195,1677567600"; 
   d="asc'?scan'208";a="209532775"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2023 03:57:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 14 Apr 2023 03:57:57 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 14 Apr 2023 03:57:56 -0700
Date:   Fri, 14 Apr 2023 11:57:40 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     <daire.mcnamara@microchip.com>
CC:     <nicholas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
Message-ID: <20230414-rumble-posing-74b2796e309f@wendy>
References: <20230413180337.1399614-1-daire.mcnamara@microchip.com>
 <20230413180337.1399614-2-daire.mcnamara@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zy33J9p2LYBt6trI"
Content-Disposition: inline
In-Reply-To: <20230413180337.1399614-2-daire.mcnamara@microchip.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--zy33J9p2LYBt6trI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 13, 2023 at 07:03:37PM +0100, daire.mcnamara@microchip.com wrot=
e:
> From: Daire McNamara <daire.mcnamara@microchip.com>
>=20
> On mpfs, with SRAM configured for 4 queues, setting max_tx_len
> to GEM_TX_MAX_LEN=3D0x3f0 results multiple AMBA errors.
> Setting max_tx_len to (4KiB - 56) removes those errors.
>=20
> The details are described in erratum 1686 by Cadence
>=20
> The max jumbo frame size is also reduced for mpfs to (4KiB - 56).
>=20
> Signed-off-by: Daire McNamara <daire.mcnamara@microchip.com>

I guess this also needs to be given a CC: stable, but I am not really
sure what to pick as a fix commit for this. It should go back as far as
the mpfs compatible existed (it was introduced in 6.0), but the commit
adding the compatible didn't introduce the problem.
The default GEM limit, which we used before I added reset support, is
also too large for us.

>  static const struct macb_config sama7g5_gem_config =3D {
> @@ -4986,8 +4985,17 @@ static int macb_probe(struct platform_device *pdev)
>  	bp->tx_clk =3D tx_clk;
>  	bp->rx_clk =3D rx_clk;
>  	bp->tsu_clk =3D tsu_clk;
> -	if (macb_config)
> +	if (macb_config) {
> +		if (macb_is_gem(bp)) {

I don't think this here is correct. This is being done before we have
configured the caps, so macb_is_gem() is always going to return false.

AFAICT, this should instead use hw_is_gem(bp->regs, bp->native_io).

Cheers,
Conor.

> +			if (macb_config->max_tx_length)
> +				bp->max_tx_length =3D macb_config->max_tx_length;
> +			else
> +				bp->max_tx_length =3D GEM_MAX_TX_LEN;
> +		} else {
> +			bp->max_tx_length =3D MACB_MAX_TX_LEN;
> +		}
>  		bp->jumbo_max_len =3D macb_config->jumbo_max_len;
> +	}
> =20
>  	bp->wol =3D 0;
>  	if (of_property_read_bool(np, "magic-packet"))
> --=20
> 2.25.1
>=20

--zy33J9p2LYBt6trI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDkxpAAKCRB4tDGHoIJi
0gHQAQCP78zydWdmnfPYrF7Nw5BenfNdzRYjVYhEkkUVxE5q5wEAmU5qQ61ZlsMy
IAUPTmePjjyXflDjyWRoHgZklUhJ5gw=
=QB6S
-----END PGP SIGNATURE-----

--zy33J9p2LYBt6trI--
