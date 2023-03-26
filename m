Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471C16C97E4
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 22:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjCZUrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 16:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCZUri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 16:47:38 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7BA4214;
        Sun, 26 Mar 2023 13:47:37 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Pl7LH5Ymzz4wgq;
        Mon, 27 Mar 2023 07:47:35 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1679863656;
        bh=TWO3WmlGDnVwIb5BNDwvFUNHK7qRJtMupM+7D0ys6yU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KsGfqjwx+rXB9kJB7UvNxtFW7GzUXHah5uDIqIG/excgsJsPuI3oTVRFz9w1Y2ptV
         K1Sg3QRisfIHjE93H92Vh8NgPsVuYO77cREVBp2G7GEeN5NuVvKnaXGJ9ReUYyekZk
         T5ua4hYbaOmT9TKDtX8FIsMFzfdQt2EFn29thLjb/ZEA0OU9Pbri27o5z4F7QiNuTz
         tyD1L078WXmqdJJqG2eCmc6aaKU45eEWO0YtkpelXg9QguH+zZpM8aJ9ngU3y5DGr1
         yEFVnA+QFLqQn/y+05eLWLwAkiR/s8G6wI8Qqzo8PPYT3W1cQQYnpQGPjqR1ncLFlg
         e9k8NIZz+TYYQ==
Date:   Mon, 27 Mar 2023 07:47:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: duplicate patches in the bluetooth tree
Message-ID: <20230327074734.4bd3af8e@canb.auug.org.au>
In-Reply-To: <20230324122159.0f34ffcb@canb.auug.org.au>
References: <20230324122159.0f34ffcb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/OpOVIFqSfylDXMhyWRkzinf";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/OpOVIFqSfylDXMhyWRkzinf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 24 Mar 2023 12:21:59 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> The following commits are also in the net tree as different commits
> (but the same patches):
>=20
>   0b0501e48331 ("Bluetooth: Fix race condition in hci_cmd_sync_clear")
>   1446dcd9dcfc ("Bluetooth: btintel: Iterate only bluetooth device ACPI e=
ntries")
>   23942ce75b8c ("Bluetooth: L2CAP: Fix responding with wrong PDU type")
>   363bb3fbb249 ("Bluetooth: hci_core: Detect if an ACL packet is in fact =
an ISO packet")
>   36ecf4d48b5a ("Bluetooth: btusb: Remove detection of ISO packets over b=
ulk")
>   3ebbba4feafd ("Bluetooth: btqcomsmd: Fix command timeout after setting =
BD address")
>   592916198977 ("Bluetooth: ISO: fix timestamped HCI ISO data packet pars=
ing")
>   59ba62c59bfe ("Bluetooth: HCI: Fix global-out-of-bounds")
>   6eaae76b4aed ("Bluetooth: btsdio: fix use after free bug in btsdio_remo=
ve due to unfinished work")
>   81183a159b36 ("Bluetooth: hci_sync: Resume adv with no RPA when active =
scan")
>   853c3e629079 ("Bluetooth: mgmt: Fix MGMT add advmon with RSSI command")
>   906d721e4897 ("Bluetooth: btinel: Check ACPI handle for NULL before acc=
essing")
>   bfcd8f0d273d ("Bluetooth: Remove "Power-on" check from Mesh feature")

These commits are now in Linus' tree as different commits but the same patc=
hes.

--=20
Cheers,
Stephen Rothwell

--Sig_/OpOVIFqSfylDXMhyWRkzinf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQgr2YACgkQAVBC80lX
0Gwo4Af/cakCzVrlXhEIauUf53JUm6c91M0ccYo+xNiF06TzOCF5r72HYD0Pqgq+
FihOkLvAUe8Zytan+bj8fJIEUWGWCw596b4Djk3yJ0J7sxZmwTl240r7PVgsP+cd
kQx+XYeI5qNKGXxlG6pCAaPGC/iBeM9ArO042rLYXKX4uqhoz8Hv2vueFAs+b5t0
BzRMcmDtaOJa1l5ob6jegv6sdXv1hQUq3RvsDgUjmNFivoMVfywOCrRW6vScNYOn
c8u9btpmBQHMvSpaGQzhlbPb+Vq1ulebTw0eTKZxWO1uwpiBLCZCfese54rJBMYE
CkjxDhxj1F9W38jkmardXAI8OwtyqQ==
=kM0E
-----END PGP SIGNATURE-----

--Sig_/OpOVIFqSfylDXMhyWRkzinf--
