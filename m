Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4533D0B69
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 11:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237450AbhGUIjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 04:39:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45902 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238203AbhGUI0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 04:26:23 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626858419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D7gg5VxuWurzD4vHHotgX8lONKIb8ymLdfuaw++jjGI=;
        b=UrMg0KvD7JX4QfDfmM/KmOL26TZkhZmQiiEOoDikjvQ3P7OqfwPX2G329dJHhmIQb1er7w
        jKF+HLVNxF9e27SZlydWdNDGwcnmakINXJCqSYAozvBx+aaQ1q9sKx5LU5Bjc8aK7Pxq6q
        /W5csRkeAeZrHB2G0z6MD5fppBU2alnJ0fSSuIRrYBqyHfBMOcn2h0WveWhASRfhfJZtNj
        bsKnhcwCdLL9aVi3wcQhZH0nHSBHTpv63TJaD8PYO6i2RyuKU1YQ3InvUqZPYw3O/GbJSy
        rDT9bKWjjVEFS9NGg5O/Whs6BGvvWzof5Bzi3mRXpyC6bXgXtACJ0iKjsOAzBw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626858419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D7gg5VxuWurzD4vHHotgX8lONKIb8ymLdfuaw++jjGI=;
        b=VEm47VCtQZiTBXmzBOmbWOt4d8R6YspWovL9eWUSc654oNYn+8tFNiEDcmft8dEKXTWuv+
        SYSuamPjhIpzD1Bg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 10/11] net: dsa: tag_8021q: manage RX VLANs
 dynamically at bridge join/leave time
In-Reply-To: <20210719171452.463775-11-vladimir.oltean@nxp.com>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
 <20210719171452.463775-11-vladimir.oltean@nxp.com>
Date:   Wed, 21 Jul 2021 11:06:58 +0200
Message-ID: <87lf60vxvx.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Mon Jul 19 2021, Vladimir Oltean wrote:
> This is not to say that the reason for the change in this patch is to
> satisfy the hellcreek and similar use cases, that is merely a nice side
> effect.

Is it possible to use tag_8021q for port separation use cases now? I'd
be interested in it if that results in a simplified hellcreek
implementation :).

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmD347ITHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpjjIEADXj6Ek5N8jaRei/UHFxGo+Om3nngwU
TSYUt0TV156F/IXXp6gUlan073dooQZv84ZeXavpya+zQjG57VlooX9F9DxBjSCd
de+RWdP/NAPATbUJoLvQlZPP5h0+qQgFzCrECWyVqQ54yncE2d//AY+Sm1ecjlHK
Xa9s5kyHl2HZOKBUBmW2qdhemszjaqo7ilT+LeCFSCx72la7RwlVO9BklcpGddn1
XFQ86MzC5e/7BssiGjJd3BInaXzIeKFcih28tF5ypv8AllTZr7g94VN5GtqxUWrF
/wQk4uWfZwAkfstWUNAroNEl+9Fi+dGX/r7sB/6Ut5w6VGwXatWFHu0HndEP+WYj
HAv0bp3sVJU5JP6hQsnwr4rVvUH8cq0LqFV39lvWiqFMB/WotR/RngNg/BrKI0fT
jCud5rrTfhCuJKLw1+EdoNBW+hE46WBXg1sc+mxnkgVC6VRNUzD63N2WDC/Hr8Uc
8v4E2X+CRhnK+1rn4noP0/7YJhyRnlaHlDoW73u4ji8E4Q5zYT4nCMBhTmzfOY7F
Ltl9eIOq1eyK8NH6PVYhmfqFAoE+oTo9O+MjWW1UgZPZiPbyUnI0IfBg7y9QHOdI
daqR/TzEK1dYl05zx7xQIqnlv5NwmTHWIuKuAqthvDuienkZvvvVSgHH1R+0T/UQ
ZQPjA/eaLFzmzw==
=Xw7C
-----END PGP SIGNATURE-----
--=-=-=--
