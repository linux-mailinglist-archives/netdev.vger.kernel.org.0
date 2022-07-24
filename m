Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD9857F76E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiGXWvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGXWvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:51:01 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E3A5593;
        Sun, 24 Jul 2022 15:51:00 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lrdgj419Wz4xD0;
        Mon, 25 Jul 2022 08:50:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1658703059;
        bh=BJ06tJ3A5sxZAH44mcCHE4iMQK2ONFJMQaaQd6Q5xE8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YQhx2EpVTJaq9J19A3lTAvxC0kcYGj7+iu5LaWBGoep2iZCdBi4dHzHt6bPRyAqM5
         zIhLsVVkicEzu4LZdCyTm67rFr7MzFSjkd/z5Y92QtUX3xcSURflp9dx3AHTpZgy0S
         o/zhxFVnPx0Z2mju4rJGgW/pm0a5uRQhrXkHsqdmJh3tDm5nZPd2yBvlkiZ28P2KJU
         GNjoCebS+uYsFF8ZJh4EgIx7ZXM+d1lrWRlVlIESofzLqUMErpo3nR++IDhOfQpofw
         v6KSsy1AWU1A/kJW+mbsC+hd1qY910Ml4t5TyLgtpoz6rCQ5CzeCJuCiuc9lgyodZY
         gTxOfqmkTThFw==
Date:   Mon, 25 Jul 2022 08:17:41 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: Signed-off-by missing for commit in the bluetooth
 tree
Message-ID: <20220725081741.19174e59@canb.auug.org.au>
In-Reply-To: <20220725075728.499066c9@canb.auug.org.au>
References: <20220725075728.499066c9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3ezbk4uwBmnvBCoWCEq8/kg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/3ezbk4uwBmnvBCoWCEq8/kg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

[Resent with corrected mail address]

On Mon, 25 Jul 2022 07:57:28 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi all,
>=20
> Commits
>=20
>   a5133fe87ed8 ("Bluetooth: use memset avoid memory leaks")
>   9111786492f1 ("Bluetooth: fix an error code in hci_register_dev()")
>   4f17c2b6694d ("Bluetooth: hci_bcm: Add BCM4349B1 variant")
>   88b65887aa1b ("dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT bindi=
ng")
>   359ee4f834f5 ("Bluetooth: Unregister suspend with userchannel")
>   0acef50ba3b5 ("Bluetooth: Fix index added after unregister")
>   877afadad2dc ("Bluetooth: When HCI work queue is drained, only queue ch=
ained work")
>   ab2d2a982ff7 ("Bluetooth: hci_intel: Add check for platform_driver_regi=
ster")
>   629f66aaca81 ("Bluetooth: clear the temporary linkkey in hci_conn_clean=
up")
>   af35e28f0fea ("Bluetooth: hci_bcm: Add support for FW loading in autoba=
ud mode")
>   0b4de2523f28 ("dt-bindings: net: broadcom-bluetooth: Add property for a=
utobaud mode")
>   bde63e9effd3 ("Bluetooth: hci_qca: Return wakeup for qca_wakeup")
>   c69ecb0ea4c9 ("Bluetooth: btusb: Add support of IMC Networks PID 0x3568=
")
>=20
> are missing a Signed-off-by from their committer.

These are now in the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/3ezbk4uwBmnvBCoWCEq8/kg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLdxQUACgkQAVBC80lX
0GzuWQf+NoZvlWF9A5nKk8XPwyuljLoPxjT9PWVyqXcP4l8UVEQviFpT7r9jEu4q
byihzmao17IFEUW+3+TmKCxNOevSf7WXGdB6nhiF4uGHbJsE0juD8g+wcS1rBnYN
lsPgXh2udF9xaz97F7ZZQAxzSoxZyAoy6xRJdP1KfKXJ//kPSrJEwvuqtyXE5o9e
0ZyVVzcdghpAbKBikCxIjZNb0aPeBJSoZTP2gVZqTKo03lRQWmpmKS6V13HxSZdT
EvQF5A4VTon7lDDv7Cj2Gtv4pP+XEhxDZXjPisxZkNxXJ2iQGXK3KfX+n0u3c7Es
+2sZfgGNbCR3YVkk9oVONIxxOOrSVA==
=SeWK
-----END PGP SIGNATURE-----

--Sig_/3ezbk4uwBmnvBCoWCEq8/kg--
