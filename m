Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E915F4AA853
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 12:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243780AbiBEL17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 06:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243390AbiBEL16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 06:27:58 -0500
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A97C061346
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 03:27:56 -0800 (PST)
Received: (qmail 27698 invoked from network); 5 Feb 2022 11:26:10 -0000
Received: from p200300cf0744fd00709fcefffe16676f.dip0.t-ipconnect.de ([2003:cf:744:fd00:709f:ceff:fe16:676f]:56536 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <andrew@lunn.ch>; Sat, 05 Feb 2022 12:26:10 +0100
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] sunhme: fix the version number in struct ethtool_drvinfo
Date:   Sat, 05 Feb 2022 12:27:47 +0100
Message-ID: <5538622.DvuYhMxLoT@eto.sf-tec.de>
In-Reply-To: <YfwNCAYc6Xyk8V8K@lunn.ch>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de> <3152336.aeNJFYEL58@eto.sf-tec.de> <YfwNCAYc6Xyk8V8K@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5792010.lOV4Wx5bFT"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart5792010.lOV4Wx5bFT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Donnerstag, 3. Februar 2022, 18:12:40 CET schrieb Andrew Lunn:
> On Thu, Feb 03, 2022 at 05:22:23PM +0100, Rolf Eike Beer wrote:
> > Fixes: 050bbb196392b9c178f82b1205a23dd2f915ee93
> > Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> > ---
> > 
> >  drivers/net/ethernet/sun/sunhme.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/sun/sunhme.c
> > b/drivers/net/ethernet/sun/sunhme.c index 22abfe58f728..43834339bb43
> > 100644
> > --- a/drivers/net/ethernet/sun/sunhme.c
> > +++ b/drivers/net/ethernet/sun/sunhme.c
> > @@ -2470,8 +2470,8 @@ static void hme_get_drvinfo(struct net_device *dev,
> > struct ethtool_drvinfo *info> 
> >  {
> >  
> >  	struct happy_meal *hp = netdev_priv(dev);
> > 
> > -	strlcpy(info->driver, "sunhme", sizeof(info->driver));
> > -	strlcpy(info->version, "2.02", sizeof(info->version));
> > +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> > +	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
> 
> I would suggest you drop setting info->version. The kernel will fill
> it with the current kernel version, which is much more meaningful.

Would it make sense to completely remove the version number from the driver 
then?

Eike
--nextPart5792010.lOV4Wx5bFT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYf5fMwAKCRBcpIk+abn8
TumpAJ9j9hOdErU8FlHbPtvjWYivfV3t1QCeKSDKwMNpDdfpiPIeyY1THsqrfI0=
=uOwH
-----END PGP SIGNATURE-----

--nextPart5792010.lOV4Wx5bFT--



