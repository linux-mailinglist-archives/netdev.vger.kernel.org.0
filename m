Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7414C5E88
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 21:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiB0UV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 15:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiB0UV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 15:21:28 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D261955755;
        Sun, 27 Feb 2022 12:20:49 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4K6FJD30xyz4xcZ;
        Mon, 28 Feb 2022 07:20:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1645993244;
        bh=bj4kQe2ga8DdybKfRKNaqFOjWtocJLyBV0Y3f+6szJc=;
        h=Date:From:To:Cc:Subject:From;
        b=fvDMSZE9l2gjzHY7ZxHfhbPz0tTliKc3uLxm7/3z1mmt7Ol0f2IHwMUxDsvUCq188
         u+WpcvTtB2ciiE4PPwsUHUaTB6QOZwzq6tbxplKENWMtVoEzvSHbFPZMYm65pxdqxO
         N4hNnnvoxvI0FY7w490vsfYDpwpDPW6MnP/UHKs9cm1ahsdOW5PSSlLX/pWTN13nOP
         z2acZh3RweGxsovhQt9lnMJvl8FLB/z3JzT79ips2/bLMs4MMcarrelhp7hQcLcba7
         FQlLnHcVl1vlyjgnV5WyIcyDgMS86Qxyu3ZOpjW4iVsrYmkEGRXOsuL41kKfIai45G
         v9PzOsFEiLfDA==
Date:   Mon, 28 Feb 2022 07:20:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20220228072042.5314e22b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/C7ouye5q8627jOdzauxjfu7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/C7ouye5q8627jOdzauxjfu7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  765559b10ce5 ("ibmvnic: initialize rc before completing wait")

Fixes tag

  Fixes: 6b278c0cb378 ("ibmvnic delay complete()")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

So

Fixes: 6b278c0cb378 ("ibmvnic: delay complete()")

--=20
Cheers,
Stephen Rothwell

--Sig_/C7ouye5q8627jOdzauxjfu7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIb3RoACgkQAVBC80lX
0Gyfmgf+L3yqbcnI6avxhcU+ivOnkGKhZfuy0IzwqVG4WghKtXRvfhsYs9c+1Bml
IVfT3OyeGRns/9du8i7mVJWdOS7p+ITgDjdQXl5OHG7nXkRgRx/WJUo/bja/VzfC
EjgoZt5kc+Y1QM1tFbdG/t6xQPK2y/kIe37KBZyqXs22vliNgkSzOu+SDAoirsbV
sgfovsasGl2Xn/+QsEhwb4/W66MIsq8l7rOUlThFcfZWO119hhysN5C2Vg6289ke
OGIno95mxafmZtg6ByKWX8i0FYmbj6I/1PdAnquQHSUbIBQ74dS3EfJdNGkdn/qE
qu6VdBKE4l7J/PolMp0jtO5d6L+OCw==
=eBrp
-----END PGP SIGNATURE-----

--Sig_/C7ouye5q8627jOdzauxjfu7--
