Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EB949D3EB
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiAZU5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiAZU5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:57:06 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B725C06161C;
        Wed, 26 Jan 2022 12:57:06 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Jkbcw0LRfz4xmx;
        Thu, 27 Jan 2022 07:57:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1643230625;
        bh=cjuTzKhDkCsuuyLW9b96xzPl6QhdHMRo44uq08vCYms=;
        h=Date:From:To:Cc:Subject:From;
        b=EIgIIWetf8yFVGQHZc+zkqlkKeY6ufzzGm4FO39lFqtr292YNV696BmrRJb5mAOjV
         wiH/mcWFZxlxjSjtcIXffHrC6xIzTCbVP8W7bvsPLh/ciXrOPBORmGIhCPNczqZ15c
         fJFUIjG/U5i9hw5lP8HDt59GKiqC5Q62b2szkr74nU/G6akJZVWzt6A3h8lCcD3MOO
         TGwIlnpzbgJkjblkjoZtAccs/nx3uh/WqcJgQ/NP5xy8JLEpAtSUlqvC+UfewhoBTr
         6cjq8qaKPZDiM7bqKKHgXc0JZQ1tczD95+shzMGhfcQRUEnWj7MaxnNn5mIXWPRrGs
         U16mqkg80ntUw==
Date:   Thu, 27 Jan 2022 07:57:02 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commits in the net-next tree
Message-ID: <20220127075702.1b0b73c2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ho3yJJm664Ov7YLS+Zw88gM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ho3yJJm664Ov7YLS+Zw88gM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  04a0683f7db4 ("net: stmmac: convert to phylink_generic_validate()")
  f4c296c90976 ("net: stmmac: remove phylink_config.pcs_poll usage")
  d194923d51c9 ("net: stmmac: fill in supported_interfaces")
  92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
  be6ec5b70266 ("net: xpcs: add support for retrieving supported interface =
modes")

are missing a Signed-off-by from their author.

--=20
Cheers,
Stephen Rothwell

--Sig_/ho3yJJm664Ov7YLS+Zw88gM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHxtZ4ACgkQAVBC80lX
0Gw4sAf9FhJRCPchnhM+UlW0VC/k89qoLcm6DAiZolMvGa2RVHkBIbKRJtjir0BH
pmE/nQzOmFB+FvPSMST0TOk1CIoYglqz6gvZFkGx8vcQAU0iR+V3oT6zHBDwa5tu
tqhMfNjoOe4ITQfEN8TXs2gg9f82DJ74+1XBkD9bWwjAKn+FBTiaICmXDsKf6Y+g
jjNjt843AIegCaP1uwDBHZmDF0MdBI6dR80EMZctXpBN4DEr9rQdV6fDRb+lwCqy
c3bsMjKJiztc3QvC8lD50DOy8PdYOTvN+exhDOI38nagSkTvpEbUl4XQlJaCPtvY
kGW9Z38kYTrfxnJwWuLxMM3yXVKUSw==
=SxhN
-----END PGP SIGNATURE-----

--Sig_/ho3yJJm664Ov7YLS+Zw88gM--
