Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8E63694D2
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 16:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbhDWOgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 10:36:06 -0400
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17474 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbhDWOgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 10:36:01 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1619188510; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=dcJNNI8pmtiInXQeyw1r9uQBYltypcyc7Er2Xg3sUYpGQ0T5rfqYTtMgWrtxI8aGClJiVN4sGHmtzJ+Ybv/S/XcWOOO7xOaio2/QRzmmTWXDOeqSju+q72/o33SecrReISQcQGpww8sD0RPCpvf1Ey08jhGTwHJYEJY7+KirYjA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1619188510; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9+apoH+2AFQr9EAzLeLG2Umbi8a49d9Y10mHolgEbFg=; 
        b=f+9zp60DRsqcxUoBd2ZdeDfwO4c2hEiEUAIoYDGc+INuVMLL0YFH30/BD3jl8BeaGoPya1tcxE+Y/WuyNVo4kKzkIUmxLxrDMQwPcUdX7x2nVZz1HlqAUgUmqqAtxF4Amd4yBRuG7gWLivd33fZa0M0PkrpNwY9wMDu6qixz4/0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=dan@dlrobertson.com;
        dmarc=pass header.from=<dan@dlrobertson.com> header.from=<dan@dlrobertson.com>
Received: from dlrobertson.com (pool-173-66-46-118.washdc.fios.verizon.net [173.66.46.118]) by mx.zohomail.com
        with SMTPS id 1619188504531448.3632427738072; Fri, 23 Apr 2021 07:35:04 -0700 (PDT)
Date:   Fri, 23 Apr 2021 10:35:02 -0400
From:   Dan Robertson <dan@dlrobertson.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: ieee802154: fix null deref in parse key id
Message-ID: <YILbFi7LQb40lTkP@dlrobertson.com>
References: <20210423040214.15438-1-dan@dlrobertson.com>
 <20210423040214.15438-3-dan@dlrobertson.com>
 <CAB_54W557gEShnirMUfa1Y0MM0ho=At-sbuW10HbY=HEAX91AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2p+E3+hU0vJz9kLx"
Content-Disposition: inline
In-Reply-To: <CAB_54W557gEShnirMUfa1Y0MM0ho=At-sbuW10HbY=HEAX91AQ@mail.gmail.com>
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2p+E3+hU0vJz9kLx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 23, 2021 at 09:28:48AM -0400, Alexander Aring wrote:
> Hi,
>=20
> On Fri, 23 Apr 2021 at 00:03, Dan Robertson <dan@dlrobertson.com> wrote:
> >
> > Fix a logic error that could result in a null deref if the user does not
> > set the PAN ID but does set the address.
>=20
> That should already be fixed by commit 6f7f657f2440 ("net: ieee802154:
> nl-mac: fix check on panid").

Ah right. I didn't look hard enough for an existing patch :) Thanks!

 - Dan

--2p+E3+hU0vJz9kLx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEF5dO2RaKc5C+SCJ9RcSmUsR+QqUFAmCC2xUACgkQRcSmUsR+
QqUDdQ/9FclarcMjC6urIsBrsNOF5IzA8A/RCrPlG1IApiumstK+51zWtL8mYm71
laek0n3GbBzRsTZdM5kQOTCeSTY0TqyPDfNQ0besVKuEo2X3w5sP7bdq+rVJVjlo
Ls5ahTOQJQzmbvyq1YG0rkceD/1GS5RPxSYfOEHGm4/M7/wMeGZHGgRwvNb/lFO/
lZAEVddm1rH/MxIpw1XU3fmNTPEUu9l97lv0Xf8OBKcfeHH+QSKsZfNoKErm2kOR
sGYTCiT8bWXWNbFYyrly4/y8zBIXcbCXyjD3W8M0Rgw4jFuvq6URXwLftIPUmx6C
kr9ESrOTBaUAaG7IOdSuajKTTlTbxhmgdlK+ky7T7DOoRoYPF6cqs59j1ppjNyA1
dEpC12i2V88Xp+GYMUnekOqRpQiCjkyTJKj0+qVpObg1uPpwa+bjfP40tQoPP0ag
Up4vmocdQ1ZvyuTmYisSapUs1r+7p07OYoDc8Pm5ww3RKhOcsKuaE7kvINVX9ueq
t75IWwzIrycOZYbLYghQBYwvFqqNwDuZISDwimZInJmnxWJL8oTH9b+hU3vqVTTQ
mCbeJkb10K6FngqDKqjZuClelPBJZ2y2TdKz89XdoTFpw38MU62KcutwprJJpGQy
JFnrOobtz+PwpoYi/AcWklGG2EdCEtSbEABNb9ErFkV8usGoyY0=
=NJtg
-----END PGP SIGNATURE-----

--2p+E3+hU0vJz9kLx--
