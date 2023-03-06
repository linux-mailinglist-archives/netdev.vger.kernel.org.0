Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011016AD0AA
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCFVhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjCFVhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:37:11 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E26D31E3E;
        Mon,  6 Mar 2023 13:37:09 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PVsNd17wqz4x80;
        Tue,  7 Mar 2023 08:37:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1678138625;
        bh=r3AVatlEtKngOEy1MVVQV8rLTGTVB8fMDdpZuiNjlYQ=;
        h=Date:From:To:Cc:Subject:From;
        b=b05xY+IPLLR40P1OFpUFe3icgzS4DbcVX2fcuH1ObJtRJaVQL4aarJSlSAOE4PY3f
         rlPhLKg5LiAApyRUQb9OnRjwUzTGVrlYlsLDZHmNVLGMgQSG+QtOTDVIpNCrpYwFsU
         9c6TIfEY2IwLxNTjVyeH2tEyvYhAnd0zuFjIX2EJIp5+6x1Q2Ca1hbHdpeR6B/d4S6
         AuSpMGinQ0SePBfX2jrTtk6/Citn1hc4dljCae9C1R+Efwyvw3XZ6dr44bK5S6Thb9
         0fjbpAgiYzK/BY8vuen7+BBgfQAykoPFNj9q3jtR/RPz5aXZMlBHxDHy4/rvSkp/z/
         S2RqLH9eOqMLQ==
Date:   Tue, 7 Mar 2023 08:37:03 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20230307083703.558634a9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qCBZSmhRet+g2C77uRykZCq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qCBZSmhRet+g2C77uRykZCq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  58aac3a2ef41 ("net: phy: smsc: fix link up detection in forced irq mode")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/qCBZSmhRet+g2C77uRykZCq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQGXP8ACgkQAVBC80lX
0GzoMggAlKW3DK3RuOD9zynSgqf9RwJdKJ+GO+qLv1Zx7y++FM2P5iBE4b+1hXSh
p3M4UeGnCrbWlkmSYFH/0cy9eAX3slxBihxer/DjTIFeRPSzF2SI4VHA4/QQ5PC8
gFVuq3/NdepGPmphY1/zrM7IIi7D0UROLphJEGSFSCutLyW+D61eQ+8qwst7FzMC
wF2L0yoaB1L5UdgHrsu4G5x5ptB2XzWmP+z5nbLMjBjFqkdtZvo52jh1RXqLiXeb
SsLFlayOW5tF1kzIKmTtrpfVcjOnYo/1FVidT+/91ZFk2tuTy8TM7J7NYf52sm/h
y9dEOfAXwLcLCdk8g6PGp4BkLb9xmg==
=55N4
-----END PGP SIGNATURE-----

--Sig_/qCBZSmhRet+g2C77uRykZCq--
