Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AF064AEA9
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 05:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiLMEhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 23:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiLMEhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 23:37:18 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB31AF25;
        Mon, 12 Dec 2022 20:37:16 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NWQh64RxMz4xGH;
        Tue, 13 Dec 2022 15:37:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1670906231;
        bh=6PEiYlZXv+uu49FitHkjRRS1UJTXbjXhNAPpNWM8y28=;
        h=Date:From:To:Cc:Subject:From;
        b=Duu0J29EFawFZ+MtrTrwMXPnnpW1LgI9c8xcKDKabqckz2rn0KpTxbJYu4tLF8Zds
         daTDPneMa3IotmwcyXUCHJuUp8IoOY5ya624BfejrOoNyEB4/6JYmwUo9PstvdO+hV
         Wiuub0eh9xZlfXaOGlMospmqMtJpkZosuyYPrdQGGPrtSDmtLjBOxF5/9enRKziBZi
         aoN/0QNKVUm5tzoZFeN3gpus2IHXnYZxXBSiIyctjPMnNIFD++H6Rgo9nxXH2MCxSK
         fugqyMG5QNvF8fCNDnIVimTBYXcVId23lw/l2fGNklFgAUHRoRPPGQeynYaeAJfkvt
         IF6lkYWZisO7Q==
Date:   Tue, 13 Dec 2022 15:37:08 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20221213153708.4f38a7cf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4vSdMI=5FFYser9j2tRif3V";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4vSdMI=5FFYser9j2tRif3V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't in=
cluded in any toctree

Introduced by commit

  9f63f96aac92 ("Documentation: devlink: add devlink documentation for the =
etas_es58x driver")

--=20
Cheers,
Stephen Rothwell

--Sig_/4vSdMI=5FFYser9j2tRif3V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOYAXQACgkQAVBC80lX
0GwzNwf+Ktbnt8UPhIhnot8TWTtyP7Pky0i1OlkD8xz8FXK6CO3blbtg7G/wBnjC
O8FZNWpjGmFUqmF7e77x9KlcLUdQbkzPitDDm/jax2dRis5gcIthJlLKoYaZlBTA
xhui+qV/WqmBo5/C2P224IkMHtQcoHMG1/93LGPMBgnm1aCuXnT5dONrmk0S3/0p
dHuZ4WXIGYHCjMKQ0kuLbMKDs+3mLIUvyb+yqbKW+YXze/VDjpa8v6baLeZ/6v5W
tpdYwwZCReYvXHrdkyhFHbcF17GPfj8IjsNk82ZBds4+BBew/GdQezSm2xEY2ZgR
4V1Yi63HiyCxcZhloutLdZGaKl4xUA==
=PTqh
-----END PGP SIGNATURE-----

--Sig_/4vSdMI=5FFYser9j2tRif3V--
