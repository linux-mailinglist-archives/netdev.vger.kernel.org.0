Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DBA672DB0
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjASAtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjASAtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:49:01 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9217F613C3;
        Wed, 18 Jan 2023 16:49:00 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ny3sk5vgrz4xG5;
        Thu, 19 Jan 2023 11:48:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674089339;
        bh=OwdFYdWIoIIsHwM+sB3acXiZlJwSVm5lyRbWqIdINlQ=;
        h=Date:From:To:Cc:Subject:From;
        b=cxDAb1468wEv4krx+rFom8oIVO/DrJ0x+1r3agDcBI/S4XnpQwWtACH6PNY//BDMN
         0DtAWTNT1lQUv7+2giYfZU2A29KjWGz/izatfq6bmaP7VvpYWuivVfgN+zEVZ01uwg
         n9QY+SPnh6QsJgyvspZ4pCoxEFa2d33FzE64tZ+nk2+V2kaALOtN4COSClQQKEMfWf
         Q5VXhWMiKeyY3y+ZTCnoXz8HUNtcYFDwIAaGNMsGK9V1CVJ1YNBI+w3c0jXTRhjvS2
         Nr2wSEJyqQNEByZq07ayJWOr/Q8XYfgWLZ4Jjd0Oisvhl2KPoVNhlQUM0uwOXnMVZ5
         J0o2QQ8PX7PLA==
Date:   Thu, 19 Jan 2023 11:48:57 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patches in the bluetooth tree
Message-ID: <20230119114857.51b845bd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LmABG8c+DiJzhYnfD5UQIRp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/LmABG8c+DiJzhYnfD5UQIRp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commits are also in the net tree as different commits
(but the same patches):

  08e664b73363 ("Bluetooth: ISO: Fix possible circular locking dependency")
  489691e98909 ("Bluetooth: ISO: Fix possible circular locking dependency")
  5d043a6a43b6 ("Bluetooth: hci_conn: Fix memory leaks")
  711d2d5f3b42 ("Bluetooth: hci_sync: Fix use HCI_OP_LE_READ_BUFFER_SIZE_V2=
")
  7ed38304a633 ("Bluetooth: Fix possible deadlock in rfcomm_sk_state_change=
")
  a18fca670e14 ("Bluetooth: hci_qca: Fix driver shutdown on closed serdev")
  becee9f3220c ("Bluetooth: Fix a buffer overflow in mgmt_mesh_add()")
  e8b5fd71713b ("Bluetooth: hci_sync: fix memory leak in hci_update_adv_dat=
a()")
  fd18e1680ee2 ("Bluetooth: hci_event: Fix Invalid wait context")

--=20
Cheers,
Stephen Rothwell

--Sig_/LmABG8c+DiJzhYnfD5UQIRp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPIk3kACgkQAVBC80lX
0GzL0QgAgCQJvtIbH5whXuBy0tk2Kx5WBxwTTONLOLBTw2qrUkXIpsLEOx3etp5X
BPzpv2QhUql66/BgEBOTpyw6GGGxUub3+6JFLxH/mkbtvx/8FmpkQ5jvnseNLxGN
PiiEI5UTsY0QGdQTT74OFPRNyxt7WX1zvxPrlPPlbdK+eNOn5jy1J0Ii6toB8weh
+azyZWphu+mzg0B7O2y59AycvnzHEOYMQklWsxLET0SGa4Omg9giPcEitK2NoPYa
Tp3aEPdDe3WKZ6RUEJp08mSqgC6RHzT86SrbJ+48S/7bS5olBa2wUWM7VDwIGNy6
FIb5QFwCORKsN5kMa+cAwh5lljRK8A==
=Qm3U
-----END PGP SIGNATURE-----

--Sig_/LmABG8c+DiJzhYnfD5UQIRp--
