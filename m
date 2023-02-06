Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8E268B4B2
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 04:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBFDyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 22:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBFDyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 22:54:50 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE54E3AAA;
        Sun,  5 Feb 2023 19:54:49 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P9C7m0G9sz4x1d;
        Mon,  6 Feb 2023 14:54:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675655685;
        bh=vSpcOsao2kHslxh5hL8bLwHPNvA3hbIuLd/9ZK3iEyQ=;
        h=Date:From:To:Cc:Subject:From;
        b=k3FJRr6Ij7exqrxDcosSi9+FbBZSkgZtVeDIemybq6gwVjblol0vYM58Hlhr65f/v
         noNjJw31j9yl+ssDAlljv8y4Ec0WnJIkPetgNuBT+UKuur3rJtL0DxUaJ8dLnXEAr9
         WwHzjMaBJ1BvwOp2QHFExW7eXvyK2eQsXULJlv1r7OYbl+spqGe6ehgJ5TGdn+qKxg
         vYTqPKbGS3NNlR3mA/+Yg6oYEYeub2qmGxpXUlKzp57LErwCOHwRcjI5dHejeQWc6Y
         aAwfWwmFOM7ZCdm7DF7wuQat63myDwWQL3LNaHR8rEmArGYoHvcUTsdwhIvBrXl4TO
         Hp/aGnmiAFn+Q==
Date:   Mon, 6 Feb 2023 14:54:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majtyka <alardam@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20230206145442.15f85e1d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/to2RIwYqsIty74KeKC6fGO6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/to2RIwYqsIty74KeKC6fGO6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (htmldocs)
produced this warning:

include/linux/netdevice.h:2381: warning: Function parameter or member 'xdp_=
features' not described in 'net_device'

Introduced by commit

  d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuff")

--=20
Cheers,
Stephen Rothwell

--Sig_/to2RIwYqsIty74KeKC6fGO6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPgegIACgkQAVBC80lX
0Gzdjwf9FneH7UwGZwBK/FRLbZozhEN6dX6o1ufQnuww4MbCE8CF/OameM534rpL
GrJ1SJ7Pr47dIn4iyNBhuWncVqtEzTOYWO1luJOIBFPLqY0hmaIHPkXabUxwB3rf
APDKO6GACUGp3mkUeeyyxVe6Qpdv7zDYQFDLoakNEtjhvcq9SZCVajauo/O2rij3
eZE6s8HDzT9Tp+HYLmdADsdKfLtRVvW8VJaCY6sBOkhEsuZwvHCZ4EEHkunCGwLh
BqrVJormXPIKSCXbnjIGZc4hfqYx0Me2i68C8zYcIT6Jk9+Ud+lnThBJ+nSye3SG
8OhQOE1LtXU4JNxrow9ZrlM40DCwLw==
=wuWD
-----END PGP SIGNATURE-----

--Sig_/to2RIwYqsIty74KeKC6fGO6--
