Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7C959F2DE
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 07:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiHXFBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 01:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHXFBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 01:01:00 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92B31CFEA;
        Tue, 23 Aug 2022 22:00:57 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MCDSh5hxmz4x3w;
        Wed, 24 Aug 2022 15:00:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661317253;
        bh=V2ilpx+/EsqvKqbwObJy2UqScwcG7aG1Mhl1qA8pYzI=;
        h=Date:From:To:Cc:Subject:From;
        b=OM4s5ZrOEVhFLWFxGyPgqQLyk4FDkogZ+LvEyZIcRmfEW62mgU+uKp8nFu+9io0Z7
         5aXlGTthUH6UsS7FPutnr0hTjMlKBaWMIqmVXD3TD6aUd7rO1SllKm1Bk8Po0Vq3GW
         iz3mSsfo2r/92205QM0pfHqrvyZnQesSxWIY/aga/asOZLW7SOr5tBlzop5sQlZNiW
         VulDVuUB7e3aohoAYrT7cepa/xKhbe2OQwq/5hp1DfaEGwUGjyNBAubd4XPeSVQoTE
         GbMrqg/pf3aC6yyrKghSVQ1ZYN3gFygmaBJJwpBTV8Yz3QJ52G5l5IKSMwPEeY435Q
         z90wJ5mdw3zpQ==
Date:   Wed, 24 Aug 2022 15:00:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the bpf-next tree
Message-ID: <20220824150051.54eb7748@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/e82=/_G4ZCTNQ1yvnJ+SXwy";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/e82=/_G4ZCTNQ1yvnJ+SXwy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  2e5e0e8ede02 ("bpf: Fix reference state management for synchronous callba=
cks")

Fixes tag

  Fixes: 69c87ba6225 ("bpf: Add bpf_for_each_map_elem() helper")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")

--=20
Cheers,
Stephen Rothwell

--Sig_/e82=/_G4ZCTNQ1yvnJ+SXwy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMFsIMACgkQAVBC80lX
0Gwn/Qf/YynmSHmle53V+9cdHuxUwPON+9vpRfj36MmdOYqEHDuZOJpFqECYo5OQ
PcNC9AM8b5E6BmLlwHX4H3JGK5heGt2USj2uIRcWkbQ0nhNmwvWyh/AImNSDXoI9
/9IK295MTGOWn89cfxLudTlTVVDW/emnS3qooISTq7BNVnjJg5n50nDwFErHn44F
DTl1uY22rWjkvOqyOXsqYd6w/A25rnB5zpGE+CccmqQq6+2fp91xo4WI/R/LXfpc
hw+8MxfR7+IGiRtfDEZiEyuqCGWeJDy6aPzmpgPE1LnYmzJ8FWHXHsq5Ql+pvp6k
qxwBzbGzodidqfmf7DMvAfpjhAFv4Q==
=LNUe
-----END PGP SIGNATURE-----

--Sig_/e82=/_G4ZCTNQ1yvnJ+SXwy--
