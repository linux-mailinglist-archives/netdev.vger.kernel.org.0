Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAC3EEAB2
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfKDVBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:01:39 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:40351 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbfKDVBi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:01:38 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 476QFq6vnYz9sP4;
        Tue,  5 Nov 2019 08:01:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1572901296;
        bh=brx9ehP4FCaic0vmXRQ06+f8+KlGVKbOLJleBD7faYg=;
        h=Date:From:To:Cc:Subject:From;
        b=psHy4bvAIm0FYQ07rJGiqy1/GKaW7Jc7m/+Ps7bMISdZboZcqWaaZxXT5O8ItoHPo
         uXxJQbhfWv57ZgSCUkMEpVlTlt4BzLlMU9oh8wsvGsfDwJhp1EsGULZTk3gOx8jAmO
         G1PSOkhFbEH1JpAeQehlLbheSh1nW+P/e7FCei3aNQvAaOAQsCBDGJG3Rz6AovRHza
         a7VfWtyRpYU0QUBRdXezsOaDv/iURklYX+oKX4VYsnOaplrUS+c8uo3/umaElpD4wY
         QaJ7A/mjfMOMhtEn4LnQaZflB+3PkQswzGCwMHoOi9LlS6AIGyL8WpD2oqripVWdYQ
         4q0VK5XAjWoEQ==
Date:   Tue, 5 Nov 2019 08:01:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20191105080134.33aab6a1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/avb18f9WLh=P4yYwbKJ6AmW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/avb18f9WLh=P4yYwbKJ6AmW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  4c76bf696a60 ("net: openvswitch: don't unlock mutex when changing the use=
r_features fails")

Fixes tag

  Fixes: 95a7233c4 ("net: openvswitch: Set OvS recirc_id from tc chain inde=
x")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/avb18f9WLh=P4yYwbKJ6AmW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3Aka4ACgkQAVBC80lX
0Gxh1Qf/VPbOCMjnC53qoYQ/sjCHnkCid+CZjpDd658pC5jjnnGjFsG/80tAu20F
Vq9Pn1wsh0bnb6Ws1W3AP52VYsTlPmsdUqD/OySA/FgqUCGS5wj4BT1F4HFlDmGT
nqiiPsoK7YJ5GwFry+GX8CgfmN4agQ6UQUIz4NQ5x1XEO0y6xPj43tM4VyjRLJHy
HAWn1XAfLBhUYl0KKIZYt22eIR1KNchx4bsD473fem11wQ7Wus/9Aqf6s+3oD+oW
2IbDhTh1U8opcUDoVBtVOEYDug/YvNRUgFgdiWUG8MschX/1wCXbXGBJg6Fh/FM/
wU1vtxVibJK+HyN3nepEfuQu7uQsdA==
=YSCu
-----END PGP SIGNATURE-----

--Sig_/avb18f9WLh=P4yYwbKJ6AmW--
