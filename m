Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1734957F126
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 21:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbiGWTZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 15:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiGWTZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 15:25:53 -0400
X-Greylist: delayed 593 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 23 Jul 2022 12:25:51 PDT
Received: from yangtze.blisses.org (yangtze.blisses.org [144.202.50.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8871055E
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 12:25:51 -0700 (PDT)
Received: from contoocook.blisses.org (contoocook.blisses.org [68.238.57.52])
        by yangtze.blisses.org (Postfix) with ESMTP id B1231177217;
        Sat, 23 Jul 2022 15:15:57 -0400 (EDT)
Authentication-Results: yangtze.blisses.org;
        dkim=pass (2048-bit key; unprotected) header.d=blisses.org header.i=@blisses.org header.a=rsa-sha256 header.s=default header.b=NsK4bbKy;
        dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=blisses.org;
        s=default; t=1658603757;
        bh=qATaAbC1rUyDfX/dSVKi6fkk8XGVOsgWeWblIQ2ZFcw=;
        h=Date:From:To:Cc:Subject:From;
        b=NsK4bbKyGCwNmeF2RLEtQuF+SxCPEiTn2n85ONAIQu5XVA5hDFoIIBDoyPJxnkb//
         NNGv7vV3XGjSq5+e+le55fLKYscFB7b7eMYAhDqvaTP6K2ZXV+XF1y7p2+Qv+A7/Je
         XbkBI/bhH9BdYkgu3S7tagCUM5ZssyryUS0n3rDHopvLqjiL6IsmxAFHe8HXCtHeXa
         J099rdAmAhqibZC5TfCRooHl+buHorBADUT2E0C0PAuvuhu9gv22Gdn4EOVuv9AMFo
         9AS65pIEzxCzS12U7MVGEac98x+7eL0bQU5/zg6PIxUof/WlGZMqHcoLhf+0WgO+HL
         vCr0PSO6eaK4A==
Date:   Sat, 23 Jul 2022 15:15:56 -0400
From:   Mason Loring Bliss <mason@blisses.org>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>
Cc:     netdev@vger.kernel.org
Subject: Issue with r8169 (using r8168 for now) driving 8111E
Message-ID: <YtxI7HedPjWCvuVm@blisses.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KFmEwrdeH28qTct0"
Content-Disposition: inline
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KFmEwrdeH28qTct0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all. I was happily running Debian Buster with Linux 4.19.194 driving a
pair of 8111E NICs as included on this board:

    https://www.aaeon.com/en/p/mini-itx-emb-cv1

I upgraded to Debian Bullseye running 5.10.127 and started seeing this
popping up regularly in dmesg, with the status varying:

    r8169 0000:03:00.0 eth1: Rx ERROR. status =3D 3529c123

As this box is being used as a firewall, I didn't want to leave it with an
obvious issue, so I installed r8168-dkms and it appears to function with no
issues.

If it matters, I was not seeing the error against eth0, just eth1, and in
this case eth1 is used for PPPoE to the world, while eth0 talks to my
internal network.

I've not yet tried the Debian-backports kernel to see if the r8169 there
works, but I can do so given some scheduled downtime. I'm writing in
advance of that in case the nature of the issue jogs a memory of something
already seen and addressed.

If you tell me what debugging data might be useful, I can supply it.

--=20
Mason Loring Bliss  ((   If I have not seen as far as others, it is because
 mason@blisses.org   ))   giants were standing on my shoulders. - Hal Abels=
on

--KFmEwrdeH28qTct0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEEXtBZz1axB5rEDCEnrJXcHbvJVUFAmLcSOkACgkQnrJXcHbv
JVUDtQ/8CgjzbFAV+W/S81fTg+j4dp9W9CHOfRr08Q+c9e/lkkq+tbZTkR5ekoQL
H/QmvcAPJ3iFWOd8LmtGOhCVFqSnwZ8lJJkGzPi+z615dwD9+h4VnxsKbdnTsH2x
PWpshx4e6uW7PxLZOGeOjKObVvYYHTq+0scgKu2OTjCIQJhmK4o1D4E5hQg6Id8s
J1VadrMZYFiRnUacY/VPEsCMroJD6LvZ9zAMNertc+cI6x7PTOjbWrbFz1Nezqkn
YtF0OPWW3xNtnciK9GQZ4h5q6kvlMbZEIskt7GoqwBbfzVyQBWXhVIQR6NVG8tVC
28ut+IZLTQ1HoT7g/GHgXQPNQGbyjb3BCHsWvxuBWivNTVwnmlIhuHMpav4Nbyoz
Svu3waQ4EF6mwadNgHYcae3DXxCJLyJ5Gfq3bsbwiJcxd6S8rQPrkcw7qtIgYDla
mX4P6HkYNWMSgvkwao/U3ijqYCmRsDJOan+k+BXzE1mXVlNDDIPtJLwjkTE4Am/N
PAmSizOmLtSjyHWrWIfTMde4zbQ4/juuWhreWcvolJXcazaoc+zXIThIyYAXLcS1
5i1XNTTGXz0vOxa4wKDzDqDOU2VsuiyLoIUFKoEtEeWeQ632REEW30MaXf4GQfzl
U1s4wSZSZ6Doe5JjzrtsILmeKBoGfRlz9uWfLpXYfv1OyiHDjls=
=+evl
-----END PGP SIGNATURE-----

--KFmEwrdeH28qTct0--
