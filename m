Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCF51E99B9
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 19:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgEaR6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 13:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgEaR6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 13:58:03 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C108C061A0E;
        Sun, 31 May 2020 10:58:03 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49ZmHW6SmGz9sSJ;
        Mon,  1 Jun 2020 03:57:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1590947880;
        bh=dXArXWaqSpik6S2cclpveq9exEP8xHQe6YZaTGds8d4=;
        h=Date:From:To:Cc:Subject:From;
        b=M8n7QXupyemQrRtMwv0RsASHsgnxDiWsbRe89Nz0UkoI+VPTpovDomDNKnnMv/nre
         XZLhj6bhUHyv0oJyC1tN9plvhTQ1y/2Hn0IrBz3w5WqUwBhf1G5w6CH3ny2jy64AUr
         bBxOizk2jhUsyFcidn8Z9yPqRvD8k4lndrroLY/Ckrt/phT32b2E3PAioVaEuH767l
         vcpviRVxLwbZ1BsJB2iclM9IUwBNsZHwizwXVIy3x54OuOdnN2HJ76M95150ixYdMo
         OdbswIMBAH3+2MXYJEJTacQZYKRc5zb39snMsSafwqz3Aedy4YzbD9T/uh1s4G9+kE
         ptcbqftN7xHYQ==
Date:   Mon, 1 Jun 2020 03:57:57 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20200601035757.272ee91e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ixG0bGy+jF4kBroPqt5zbCS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ixG0bGy+jF4kBroPqt5zbCS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  02c71b144c81 ("l2tp: do not use inet_hash()/inet_unhash()")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/ixG0bGy+jF4kBroPqt5zbCS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7T8CUACgkQAVBC80lX
0Gwa2Af/YOMn18ZMxkiYZV4T3cEWFBf2uxDXg9ABnsGvQinz4SCbF6bfE2qgsnmG
x9jGcXwqD2+Eq+msw/qdnA+KhcKwyArgsXs28kTKcZSXKcoKG3hZiY0NbzHHLcrf
/qf1DFQwf8tcfdVMnd8YNo5UMktTNQVRt476WpXJ/h4JNf52K9xr4iTYZataaZxz
HtFWL7y8xq0SmqYKRuAjW0lBTzwpiTPI6dKLCTGV065mquhGb+R2ZNhZcxI+nsv9
g5k4kURe0+tQN1pL8hsRTRctSuRgqSFgClAgHqxwXv9mpGC+ZRgTIMw3FEhciqAh
79p4R2XKIHw/ZjfmiWoYmQ7kXgA49A==
=NCg7
-----END PGP SIGNATURE-----

--Sig_/ixG0bGy+jF4kBroPqt5zbCS--
