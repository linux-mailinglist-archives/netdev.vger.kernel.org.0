Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5E9623589
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiKIVM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKIVM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:12:58 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E32231201;
        Wed,  9 Nov 2022 13:12:57 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N6yNj5PFxz4xTt;
        Thu, 10 Nov 2022 08:12:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668028374;
        bh=Ped2l6nkk69riuO/N3Bu3vWXjzv55NXbXWkolhgbltY=;
        h=Date:From:To:Cc:Subject:From;
        b=QGdgNYRMIlEdu8QI3htSo2gPUMu1VVOdftp7qkIP5YQKGa4SGCurvKlN/mcfduxnJ
         5x+JinIMvw26wOuYwNEh7GX1rwoJGwyrQDV3xg+hjmjMzNswAOMnHwoastb/2rcBbD
         8IhF4NiM2rvS6YD1lFPZOC9T1e1m5TK0IdojsJlsd+azoRQQcUp06IEbvtQH+wjmm8
         eOJ2USvQNHPa7aZI6T1xlABmmHsi+0zjNHVkJcOXFvgSO+qfI9c3IMsU4yLwl9qf75
         QzKIX9wy+tg3SrPwsNeBZSapsVw46jxpScsZgw0DI7RbirNDv4/NallbQRES+94RJb
         vpSVaew4CwrjA==
Date:   Thu, 10 Nov 2022 04:33:04 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20221110043304.53b904dd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/L+K5N6u7SmpX9TjMg+s1BT3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/L+K5N6u7SmpX9TjMg+s1BT3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  1fc4fa2ac93d ("rxrpc: Fix congestion management")

is missing a Signed-off-by from its author and committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/L+K5N6u7SmpX9TjMg+s1BT3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNr5FAACgkQAVBC80lX
0Gym+Af9Fruiv45KdVx3JzYlStHVNB/fPS9VI53sfQS43rr1lTeA9GtxzsZmdKU1
lTesfiu5aW7NATEXnoz3hrB7BepRkZ+xL+8i8773Rk+qR0sJDODvwZiT6DUSwU14
am+BPbvz85Chgml3SnINKRo3i9wAAz4dBaiAjoOkDLd2gyS7R+nGXOT2o+Uc4whP
IwdK7Fumf1e4Jf4hXMMoAmuyBfnyCkWF4kMNOlKsK1K6ic6A/Zl1VxVZcycydGq/
F+ceD2aJlY3T7TJm4oSJ3+NDlQ8Peg9rLM8YgRyq6x4h497lPFauTlMU+ghkuqQK
eWnJlEeMWOc4fPKjIlxCr+HZVL2huA==
=ibNH
-----END PGP SIGNATURE-----

--Sig_/L+K5N6u7SmpX9TjMg+s1BT3--
