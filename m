Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA664620A3
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242794AbhK2TkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:40:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53364 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbhK2TiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:38:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE402B815CE;
        Mon, 29 Nov 2021 19:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B7EC53FC7;
        Mon, 29 Nov 2021 19:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638214487;
        bh=uePvt5gMX4TCL27r5CN6jhQcivmaVfv/7LWiS3z51Z4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MEE8n62NGTa/brNFFlvb9FgYyKurmn24pS/XrKGR42MPp1tduyLil2D7SAgiVPTb+
         Zoy2CsrLD4FTlDlE+Q9xSXjuOxxv1LG8RZ9DDrCFCGzCBVWjJ82aAJc70B9OsAVhEG
         LjlYy+7j5hxgxDfInoCEtj0pzGelawbuwJ1h9sYz/LgiMXQ9M2rkCHf7AuqJ2vZfi7
         bXMwo7KmTo4TIpSryev2s5bxpe8FdQdkqaBnOy4Oe1gw70wivT0AGrWi4xeoW7Rzjf
         j7Dq3+KI/WsW+1N91On/pJHrcllIxemTzTc4nsC01Xoe3RYNdNBgtfzfauU9eNal6H
         MSqpTEVTeFhAA==
Date:   Mon, 29 Nov 2021 20:34:44 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     zev@bewilderbeest.net, robh+dt@kernel.org, davem@davemloft.net,
        kuba@kernel.org, brendanhiggins@google.com,
        benh@kernel.crashing.org, joel@jms.id.au, andrew@aj.id.au,
        avifishman70@gmail.com, tmaimon77@gmail.com, tali.perry1@gmail.com,
        venture@google.com, yuenn@google.com, benjaminfair@google.com,
        jk@codeconstruct.com.au, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/6] MCTP I2C driver
Message-ID: <YaUrVD0AMwCc7+Cf@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>, zev@bewilderbeest.net,
        robh+dt@kernel.org, davem@davemloft.net, kuba@kernel.org,
        brendanhiggins@google.com, benh@kernel.crashing.org, joel@jms.id.au,
        andrew@aj.id.au, avifishman70@gmail.com, tmaimon77@gmail.com,
        tali.perry1@gmail.com, venture@google.com, yuenn@google.com,
        benjaminfair@google.com, jk@codeconstruct.com.au,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
References: <20211115024926.205385-1-matt@codeconstruct.com.au>
 <163698601142.19991.3686735228078461111.git-patchwork-notify@kernel.org>
 <YZJ9H4eM/M7OXVN0@shikoro>
 <20211124031522.GB18900@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gpsjBBqS4+607dEI"
Content-Disposition: inline
In-Reply-To: <20211124031522.GB18900@codeconstruct.com.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gpsjBBqS4+607dEI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

sorry for the long delay. This cycle, I am concentrating on overhauling the
bus_recovery handling. I am rather unsure if I have the bandwidth for
larger block reads this cycle. But it is planned for next cycle.

> > (extending SMBus calls to 255 byte) is complicated because we need ABI
> > backwards compatibility.
>=20
> Is it only the i2c-dev ABI that you are concerned about?

To at least give you a pointer what we discussed last time, have a look
here:

https://lore.kernel.org/r/20200728004708.4430-1-daniel.stodden@gmail.com

I can't go into details now because they escaped my mind :/ But I'll
work into it again when the bus_recovery thing is done and the recent
driver patches are handled. But you probably will get the idea without
me...

Thanks for sharing your script and working on the issue.

Happy hacking,

   Wolfram


--gpsjBBqS4+607dEI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmGlK1AACgkQFA3kzBSg
KbZQDBAAl9AQd3eSooJNmxHZhi63DLh9LFY+YPCISpqGsUYmntckM1+2LPF/hdv5
fK+YDAnLGeLd/G9VgbQ+gzE9DdLQyv/rxpaNz/vgLkdWF4uz32n4qswYiZrpEFwP
ByH4C3hcdwt7DErHNABidkzchbXW/3yZ9gQNX0fTbeTaNqvv+OrqrawGMHEKbFMZ
09M98fQ+aTSztAmpgSKMvJEyy96+afkTAcFsIbGgGC17I8u0daOpuaFoiGakIsvv
HviYzdpVDeovy20Y9kGAhvxp3IscRBAW9YX9IQpASv5c4OC1NY7Gtw8gkwFqsqHY
QHXUMrgFqOaglaghfQyFyxcUIKxgq0elq1KFz3dZHOHkddd3xq1Ixkd1AG7wtL4f
XoL/cTsE1N5YPn8LeVLRNfKvAxwc7uEwi7nC5LwXWHTiu3PRH6rP19PmzyGv/pNL
Ge10kKSViKy04B4cnCAGMdbM17RZ0Py+nEJdOpKDU4YTGLOVU3c6ciulYjZ+L3uK
8y7GGu2ilfdryCN0DrlwRslJjfX2SE5Pq7UKpmgxTXsQzuRinqodpzb7v8h2S6pL
pGQRu1NypiuE9nyt67W5a6DcS474qFlbKYfZYGXpqt48tXQJX8sdnkRuHdYOqU1X
GqXmNXtuDOmYe9vOlDKP+PQaTx2v3CQ129MtY2H1WIAo6+Zd444=
=/GFC
-----END PGP SIGNATURE-----

--gpsjBBqS4+607dEI--
