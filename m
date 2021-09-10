Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C914F406C7C
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhIJMwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 08:52:06 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:53047 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233095AbhIJMwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 08:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1631278250;
        bh=cNJI1AfIunOpdNTOqDtt4KGuYnNQfkP2HgkQo2DrdbA=;
        h=Date:From:To:Cc:Subject:From;
        b=iSTg0n7cW1JyMXpZ3JMOymiKOJa570HpOKz/9IWaieOZFD/tLfpYUahf8mziDn15E
         TvDIYZZB+1WDh5f0W6z8UQupoXsRZJyfEy0ilF8hDMSefkmJtchTQCdR5tmB+HBfAr
         FzUd9UgzuJs6PnXVq0xnKDIhnLLTCHGmfIBYA4CXlkAe3Gp6ADLHVr4s4225Hb1zBi
         r2NvlGnlYcolG5o00WfFexPPsmxfuEpJx+fwG9LlbK3RPxWmXMjb2wsS7QeMRtGsf5
         FfOhzyVMls5y/NRGf8VL+STDOSO2zu3RrNppNtdRqCZrsOejowucSVlDvfU02kK7Df
         VScmV8MYUuohQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4H5bMZ1YxCz9ssP;
        Fri, 10 Sep 2021 22:50:49 +1000 (AEST)
Date:   Fri, 10 Sep 2021 22:50:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Ariel Elior <aelior@marvell.com>, Shai Malin <smalin@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210910225047.58659762@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EHzCZo/TkGneLv9Uj2rHRfR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EHzCZo/TkGneLv9Uj2rHRfR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  20e100f52730 ("qed: Handle management FW error")

Fixes tag

  Fixes: tag 5e7ba042fd05 ("qed: Fix reading stale configuration informatio=
n")

has these problem(s):

  - No SHA1 recognised

In the future, just use:

  git log -1 --format=3D'Fixes: %h ("%s")' <commit>

--=20
Cheers,
Stephen Rothwell

--Sig_/EHzCZo/TkGneLv9Uj2rHRfR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmE7VKcACgkQAVBC80lX
0GwxnAf+LJgiZOKGiWwG8rt7Xmf77VZyEmhrlFN6fBUa/zn+9vFByuSDTAYFjyE/
+TW5/5dakB+Efi1gxpvNVQlpLCSSKZqHUtlm8APsLvgVZvTWZGAaqtnA59C4yOaW
+5kG5rME1rHJ2HtkPWRdjAYPb5STBkXaRDExFzTqzaeXFJhUszvfnNRzLSkNS8g2
o8WeJuOrEufEAqIeCqUwKIIaalxwSNtaa06TGpa9jhL8yE61z5SotAgDLFv3EV66
gnwpEr4ky3WZehyGndwtsduQhFTIxlgOwtyeC5RdBYS9w+IzmJElSSF7GTOS7dsD
qHBVS6buBRop+y8prvnuyc0v75kTHg==
=eDXV
-----END PGP SIGNATURE-----

--Sig_/EHzCZo/TkGneLv9Uj2rHRfR--
