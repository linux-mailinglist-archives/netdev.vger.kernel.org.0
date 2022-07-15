Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650ED57595E
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 04:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241192AbiGOCBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 22:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241184AbiGOCBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 22:01:40 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008016E8AA;
        Thu, 14 Jul 2022 19:01:38 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LkZNK2VFPz4xj3;
        Fri, 15 Jul 2022 12:01:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1657850497;
        bh=DYH80/QwUNARf0Y6SX2i3c5FMfQQTdmC0PDzRMVMNm4=;
        h=Date:From:To:Cc:Subject:From;
        b=L3/Zp/uGt7WBaZ4cWMcOfSVAPbyvFl5QxnaOV7REmqNRihryrP4sBWDngLvI0KFI9
         zLNCXX3nQVYh8nFY4fXw4O2V3fAjDx7A+XQ6Y9Q2yHXdlHXpfVohYEDe5D2CM7c06s
         je2ags07Xm0kZ2JCUgrfcjQ3jLacXjZiTNghiICoNwvR1Mh7MK4iJE6X79krB3LMC1
         y2YmSjGBWqHbxD2CbJuj7VifhHzJN1qYUtGEPiiCklcSEdXvEknHDNaoGjM9wm5S1Z
         s5XFGe/gJ7AiR1SK404x8aVfPcM109swUR7OiP5DsZQPeI+s8R9WlaAeHujlWAp8/c
         CJ56edubRDmRQ==
Date:   Fri, 15 Jul 2022 12:01:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with Linus' tree
Message-ID: <20220715120136.479ab661@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Dui7ieouFRRa_Fs=Kc1NyG5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Dui7ieouFRRa_Fs=Kc1NyG5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  include/net/tls.h

between commit:

  3d8c51b25a23 ("net/tls: Check for errors in tls_device_init")

from Linus' tree and commit:

  587903142308 ("tls: create an internal header")

from the net-next tree.

I fixed it up (I used the latter version of this file and applied the
following merge resolution patch) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 15 Jul 2022 11:57:39 +1000
Subject: [PATCH] fix up for "net/tls: Check for errors in tls_device_init"

conflicting with "tls: create an internal header"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/tls/tls.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 8005ee25157d..e0ccc96a0850 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -133,7 +133,7 @@ static inline struct tls_msg *tls_msg(struct sk_buff *s=
kb)
 }
=20
 #ifdef CONFIG_TLS_DEVICE
-void tls_device_init(void);
+int tls_device_init(void);
 void tls_device_cleanup(void);
 int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
 void tls_device_free_resources_tx(struct sock *sk);
@@ -143,7 +143,7 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 =
rcd_len, u32 seq);
 int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 			 struct sk_buff *skb, struct strp_msg *rxm);
 #else
-static inline void tls_device_init(void) {}
+static inline int tls_device_init(void) { return 0; }
 static inline void tls_device_cleanup(void) {}
=20
 static inline int
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/Dui7ieouFRRa_Fs=Kc1NyG5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLQyoAACgkQAVBC80lX
0GwYJggAjKtFDsDiRzD45dVP8rJZfa72RCl/jU4/7TNkbYKjmmQnNpZ6YCPFRgD+
yOZFr2u7hcH4nEa9F3taKDfmW0/vULjk1ldGMpOKe4VtiM9mOeqB2sItEtBlY7Q7
oszjwNWO39f70sQrDC8O7hwV4ruMNvYzJgGy38aiqt9kImpWkjFnb5NkXCP+DxoN
gJ55TOLVRq/EqYg/LcDqDqcY9IM8LSveQBOuLDFcBg5O6SwUaifjUMqp9K2bGorG
3/FFL9g6XHzAsPzLkGn247grVIKU9JnyD+D8O4U2DsELP4ZhZ226WuoEdj25Vv03
EilNxBaHHtIsazFbLfPhlFbhOKy8xw==
=FcSN
-----END PGP SIGNATURE-----

--Sig_/Dui7ieouFRRa_Fs=Kc1NyG5--
