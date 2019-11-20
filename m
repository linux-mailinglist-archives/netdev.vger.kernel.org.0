Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C1D1036FE
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 10:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfKTJuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 04:50:21 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:34365 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfKTJuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 04:50:20 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47Hybs2hFjz9sPW;
        Wed, 20 Nov 2019 20:50:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574243417;
        bh=jarMthNl+BB7P/L/XYhT8oysem+LhuxZinotaVL4Jmk=;
        h=Date:From:To:Cc:Subject:From;
        b=CnG1+tqGXOuruHWjTs93StwM/sz/9Zkg2fkvxs2ODkKaRCWwFUbuQUugrsCZVExMn
         zSNJG1Olp2ufdDH1lrRG2/R8Jo9n+NmUCXmZ4vuv8ZdkvpAl+QX6Xs+z2IxRpcXvSb
         P1YlX1BY9l4aEw7wbsHeUx7BwSE+po4UM2ZgD6pmoHluGeeomB3u51Gl7pzKxU5Sdl
         yMGReQ7sejBnCj3XnQoIEyQ+qf0HHUHCDWuUQ2bnbcG19UwxRSEer6/raYvGaFnHqU
         9suY/aRniYnUvux6Brs3O3+OVMUIRswCZEQiCJrHnQ5jQA1sI/TMeN2AaBp/XlyAF7
         CI5dVV182xioQ==
Date:   Wed, 20 Nov 2019 20:50:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20191120205009.188c2394@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/V6756Ingn_QCm6UxIl0GuAW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/V6756Ingn_QCm6UxIl0GuAW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

n commit

  d4ffb02dee2f ("net/tls: enable sk_msg redirect to tls socket egress")

Fixes tag

  Fixes: f3de19af0f5b ("Revert \"net/tls: remove unused function tls_sw_sen=
dpage_locked\"")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

Did you mean:

Fixes: f3de19af0f5b ("net/tls: remove unused function tls_sw_sendpage_locke=
d")

--=20
Cheers,
Stephen Rothwell

--Sig_/V6756Ingn_QCm6UxIl0GuAW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3VDFEACgkQAVBC80lX
0GwjrAf8Cr5xgQcepBQx2ubjwqRBw8z7vRH8A13GDkrPMIxNFNCBpBytMSmN+D8y
u1sPM8gm9rRx5nQku01EHXvNl54HveDUF+1nzG+T7W7z0A570CXzSZ29TEdKbBQn
jnxKCwXE2TIab74BXU5gWhOioKNO/qWcKXL2WIrWMbZiV4Nnl3TVaCQ/wvAavyrc
y1UzAC5dngIcVnB8nYIgz+hDeAUzzmlO1Hm7H92l3azrNbY5JP0YMz1AjFXMW0ty
lfLwJ87s8fT5TL4yyAnh5xZV2yH0r+Snjw60I8rEMwNDAXvEdTxbmryuqKbuGmZ2
y2JbAUH50d2kNDh7tWCQwXQWRfzd/w==
=2rr0
-----END PGP SIGNATURE-----

--Sig_/V6756Ingn_QCm6UxIl0GuAW--
