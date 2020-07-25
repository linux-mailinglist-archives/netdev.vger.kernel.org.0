Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98E922D7EB
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 15:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgGYNt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 09:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgGYNt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 09:49:56 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4216AC08C5C1
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 06:49:56 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id cv18so6884874pjb.1
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 06:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pesu-pes-edu.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=LLAXJNdpHy0u7H/oEPx2Cu3c6wN39L4ifePW5R8OKms=;
        b=GvWm/kVYYK5AqBeDOL4ZsAA2YqeZVJWkqybnwScQtjr173iX1SOBd6ZvWLuGCSL0xt
         QLAqUmB242GbTTvtYOR3nClE6JyJiF2Afp3BYfnKuZ+OlIrfV06uNwvuVXaQ4Brs/02J
         JNqgAaY1Yw8aFvkQsRMxgAJUXbbmi1WJe7v3mJ8wvJtjJKRn4n9gF+NFMkshn84Sg2QO
         rFIUMuaDrZV6cY3Xb5a/BnlykD5iFsO7DKcfXMo5phgTL4MXIsazUaYuhX9M0A8tC8oL
         qUBMESzhK2/55Sbj+xrZBMWb6Z/WP5nXs9Wim4lT92BJ9fcRxdqeXJUkiOBNeH6SIEOc
         re/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=LLAXJNdpHy0u7H/oEPx2Cu3c6wN39L4ifePW5R8OKms=;
        b=VYe/xMqtpF6HisuDNB2o069q+ywIht/vBITYVj68nh6X6UhCPtmVewrH2U4YuJKyMI
         DUHf9jJblP5BLP3Z24/XAhbOyUUNo/UfhBsh6+VKK19zXzhyHZEkIevQFSDNulF2J+rV
         FU601cETjuvfaMjPgjMyaPlGSaNFl4aVYFfjrIchNkgQe0yaPUTLL/znCgVcd9iG3NgC
         VK70bzkXxiBN2XFgb4nCgkkopKx11IIvqUpNTuxRp4on0NT4FG96saWAbNELxvbebQS/
         QW7co2lN2a/eCk6rHQ8U5nP/LEGIDKHY6N59nSji7JqcpPCr+B1dtAvnVF91OuRbgQaK
         LzdA==
X-Gm-Message-State: AOAM533plo96jUno06s51z69BWWJVQHsiJMJmxdWawMIin7xqdARtdVd
        4h6zPwUrWzVZusAj9cVP70Ua9ZZK1jM=
X-Google-Smtp-Source: ABdhPJyI336c3IHJNjAB7jq1BLzEP4muENEnxtaHINy1KDGw0ArcalwtEp7auSFnch2dCaZizzM3Tw==
X-Received: by 2002:a17:902:eb54:: with SMTP id i20mr11989114pli.183.1595684995621;
        Sat, 25 Jul 2020 06:49:55 -0700 (PDT)
Received: from localhost ([2406:7400:73:5836:d1f0:826d:1814:b78e])
        by smtp.gmail.com with ESMTPSA id 204sm9474743pfx.3.2020.07.25.06.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 06:49:54 -0700 (PDT)
Date:   Sat, 25 Jul 2020 19:19:49 +0530
From:   B K Karthik <bkkarthik@pesu.pes.edu>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: xfrm: xfrm_policy.c: remove some unnecessary cases in
 decode_session6
Message-ID: <20200725134949.z53thk4jubabiubd@pesu.pes.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c4fplsydpb3vei3c"
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c4fplsydpb3vei3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

remove some unnecessary cases in decode_session6

Signed-off-by: B K Karthik <bkkarthik@pesu.pes.edu>
---
 net/xfrm/xfrm_policy.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 19c5e0fa3f44..e1c988a89382 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3449,10 +3449,6 @@ decode_session6(struct sk_buff *skb, struct flowi *f=
l, bool reverse)
 			fl6->flowi6_proto =3D nexthdr;
 			return;
 #endif
-		/* XXX Why are there these headers? */
-		case IPPROTO_AH:
-		case IPPROTO_ESP:
-		case IPPROTO_COMP:
 		default:
 			fl6->fl6_ipsec_spi =3D 0;
 			fl6->flowi6_proto =3D nexthdr;
--=20
2.20.1


--c4fplsydpb3vei3c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEEIF+jd5Z5uS7xKTfpQZdt+T1HgiEFAl8cOH0ACgkQQZdt+T1H
giGm9gv+Mbsp1RKYcqvsnvHJ0O17aSHT6xr737iabQT0LjWNciXifs+MFWw4y/Yg
B++aJumrab6YvQrFGkp2GizBeREQCkXzmNHZSdBgAVgFLTz3oEQTNN6NlK3MHT0S
MPe7F7lFPirr0j0RzldYg7Jty2dNyk0Z1PZUApHyUDm7+j5zJN5n30EP320LGn1v
ptGO1mi7q5glDI9lRTLn5gXGp6VZZgp0S9SBNLXWudnsdxgxwaKEjjjPORPHapT2
eX6fmtufcvhe1Gu4Zc2K0mA9OqcrmL9iHFrL5oxMyoV2m8rQWQddcOdsvigK9RGR
MfuFU4RH7xBPJB/dof7DPvQKdGMEdexZ9cYTbjPZiVQfDKCwcr9WD4Z4o9yHc2Oc
H6BWIDPyqhXYJBXhymA+2UCRuKq/PbDx0EiEY2qgvhBA0EmtvxkOq6n/yASHeqjb
xJ1WxFSvtUj/QDuhhKizIK+UkRa0rF4FMAitTsYWKgy5NTaqYBWwIoJRKcL3E/tr
/91HbrDi
=NZDt
-----END PGP SIGNATURE-----

--c4fplsydpb3vei3c--
