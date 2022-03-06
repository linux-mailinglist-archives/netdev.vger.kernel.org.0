Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20D44CEDA5
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 21:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbiCFUXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 15:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCFUXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 15:23:45 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F52527B13;
        Sun,  6 Mar 2022 12:22:52 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KBY1Q1f6Lz4xcq;
        Mon,  7 Mar 2022 07:22:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1646598170;
        bh=Uiu5F+tNy40rBlfCD7qdyaE5/5cwZA/CneGgiZBPgb0=;
        h=Date:From:To:Cc:Subject:From;
        b=QI12b3CRdSgj5w5i5TB1HY0qmxebu7ZW6sQ0mzBLSVGocgVsHgX2acsbVFeS8fief
         nWnpCuC9QhpGGNO0cY5HxQnNYMwl55SXt5xNczA2W5cwOTFhMSSH+2NQU6zIHfGBSa
         FC9I4lEDFMVe9p6JAS+rZClmn15j6iihEuhRElj7m5F/7j63Y6dKhxkuaER+vsSV70
         TJWcXSW1/8hFd7q/iN8tZ69w7Z9ne1yLQmw6YzXidVO8YejyE+z3TiVEqFbK5MLyIW
         wdVjzfXmrARxrgmD8pI3aENbPr5McCP9OnPocAAfVnpJHmmiF2KlOZDdFWmERfHI4d
         0Z4lLq0skEDMg==
Date:   Mon, 7 Mar 2022 07:22:48 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commits in the net-next tree
Message-ID: <20220307072248.7435feed@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/f1x77AK6TAAYrBeg/UIsVf+";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/f1x77AK6TAAYrBeg/UIsVf+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  c2b2a1a77f6b ("Bluetooth: Improve skb handling in mgmt_device_connected()=
")
  ba17bb62ce41 ("Bluetooth: Fix skb allocation in mgmt_remote_name() & mgmt=
_device_connected()")
  a6fbb2bf51ad ("Bluetooth: mgmt: Remove unneeded variable")
  8cd3c55c629e ("Bluetooth: hci_sync: fix undefined return of hci_disconnec=
t_all_sync()")
  3a0318140a6f ("Bluetooth: mgmt: Replace zero-length array with flexible-a=
rray member")

are missing a Signed-off-by from their committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/f1x77AK6TAAYrBeg/UIsVf+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIlGBkACgkQAVBC80lX
0GwSkwgAiXQ5e/J8TXhYMEQFuYMEhsDhg6SgMOIT5RBHqjE5qgBKMJtJqOoePVES
ZpUc4tdkQMJBqVg5eCncIVwTZgk8v+eCY7gJ4JOcFmMpxfFd5Po3aARxjuwjVF0m
ej7DqRfmXjH+OzIgSRdiXar4XqrsN6OzzKDE9+0I8fO9wpUbqZRNefYUm4YpSrti
fvdoBFwxiuVsiPPhMG023HRXUAI+T47rZXKG2uhobQzK4aTdFtAWr7XMIFdEf8kP
SNGnhMz8AXaqwsSz1Dgv5KgZ7Hdpe9BEUs/UvEAU5jzkEsJQN7oj4/cKwFjiINCA
gEgJcThGAwh92oyX5fhtuKo5a6JUdg==
=3gTD
-----END PGP SIGNATURE-----

--Sig_/f1x77AK6TAAYrBeg/UIsVf+--
