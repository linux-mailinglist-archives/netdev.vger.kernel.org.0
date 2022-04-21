Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC155098DB
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376885AbiDUHKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiDUHKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:10:42 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C92816595;
        Thu, 21 Apr 2022 00:07:54 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KkTBt6Cw8z4x7V;
        Thu, 21 Apr 2022 17:07:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1650524872;
        bh=FFVJbC5IdcEfkW8gho2dj5lOtNJGtVZWhAKi4jyzt0Y=;
        h=Date:From:To:Cc:Subject:From;
        b=tjqf3+5IILss+BhDOeVYVyLgXP+tP4hXmNGGhUwlfkqc99of9VzIMPCQb1wb0tZ7S
         ikctHrp/qMcvYUlouilVzetUzsKopuEYsFup7wqWXyO8Co2+FWQoNnXP5PA2mi86+6
         hb/L8svf9dzIhKFW5JuRr2gbfLAfN/LsMM8wVI3CB7MTgX644y/gU+4fBiis7NO0yf
         S1krm+YrmHDeGQC6MTGY2xnCqJsjl55z3PVn7CzZZatLwEv7Hj1rXgG1/YpwX8Ouqo
         o5cWPPKqi3GnIn9tZi9W3pwzMxo6NPH62v97blTxY6Lp8L8eX6GUK6HvL59h93N7Ux
         hDpERgOFjKo7Q==
Date:   Thu, 21 Apr 2022 17:07:49 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20220421170749.1c0b56db@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gPSSxANV3piWA3_G/Y.5WA4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gPSSxANV3piWA3_G/Y.5WA4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst: WARNIN=
G: document isn't included in any toctree

Introduced by commit

  c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core documentati=
on.")

--=20
Cheers,
Stephen Rothwell

--Sig_/gPSSxANV3piWA3_G/Y.5WA4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJhAsUACgkQAVBC80lX
0Gw+ewf/RiYj/MmHPXdohs+xS/yx68oTUzw5WYDX85Mhau2z8Qd3XW/5R56iue1/
67D5T2vzYyxrTHTAt86/z0/uEzx+nWnVbRzfdovVXCKXd+afL4wM2+U2+iPSkg23
BdbXY4KbrSvlqou7EU5mN75CAuuLtGoKp/jKk7rD06P1irjhOwRHCJnwAiRyiWuO
+dB8YWQMzNF0ZEbI7DjeyaH8/HZpeB9vqJSoJhD+2fk83hO7H3YWC3edtGoZLegt
//8P3T7W7XOTtYvkbAz1aQ4XUEO4j3IUgzxmVcubbYTRM1HwCu9LVQj+Z0NEbibi
lgiHmjP2izn7hwvwyvjCmYIZQZLCwA==
=wjZ9
-----END PGP SIGNATURE-----

--Sig_/gPSSxANV3piWA3_G/Y.5WA4--
