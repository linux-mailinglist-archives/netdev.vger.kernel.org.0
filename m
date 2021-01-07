Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B4C2EE75D
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 22:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbhAGVDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 16:03:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbhAGVDf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 16:03:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7014233CF;
        Thu,  7 Jan 2021 21:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610053375;
        bh=ToEzhe4aTG089+z+ka+nehd5MRIUlw197n8wPBEnD1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=osco3fRsZ7Xil2mUNFljGzdioz2qxmYMoZbM0vYKSTvj7WTueOXmzwxmIGTTSIkHO
         evHCKj9irBktI00NElt4VRMCa4u8ce1QqlACNgF2u02+w8DYjf6AOiWegn1RB4w5Mt
         V96VA35Z+WKVpEvCnOiNJr9XKDczypF4b/7xe1dmTg2HfYmYn5X2a23YtPdOHA9T3W
         8/ZRxKt3/KSXJ5bB2iSmv/fo1EM/xxQrlyoNT+sXSK3wd4eR/6yB85xYAFd87uL23N
         OHjK//q9Zb6RCoOmIGZXlzqzdbLUB1uf7anTqBut5v8lYrhbnQ+xWPJkoOFba3/UaT
         z5qrhFRUPQ/DQ==
Date:   Thu, 7 Jan 2021 22:02:48 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: question about i2c_transfer() function (regarding mdio-i2c on
 RollBall SFPs)
Message-ID: <20210107210248.GA894@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        linux-i2c@vger.kernel.org
References: <20210107192500.54d2d0f0@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20210107192500.54d2d0f0@nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> My question is whether this is allowed, whether the msgs array passed
> to the i2c_transfer() function can have multiple msgs pointing to the
> same buffer (the one into which the original page is first stored
> with first i2c_msg and then restored from it in the last i2c_msg).

Sending the messages is serialized, so the buffers won't interfere. At
first glance, I think it would work this way. But it's late evening
here, so I will have another look again tomorrow.


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl/3dvQACgkQFA3kzBSg
KbYN+RAAq/GUwli2ZLF1jFSc3m48a+PPoTM4nEKil3mqL6mpTTx4Y6narbx05w9/
rDP1/Bb3eqdSO5qxWbs84knahZi3yYpm71DRXp3859T3LxFPGDimFoHE0sxpOJGX
nG5m00rrvBBuCv5iPReA6rjJGIyn4pdCM+zd77Er9yNinQaV9OIywZ2WjyVVIqPI
AIW4lQFFiDq3d7axBUGKpL+suEgn4LFqRRI9j+KHYSpTcEHhrBWg0OdEFwFpvKoT
ANgZXAL7B8QCpkZw9Z9Yp0d8ujWPAfN89CQWdpc0l3c8PSETEkXPXUgQ+Lor4DRz
efHkZSUNX3u+lu52McL7l3x334zjQ4b1VPXYE5OJ6vgzPlAB5NK69vIfoVYpedku
BoGHM0JrJ8UckBrup31FWqSNmhzDCdY9PIwlcgUWakvxFzVV8RnYD4Eu2V8Vwi1E
tH7iOFH6qS3iZEedosmaiYzWfh047W5GNXPyz6YbxV7nuxjvghm+ivTT6oa1V+FP
6wAY4uliOfW5aSk0Py51VDqJWtCpZcvod7Ru0FHvD2XncayNgdsen8Tn+Fk8x5f3
6QylXTpIOc/OlbLDaHJRuXxUSWH/88mxBVvEs6HMVDoPZO+YHQ5y5Nj5QUsZcQQ0
ZgQpvACu3cMIIlw5BWLMxuEOsamOomS6F3NG9eAix8a/kO8Ci70=
=rEBb
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
