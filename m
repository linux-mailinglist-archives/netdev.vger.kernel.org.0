Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8984DD003
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 22:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiCQVQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 17:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiCQVQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 17:16:10 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5A3247C26;
        Thu, 17 Mar 2022 14:14:52 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KKKfK64NNz4xw7;
        Fri, 18 Mar 2022 08:14:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647551691;
        bh=MZK+qMZWlkhk6Pszi8zLGu3p8NpkMEGMJLuYRUBSOjU=;
        h=Date:From:To:Cc:Subject:From;
        b=PEJY4CXHG93LvI4P9n1PN3z5LX5uf9zb548RypM2C7IEwXrjMCSd788YSD/W0sEbH
         O9gPMAINYA/68YCT7eMReI84ftvpgSky4g5LLtXZG3122ZDZfrkr7Fzq3yZiwPsyTb
         I77NvCQP8TBopYWpNIvrz3fmj03OC49Xju40vhiPTBnTiTS55JAKxww4853Z98142R
         fNfkO5j9E7TT1mg8yBOQSkGFOnAtmdMNlGYcnAvM4N2OUFEbaqRMPxSSaePReWcdLO
         V2aBd6J+OD7FjGj5Q5ZwS5B1uWrY5Frcpoy2WLDpVbvyIeaQNgRzb34sGdS7G2c63c
         CsQgaUiuH8nXw==
Date:   Fri, 18 Mar 2022 08:14:48 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Kaixi Fan <fankaixi.li@bytedance.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the bpf-next tree
Message-ID: <20220318081448.586adc42@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SM1ktpCV0NyCJ=79+77cuM7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/SM1ktpCV0NyCJ=79+77cuM7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  a50cbac6d81a ("selftests/bpf: Fix tunnel remote IP comments")

Fixes tag

  Fixes: 933a741e ("selftests/bpf: bpf tunnel test.")

has these problem(s):

  - SHA1 should be at least 12 digits long
    This can be fixed for the future by setting core.abbrev to 12 (or
    more) or (for git v2.11 or later) just making sure it is not set
    (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/SM1ktpCV0NyCJ=79+77cuM7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIzpMgACgkQAVBC80lX
0Gz/4wf+On4vnxj/D2y0yuq4X2GXj7qJSK1hYLct1XPJV8RZnbMuUuN3e98EqcOv
tGZmE1Ndc3NncRQ/zC6iRVyLZZXibcRdLl5iwyP6xPKtkurts8iaMAVcPdz8AASW
Vgk+OVMwcPxparEl1DDckmf1OE8HdYFVotYuXVirvFsF6R370IuqZN1DwmG5nNQM
x8ZgsjAUcvI30gPVy+vTlBWShP2HURFbS3yV56PR3lavYvd4Q7LADO9y2s7JCl4S
t8FNLrKHN96JuTnrG4orprlgSPONGS+QbFGw55+8txI/A6kWlPgb1hyF1e2f9P4Q
xF+FVgKcluJb8GhiVaLkRKBcwST8Rw==
=1Q2P
-----END PGP SIGNATURE-----

--Sig_/SM1ktpCV0NyCJ=79+77cuM7--
