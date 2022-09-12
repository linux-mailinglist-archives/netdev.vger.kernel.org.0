Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611DF5B622F
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 22:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiILUaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 16:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiILUav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 16:30:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F837402D7
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 13:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32F0EB80C9E
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 20:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACC5C433C1;
        Mon, 12 Sep 2022 20:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663014647;
        bh=q3ZJy4jEm644rFuFf3qaQ6p/4c00+LGN9RIpEWWal1I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eb+I8uijvRSIuCHo8djP/vVGnOrEgsxphtw0nxwUbj4d0XzlUn4t0r4HzfJpsWyNE
         /hdu4kmu3/2wmXxgGk0o45UmqcaVoLS/DMbBAFtdPFJKWbH3fKxu010dpD+uEo46br
         kFVMcO1eZlLMrhsLb6YVnwj+PM/DXLN5oLceIJ0wCyr6AH2x9nOU4XOMWx+5yoy0wN
         PEcLvALkqPL6rm7ofBcqF/m+9+3IaqNO2O1ViIFRvXLdmVkYpbD2AWqNgHBxvHd77i
         4PimBVTwIdmBGrPa4qFbpTgb5EcQA+lFVmYS82XqKhXi0UCxO9Cbb+ft49RpZzT2jC
         d6qRU7hZSzgJQ==
Date:   Mon, 12 Sep 2022 22:30:44 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: Re: mtk_eth_soc for mt7621 won't work after 6.0-rc1
Message-ID: <Yx+W9EoEfoRsq1rt@lore-desk>
References: <146b9607-ba1e-c7cf-9f56-05021642b320@arinc9.com>
 <Yx8thSbBKJhxv169@lore-desk>
 <Yx9z9Dm4vJFxGaJI@lore-desk>
 <170d725f-2146-f1fa-e570-4112972729df@arinc9.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YDZGR56KsyuKyCh3"
Content-Disposition: inline
In-Reply-To: <170d725f-2146-f1fa-e570-4112972729df@arinc9.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YDZGR56KsyuKyCh3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,
>=20
> On 12.09.2022 21:01, Lorenzo Bianconi wrote:
> > > > Ethernet for MT7621 SoCs no longer works after changes introduced to
> > > > mtk_eth_soc with 6.0-rc1. Ethernet interfaces initialise fine. Pack=
ets are
> > > > sent out from the interface fine but won't be received on the inter=
face.
> > > >=20
> > > > Tested with MT7530 DSA switch connected to gmac0 and ICPlus IP1001 =
PHY
> > > > connected to gmac1 of the SoC.
> > > >=20
> > > > Last working kernel is 5.19. The issue is present on 6.0-rc5.
> > > >=20
> > > > Ar=C4=B1n=C3=A7
> > >=20
> > > Hi Ar=C4=B1n=C3=A7,
> > >=20
> > > thx for testing and reporting the issue. Can you please identify
> > > the offending commit running git bisect?
> > >=20
> > > Regards,
> > > Lorenzo
> >=20
> > Hi Ar=C4=B1n=C3=A7,
> >=20
> > just a small update. I tested a mt7621 based board (Buffalo WSR-1166DHP=
) with
> > OpenWrt master + my mtk_eth_soc series and it works fine. Can you please
> > provide more details about your development board/environment?
>=20
> I've got a GB-PC2, Sergio has got a GB-PC1. We both use Neil's gnubee-too=
ls
> which makes an image with filesystem and any Linux kernel of choice with
> slight modifications (maybe not at all) on the kernel.
>=20
> https://github.com/neilbrown/gnubee-tools
>=20
> Sergio experiences the same problem on GB-PC1.

ack, can you please run git bisect in order to identify the offending commi=
t?
What is the latest kernel version that is working properly? 5.19.8?

Regards,
Lorenzo

>=20
> Ar=C4=B1n=C3=A7

--YDZGR56KsyuKyCh3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYx+W8wAKCRA6cBh0uS2t
rBGgAQDUcKa8CglqOitiaeurxEP0nIo76YaXE65b5jUrZF37DgD/RvLxb98U8pVC
RioEeKodHMaCzvLXIxHY/Jq5FJMBrw0=
=FNYl
-----END PGP SIGNATURE-----

--YDZGR56KsyuKyCh3--
