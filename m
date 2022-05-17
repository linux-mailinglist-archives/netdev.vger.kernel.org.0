Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B62A529671
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbiEQBDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiEQBDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:03:15 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CECF46659;
        Mon, 16 May 2022 18:03:13 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L2Ht15h7dz4xXg;
        Tue, 17 May 2022 11:03:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652749388;
        bh=x8n3X36KlVWnp5dnmrsf7vx3RDNzI6P6bYznSPqb0Zc=;
        h=Date:From:To:Cc:Subject:From;
        b=lcaedIKosIECiKiGSFqklVwjLh9zRgXj5RjPlPieEIjEY3gGzPo2W2uTB8W3IpF5j
         eVAmBHl86OlEv5I3KKc9WnZg1UZiNN8pf/B5kElNZS/mzEIlTABOgQk6mn1IlXulSD
         EHH38zEk726I0O41WGK6KQB7J0sdPX4GlHvywu4U/DcsDaimKEMmLlUKl+DomhUbuf
         UcNcN1+o+pYr0UO1gzgh2BT3RC1eu4rOKm29oG18t/FGF+f1CiclhnkVZe6dvEIRM0
         7IAXvskv+xyHrFhqBS2rVUueqGytDsuDMk9aDzd7ImEEkolnbaU2tTvBg0rgKT6D6T
         LqxVqVrcpkhag==
Date:   Tue, 17 May 2022 11:03:03 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20220517110303.723a7148@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mq3Ceug_MSxIgDEitd.vmpH";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mq3Ceug_MSxIgDEitd.vmpH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

net/netfilter/nf_conntrack_netlink.c:1717:12: warning: 'ctnetlink_dump_one_=
entry' defined but not used [-Wunused-function]
 1717 | static int ctnetlink_dump_one_entry(struct sk_buff *skb,
      |            ^~~~~~~~~~~~~~~~~~~~~~~~

Introduced by commit

  8a75a2c17410 ("netfilter: conntrack: remove unconfirmed list")

--=20
Cheers,
Stephen Rothwell

--Sig_/mq3Ceug_MSxIgDEitd.vmpH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKC9EcACgkQAVBC80lX
0Gwsmgf/fixbABcmvb2K104o5veCFn9NMzlqZQ+rAcog5sHVKrnqcYIH9NFeBAht
Oq/c6ldW2HkVSxb6FbyYonJ+hQaahxyvofaMkTjBA9dQmZMeUOBGBIl0CagCfZBv
gIIkeLasHuFOIvxD+J7UpTgyHr7/2j7srxy87U8/IvCGkzmMaehJG9E+VFuc2yJD
1TZS45BLQXXCqnxmIlVL/NRsBPvsFYh5laLgejq2UOCvhvor5Kz4/oSoBpNYawsd
870TSD82G4/zuFEXz1OR8IlG554l74gywbg5j5EIRVuLlSE0BgiAbpQ7MFGhV/l+
p4h/tLP2Sgafi5ZNhJZOcFs9rpURbw==
=dlmg
-----END PGP SIGNATURE-----

--Sig_/mq3Ceug_MSxIgDEitd.vmpH--
