Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E814B3F41CE
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 23:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhHVVzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 17:55:20 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40191 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231882AbhHVVzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 17:55:19 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gt8Kl2rwbz9sT6;
        Mon, 23 Aug 2021 07:54:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629669275;
        bh=Xt3MVbNw06Px3ai7Z2p/o2LQA+PZ9SjxUJLBKKvexBE=;
        h=Date:From:To:Cc:Subject:From;
        b=skgYTp+7mElxGJRO9pYIljFwjKBRXUY1+806BE3Y5xBBe7d2a0+5v6T4tAfs8fQ9s
         HdYVaHfgaZl2VZuqz5s0FXTmeXSzmkuv5as5V1EwVpVbIQqZ2cq1aTeRUCqmtotfKx
         vtj7TfUFJPzjqkPOMd4hmuFqikOw5miIcgBzRI6hNRMO3FM9D4aUN9Ghshg2n7GDPD
         Wq7cJzjyBzKiz11ULZ6E/q9e8f4QAY/fxxBqieFKkPZaZYziI1yb2HLdYnmo35IOYG
         Gw+nz4w+SzqfhfNKmRYvntddxiX+LFr1/rJw8MWRzzhWUAJ08GZzQyxrG57fi7BEak
         9uS8RkLDaOF1w==
Date:   Mon, 23 Aug 2021 07:54:32 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210823075432.2069fb0b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/A2AuWcSbGhU6bEisIon/Wb7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/A2AuWcSbGhU6bEisIon/Wb7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  9cf448c200ba ("ip6_gre: add validation for csum_start")

Fixes tag

  Fixes: Fixes: b05229f44228 ("gre6: Cleanup GREv6 transmit path, call comm=
on

has these problem(s):

  - Extra word "Fixes:"

Also, please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/A2AuWcSbGhU6bEisIon/Wb7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEix5gACgkQAVBC80lX
0Gxa/gf/TjjV18hI8ndKpcp51DhiSBKDX/FMkSr5auo2rO11Z9EDQ0w30aO5OCsQ
3zlnqy+LFtPvGwTTQsLGVAAc/VKONe3FQYmE8l9Oy5sLCpPDiN6o2HJ8pqkMxLXC
p5pdGFJIr7zBKF+E8S7nviDYbuTQdxU2zhfmuqKnLki0Z6YxNwBb1WWT/4WNbT6E
rqyycirn1GkrwdqUn2DaCUD08L0rlmoAQZjbl8Tt1ND559X+9izXmeJrU7s4LAwu
7IHyXOemdrPxml4FqXWG/GyL8kvF0hHWqAJhOe3xIEowfkfcea9cQH7NYZ+OuHyj
p5di29LZOB44QECenK36pIihXL5TMA==
=mRMY
-----END PGP SIGNATURE-----

--Sig_/A2AuWcSbGhU6bEisIon/Wb7--
