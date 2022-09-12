Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB125B5AC2
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 15:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiILNBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 09:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiILNA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 09:00:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCB113D77
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 06:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE59BB80D36
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 13:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478C9C433C1;
        Mon, 12 Sep 2022 13:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662987656;
        bh=jTDpB5To202Vc4BNDkqkvMnW3sK+kclW2jBK2StT8y0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sCgK8pmBLZk+Xut+tdVstK1rU7CxqAepOMDrp2jG69TkBjxXvcFpV5HMETKsG7bxA
         Zy/P/+5RGYOAFYPAxcaWxikD5V7A7ajXodHxM/Rlf/eySESOMlltZq51bE5HcIf8TF
         HFYDXDwMXmJJUBMwms7PE23KVt5+FFa/8KwDWQU9452jXgav4qsdv9C/iNjhuvElWn
         X4A71dTA6LIy5pZ2rWARjKIgeV02xA9m3TJ+ecnyUgq7ff5vEbQEn1JRRuEVlSw3PD
         Sv7Abjj2zJwORWhrEmHf3IdZZbITTWP7nPCAC1MA872LlreLTJE9GOaJUky9dHEoeo
         ESlF367ue5WSw==
Date:   Mon, 12 Sep 2022 15:00:53 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: Re: mtk_eth_soc for mt7621 won't work after 6.0-rc1
Message-ID: <Yx8thSbBKJhxv169@lore-desk>
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="26PKOtiXWgL8mobe"
Content-Disposition: inline
In-Reply-To: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--26PKOtiXWgL8mobe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Ethernet for MT7621 SoCs no longer works after changes introduced to
> mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise fine. Packets are
> sent out from the interface fine but won't be received on the interface.
>=20
> Tested with MT7530 DSA switch connected to gmac0 and ICPlus IP1001 PHY
> connected to gmac1 of the SoC.
>=20
> Last working kernel is 5.19. The issue is present on 6.0-rc5.
>=20
> Ar=C4=B1n=C3=A7

Hi Ar=C4=B1n=C3=A7,

thx for testing and reporting the issue. Can you please identify
the offending commit running git bisect?

Regards,
Lorenzo

--26PKOtiXWgL8mobe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYx8thAAKCRA6cBh0uS2t
rAgdAP4riIjW+M2xarZ0nzj/2DsgKe0YTaSj9TaWVV89lCDX4gD/U/DqWFBnX0fn
P3oscbeIYqVs54Fn0deONA1YlLx1nQ0=
=Hgqn
-----END PGP SIGNATURE-----

--26PKOtiXWgL8mobe--
