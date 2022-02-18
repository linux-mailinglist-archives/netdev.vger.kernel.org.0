Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EE24BB5D0
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 10:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiBRJl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 04:41:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiBRJlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 04:41:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7665DE58;
        Fri, 18 Feb 2022 01:41:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB87061C3A;
        Fri, 18 Feb 2022 09:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E266BC340E9;
        Fri, 18 Feb 2022 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645177266;
        bh=KxJ9Vxs4B0Pl8mRx/4SGNFO7BcYqKJXVD30lpUKtT0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FDbHUxv4wZxlp3O9mVRvthU68Qx65VP8LyPo7MGFl4OriV3xp62rinvrKL9ScmCjc
         SKu1SUJZiPX2lNi8GVfFddB6z0MNbUsstd6ljYiDzV6duUuvadaXPGZNOGg8JVzUma
         5tbPCnzegvp+rj5lLwxUNqYg9VWt5R+EoiXbBpJ9xezLTawbbu5GK1XQrjKYpE9Sii
         oqcZt+JczztCVLB5M3q8BzALSO/EVPThM0FnD0mGqS33mS9CSjj8ig2wWxcCqwzIFA
         lPLPDbsu6DdkC8wKFGb3lCKj6MJrOy8FgrpYOCli20gZ5S4eIxxfQrWw1VSPaxkkZP
         C/Dai34AuWZdw==
Date:   Fri, 18 Feb 2022 10:41:01 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Subject: Re: [PATCH net-next v6 2/2] mctp i2c: MCTP I2C binding driver
Message-ID: <Yg9prTWlC5eTY5J5@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>
References: <20220218055106.1944485-1-matt@codeconstruct.com.au>
 <20220218055106.1944485-3-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OiUcSEdALkkZmsV+"
Content-Disposition: inline
In-Reply-To: <20220218055106.1944485-3-matt@codeconstruct.com.au>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OiUcSEdALkkZmsV+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 18, 2022 at 01:51:06PM +0800, Matt Johnston wrote:
> Provides MCTP network transport over an I2C bus, as specified in
> DMTF DSP0237. All messages between nodes are sent as SMBus Block Writes.
>=20
> Each I2C bus to be used for MCTP is flagged in devicetree by a
> 'mctp-controller' property on the bus node. Each flagged bus gets a
> mctpi2cX net device created based on the bus number. A
> 'mctp-i2c-controller' I2C client needs to be added under the adapter. In
> an I2C mux situation the mctp-i2c-controller node must be attached only
> to the root I2C bus. The I2C client will handle incoming I2C slave block
> write data for subordinate busses as well as its own bus.
>=20
> In configurations without devicetree a driver instance can be attached
> to a bus using the I2C slave new_device mechanism.
>=20
> The MCTP core will hold/release the MCTP I2C device while responses
> are pending (a 6 second timeout or once a socket is closed, response
> received etc). While held the MCTP I2C driver will lock the I2C bus so
> that the correct I2C mux remains selected while responses are received.
>=20
> (Ideally we would just lock the mux to keep the current bus selected for
> the response rather than a full I2C bus lock, but that isn't exposed in
> the I2C mux API)
>=20
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

Thanks for the update:

Reviewed-by: Wolfram Sang <wsa@kernel.org> # I2C transport parts

Note: Your mails miss a To: Header which causes hickups with some
tooling. Please add one.


--OiUcSEdALkkZmsV+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmIPaakACgkQFA3kzBSg
KbaVzg/9FfBGrnGaGKrhqRGzkihwzHVRj0iV5OfnAvEZJZxmr8wzoYB1ek08CjYm
u+hAeafTnKQOEn48EbqvH3uq7vpxEIVIu/7KcXKYxLuDDvPeGVxXGBUPs/uWdglH
CZuI729o5bp3HN4gFJFkZqT72/Yr4Be/VwSBOUi0FeEKzSrHa6rhRsraZcQKHVWy
o5siQUNO/wpK8z0fukt/4/vU4JQDkn2ZwrXcf3boGZheELwUwEvKgocr5cAglluq
8WVsrj/6KjDI29Sipr5SZlce479A8+/cUZY4xkKcDARUwN8UMV099JIvwwZ9WEtx
oC44WNraLXgQWhxk705CbmgLZhagDARIOzyTHefLC7i9zlNc6hzrD1kb2MBHb0wK
dnMWkOLViQTn/wLrc7e1VGlsed+qFlP648aRLtKUftkgt8Ez0UIhl9hCCpFCOtsg
ZZd/Yqd1tsB7SYX8/rYqAGTaxgTxMyMICfjuTD3ODHL1+2/x6StFDzZTe8DWyOId
jDQT1ZXKwCM95ddvdNa4xkQRtpQ0V2P6LddfDeYwbE3ag16K83iTH73GOGvv8Skp
Dd/QYnCMXhC6hX1M4IioyREcjU+UHL132GRP24MtZJ+H8ca+RlElTwOwDspLP+/w
mclnPrzXvvq+OfHKI8loLGfbW5fUSLCWT/z7oyvnK8a42pNVVuw=
=PkbI
-----END PGP SIGNATURE-----

--OiUcSEdALkkZmsV+--
