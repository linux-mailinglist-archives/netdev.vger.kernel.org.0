Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486CF5A0898
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 07:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiHYF7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 01:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbiHYF7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 01:59:44 -0400
Received: from gandalf.ozlabs.org (unknown [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CDA9F779;
        Wed, 24 Aug 2022 22:59:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MCsjz4LPtz4xDn;
        Thu, 25 Aug 2022 15:59:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661407176;
        bh=POsJV3a/Z8MX+zPOO3Iy3ED/REn0HtuttgOVgg5uNoQ=;
        h=Date:From:To:Cc:Subject:From;
        b=LjyApFDXSBkBU7Th4okxow694BJlIEXx0Li/zgR4LLTgyuCgqW9qZ3lZR0cgw2Fig
         2uoBMzfMqWkPTotffrFsB9huvfXGtPOaV2JfZ+ncSGXQeGtRDlmn9QftLi8qWl3XSn
         mxH4rvvR7+gh7zo/4C+oW4pZcPWT6Rfplrn5HXN6cGBVVMj/f/IsPvgKyz8S9/ZkTy
         3oPcSc/qeBpSqffaXhTMrc7c7kId5VAJPmvbcDv8NHmlbU3eMhMPchjnC/QbdOwlw1
         SGqT13pE51bILqNpBvay+je/1GkrletdW6DD+bTDir66GiIhhVlS6cX/QHsWA4fE8O
         GVBxND7NK+ZCw==
Date:   Thu, 25 Aug 2022 15:59:34 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20220825155934.0e983733@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/epF2YdGp_uvJAA_Spic0v1U";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RDNS_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/epF2YdGp_uvJAA_Spic0v1U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  00cd7bf9f9e0 ("netfilter: nf_defrag_ipv6: allow nf_conntrack_frag6_high_t=
hresh increases")

Fixes tag

  Fixes: 8db3d41569bb ("netfilter: nf_defrag_ipv6: use net_generic infra")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 8b0adbe3e38d ("netfilter: nf_defrag_ipv6: use net_generic infra")

--=20
Cheers,
Stephen Rothwell

--Sig_/epF2YdGp_uvJAA_Spic0v1U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMHD8YACgkQAVBC80lX
0Gz34AgAg9pJWLHRzLwJdnIl2hBZp7/K8UVa9GEAamLQHkfV4NMnGconkiZbOsHA
MnvE/7iOW9saibYLbEjRhJHWg2n2w7R82AZ8PmEH7oSlyKn2OFcxpcJDcuYY3624
b5DN4wvEqCf7RsxDDY8yfk9YDFNC5KA52rOdebk1pbKqWsD5k29vFDPT7KMwItcd
0u0vvVGkMEYdBaf4NNnqo8x+0Z6E9/r75baJnCo4vPHgORNcDNvrG+F/lFZSTPB2
TCefu8YlwUpmLe2W+BvhYkH6WvvSNtf5KFPp5zcwFsz/EoKSlZ6FRx1j3xKK6cM0
70EEH4dDonK0XC2rSgmrI710v1zfUg==
=ZmRj
-----END PGP SIGNATURE-----

--Sig_/epF2YdGp_uvJAA_Spic0v1U--
