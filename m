Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460E86C74F5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 02:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjCXBWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 21:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCXBWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 21:22:09 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD8ED515;
        Thu, 23 Mar 2023 18:22:07 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PjPZJ6Jdsz4xDn;
        Fri, 24 Mar 2023 12:22:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1679620921;
        bh=QJyYt0zaRUYHxyT+kUDN1KRXALcFkkSiTA4EgDMKxYA=;
        h=Date:From:To:Cc:Subject:From;
        b=E8v/nzOpFa20q74xzPFSdBWoR/53Tnmp1+nzD3Ci8knO5S644QllsGIxdoPd8Iw3X
         wR5A91iP4DzrqkpgXPD7Sae7qTzpYAZ9qHR0PXWBsRShvXY+S29in9BJRJ11qmgvHP
         4xuSWG6zZLppeUVmf1ifvTIAMgzhGHV3Kt5X/3RwzEHXBSKCubD2nblPQeTAiVUL4B
         ePPq+pBpSdxAkIRDNyBSPIOPM+ZF3WYjCWa5xh0/BIJUZ0E1TbKVdQFyQ1IycdMZSK
         B707dfQgirIM8/+SAzfsVXb9THKbuXMcwXxqlpP27knk4UqAiLf7PPK775IkDqxZ/e
         KT/x+StQ1tM/Q==
Date:   Fri, 24 Mar 2023 12:21:59 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: linux-next: duplicate patches in the bluetooth tree
Message-ID: <20230324122159.0f34ffcb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CJwEIDzeJZ01xxFtChdXG0w";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/CJwEIDzeJZ01xxFtChdXG0w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commits are also in the net tree as different commits
(but the same patches):

  0b0501e48331 ("Bluetooth: Fix race condition in hci_cmd_sync_clear")
  1446dcd9dcfc ("Bluetooth: btintel: Iterate only bluetooth device ACPI ent=
ries")
  23942ce75b8c ("Bluetooth: L2CAP: Fix responding with wrong PDU type")
  363bb3fbb249 ("Bluetooth: hci_core: Detect if an ACL packet is in fact an=
 ISO packet")
  36ecf4d48b5a ("Bluetooth: btusb: Remove detection of ISO packets over bul=
k")
  3ebbba4feafd ("Bluetooth: btqcomsmd: Fix command timeout after setting BD=
 address")
  592916198977 ("Bluetooth: ISO: fix timestamped HCI ISO data packet parsin=
g")
  59ba62c59bfe ("Bluetooth: HCI: Fix global-out-of-bounds")
  6eaae76b4aed ("Bluetooth: btsdio: fix use after free bug in btsdio_remove=
 due to unfinished work")
  81183a159b36 ("Bluetooth: hci_sync: Resume adv with no RPA when active sc=
an")
  853c3e629079 ("Bluetooth: mgmt: Fix MGMT add advmon with RSSI command")
  906d721e4897 ("Bluetooth: btinel: Check ACPI handle for NULL before acces=
sing")
  bfcd8f0d273d ("Bluetooth: Remove "Power-on" check from Mesh feature")

--=20
Cheers,
Stephen Rothwell

--Sig_/CJwEIDzeJZ01xxFtChdXG0w
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQc+zcACgkQAVBC80lX
0Gyzagf+IFiafALspAZ6e8kJXux1S3N0cIhDOs5tZzw4ZnYZleC/STwHxyGhwn7e
qh1dlbmVRWewocg+YIKi9g288IMKaxZJxk9CsjJdJHCb56BnB+n/52DjC0bowv7S
Se3NkqNbj13rEr9sYs3b7kFitZaG+ZrxL9nawrhUWCtCGrRDPeyPvewpJHvuM50A
7jA4ZrKQA7utcbz211BDuXlx5qVGrwt+eTYAhkRo91CYJ80cczz4tmUIB6Z20BFm
O7C9rTyn2p+tE7nr8/32A/ZKHFuShU0OMT1uBWcn+NEo9HOdH6ypTF4KC8pG3mD0
ep2OHe9iiVQ81lcBRXYZl/D5ywlQag==
=SBdP
-----END PGP SIGNATURE-----

--Sig_/CJwEIDzeJZ01xxFtChdXG0w--
