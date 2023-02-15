Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA0E697507
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 04:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjBODpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 22:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbjBODpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 22:45:18 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B4E3346D;
        Tue, 14 Feb 2023 19:45:08 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PGkVV4jPhz4x1h;
        Wed, 15 Feb 2023 14:45:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1676432707;
        bh=CRIFzpVkyuOkr+34RToeNN4kalv1EkVdunzNX/+rO68=;
        h=Date:From:To:Cc:Subject:From;
        b=CWtlVs5kCJ4+NDRgz4XfnmzmRzNQbYgn/QUJ0SSD8U7MuzKnsKMaCWHyVL7J6mU/b
         jm8rvN7bRMFatDWqzDuZmY2qCvPhj9Em2iFYqZZaMqMX09OFZ2RfFvHWAH/ccujS/y
         8fuwkoXNlV7UCPtsqH2pNJVO56EKVXp2cplQz8NpbPoN2losqwdWCWOvH8seZR/4I7
         HOq0WzF0vFyrgsx9qX90/mZEwY1fV3j+iPFlbCTxqv/uWEKFLzatcN+XaXnCTSKU7O
         MRfEMNU6pnX7ddlRrXGl4s23087UiqIYo1aJTUpCV/lVA5XT4XBIpYKHQ3UV6uayrX
         eB/QaJX0QD87Q==
Date:   Wed, 15 Feb 2023 14:45:05 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Dave Marchevsky <davemarchevsky@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20230215144505.4751d823@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+dqpjlbrDuqyM.GoP5Eh1NK";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+dqpjlbrDuqyM.GoP5Eh1NK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/bpf/graph_ds_impl.rst:62: ERROR: Error in "code-block" direct=
ive:
maximum 1 argument(s) allowed, 12 supplied.

.. code-block:: c
        struct node_data {
          long key;
          long data;
          struct bpf_rb_node node;
        };

        struct bpf_spin_lock glock;
        struct bpf_rb_root groot __contains(node_data, node);


Introduced by commit

  c31315c3aa09 ("bpf, documentation: Add graph documentation for non-owning=
 refs")

--=20
Cheers,
Stephen Rothwell

--Sig_/+dqpjlbrDuqyM.GoP5Eh1NK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPsVUEACgkQAVBC80lX
0GzDRQf/QmMclFZ2lTiLNLWSx5VZIGgPfi8rrrXh63awbM5icW8gJmouZofTLwXN
/aA27CZHv7bHFQK1p7953F/gpOIabBRhtbWlgXPi0PIWa3M2RbFxTJc7lMl77DrI
nSylufBCDSGh8zO5M5wcCSv04YOigTowiX8qnjmunvw1tvWdhCjlvCI38kv3MC43
hWhSfJciTatygJjAlDVMIyVTup3Ucgc0WHJvCOo6AbI2jUlu4rKHe6WhpiEUWmnE
blqEnfmLghhLsySrTVl8CVlXAHXt9qonk/4hhxC1lkcDA2+eMQJZdNUcC9bppok/
mDq7ti6jMBIXOb3Cpgp1O9QWHPyRWQ==
=Ug18
-----END PGP SIGNATURE-----

--Sig_/+dqpjlbrDuqyM.GoP5Eh1NK--
