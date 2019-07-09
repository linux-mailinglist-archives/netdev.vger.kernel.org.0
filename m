Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBDA63D67
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfGIVhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:37:06 -0400
Received: from ozlabs.org ([203.11.71.1]:37421 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbfGIVhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 17:37:05 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45jwdB6nWwz9sBF;
        Wed, 10 Jul 2019 07:37:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562708223;
        bh=MEmOXDI97jity7DijGRA1XeyE6JKjpiqpj9iM0EwCqE=;
        h=Date:From:To:Cc:Subject:From;
        b=VxKXDupfP217sU2hOLZ5jkEtvwkH8PBLBVI2mqdypq7hjjLrx3RKhnU9Vv12k4ylo
         Vx5Vky15Lxs2jbKnNDnyPfrW9lNVr4aFDNokrTqbrOzCO33fRnkdOxnqTNAYBSyXKv
         +ljB0AQYcuzW1deMBjESPqB30C4jnl8ToljSh8uvOwYgg2vgY8z7m6VCBXf6+l8tHV
         hRf/XiiSIzJ/PGko3veFs8YUrrQ0X0xx6jBJRkaIYQ/KQ38+M15Yxkg+xBUERV4o33
         RCkmNBaH5+xJbTezlXra6UZCa2l6AxP3AhOPMQzUzi2LYhnIipNZcjlpQlmwMtdpi4
         c+9MLSFU7Ey/g==
Date:   Wed, 10 Jul 2019 07:36:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Paul Blakey <paulb@mellanox.com>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20190710073656.45a843db@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/akBiVyxF7kLJ5yKG_sTIIe0"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/akBiVyxF7kLJ5yKG_sTIIe0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  6e52fca36c67 ("tc-tests: Add tc action ct tests")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/akBiVyxF7kLJ5yKG_sTIIe0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0lCPgACgkQAVBC80lX
0GzNrggApEX4LTveaFpL/lsLcs8Lxp9DR5q5vXAsGSwfePOmKOv7VA0KIo3NtmJp
YuBPiyEaV29gcHkKd5StK52XQe0hzJdS2raI3vkq2ZQ3hgiKeTJHEC8ZNbmvzFWy
O12mjO5SI3MUdiRFLkJsevTXMOGWONjypfRabJcbrULEScGwh0Mqj41xZznWQsnB
ppEA1GFlSVwjgjmA++mC1FgLyfALsBdrLPQOUGj6vwy81GNt25bZemoq5lUn0JLh
fR+KTTyGza8YS+MuJmJrar7aAzOjuETIIWg/3ynAWVDNqamiAK0KwZyc87c85wrn
PxdDeo+blNlf2jKoEo0l55hZJJ+R3Q==
=AEcI
-----END PGP SIGNATURE-----

--Sig_/akBiVyxF7kLJ5yKG_sTIIe0--
