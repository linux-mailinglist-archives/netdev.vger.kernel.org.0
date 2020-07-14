Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30BA21E596
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 04:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgGNCWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 22:22:50 -0400
Received: from ozlabs.org ([203.11.71.1]:53749 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGNCWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 22:22:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B5PS76tcBz9sQt;
        Tue, 14 Jul 2020 12:22:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594693368;
        bh=AFPB0ijJm1Rz6TMaKXC13/pjsN5PDvcIKjOmLwZ2p5Y=;
        h=Date:From:To:Cc:Subject:From;
        b=Y8df6wtMRWJL9PixGxmbRSY6dEJHG3OO/VXCcnn1Q7aa4H61uZcBPjcF8VMNYVkZk
         baTUjACcwX9nqs2ROB2Um0gt+o7ckKQpStre6sHItbNg2QSTKo+t8e5WlMx6XhHWZx
         fuuZufZdEC5X9eiPC15AJtacuwbmJ3p+MRejyE8Tomg3Mqt0R2+gk+xnA+UqoZXNMb
         RV/H4E/4OBowooPFJ+QAf7nm8I7pt/HTHaowGsZXXa+W5ymE891dPYFfGQw3iwFlbM
         3jE9F5Ogmnr9Lb4PGyLT0CYsuNi2sUbRZqwfz0Bt5CG2B+U9Vdyz2IIPnjas2DQSPw
         MIi3OxxT6qCRA==
Date:   Tue, 14 Jul 2020 12:22:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20200714122247.797cf01e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/g8e.JBOuf0Uvu.lVYygqL3j";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/g8e.JBOuf0Uvu.lVYygqL3j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

tmp/ccsqpVCY.s: Assembler messages:
tmp/ccsqpVCY.s:78: Error: unrecognized symbol type ""
tmp/ccsqpVCY.s:91: Error: unrecognized symbol type ""

I don't know what has caused this (I guess maybe the resolve_btfids
branch).

I have used the bpf-next tree from next-20200713 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/g8e.JBOuf0Uvu.lVYygqL3j
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8NFvcACgkQAVBC80lX
0Gw1xAf9GiD9sP2Wu+cYyfBMKI2rsjZKp4jedskQTkMXxtjKluceG7PjMwY/IxCP
onNnvBqE/6xpA4j2XGKC8E4LV/l2gW9ErTk/o6AOdkF1kWiOJ9c4r0th5DhQ+WiY
mvUe/aTUVPmN90PB/sjD2tzpRJWEXYa9CQfq0vQJ+lUX3ceaRe648ExCnRF8OaJ5
wtXKbgFhqGsae3v2Dh9xzjBYQIAV+KpfE3+9KWTaYeeWJnhXePP+zsXwqsinFOoL
J6baAwO6EhAdwnSksnPFGaCmRjCQE9i8y+3SaDH08X5804Mk9wqf5HnOeg6WjUga
2B8bJLemSRUO+kqlo4vU051+XWNr/w==
=sWzY
-----END PGP SIGNATURE-----

--Sig_/g8e.JBOuf0Uvu.lVYygqL3j--
