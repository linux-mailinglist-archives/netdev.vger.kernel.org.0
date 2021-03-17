Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D6933EAE8
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 08:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhCQH4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 03:56:32 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39051 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230506AbhCQH4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 03:56:08 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F0jCB26KZz9sWm;
        Wed, 17 Mar 2021 18:56:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1615967766;
        bh=PmIeaa/WNTkX5nlR7ItkwBd6zESnAME1BiN4vooce7g=;
        h=Date:From:To:Cc:Subject:From;
        b=c3nSradtsTjQlzjhUwmPX5Wcrjn77XQSQwdaFm5IKK8UGJ/9MIJ2NwU/x0WLkffEg
         FRxJKjWV7DKn8TCM6ajaZPZypG22pkCwwg2XeE387XrKiddyHCQfwIrh92Kx5XlKw6
         BkQPXEFy6rsJEstmOfbv2zWeq4yg9alxYpb73vtZcpIq9DXYPs4XiBteZKj74UG9mu
         CkZ9LnmDyhu9EYwuD3QNq1DNmnaA1P0F4YaUUjEhokcNhmPSCi2sPgIoSA0PmVeeJ6
         /QpaaidglmhGYeL5IasQnOq7Yc5zetUk/0uhCmVb89mIn+Yi5jOT6MYsNpF5upFjlG
         csBNIvTi5kZfg==
Date:   Wed, 17 Mar 2021 18:56:05 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Chen Yu <yu.c.chen@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210317185605.3f9c70cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hy02d1WUuMg=_M+_Mhruz6x";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hy02d1WUuMg=_M+_Mhruz6x
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (sparc64
defconfig) produced this warning:

drivers/net/ethernet/intel/e1000e/netdev.c:6926:12: warning: 'e1000e_pm_pre=
pare' defined but not used [-Wunused-function]
 static int e1000e_pm_prepare(struct device *dev)
            ^~~~~~~~~~~~~~~~~

Introduced by commit

  ccf8b940e5fd ("e1000e: Leverage direct_complete to speed up s2ram")

CONFIG_PM_SLEEP is not set for this build.

--=20
Cheers,
Stephen Rothwell

--Sig_/hy02d1WUuMg=_M+_Mhruz6x
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBRthUACgkQAVBC80lX
0Gx5Zwf8DlACa0xqip6DHHefI3ggZtk+CEmd2PwORaoHgBaGJZ/DlK6QmXs6w0tz
wJIoNsrlMyhaqZlygozW3v0v1vZt7J8YkAiZFv4BaHGwigs7ohGS+H9EqBqUNwRu
HfkFnpw0vD/3vHFOdOcIWZZ4Y/dbEH99iO7XdQLTf17n5+i3YdIhGdY18dyPBdwi
Kx5k6etFozJZNEbZvBLp5wvW8qmJdTqABx/uQzXv+XqKcxpWcU3P4g/fqI6SE1Xm
L9cMzcDlIKYnX9kmO1I9aFkuXKQqdR/wXe6o+WBEAh1Q3/9+LhBsTcAWysL2G3EM
CjXvHKTJT+RIiOpk+XnfBU6FFGsWIQ==
=b72g
-----END PGP SIGNATURE-----

--Sig_/hy02d1WUuMg=_M+_Mhruz6x--
