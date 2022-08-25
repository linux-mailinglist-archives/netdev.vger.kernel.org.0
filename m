Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CC45A087F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 07:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbiHYFlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 01:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiHYFlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 01:41:16 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C776B8DE;
        Wed, 24 Aug 2022 22:41:14 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MCsJj0S4qz4x1G;
        Thu, 25 Aug 2022 15:41:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661406069;
        bh=VhaXv+qP3LKbKQIlGSuNXdJzk07OtMabE72WJEn3634=;
        h=Date:From:To:Cc:Subject:From;
        b=MeAouKlV+cEJhc8s0pdK84CoYlF3o9EHP7RJ5CEYwlX1Od8MV+ScgqkYH8Dlp5Qxl
         4zPduNoJcPjIVdmFgGFqXueDedKHPjxsatXoyBgroeQYQZOhScoqF5uxEoJ/loxxDu
         CCNtbpzdJUPXJTdT7aOhV7cw055qUTzr1YCtMabcE1hs57SmqVx/kF6nmcuOSxCura
         McExJOXdZEujA2zBWX2yYclH7grjZjk496i1h7M7OwHWTubfii+ZdpTBkCLgmHGXr5
         s2GnvpGWFvaHMEyVQedvqHKgt7UieFKrb+8/r7uyAog9ImVzaapXPnFkn5bM8cgZo3
         GRH3AfQx6VyXw==
Date:   Thu, 25 Aug 2022 15:41:05 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Menglong Dong <imagedong@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20220825154105.534d78ab@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ozGHw5W.bsKRz4C.I0j2z=0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ozGHw5W.bsKRz4C.I0j2z=0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/kapi:26: net/core/skbuff.c:780: WARNING: Error in =
declarator or parameters
Invalid C declaration: Expecting "(" in parameters. [error at 19]
  void __fix_address kfree_skb_reason (struct sk_buff *skb, enum skb_drop_r=
eason reason)
  -------------------^

Introduced by commit

  c205cc7534a9 ("net: skb: prevent the split of kfree_skb_reason() by gcc")

--=20
Cheers,
Stephen Rothwell

--Sig_/ozGHw5W.bsKRz4C.I0j2z=0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMHC3EACgkQAVBC80lX
0Gwdmwf/SIWYW2/JkkMIJKNTpkMIVx8Sl8LvCasK6nh4fPJLNIBlToUeJjW1aZyd
jE946vSy2WEjOo0OQ4NZ0E8N6rMKO0dVBSVYk0xSCZ1rFTgXSqIx7U8aYRC3/hwt
vsCCt4RoPiR/jjaSiY0ibU+qejzhoSD7CXcftKYv8jAAZAr2tFdLPb4XKHaVkHE7
e1yOgM0edLj5vxFhsBdNjRoFuRazEx3NX5GZPtX4wZjoC5I0uosrMpxqtIfxbN4u
YAUMQfTaFsBELNzVQY+FA9pAghvByJuHoM3w5S2eVkaeKd7vitG9KI7/cM0axQ/Z
IlL9NlAO8glUK81Y9P/3bm/FssIXoQ==
=hkAX
-----END PGP SIGNATURE-----

--Sig_/ozGHw5W.bsKRz4C.I0j2z=0--
