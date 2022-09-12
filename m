Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327055B5FBA
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiILSBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiILSBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:01:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932751FCF0
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 262D9B80882
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 18:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E88CC433C1;
        Mon, 12 Sep 2022 18:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663005687;
        bh=LTBcVWwTOCNfp5SnqZKqzxHmX7WOZpkd4dFoFoW46fw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WyS2NDGf2IbXfMkfm88uO2BQGeYB3GQzbWIpqLz/48OFms6qjj9tkX9dYWWwf6tuo
         ZPKbCrczpJchFtDeR5Wf/2NFBA08T0/whj3W0QCx7ABEhyG4Cu8R9S1x/cdK/v9LfB
         JHfHhjJ6g0D1q/uX8w1kx+r1epYm/9RUnDtR+Azpq3OsCelM7MWm/qUEBP5kVozq79
         51/UxqiBargM47eaFUOmqRb0zi6nPjefq3461JRZu/vAjdPRCE2/Yhn86Ioebg4KO7
         2j9VX6+J7A6QzzWgLGO1AOXQuub6F6yfcc9MYbLDYwUgLtwg+VoKiGiPT0C5Sb5V/U
         FmW0mg3bmrO4A==
Date:   Mon, 12 Sep 2022 20:01:24 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: Re: mtk_eth_soc for mt7621 won't work after 6.0-rc1
Message-ID: <Yx9z9Dm4vJFxGaJI@lore-desk>
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <Yx8thSbBKJhxv169@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Qej4phue7k2tiqDK"
Content-Disposition: inline
In-Reply-To: <Yx8thSbBKJhxv169@lore-desk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Qej4phue7k2tiqDK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Ethernet for MT7621 SoCs no longer works after changes introduced to
> > mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise fine. Packets =
are
> > sent out from the interface fine but won't be received on the interface.
> >=20
> > Tested with MT7530 DSA switch connected to gmac0 and ICPlus IP1001 PHY
> > connected to gmac1 of the SoC.
> >=20
> > Last working kernel is 5.19. The issue is present on 6.0-rc5.
> >=20
> > Ar=C4=B1n=C3=A7
>=20
> Hi Ar=C4=B1n=C3=A7,
>=20
> thx for testing and reporting the issue. Can you please identify
> the offending commit running git bisect?
>=20
> Regards,
> Lorenzo

Hi Ar=C4=B1n=C3=A7,

just a small update. I tested a mt7621 based board (Buffalo WSR-1166DHP) wi=
th
OpenWrt master + my mtk_eth_soc series and it works fine. Can you please
provide more details about your development board/environment?

Regards,
Lorenzo

--Qej4phue7k2tiqDK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYx9z8wAKCRA6cBh0uS2t
rKaKAQDPo22U6vuEISxZQQRlwjrfECyty44GdPkIzywOTxrR9AD9GWfV2klWimqU
isj0mpKBu4AqggV/UMEdAy1aeF4EBA4=
=qPFR
-----END PGP SIGNATURE-----

--Qej4phue7k2tiqDK--
