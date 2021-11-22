Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B041E459659
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 22:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbhKVVEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 16:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbhKVVED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 16:04:03 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B9DC061574;
        Mon, 22 Nov 2021 13:00:56 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HyfnG5pMnz4xZ5;
        Tue, 23 Nov 2021 08:00:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1637614851;
        bh=xZKJu3ktLCt1VSx+EbM+nSgdcGPvWa4Cc1d27ttwLnc=;
        h=Date:From:To:Cc:Subject:From;
        b=bP4ppg6CfF/jyHCERlPZ+rRep99CQfFyEhUGoDF4JPhN+dnI8QJ3SfuAiFP+dZuqG
         DqTsBxx+JSmhDsmB+lBlQ63X6EFEDfA8zhQtRLUl8fohR8X3na045qPoU5r9grO2dK
         KreS64TQ5bWpya9WUWV5CWSH0AypRKIFO3b0hpiyUNlr3wSwdUqSHpzqXhW141HNQA
         ZBYNqHe09eEtrdothZL788MrrldnxcnXDA5yNLIvL5ythyYkWmb5w82u9LNGp0KMI6
         Oy8I21jl+zH6nkNigV+vZtVnA9JChrvYCoBRWggvrFBnJy0N9kQ+4hBvdyeoZuEkkj
         9UhneM7Z8TWgg==
Date:   Tue, 23 Nov 2021 08:00:46 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Wen Gu <guwen@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20211123080046.5ed4795e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RT9UBgFGi/.caKc4mbwoTBp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/RT9UBgFGi/.caKc4mbwoTBp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  7a61432dc813 ("net/smc: Avoid warning of possible recursive locking")

Fixes tag

  Fixes: 2153bd1e3d3d ("Transfer remaining wait queue entries during fallba=
ck")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/RT9UBgFGi/.caKc4mbwoTBp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGcBP4ACgkQAVBC80lX
0Gw4igf7BdrFdgc4b/b5u9PDLDkL/TCQFQVZe8KrWgEPt+DJg5rZ/VzWwLZZsKnx
96hTQ1ukykVn2uyAZbOEWL1qKXsETGFHkiwWH+KfiHIMLIjZR+gGa8UdVWJMcQh0
qix0/zjEJFUzuyK9mUTwacBz7ZQ8AG4/omoR6gl6n3SnyjwPmkndGFXc3ruTWXp7
7hll/+phHUrKULYwiQMAeVeQ1XEgXgXWzjQS4awRXXGpPnGoC2V+x6L+fm61jHRj
MFPApjOs37gGitKf3dso0D3IWtsxeVTta4yMqvY4ERQf7MugG3rZUFA/ULQC/GDJ
YOs8+Y+XLpNKYACPGf9SgyMBbVoC4A==
=pZ5N
-----END PGP SIGNATURE-----

--Sig_/RT9UBgFGi/.caKc4mbwoTBp--
