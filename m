Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65142216704
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgGGHG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:06:56 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:48413 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbgGGHG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 03:06:56 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B1D5B06dRz9sDX;
        Tue,  7 Jul 2020 17:06:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594105614;
        bh=iYKuxNhEWlKwLkkOoPaKgEVuqVYwuJyOKFAZbOxF/C4=;
        h=Date:From:To:Cc:Subject:From;
        b=rw1tNmqRjzrucKun1MjmoC3xBvtlpjKdDzYxe2egUyoA7yjOM9Ii8vY9wfKIKwfj5
         RHnDzxV1ZKN/rtheh+4Gic90N6F8NCM6Z1bjTHn994o9Bx23zMVwXnVTcUP6AWOho6
         qy4lgfpfrG7oSUx/x/p2cWlkIwGAxA0uZBBF/DNMAzsNg0OMD6rpWA7BFwlhVf+h3g
         wm82hsJOHRdbQrVxxTh+Ugktqtwtrvx8DA/P6ggdrVLSdE51QpyUvscuM509ONP13h
         jLOHUGYNGqdTZvaDDcM77k9YVAqKF9mg0rti1hhqjuasUiZFLoI4pDeu1DQWWB7Sjx
         d1MMuxmXwj2lA==
Date:   Tue, 7 Jul 2020 17:06:50 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20200707170650.692c98f0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/cHvn5c/+F1OX0ls62Lx_3ff";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/cHvn5c/+F1OX0ls62Lx_3ff
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (sparc64
defconfig) produced this warning:

drivers/net/ethernet/sun/niu.c:9903:12: warning: 'niu_resume' defined but n=
ot used [-Wunused-function]
 static int niu_resume(struct device *dev_d)
            ^~~~~~~~~~
drivers/net/ethernet/sun/niu.c:9876:12: warning: 'niu_suspend' defined but =
not used [-Wunused-function]
 static int niu_suspend(struct device *dev_d)
            ^~~~~~~~~~~

Introduced by commit

  b0db0cc2f695 ("sun/niu: use generic power management")

--=20
Cheers,
Stephen Rothwell

--Sig_/cHvn5c/+F1OX0ls62Lx_3ff
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8EHwoACgkQAVBC80lX
0Gz9Wgf7B8c0Hj9I+p6mdiqGGQgI6Eb8C/Ue9BRR6xslG0m0POJfZhJBess21NwF
lcWdQVRHo+GxC/jgvpQKlKMO1D7dtfXc3EjF9LBjO00vziQamf3Ywx3tPy+jZy6N
/BhkEvlorjI4teIJT0teKxX8D+D1HDw6vyPOfwzYde4BWE77BV7nxTvyNXhVgLRE
O51ewAvE9HpwGhxJvNbPj6Pq9BI6/kVbjn9E6GoJUSwF3gnMXK3EKIrbGI38doYa
pLfEOQNGYyEWuZm8Ml3H91ULsg0b0IaGTlaOpIrX9wHYsv16O1pKJ/qL892OfI2J
kqyna/vLlZdv5xgkQ5HNWusotZFuKw==
=L/Uf
-----END PGP SIGNATURE-----

--Sig_/cHvn5c/+F1OX0ls62Lx_3ff--
