Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441A76E1246
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjDMQ2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjDMQ2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:28:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963A193CA;
        Thu, 13 Apr 2023 09:28:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32446611B8;
        Thu, 13 Apr 2023 16:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2110DC433EF;
        Thu, 13 Apr 2023 16:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681403316;
        bh=vA2rZqb3GSus8sF2oE1urSUYmfiV7TnsgeUY7yqFW1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wvo4TB313FF7e/8W9ivt2fumQnT2x5NF+qMIQntPpWpmukDIFJGOlPX7N/aY/KgQF
         UzwHti7beKLjmE33QFZdCBtrgLA9nW4Npb58P/zYHH7vikfkMC6J4pE8aDEWYbs7kO
         3tFNf9T19QepQlVLZ+QT7RD4N1lBsQGzsSC6Pe06aTBfO/4JAg8brX52A0vDBe++u1
         2JuFr9YuVOCBO5FzNyhVd4VR05g73ajDn/66y9YyC0qCOQK/sho5GZvsSqbTtp20Gc
         C0eXDbfHnutTyOMSUgwp1TZ7ABfTiM6E7+vdPgrVALgfhdrGTdUZwsDBgk/tCeTZyP
         xMRy/tJlpYZMw==
Date:   Thu, 13 Apr 2023 18:28:31 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 2/6] net: txgbe: Implement I2C bus master
 driver
Message-ID: <ZDgtryRooJdVHCzH@sai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux@armlinux.org.uk, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
 <20230411092725.104992-3-jiawenwu@trustnetic.com>
 <00cf01d96c58$8d3e9130$a7bbb390$@trustnetic.com>
 <09dc3146-a1c6-e1a3-c8bd-e9fe547f9b99@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gJ62P6exb1TR2UkD"
Content-Disposition: inline
In-Reply-To: <09dc3146-a1c6-e1a3-c8bd-e9fe547f9b99@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gJ62P6exb1TR2UkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > Implement I2C bus driver to send and receive I2C messages.
> > >=20
> > > This I2C license the IP of Synopsys Designware, but without interrupt
> > > support on the hardware design. It seems that polling mode needs to be
> > > added in Synopsys Designware I2C driver. But currently it can only be
> > > driven by this I2C bus master driver.
> > >=20
> > > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> > > ---
> > >   drivers/net/ethernet/wangxun/Kconfig          |   1 +
> > >   .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 153
> > > ++++++++++++++++++
> > >   .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  23 +++
> > >   3 files changed, 177 insertions(+)
> > >=20
> Looks like your use case has similarities with the commit 17631e8ca2d3
> ("i2c: designware: Add driver support for AMD NAVI GPU").

Yes, can you please check if you can't use the current i2c designware
driver?


--gJ62P6exb1TR2UkD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQ4LawACgkQFA3kzBSg
Kbb13A//YPHiYvwN8Wo09sYS3KY1NiB4EUW3xYRdhDI3BAfuGUyTgzYeNnEOqGGM
rmbe/TydPie+579ihWsiNO151jzFbYkRX2rjqXmp5PZCCo4hzUyT0qSLtxzLIl2e
9tsSx4mg90DO5Zz3AkEt4uYmTLE2ClICPaZgbjCRDoKtuz2SqWhbu2X859AX4YAJ
POt2Yft7Gt0SedIUexnfsLvbdlbAbk0YxQwq3ybAwiljKPZxuzoLTFc+1x6jFpnk
EqdmzoGklm1omUYL1PLz36dFLMBcWIhYVfJIS9WAfKwVbsBTJP7YNKE5PJ6+MGMu
r4Vi8s2Cj/CcNW/HaoDbeojBI54By8W/bSO20udNx89CvpOvsxt79me/J3E/4Hq4
iWAcxCsAcN+kcd5OS1kE3fNSQIah4wQuttV7gay+wWU+7wKKaw6pj1Xs+nKlpJZG
fUhoQJNsH7zrX9IPxhGQJQwxHFo6JMdDyQ9jolfvyD1KCOo1L88TO24uiDOROBpS
qcuKKpndLR9XPAO249gUN2k63nlKx8AKwspJ3UuSI3KwY2g6t9/ppgMx2qNgD853
w0FiMKVpRmCDlEY49aOANceF60nLX/MbeL9t5lnpm6nhb8h0+jiOfUxT0xCBvpV1
ik+5o431LxgousoN7ssylXZz/QwPm7TRLjo6M4VgBqWlve1u7jU=
=iVCY
-----END PGP SIGNATURE-----

--gJ62P6exb1TR2UkD--
