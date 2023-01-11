Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2487566654A
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 22:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjAKVHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 16:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjAKVHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 16:07:40 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AA61158;
        Wed, 11 Jan 2023 13:07:38 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NsgHS5V5zz4xFv;
        Thu, 12 Jan 2023 08:07:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1673471252;
        bh=PJrBmyilTMqQChNEnVYG45YXM1V5lE3Py1zwloceUko=;
        h=Date:From:To:Cc:Subject:From;
        b=dhuoSscQ5bbYM9H0XygX0opqIL4yb472AVQAxjfVGGIfCjato0t5H7+2a10dz90Cr
         1T+44qyuFO6fXT/VUwMJv7VBAz2wG0S+c6TeHrMzEyWK8FdUz2MrAJRpzlFx/o3ifC
         sGRurQApven4xTEhFgn02+4ZKVcN6oNg1Ooe1tg4yXmbZ9ZGoBKOjaRmjSnZXxAMzs
         vMTfDSl3emDOpfbx2PfqIu3GkR5IgpBBMCX0xzVR3z+m8ClgVEDUv8F5AXKZQM51Pb
         xaAdCrmsE9sJ8BnoaLuYESsEdCcf5359pcnrbyDIlDbJTyubD2HTMEuJvUAUfuBvjo
         Mk/1JHFZmWfSA==
Date:   Thu, 12 Jan 2023 08:07:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20230112080731.16e8e480@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/O8lPMCDQe48FbdGAZ/d_1ZJ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/O8lPMCDQe48FbdGAZ/d_1ZJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  17b3222e9437 ("net/mlx5: DR, Fix 'stack frame size exceeds limit' error i=
n dr_rule")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/O8lPMCDQe48FbdGAZ/d_1ZJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmO/JRMACgkQAVBC80lX
0Gz9+Af+Nud3m1kLn5xuz/g0ihnThcizieDOz0ZSEUXGVYfzcI6hkj3qlGsyql3B
t4Oj1c5iqoYvxCJnV0dIMUMX8KuGSC0bUl2wDZySga0Oi8nhZtWgeNIGyP+QKEQ/
ImXa85iLswgA0SkN5jOZmf6R5sxVEfPjishGViObe1zF8yNXsIFRgPic/o77XXsV
4iRkLss7PdE19HVn4j0058NadBRxDJYC1YAXwWR8q70EHJcvparuM7LDN4raXno9
2VT6c51QbgcAudrGYD+rbkp97G1/OYh8Fllmczx3q2YbCdx/deLrCtq/o2ikjUo7
IU5ZlwvByHgdYDFw1i+jwmcjYtBU8A==
=yYrL
-----END PGP SIGNATURE-----

--Sig_/O8lPMCDQe48FbdGAZ/d_1ZJ--
