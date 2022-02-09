Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78FF4B0354
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiBJC1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:27:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiBJC1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:27:32 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC7C22BCE;
        Wed,  9 Feb 2022 18:27:34 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JvH0y3Fwfz4xcp;
        Thu, 10 Feb 2022 10:59:29 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1644451170;
        bh=3taperdGKmrOZtQFKGHUJwb32+AU1uia470nz+nIGLg=;
        h=Date:From:To:Cc:Subject:From;
        b=FvNQe8WgSZ81ocK6UfW2hJ442D6RROI38Bh57AKin/k4EWQkR+mRU2J/y+xxUu81E
         O+FM4zz6hE1Zx80LFM9zaWxvZWIHwuPTK5tBe3/fAVg6u9K2oAONl87+Kugc1orZTT
         HTs8DsPx2ULolcWL6VX/Hpgdo3ExhUstESq9agdHRzt4sRTJv+peBAK4KS1kTL5ua4
         nWjk1j+UX9e1Ccg7FqyzYIumQtFdtKeGgKrYBsnSyH1NHMZSR/3p6xhACr3Rc9loQ2
         CYng+mN4K05d46Cg36pKJyOQAhDMlxtBHL4oFE5D5QNzF+LlFMvkGg5j1Pbd30u6ZI
         e3Wkna4SSCsng==
Date:   Thu, 10 Feb 2022 10:59:28 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Sunil Kumar Kori <skori@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20220210105928.1877d587@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JAQtZNoJvBCGJ1elJ+aszuF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/JAQtZNoJvBCGJ1elJ+aszuF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/bitmap.h:9,
                 from include/linux/cpumask.h:12,
                 from arch/x86/include/asm/cpumask.h:5,
                 from arch/x86/include/asm/msr.h:11,
                 from arch/x86/include/asm/processor.h:22,
                 from arch/x86/include/asm/timex.h:5,
                 from include/linux/timex.h:65,
                 from include/linux/time32.h:13,
                 from include/linux/time.h:60,
                 from include/linux/skbuff.h:15,
                 from include/linux/if_ether.h:19,
                 from include/linux/etherdevice.h:20,
                 from drivers/net/ethernet/marvell/octeontx2/af/mbox.h:11,
                 from drivers/net/ethernet/marvell/octeontx2/af/cgx.h:11,
                 from drivers/net/ethernet/marvell/octeontx2/af/rpm.c:8:
drivers/net/ethernet/marvell/octeontx2/af/rpm.c: In function 'rpm_cfg_pfc_q=
uanta_thresh':
include/linux/find.h:40:23: error: array subscript 'long unsigned int[0]' i=
s partly outside array bounds of 'u16[1]' {aka 'short unsigned int[1]'} [-W=
error=3Darray-bounds]
   40 |                 val =3D *addr & GENMASK(size - 1, offset);
      |                       ^~~~~
drivers/net/ethernet/marvell/octeontx2/af/rpm.c:144:68: note: while referen=
cing 'pfc_en'
  144 | static void rpm_cfg_pfc_quanta_thresh(rpm_t *rpm, int lmac_id, u16 =
pfc_en,
      |                                                                ~~~~=
^~~~~~

Caused by commit

  1121f6b02e7a ("octeontx2-af: Priority flow control configuration support")

I have used the net-next tree frm next-20220209 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/JAQtZNoJvBCGJ1elJ+aszuF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIEVWAACgkQAVBC80lX
0GzMIggAnZEdjRVp48k/a5FBizoXCCA3d36ID1HAPYJ3dMqKeZbAN06K6nieFiQS
PzooAipsaw9kltj4vVGHUFsJh3owKWUgQUFgpsDt7Ni6WnwrAxTuJsszr1xIZhr0
6nMnRdNBFiuymXSaEr4LtemzamnliYKi0SewLxDynI7QfcWLBiFI5ikiyvnH5TSZ
BQebm3Wryv3XYWsHQyMsrT3QsV6mPRO7NLqYbQOKbojn79RwwVsA+xugy0rBzhcx
Eyi1LIudq4NHEsgU49yHqdz8+t/4Wqv1fOifxVNjleGNoCEbofvDk6ldSAuVx9uk
shO+lBaibvsyATz3mT1gzCRnKbo2kw==
=Xslb
-----END PGP SIGNATURE-----

--Sig_/JAQtZNoJvBCGJ1elJ+aszuF--
