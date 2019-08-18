Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D254D919BD
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 23:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfHRVeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 17:34:01 -0400
Received: from ozlabs.org ([203.11.71.1]:42777 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfHRVeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Aug 2019 17:34:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46BVg90cpHz9sMr;
        Mon, 19 Aug 2019 07:33:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1566164038;
        bh=K9EttbdWwopUqdzRa06R0PNMgOk9RJInzLk0T1xYuzo=;
        h=Date:From:To:Cc:Subject:From;
        b=nu6xbBI4Dvwh4bZRqneGdr8QJxXrpW2tzMeabgjhLq/bx6n6V52yQUvLCUXE2/xjY
         Oeuxs4NFOGvgLGnmgOTv9jWTPbJQBZ++H/XM5J8Fo8NvHKGO0rthY9DSK163GKwLNS
         bKf6gzCHcB6Kben144GIV3vsxronWM4ulorZosUNbIJtPVxT64LRrfqatu1L8yBS3q
         i2B3vsvJ93tJwtswsf/V1egn9ZF+dH8l6yjc3bbQZqT6N1eFcBhr8MaCIL5g5/+WNh
         3gyhT/OEfXcGr4vAAo31DsFv39uK5cVvjFcZMP6oJWO1LiGQynaxtB8TXhC76AZ3hx
         3au42kS6tFPKQ==
Date:   Mon, 19 Aug 2019 07:33:45 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190819073345.0e986dbd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Ex_U3nA3LxGS7PxeoJ3l.cO";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Ex_U3nA3LxGS7PxeoJ3l.cO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  dd2ebf3404c7 ("bnxt_en: Fix handling FRAG_ERR when NVM_INSTALL_UPDATE cmd=
 fails")

Fixes tag

  Fixes: cb4d1d626145 ("bnxt_en: Retry failed NVM_INSTALL_UPDATE with defra=
gmentation flag enabled.")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/Ex_U3nA3LxGS7PxeoJ3l.cO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1ZxDkACgkQAVBC80lX
0GwEOwf/Weh2WInZCRKojBIccB8/RML9EE9Vu1rCbAYpS9p2NnBC0G9ctOoE9130
t3V+imlQ7CsDKJCmL4q/pbJ5sSWlMYjmYDzvybC1Z9q/1XhbTr9VRHKR6AscvxoI
CMPPRVr3WeuokOvgJAGdkMLyJmmZRDAjd+qtzyNGojp4sGUTccCH0Ag96/2GSYE7
hvUlb9Kj69dGp3bhyvXC6ZcyqqxSFYwKeent7VKOsWwQ5EP1d+z9Oa7hfFteVfyu
bdlyAWbF1VTWgKmsHEzUHoFTpIvJffvSCYcJ1wzFUAanExvutYgYBBexHFqKaJp6
4/NLtiPwsM6jDGpeKWeDL8RFUEXW1Q==
=uEfw
-----END PGP SIGNATURE-----

--Sig_/Ex_U3nA3LxGS7PxeoJ3l.cO--
