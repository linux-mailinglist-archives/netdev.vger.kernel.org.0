Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9662FAA8E
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437656AbhARTtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437642AbhARTtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:49:40 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F70C061573;
        Mon, 18 Jan 2021 11:49:00 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DKMmT6t6Dz9sWD;
        Tue, 19 Jan 2021 06:48:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1610999338;
        bh=VPv5gujZJ8bdwkclRzMXbMfaHQf4lYksk1kUObCZnpU=;
        h=Date:From:To:Cc:Subject:From;
        b=kdgRReBlwbSDXZEuNVHJhcLnAWg4JStJLM3NIwFLsFNg3gKmo0QjKj0KLak1REWnK
         SDooXE8OVZ6V+uFbbir3dmIc1bCZFT3jofjA1WZgd+oBO2wR0bSTinVisFCV4JY5mm
         Ja0oD74QsTVUIMk27uLIHCwMsV7Ec5Wt575ITFBDNxwxvM8QN8F4giY14jUpX3/JYU
         8kFHuL8xqb7PoG78xdyk0/DbuABsT9N1NEZ1b/ZE9JBGntxVSpEvW2CqEY6NFLr6MW
         uWGtLAF0fCLvI33YjFgrO+3cs/mIwyaQhX5FUCwDyfmAwIdEZNLYQYUrwg/DuwrpoI
         3VQIM4DPQdn/A==
Date:   Tue, 19 Jan 2021 06:48:56 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Brendan Jackman <jackmanb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210119064856.1901fb96@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/e4FZrHEkJV+2hftrubCBqUc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/e4FZrHEkJV+2hftrubCBqUc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, yesterday's linux-next build (htmldocs)
produced this warning:

Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-st=
ring without end-string.
Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-st=
ring without end-string.
Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-st=
ring without end-string.
Documentation/networking/filter.rst:1053: WARNING: Inline emphasis start-st=
ring without end-string.

Introduced by commit

  91c960b00566 ("bpf: Rename BPF_XADD and prepare to encode other atomics i=
n .imm")

--=20
Cheers,
Stephen Rothwell

--Sig_/e4FZrHEkJV+2hftrubCBqUc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAF5igACgkQAVBC80lX
0GzXWgf6A9u+bxS6wWfmcIydLme4SuUo/HMiBT5ukKFx8IHumVx88dVvL6iAYDwR
bmVGyQbtK8o8/5ZlaMn8PrPHeC5+RmEPKAdm+I7lkG88TpUlhssMywhSYnH2CSww
H9QNyaFpwlVdI6uDVgZGuGN4r2v9zx4ReBaKO4BwaFuOdH41lL+vKrNlBQchMFRb
kvZW+1C27OqSzu4gSPMNX+jHb8otsgIzIuDgBqjuSwE9sDkB/99lONvfBeUtdTPW
AQVO3vIKuLsyxqcKB1MHiXKHDdeNoPtqgnopFOdIiSRcpoCth1ThBq1BOPLfqc95
c6ZbGUaZ7P4K61G3xeY54Nvi+glBbQ==
=91V4
-----END PGP SIGNATURE-----

--Sig_/e4FZrHEkJV+2hftrubCBqUc--
