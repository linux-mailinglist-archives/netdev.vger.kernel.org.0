Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2D183AFE
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfHFVWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:22:22 -0400
Received: from ozlabs.org ([203.11.71.1]:56651 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfHFVWW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 17:22:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4636zG5mJYz9s7T;
        Wed,  7 Aug 2019 07:22:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565126539;
        bh=DB/4gsWOGUgMNekDqwCl6PQ6ppOYW96vq43QS71YHhs=;
        h=Date:From:To:Cc:Subject:From;
        b=HpgD6rgN9y1GoX/yQZvXQVcfeJz+gI/mosOhkDeZGpeC+pumIiHfvStdPSCke9WAH
         oPEmeMgog4uES+gbZSFCho3/WobJpDn6VpRYKkvyWveoGtmqVW03qY3ylOjCk1Bwq1
         gEzmW8N2FoUpMroAHZO0mQXB/b9vMxO8FMfFT4dcUOmrYUqHTBt25HdCB8fhFZWO6z
         Pp50ueV32IDHd1qdoAr8ScREFcUPi9hA4gpEMlYlAIimY8Kg3DIF+qTOA4lp5+kTyO
         OE1tF2W6zR9zwFT8VTOQsb0jUo862hp8xRvsOMXKI/O1LrtdZ5RKv8kYAcUanxecyb
         yDmYPTKZm8lRA==
Date:   Wed, 7 Aug 2019 07:22:10 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190807072210.13e99a2f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QNc8HX=70e2s/5NP8IcVioD";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QNc8HX=70e2s/5NP8IcVioD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  b35475c5491a ("net sched: update vlan action for batched events operation=
s")

Fixes tag

  Fixes: c7e2b9689 ("sched: introduce vlan action")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/QNc8HX=70e2s/5NP8IcVioD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1J74IACgkQAVBC80lX
0GxG4Af+IXipOJ9IyBpzknqRwotg0RMOYW3kVDHeU5JMf17NahoITJmGzY8NsYwy
2IIrHkKV85Q0TO48absLuK1vCyyrerdKDUpmuK053YFU1RQn5jqBbEdZoHHhfSEU
UxLWpViMX4e5K5FZQ+TXW/jlYSqqKd80+TbRjcKmlFC80XDNXNnhOyN/cIPenBIN
/mBxObLZZc4CCBiSRnWZDL/g0jFuKqvUulm7OGrHsMbOJQNPmZWhaNBh04qSnOV5
AquDjNXGdNjltF6rSjcfjDCVkVjBp3lr9luRh5Ub6+6bkb1Y156Sjvd8XyD/rpnF
AmqJdfz56NR0TM1/c8gMg+x05wKcWA==
=2dz7
-----END PGP SIGNATURE-----

--Sig_/QNc8HX=70e2s/5NP8IcVioD--
