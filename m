Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9E1627665
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 08:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbiKNHbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 02:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbiKNHbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 02:31:36 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3AC616D;
        Sun, 13 Nov 2022 23:31:35 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N9gwj5Ny2z4x1D;
        Mon, 14 Nov 2022 18:31:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668411094;
        bh=GT24nafW+y7Nl0IxPljg2aoHx7gagEziTSV1tH+M9KE=;
        h=Date:From:To:Cc:Subject:From;
        b=LFmTwLd/xttcVBFFu0PU3fruoN7/JmXfg0ToxTQlIl+aIzsO/1luy145UC7bM3sZU
         CndvRDq4rslaY3/M64xDpFPx0+rDwj7HNumAtw0Bo6mH4JdOaaZv7CvZlhYjqroLQF
         aeiXj8aaTrQYESEKJIn24yrguPNtdiCC5B2YPDDpn0DXKoKUmp3EtLHnc7osZ7KfP+
         Mio7Ph0TMLrTHEOjG7fPvUTyyzFZ0WDmYqKs4LgAjkkh+hJyJaB4fjzf76CdqbfipM
         ikPEF9tYlLUZsXSz1Ah3HiziXU8p+UoL7pUzEQVQioaVyGB8/0lZSfxwOrFSdDrjwk
         qO44bhkCZTrCA==
Date:   Mon, 14 Nov 2022 18:31:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maryam Tahhan <mtahhan@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warnings after merge of the net-next tree
Message-ID: <20221114183131.3c68e1b5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/oCAY=xF0oojv8uwpX=vk3N_";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/oCAY=xF0oojv8uwpX=vk3N_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced these warnings:

Documentation/bpf/map_cpumap.rst:50: WARNING: Error in declarator or parame=
ters
Invalid C declaration: Expected identifier in nested name. [error at 67]
  int bpf_map_update_elem(int fd, const void *key, const void *value,
  -------------------------------------------------------------------^
Documentation/bpf/map_cpumap.rst:50: WARNING: Error in declarator or parame=
ters
Invalid C declaration: Expecting "(" in parameters. [error at 11]
  __u64 flags);
  -----------^
Documentation/bpf/map_cpumap.rst:73: WARNING: Duplicate C declaration, also=
 defined at bpf/map_array:35.
Declaration is '.. c:function:: int bpf_map_lookup_elem(int fd, const void =
*key, void *value);'.

Introduced by commit

  161939abc80b ("docs/bpf: Document BPF_MAP_TYPE_CPUMAP map")

--=20
Cheers,
Stephen Rothwell

--Sig_/oCAY=xF0oojv8uwpX=vk3N_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNx7tMACgkQAVBC80lX
0Gyg0gf+OZd9mC0HhnWLGH4hA2xRMO/0Dc13LjqhLZo/ec6HIX/SYeQo3MHSVrGk
m66zNVShDxaoWP3wWZZaMN/xeLnGuYFBGodfBEA7X9qmRoH18Frl53vjPwv+J5zW
u8MouplpESNVeDJTm8Uj8rtBtIfTI0MLKiTEhxTAF5VCcR0CZrruSjitQ4uV+yOX
YG9WKZvtyigpTexoXjzoYDP0ti9PeC91kbRCdOLlAqMRRcvrYo0p0OTLz9N4wRps
wifu9ELK1t3TZ4E8JxE1cb3exH3htNVORGxgHX7vjg1IloYFgaMHDTbrT3dJXlov
MTNhtgUTYFoTz99vKTfNmMkcxhzU9A==
=u+3A
-----END PGP SIGNATURE-----

--Sig_/oCAY=xF0oojv8uwpX=vk3N_--
