Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A7F412E5C
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 07:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhIUFxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 01:53:55 -0400
Received: from www.zeus03.de ([194.117.254.33]:56990 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhIUFxy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 01:53:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=TsC7Gf8WNSlJZ2XI5WCkNgZUyR2l
        j2Iij8k4znGy35Q=; b=GYDUxnuZz1WCM9i5DOD0Lyj3+f10g6mCvhKZ+yj4A0M3
        Z6lHweg2hvKsBATNUHeUyTBownIcoI4HRMuBlQZncftDW9uI0osur358+SOeOXyM
        cbeOKtqIFNusPGFl3iXgkcPyYXFv2iqHm7hCX9oZxltDQYbbifqfM2s83rCxjOY=
Received: (qmail 2740070 invoked from network); 21 Sep 2021 07:52:23 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Sep 2021 07:52:23 +0200
X-UD-Smtp-Session: l3s3148p1@EuEyAHvMas8gAwDPXxJ6ACVKg6pV4G9h
Date:   Tue, 21 Sep 2021 07:52:19 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/9] net: mdio: mdio-bcm-iproc: simplify getting
 .driver_data
Message-ID: <YUlzE43j0XwbX5kq@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20210920090522.23784-1-wsa+renesas@sang-engineering.com>
 <20210920090522.23784-8-wsa+renesas@sang-engineering.com>
 <6a8ffcab-4534-1692-5f6a-8a7906d07a09@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lhLmpLSFjJ4cOlGR"
Content-Disposition: inline
In-Reply-To: <6a8ffcab-4534-1692-5f6a-8a7906d07a09@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lhLmpLSFjJ4cOlGR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> The change looks good to me, however if you change from
> platform_get_drvdata() to dev_get_drvdata(), you might also want to
> change from using platform_set_drvdata() to dev_set_drvdata() for
> symmetry no? If not, then maybe this patch should be dropped?

In theory, yes. However, I haven't finished the coccinelle script yet
because there are a lot more usage patterns. I can do this individually
for this driver first if you want.


--lhLmpLSFjJ4cOlGR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmFJcw8ACgkQFA3kzBSg
KbZhwRAAllWphC2uNFh1IXRes+w2NxhbIvR7QkzU83hHzeYBsyhHaZuvVGAFogPq
QAlitr4Ea30sImmthBwldN79YGuX80gloJnq+gq8W4AvKbWa9bX+kmovig/jdsy6
ixuoMnAQoxwD9ya+c7wqMZax9A8QI3Fks0/aoGXZBeJWMrRaKq/V0WQ8TCrm6kZ2
RlfW6xMWmCxNia0a2p2rZRpgsqQH7eNxYG/pY821XJYXXyNFzDDm+AA9ctJuiSTS
RBiFdwSjSRIedPGm52iew2EXeh4D+o+nH/a93iFZq5DPu6TjMolVRyyNtGeU/oEL
/GgwjvaJg66NMkzOdY+aEpqPQ60+5eCOHNKoZgIxeORws7W2wlJt/VOBYq6MtROY
dDDASxQ0MyLGuh6C62JMIiMxa3+DjmTujJWu9K/YdZul47JMT1aEICUuQIEr/5U9
k5PVHgE/hM+VXfl73fXSnbqSn24HGOIKjxzi/Qf4+XLpD82C2uUwWFjqsnrMoL9+
rYINPUwo0zW6U0s48fThnkwYuY1kGlK+qFvpQIGGiAMoaq9Bd3cDxbx72qOf8KV2
U8cqzJoh0M0aLVEUyncQ+27SMo4m6xWsi77Ga9n7BbMX31snCJTDHiDn2HukdGka
pmhsHigfeelqBKR9/iTLhI1G+iWAOMyFgnhQvRZh4jVG94wC2bY=
=1qz8
-----END PGP SIGNATURE-----

--lhLmpLSFjJ4cOlGR--
