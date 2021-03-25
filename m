Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D040D34890E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhCYGYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:24:17 -0400
Received: from ozlabs.org ([203.11.71.1]:52359 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhCYGYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 02:24:07 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F5Zn55qxyz9sSC;
        Thu, 25 Mar 2021 17:23:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616653434;
        bh=jN8XQ6Q3EMAXfbzVHs8d+Y/Or+kO6E1qavxQZOtppgQ=;
        h=Date:From:To:Cc:Subject:From;
        b=tkVlKW0nr4YUgJdy6wbALUE/Af174otKsyGI9jg46RtqCFNsqMRqr1gMY2PzV3SYO
         WUbHVSyg8V72VSuNXdCUjTuNuAD0YsEBOS7vUEZnPnrvEq/57rTRGBVOW98Pu0xY3b
         7N2hFqJu98ChRMfrcIYP8b4RwTX/YcG4uTfDD4Zl7GUCKHdW/ZwdlRUDhgg/E7rDrn
         lB2KZFj9/tPwe6g/7GlrimLpdKPbgQpg3RrvpvPyrN7HH1c+mUku8B0iaCJT4EEW5Y
         vknd+HGTsbkI5cUlz4nJrMt9zeeH/mMzr8OGLshhFNZtw1CPL7ZrkWCEtXZM5KXckG
         tELLmNVTOPkTg==
Date:   Thu, 25 Mar 2021 17:23:50 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210325172350.631fe2c0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/S6Jm67LKO+X4Yk./3BtvRJy";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/S6Jm67LKO+X4Yk./3BtvRJy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Sphinx parallel build error:
docutils.utils.SystemMessage: /home/sfr/next/next/Documentation/networking/=
nf_flowtable.rst:176: (SEVERE/4) Unexpected section title.

}
...

Introduced by commit

  143490cde566 ("docs: nf_flowtable: update documentation with enhancements=
")

--=20
Cheers,
Stephen Rothwell

--Sig_/S6Jm67LKO+X4Yk./3BtvRJy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBcLHYACgkQAVBC80lX
0GwYjAf9GQB45oGE4HAQXir4qvU46nkkv60gVwG0QIdGiKEawHEVMKzzvuTz3Rdx
Zj5W2bQ1S9q71hjXxcYnrMgk6e1LDt0CVMNDMb+/Uk8WT9KSy8nHaaZ4voQym6yI
kUAcdirhBLkc60c7/IH2kjJooYpewDbda9yiusBp/RCR8JdaGfg8WXtLJFx681OM
4/f7u7srdqHmjVpojKHEXHmxK70xN64i/Ve+8KGqjM7DLBTPKqXDsPHHFQ1bUlAf
i02nRp5NOg114kPkgoZqAS8jIfdQoUgytzLVxYkNh2JGb73pqjDezWSyjK4FQ/rS
M2ysj3AYjyLg0lRBNg6P9ffrPAl2Mg==
=/7i3
-----END PGP SIGNATURE-----

--Sig_/S6Jm67LKO+X4Yk./3BtvRJy--
